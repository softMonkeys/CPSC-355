// k = i + j
// Credits: Prof. Leonard Manzara

//DATA SECTION, READ/WRITE GLOBAL VARIABLES////////////////
	    .data
i_m: 	.word 2
j_m: 	.word 12
k_m: 	.word 0

//TEST SECTION, PROGRAM INSTRUCTIONS + WRITE-ONLY DATA/////
	    .text
fmt:	.string "i = %d\nj = %d\nk = i + j = %d\n"

	    .balign 4
	    .global main
main: 	stp     x29, x30, [sp, -16]!
	    mov     x29, sp

//LOAD i///////////////////////////////////////////////////
	    adrp    x19, i_m
	    add     x19, x19, :lo12:i_m
	    ldr     w20, [x19] 			// w20 = i

//LOAD j///////////////////////////////////////////////////
	    adrp    x19, j_m
	    add     x19, x19, :lo12:j_m
	    ldr     w21, [x19] 			// w21 = j

//ADD i and j//////////////////////////////////////////////
	    add     w22, w20, w21 		// w22 = i + j

//STORE k//////////////////////////////////////////////////
	    adrp    x19, k_m
	    add     x19, x19, :lo12:k_m
	    str     w22, [x19] 			// k = w22

//PRINT i, j, k////////////////////////////////////////////
	    adrp    x0, fmt
	    add     x0, x0, :lo12:fmt
	    mov     w1, w20
	    mov     w2, w21
	    mov     w3, w22
	    bl      printf

//DONE/////////////////////////////////////////////////////
	    mov     w0, 0

	    ldp     x29, x30, [sp], 16
	    ret
