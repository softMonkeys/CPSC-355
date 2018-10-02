// The ARMv8 assembly language program to compute the functions e^x and e^-x using the series expansions. The program will read a series of input values from a file whose name is specified at the command line. The input values will be in binary format; each namber will be double precision. Read from the file using system I/O. Process the input values one at a time using a loop, calculate e^x and e^-x, and then use printf() to print out the input value and its corresponding output values in table form. The program will eventually print out all values with a precicsion of 10 decimal digits to the right of the decimal point.
// Define macros registers














// Assembler equates
buf_size = 8
alloc = -(16 + buf_size) & -16
dealloc = -alloc
buf_s = 16
AT_FDCWD = -100
        .data
const_m:.double 0r1.0e-10               // Initialize the limit where the calculation ends
        .text
// Define format string for call to printf()
fmt_err:.string "Error opening file"
fmt_lab:.string " x                   e^x                  e^-x\n"
fmt_pt:	.string "%13.10f \t %16.10f \t %13.10f \t \n"
fmt_3:	.string "N: %13.10f, D: %13.10f, ratio: %13.10f, totalRatio: %13.10f\n\n"
fmt_4:	.string "Current sign %13.10f\n"
        // Define the main function for our program
        .balign 4                       // Instruction must be word aligned
        .global main                    // Make "main" visible to the OS
main:	stp	    x29, x30, [sp, alloc]!  // Save frame pointer (fp, x29) and link register (lr, x30) to stock, allocating 16 bytes, ore-increment SP
	    mov	    x29, sp                 // Update frame pointer (fp) to current stack pointer (sp) (after we've increment sp in the last step)
	    fmov	d26, 1.0e+0          // Initialize loop counter to 1
	    // int fd = openat(int dirfd, const char *pathname, int flags, mode_t mode);
	    // Open existing binary file
	    mov	    w0, AT_FDCWD		    // 1st arg (cwd)
	    ldr	    x1, [x1, 8]             // load the file name on command line
	    mov	    w2, 0			        // 3rd arg (read-only)
	    mov	    w3, 0			        // 4th arg (not used)
	    mov	    x8, 56			        // openat I/O request
	    svc	    0			            // call system function
	    mov	    w19, w0		        // Record file descriptor
	    // Do error checking for openat()
	    cmp	    w19, 0			        // error check: branch over
	    b.ge	true			        // if file opened successfully
	    adrp	x0, fmt_err		        // Set the 1st argument of printf(fmt_x, var1, var2) (high-order bits)
	    add	    x0, x0, :lo12:fmt_err	// Set the 1st argument of printf(fmt_x, var1, var2) (lower 12 bits)
	    bl	    printf			        // Call the printf() function
	    mov	    w0, -1			        // return -1
	    b	    exit			        // branch to the exit
true:   adrp	x0, fmt_lab		        // Set the 1st argument of printf(fmt_x, var1, var2) (high-order bits)
	    add	    x0, x0, :lo12:fmt_lab	// Set the 1st argument of printf(fmt_x, var1, var2) (lower 12 bits)
	    bl	    printf			        // Call the printf() function
        add	    x21, x29, buf_s	// calculate buf base
	    // long n_read = read(int fd, void *buf, unsigned long n);
	    // Read long ints from bniary file one buffer at a time in a loop
top:	mov	    w0, w19		        // 1st arg (fd), reads from this file
	    mov	    x1, x21		    // 2nd arg (buf), stores it here
	    mov	    w2, buf_size		    // 3rd arg (n), reads 8 bytes at a time 
	    mov	    x8, 63			        // read I/O request, 63 is call for read
	    svc	    0			            // call system function
	    mov	    x20, x0		        // record $ of bytes actually read, result stored in x0, result in this case returns how many bytes were actually read
	    // Do error checking for read()
	    cmp	    x20, buf_size	    // if nread != 8, then check to make sure data matches buffer size, only way to exit is if reached the end of file
	    b.ne	end			            // read failed, branch to exit
//--Start calculation------------------------------------------------------------------------------------------------------------------------------------------
	    //Caluculates e^x
	    ldr	    d0, [x21]        // load the x	
	    fmov    d30, 1.0             // intialize the sign
	    fmov    d1, d30              // move the sign into second argument
	    bl	    calc                    // call calc
	    fmov    d16, d0                // d16 is the result for e^x
	    //Caluculates e^-x
	    ldr	    d0, [x21]        // load the x
	    fmov    d30, -1.0            // intialize the sign
	    fmov    d1, d30              // move the sign into second argument
	    bl	    calc                    // call calc
	    fmov    d17, d0               // d17 is the result for e^x
//--End calculation------------------------------------------------------------------------------------------------------------------------------------------
	    adrp	x0, fmt_pt		        // Set the 1st argument of printf(fmt_x, var1, var2) (high-order bits)
	    add	    x0, x0, :lo12:fmt_pt    // Set the 1st argument of printf(fmt_x, var1, var2) (lower 12 bits)
	    ldr	    d0, [x21]	    // 2nd arg (the long int), load the read 8 bytes from the buffer, d register for double precision 
	    fmov    d1, d16                // 3rd arg (the e^x)
	    fmov    d2, d17               // 4th arg (the e^-x)
	    bl	    printf			        // Call the printf() function
	    b	    top			            // branch to top
	    // Close the binary file
end:	mov	    w0, w19		        // 1st arg (fd)
	    mov	    x8, 57			        // close I/O request
	    svc	    0			            // call system function
	    mov	    w0, 0			        // return 0
exit:	ldp	    x29, x30, [sp], dealloc // Restore FP and LR from stack, post-increment SP
	    ret                             // Return to caller

// The function takes in an input x and a sign value, returns the final value after expansions
calc:   stp	    x29, x30, [sp, -16]!    // Save frame pointer (fp, x29) and link register (lr, x30) to stock, allocating 16 bytes, ore-increment SP
	    mov	    x29, sp                 // Update frame pointer (fp) to current stack pointer (sp) (after we've increment sp in the last step)
	    //initializing variables
	    fmov    d28, d0             // x value
	    fmov    d30, d1              // sign(+ or -)
	    fmov    d29, 1.0
	    fmov    d24, d28
	    fmov    d27, 1.0
	    fmov    d25, 1.0
	    fmov    d22, xzr
top2:   fdiv    d23, d24, d25
	    //continue if d23 bigger than the limit constant 1.0e-10
	    adrp    x26, const_m            // get the base address of our pointer
	    add	    x26, x26, :lo12:const_m
	    ldr	    d26, [x26]           // load the value of top into w1 register
	    fcmp    d23, d26         // if the d23 bigger than the limit constant 1.0e-10, continue
	    b.le    addOne                  // else, branch to addOne
	    //adjust sign of ratio based on input
	    fmul    d29, d29, d30    // change the sign
	    fmul    d23, d23, d29
	    fadd    d22, d22, d23 // all ratios calculated individually and then added to d22
	    //calculate next numerator and denominator 
	    fmul    d24, d28, d24   // numerator will be multiplied by original input for every iteration
	    fmov    d26, 1.0             // intialize loop counter back to 1.0
	    fadd    d27, d27, d26    // counter++
	    fmul    d25, d25, d27 //denominator multiplied by the incremented counter for every iteration
	    b	    top2                    // brach back to top
        // Add one to d22 then exit
addOne: fmov    d26, 1.0             // intialize loop counter back to 1.0
	    fadd    d22, d22, d26  // totalRatio++
	    fmov    d0, d22        // return d22
	    ldp	    x29, x30, [sp], 16      // Restore FP and LR from stack, post-increment SP
	    ret                             // Return to caller

