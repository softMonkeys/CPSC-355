// Copy src array to dest array

ARRAYSIZE = 5

	    .data
	    .global index
index: 	.word	0
src: 	.word	7, 11, 13, 43, 99

	    .bss
dest:	.skip	ARRAYSIZE * 4

	    .text
fmt1:	.string "\tARRAY[%d] = %d\n"
fmt2:	.string "Source Array\n"
fmt3:	.string "Destination Array\n"


	    .balign 4
	    .global main
main:	stp     x29, x30, [sp, -16]!
	    mov     x29, x30

//SET POINTERS//////////////////////////////////////////////////////////////////////
	    // set x28 as pointer to "index"
	    adrp    x28, index				// get the address to "index"
	    add     x28, x28, :lo12:index

	    // set x27 as pointer to array "src"
	    adrp    x27, src				// get the address "src"
	    add     x27, x27, :lo12:src

	    // set x26 as pointer to array "dest"
	    adrp    x26, dest				// get the address to "dest"
	    add     x26, x26, :lo12:dest


//PRINT SRC////////////////////////////////////////////////////////////////////////
	    // print out array_src header
	    adrp    x0, fmt2
	    add     x0, x0, :lo12:fmt2
	    bl      printf

	    // print out array_src contents
	    b       test
top:	adrp    x0, fmt1
	    add     x0, x0, :lo12:fmt1

	    mov     w1, w19

	    ldr     w2, [x27, w19, SXTW 2]		// use address of "src" as the base address
						    // apply offset with index
	    bl      printf

	    add     w19, w19, 1
	    str     w19, [x28]

test:	ldr     w19, [x28]
	    cmp     w19, ARRAYSIZE
	    b.lt    top


//COPY SRC TO DEST/////////////////////////////////////////////////////////////////
	    // copy array_src to array_dest
	    str     wzr, [x28]

	    b       test2
top2:	ldr     w20, [x27, w19, SXTW 2]		// load from src + index_offset
	    str     w20, [x26, w19, SXTW 2]		// store to dest + index_offset

	    add     w19, w19, 1
	    str     w19, [x28]

test2:	ldr     w19, [x28]
	    cmp     w19, ARRAYSIZE
	    b.lt    top2


//PRINT DEST////////////////////////////////////////////////////////////////////////
	    // print out array_dest header
	    adrp    x0, fmt3
	    add     x0, x0, :lo12:fmt3
	    bl      printf

	    // print out array_dest contents
	    str     wzr, [x28]                  //wzr = 0

	    b       test3
top3:	adrp    x0, fmt1
	    add     x0, x0, :lo12:fmt1

	    mov     w1, w19

	    ldr     w2, [x26, w19, SXTW 2]		// load from src + index_offset
	    bl      printf

	    add     w19, w19, 1
	    str     w19, [x28]

test3: 	ldr     w19, [x28]
	    cmp     w19, ARRAYSIZE
	    b.lt    top3

//DONE/////////////////////////////////////////////////////////////////////////////
done:	mov     w0, 0

	    ldp     x29, x30, [sp], -16
	    ret



