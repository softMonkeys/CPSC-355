// Program to show how to usd gdb
// Loops 10 times, printing out the square of each loop #. (eg. 1^2 = 1, 2^2 = 4...)


// Define title and format strings for our calls to printf()
title:	.string "gdb Example Program (Squaring)\n"
fmt:	.string "%d^2 = %d\n"

	    // Define the main function for our program
	    .balign	4				        // Instructions must be word aligned
	    .global	main				    // Make "main" visible to the OS

main:	stp	    x29, x30, [sp, -16]!	// Save frame pointer (fp, x29) and link register (lr, x30) to stack, allocating 16 byes, pre-increment SP
	    mov     x29, sp				    // Update frame pointer (fp) to current stack pointer (sp) (after we've incremented sp in the last step)

	    mov	    x24, 12345
	    str	    x24, [sp, 16]

	    mov	    x25, 2468
	    str	    x25, [sp, 24]

	    mov	    x26, 0xffffffff
	    str	    x26, [sp, 32]

	    // Variables
	    mov	    x19, 0				    // Initialize loop counter variable

	    adrp	x0, title			    // Calculate address of "title" down to 4KB
	    add	    x0, x0, :lo12:title		// Calculate address of "title" (remaining lower 12 bits = 2^12 = 4096bits = 4KB)
	    bl	    printf				    // Print the title of the program

	    b	    test				    // Pre-test, but optimized with test at the bottom of the loop

top:	adrp	x0, fmt				    // Calculate address of "fmt" down to 4KB
	    add	    x0, x0, :lo12:fmt		// Calculate address of "fmt" (remaining lower 12bits = 2^12 = 4096bits = 4KB)
	    mov	    x1, x19				    // Set 2nd argument (first variable passed into printf)
	    mul	    x2, x19, x19			// Set 3rd argument (second variable passed into printf)
	    bl	    printf				    // Print the numbers for this iteration

	    add	    x19, x19, 1			    // Increment loop counter by 1

test: 	cmp     x19, 10				    // Compare loop counter and 10
	    b.lt    top				        // If [loop counter]>=10, exit loop and branch to "done"
    
	    // Return 0 in main
done:	mov     w0, 0

	    // Restore register and return to calling code (OS)
	    ldp	    x29, x30, [sp], 16		// Restore fp and lr from stack, post-increment sp
	    ret					            // Return to caller
