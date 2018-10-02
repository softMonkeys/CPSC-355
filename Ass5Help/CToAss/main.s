i_size = 4
j_size = 4
result_size = 4
alloc = -(16 + i_size + j_size + result_size) & -16
dealloc = -alloc

i_m = 16
j_m = 20
result_m = 24

fmt:	.string "result = %d\n"

	    .balign 4
	    .global main
main:	stp     x29, x30, [sp, alloc]!
	    mov     x29, sp

	    mov     w19, 5
	    str     w19, [x29, i_m]		// i = 5
	    mov     w19, 10
	    str     w19, [x29, j_m]		// j = 10

	    ldr     w0, [x29, i_m]
	    ldr     w1, [x29, j_m]
	    bl      sum				    // function defined in sum.c

        str     w0, [x29, result_size]
        ldr     w1, [x29, result_size]
	    
        adrp    x0, fmt
	    add     x0, x0, :lo12:fmt		// set up 1st arg
	    bl      printf			    // function defined in library

	    ldp     x29, x30, [sp], dealloc
	    ret
