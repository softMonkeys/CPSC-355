// Simple program to show how to use printf from Assembly.

// Define for mat string for call to printf()
fmt:	.string "char: %c \nint: %d\n"

	// Define the main function for our program
	.balign 4			// Instruction must be word aligned
	.global main			// Make "main" visible to the OS
main:	stp  x29, x30, [sp, -16]		// Save frame pointer (FP, X29) and link register (LR, x30) to stack, allocating 16 bytes, pre-increment SP
	mov  x29, sp			// Update frame pointer (FP) to current stack pointer (SP) (after we've incremented SP in the last step)

	mov  w19, 66			// Move 65 to 32-bit general purpose register
					// Note: 65 is just a number, until the %c in the printf() format converts it to a character
	mov  w20, 42			// Move 42 to 32-bit general purpose register

	// Point the letter A and the number 42
	adrp x0, fmt			// set 1st argument to be passes to printf(format, var1, var2...) (higher-order bits)
	add  x0, x0, :lo12:fmt		// set 1st argument to be passed to printf(format, var1, var2...) (lower 12 bits)
	mov  w1, w19			// pass in the 2nd arugnment from 32-bit register w19
	mov  w2, w20			// pass in the 3rd argument from 32-bit register w29
	bl   printf			// use bl (branch to label) to call function printf()

	// Return 0 in the main, like we did in the C
	mov w0, 0

	// Restor registers and return to calling code (OS)
	ldp  x29, x30, [sp], 16		// Restore FP and LP from stack, post-increment SP
	ret				// Return to caller
