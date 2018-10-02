// Credits: Professor Leonard Manzara
//
// NOTE: To test the program, run the program normally but add some command line arguments.
// Example: ./a.out 1 2 3
// Example: ./a.out MM DD YYYY

i_r	    .req	w19	// index for our loop (integer)
argc_r	.req	w20	// arg-count, or number of arguments passed into main() (integer)
argv_r	.req	x21	// arv-values, the base address of an array of pointers
			// each pointer points to an argument

// To load the values of each argument, you first get the base address of argv. Then you
// use left shift the index i_r (multiply 8) and use that as an offset to get the pointer
// for the argument you want. Load from that pointer to get the value of the argument.

fmt:	.string	"%s\n"

	    .balign 4
	    .global main
main:	stp	    x29, x30, [sp, -16]!
	    mov	    x29, sp

	    mov	    argc_r, w0			// copy argc
	    mov	    argv_r, x1			// copy argv

	    mov	    i_r, 1				// i= 0
	    b	    test

top:	adrp	x0, fmt
	    add	    x0, x0, :lo12:fmt		// set up 1st arg

	    ldr	    x1, [argv_r, i_r, SXTW 3]	// set up 2nd arg

	    bl	    printf				// call printf

	    add	    i_r, i_r, 1			// i++
test:	cmp	    i_r, argc_r			// loop while i < argc
	    b.lt	top

	    ldp	    x29, x30, [sp], 16
	    ret

