fmt:	.string "The sum is %d\n"     // our format string

alloc = -(16 + 5 * 8) & -16

	    .balign 4                     // ensure aligned to a 4-byte boundary
	    .global main                  // make main visible to linker

main:   stp	    x29, x30, [sp, alloc]!    // allocate stack space
	    mov	    x29, sp                   // update fp

	    // store
	    mov	    x19, 1
	    str	    x19, [x29, 16]
	    mov	    x19, 2
	    str	    x19, [x29, 24]
	    mov	    x19, 3
	    str	    x19, [x29, 32]
	    mov	    x19, 4
	    str	    x19, [x29, 40]
	    mov	    x19, 5
	    str	    x19, [x29, 48]

	    // load
	    mov	    x19, 0                // total
	    mov	    x21, 16               // offset
	    mov	    x22, 0                // loop counter

loop:
	    ldr	    x20, [x29, x21]       // load value
	    add	    x19, x19, x20         // add value to total
	    add	    x21, x21, 8           // increment load offset
	    add	    x22, x22, 1           // increment loop counter
	    cmp	    x22, 5                // check if loop done
	    b.lt	loop                  // maybe branch to top of loop

	    // print
	    adrp	x0, fmt              // set format string high bits
	    add	    x0, x0, :lo12:fmt    // set format string low bits
	    mov 	x1, x19              // set total
	    bl	    printf               // call printf

	    // exit
    	mov	    w0, 0                    // set return value
	    ldp	    x29, x30, [sp], -alloc   // restore stack
	    ret                              // return to OS

