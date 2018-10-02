// Credits: Professor Leonard Manzara
// Comments were modified, and macros were replaced with register equates (.req)

i_r	        .req	w19
base_r	    .req	x20

	        .text
fmt:	    .string	"season[%d] = %s\n"		// String literals should not change during the program
						// and are placed in the .text (read-only) section

spr_m:	    .string	"spring"			// each string is pointed to by its label
sum_m:	    .string	"summer"
fal_m:	    .string	"fall"
win_m:	    .string	"winter"

	        .data
season_m:   .dword	spr_m, sum_m, fal_m, win_m	// This array is actually an array of pointers
						// Each pointer (label) points to a string.
						// Because addresses in ARMv8 are 64-bits, we need
						// to use dwords.

	        .text					// Program code is also read-only, and goes in .text
	        .balign 4				// Make sure to word align your program code again
	        .global main
main:	    stp	    x29, x30, [sp, -16]!
	        mov	    x29, sp

	        mov	    i_r, 0
	        b	    test

top:	    adrp	x0, fmt				// First argument to printf (string format)
	        add	    x0, x0, :lo12:fmt

	        mov	    w1, i_r				// Index to loop through seasons array

	        adrp	base_r, season_m		// get the base address of our pointer array
	        add     base_r, base_r, :lo12:season_m

	        ldr	    x2, [base_r, i_r, SXTW 3]	// use loop index as an offset, left-shift 3 to multiply by 8
						// remember, addresses are 8 bytes long

	        bl	    printf				// print the season loaded in x2

	        add	    i_r, i_r, 1
test:	    cmp	    i_r, 4				// pre-test loop to print all the seasons
	        b.lt	top

	        ldp	    x29, x30, [sp], 16
	        ret
