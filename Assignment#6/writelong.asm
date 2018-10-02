// File:	writelong.asm
// Author: Leonard Manzara
// Date: November 19, 2016
//
// Description: This program is the companion to readlong.asm.
// It writes 100 long integers to the binary file called output.bin.
// This program demonstrates how to open, write, and close a file
// using system I/O.

	    // Define macros for heavily used registers
	    define(fd_r, w19)
	    define(i_r, x20)
	    define(nwritten_r, x21)
	    define(buf_base_r, x22)

	    // Assembler equates
	    buf_size = 8
	    alloc = -(16 + buf_size) & -16
	    dealloc = -alloc
	    buf_s = 16
	    upper_limit = 100
	    AT_FDCWD = -100

	    // Format strings
pn:	    .string "output.bin"
fmt1:	.string	"Error opening file: %s\nAborting.\n"
fmt2:	.string	"Error writing to file. Aborting.\n"


	    .balign 4
	    .global main
main:	stp	    x29, x30, [sp, alloc]!
	    mov	    x29, sp

	    // Create a new binary file
	    mov	    w0, AT_FDCWD		// 1st arg (cwd)
	    adrp	x1, pn			    // 2nd arg (pathname)
	    add	    x1, x1, :lo12:pn
	    mov	    w2, 01 | 0100 | 0100	// 3rd arg (write-only, creat, trunc)
	    mov	    w3, 0666		    // 4th arg (rw for all)
	    mov	    x8, 56			    // openat I/O request
	    svc	    0			        // call system function

	    mov	    fd_r, w0		    // Record file descriptor

	    // Do error checking for openat()
	    cmp	    fd_r, 0			    // error check
	    b.ge	openok			    // branch over if ok

	    adrp	x0, fmt1		    // error handling code
	    add	    x0, x0, :lo12:fmt1	// 1st arg
	    adrp	x1, pn			    // 2nd arg
	    add	    x1, x1, :lo12:pn
	    bl	    printf			    // print error message
	    mov	    w0, -1			    // return -1
	    b	    exit

openok:	add	    buf_base_r, x29, buf_s	// calculate buf base


	    // Write out 100 long ints to binary file in a loop
	    mov	    i_r, 0			    // i = 0
	    b	    test			    // branch to loop test

top:	str	i_r, [buf_base_r]	    // copy i into buf

	    // Write out buffer to file
	    mov	    w0, fd_r		    // 1st arg (fd)
	    mov	    x1, buf_base_r		// 2nd arg (buf)
	    mov	    w2, buf_size		// 3rd arg (BUFSIZE)
	    mov	    x8, 64			    // write I/O request
	    svc	    0			        // call system function
	    mov	    nwritten_r, x0		// record nwritten

	    // Do error checking for write()
	    cmp	    nwritten_r, buf_size// if nwritten == 8
	    b.eq	endif			    // then write succeeded

	    // Handle the write error
	    adrp	x0, fmt2		    // 1st arg
	    add	    x0, x0, :lo12:fmt2
	    bl	    printf			    // all printf()
	    b	    exit			    // break out of loop

	    // Bottom of loop
endif:	add	    i_r, i_r, 1		    // i++
test:	cmp	    i_r, upper_limit	// keep looping while
	    b.lt	top			        // i < upper limit


	    // Close the binary file
	    mov	    w0, fd_r		    // 1st arg (fd)
	    mov	    x8, 57			    // close I/O request
	    svc	    0			        // call system function

	    mov	    w0, 0			    // return 0
exit:	ldp	    x29, x30, [sp], dealloc
	    ret

