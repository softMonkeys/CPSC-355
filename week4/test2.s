fmt:    .String "The value are %d, %d, %d, %d, %d\n"

alloc = -(16 + 5 * 8) & -16                         // 5 means to store 5 numbers

        .balign 4
        .global main

main:
        stp     x29, x30, [sp, alloc]!              // allocate stack space
        mov     x29, sp                             // update fp

        // Store
        mov     x19, 1
        str     x19, [x29, 16]
        mov     x19, 2
        str     x19, [x29, 24] 
        mov     x19, 3
        str     x19, [x29, 32]
        mov     x19, 4
        str     x19, [x29, 40]
        mov     x19, 5
        str     x19, [x29, 48]

        // Load 
        ldr     x1, [x29, 16]
        ldr     x2, [x29, 24]
        ldr     x3, [x29, 32]
        ldr     x4, [x29, 40]
        ldr     x5, [x29, 48]

        // Print
        adrp    x0, fmt                             // set format string high bits
        add     x0, x0, :lo12:fmt                   // set format string high bits 
        bl      printf                              // call printf function

        // Exit
        mov     w0, 0
        ldp     x29, x30, [sp], -alloc
        ret

