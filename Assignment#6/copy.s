// Credits: Based on code from Prof. Leonard Manzara
// The program reads 1 byte at a time from an input file,
// into a buffer. It then writes out that 1 byte to an
// output file.

	    // Register equates for heavily used registers
	    fdin_r		.req	w19
	    fdout_r		.req	w20
	    pnin_r		.req	x21
	    pnout_r		.req	x22
	    buf_base_r	.req	x23
	    nread_r		.req	x24
	    nwritten_r	.req	x25

	    // Assembler equates
	    buf_size	= 1
	    alloc 		= -(16 + buf_size) & -16
	    dealloc 	= -alloc
	    buf_s 		= 16
	    AT_FDCWD 	= -100

	    // Format strings
fmt1:	.string     "Error opening file: %s\nAborting.\n"
fmt2:	.string     "Error reading from file: %s\nAborting.\n"
fmt3:	.string     "Error writing to file: %s\nAborting.\n"


	    .balign     4
	    .global     main
main:	stp	        x29, x30, [sp, alloc]!
	    mov	        x29, sp

////////////////////////////////////////////////////////////////////////////////////////
/// 1. Get filenames from user input						     ///
///	1a: store input file name to register					     ///
///	1b: store output file name to register					     ///
////////////////////////////////////////////////////////////////////////////////////////
	    ldr	        pnin_r, [x1, 8]		// 1a
	    ldr	        pnout_r, [x1, 16]	// 1b

////////////////////////////////////////////////////////////////////////////////////////
/// 2. Open existing file for input						     ///
////////////////////////////////////////////////////////////////////////////////////////
openin:	mov	        w0, AT_FDCWD		// 1st arg (cwd)
	    mov	        x1, pnin_r		    // 2nd arg (pathname)
	    mov	        w2, 0			    // 3rd  arg (read-only)
	    mov	        w3, 0			    // 4th arg (not used)
	    mov     	x8, 56			    // openat I/O request
	    svc	        0			        // call system function
	    mov	        fdin_r, w0		    // Record file descriptor

	    // Error checking: opening input file
	    cmp	        fdin_r, 0		    // error check: branch over
	    b.ge	    openout			    // if file opened successfully

	    // Error message: failed to open input file
	    adrp	    x0, fmt1
	    add	        x0, x0, :lo12:fmt1
	    mov	        x1, pnin_r		    // pathname = input file
	    bl	        printf			    // print error message
	    mov	        w0, -1			    // return -1
	    b	        exit			    // exit program

////////////////////////////////////////////////////////////////////////////////////////
/// 3. Open new file for output						     	     ///
////////////////////////////////////////////////////////////////////////////////////////
openout:mov	        w0, AT_FDCWD
	    mov	        x1, pnout_r
	    mov	        w2, 01 | 0100 | 01000	// 3rd arg (write-only, creat, trunc)
	    mov	        w3, 0666		    // 4th arg (rw for all)
	    mov	        x8, 56
	    svc	        0
	    mov	        fdout_r, w0

	    // Error checking: opening output file
	    cmp	        fdout_r, 0		    // error check: branch over
	    b.ge	    openok			    // if file opened successfully

	    // Error message: failed to open output file
	    adrp	    x0, fmt1
	    add	        x0, x0, :lo12:fmt1
	    mov	        x1, pnout_r		    // pathname = output file
	    bl	        printf			    // print error message
	    mov	        w0, -1			    // return -1
	    b	        exit			    // exit program

////////////////////////////////////////////////////////////////////////////////////////
/// 4. Files opened successfully, do loop					     ///
/// 	4.a: calculate base address of buffer					     ///
///	4.b: inside loop, read 1 byte into buffer from input file		     ///
///	4.c: inside loop, write 1 byte from buffer to output file		     ///
////////////////////////////////////////////////////////////////////////////////////////
// 4.a: Calculate base address of buffer
openok:	add	        buf_base_r, x29, buf_s	// calculate buf base

// inside loop
top:	// 4.b: Read 1 byte into buffer from input file
	    mov	        w0, fdin_r		    // 1st arg (fd)
	    mov	        x1, buf_base_r		// 2nd arg (buf)
	    mov	        w2, buf_size		// 3rd arg (n)
	    mov	        x8, 63			    // read I/O request
	    svc	        0			        // call system function
	    mov	        nread_r, x0		    // record $ of bytes actually read

	    // 4.b: Error checking: reading from input file (exit condition)
	    cmp	        nread_r, buf_size	// if nread != 1, then
	    b.ne	    end			        // read failed, so exit loop (EOF reached)

	    // 4.c: Write 1 byte from buffer to output file
	    mov	        w0, fdout_r
	    mov	        x1, buf_base_r
	    mov	        w2, buf_size
	    mov	        x8, 64
	    svc	        0
	    mov	        nwritten_r, x0

	    // 4.c: Error checking: writing to output file
	    cmp	        nwritten_r, buf_size
	    b.eq	    continue

	    // 4.c: Error message: failed to write to output file
	    adrp	    x0, fmt3
	    add	        x0, x0, :lo12:fmt3
	    mov	        x1, pnout_r
	    bl	        printf
	    mov	        w0, -1
	    b	        exit

continue:
	    b	        top			        // Go to top of loop indefinitely
					                    // Exit condition is when EOF is reached
					                    // We check for EOF after attempting to read in the loop

////////////////////////////////////////////////////////////////////////////////////////
/// 5. Close the binary files							     ///
////////////////////////////////////////////////////////////////////////////////////////
end:	mov	        w0, fdin_r		    // 1st arg (fd)
	    mov	        x8, 57			    // close I/O request
	    svc	        0			        // call system function

	    mov	        w0, fdout_r
	    mov	        x8, 57
	    svc	        0

////////////////////////////////////////////////////////////////////////////////////////
/// 6. Return 0									     ///
////////////////////////////////////////////////////////////////////////////////////////
	    mov	        w0, 0			    // return 0
exit:	ldp	        x29, x30, [sp], dealloc
	    ret

