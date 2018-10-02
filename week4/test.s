fmt:    .String "The value are %d and %d\n"

alloc = -(16 + 2 * 8) & -16                         // 2 means to store 2 numbers

        .balign 4
        .global main

main:
        stp     x29, x30, [sp, alloc]!              // allocate stack space
        mov     x29, sp                             // update fp

        // Store
        mov     x19, 478
        str     x19, [x29, 16]
        mov     x19, 453
        str     x19, [x29, 24]

        // Load 
        ldr     x1, [x29, 16]
        ldr     x2, [x29, 24]

        // Print
        adrp    x0, fmt                             // set format string high bits
        add     x0, x0, :lo12:fmt                   // set format string high bits 
        bl      printf                              // call printf function

        // Exit
        mov     w0, 0
        ldp     x29, x30, [sp], -alloc
        ret
