// Converts a number from ASCII string to int
// Usage: ./a.out 12345
// Output: "The number you entered is: 12345"

	    .text
fmt:	.string	"The number you entered is: %d\n"	// format takes an int variable

	    .balign 4
	    .global main
main:	stp     x29, x30, [sp, -16]!
	    mov     x29, sp

	    mov     w19, 1			// the 1st arg (index 0) is the program name
					    // we want the 2nd arg, the number entered

	    ldr     x0, [x1, w19, SXTW 3]	// x1 is the base address to the external pointer
					// array containing pointers to all our args
					// w19 (1) is the index, SXTW 3 to calculate offset
	    bl      atoi				// convert ASCII string to integer, result in w0

	    mov     w1, w0			// set up 2nd arg for printf
	    adrp    x0, fmt			// set up 1st arg for printf
	    add     x0, x0, :lo12:fmt
	    bl      printf			// print the number

	    mov     w0, 0
	    ldp     x29, x30, [sp], 16
	    ret
