// Hello World in Assembly

// Define string for call to printf()
Hello: .string "Hello, world!\n"

	// Define the main function of our program
	.balign 4			// Instruction must be word aligned
	.global main			// Make "main" visible to the OS
main:	stp x29, x30, [sp, -16]!	// Save FP and LR to stack, allocation 16 bytes, pre-increment SP
	mov x29, sp			// Update FP to current SP

	adrp x0, Hello			// set 1st argument to pass to printf(format, var1, var2...) (high-order bits)
	add x0, x0, :lo12:Hello		// set 1st arguemnt to pass to printf(format, var1, var2...) (lower 12 bits)
	bl printf			// Call the printf() funtion

	// Set up return value of zero from main()
	mov w0, 0
	
	ldp x29, x30, [sp], 16		// Restor FP and LR from stack, post-increment SP
	ret				// Return to caller
