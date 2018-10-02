// Assembly to C program. These functions will be called from the main() function given in C source code file called a5aMain.c
                                         // frame pointer
                                         // link register
                                    // value register
                                        // i counter register
                                     // temporary variable register
// GLOBAL VARIABLES
STACKSIZE = 5                                           // define size of the stack
FALSE = 0                                               // define false to 0
TRUE = 1                                                // define true to 1
base_r  .req    x20                                     // bass address
        .bss
        .global dest                                    // make stack global
dest:   .skip   STACKSIZE * 4                           // each stack has size 5
        .data
// Create a pointer. it points to an interger
        .global top
top:    .word   -1
        .text                                           // Program code is read-only, goes in .text
// Define strings
fmt_fl: .string "\nStack overflow! Cannot push value onto stack.\n"
fmt_uw: .string "\nStack underflow! Cannot pop an empty stack.\n"
fmt_ey: .string "\nEmpty Stack\n"
fmt_cn: .string "\nCurrent stack contents:\n"
fmt_top:.string " <-- top of stack"
fmt_new:.string "\n"
fmt_d:  .string "  %d"

// void push(int value)
            .balign 4                                   // Instruction must be word aligned
            .global push                                // Make "main" visible to the OS
push:       stp     x29, x30, [sp, -16]!                  // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov     x29, sp                              // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
            mov     w24, w0                         // move the value of "value" into a temporary register 
            bl      stackFull                           // call stackFull function
            cmp     w0, FALSE                           // checks if the stackFull function returns false 
            b.eq    plus                                // if it is false, branch to plus(else) statement
            adrp    x0, fmt_fl                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_fl                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            bl      printf                              // call printf function
            b       done                                // branch to done
plus:       adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     w22, w1                          // move value of top into a temporary register
            add     w22, w22, 1                   // top++
            str     w22, [base_r]                    // store top back to it's memory address
            adrp    base_r, dest                        // get the base address of our pointer
            add     base_r, base_r, :lo12:dest
            str     w24, [base_r, w22, SXTW 2]   // store the value into the stack at index of top
done:       ldp     x29, x30, [sp], 16                    // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

// pop()
            .global pop                                 // Make "pop" visible to the OS
pop:        stp     x29, x30, [sp, -16]!                  // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov     x29, sp                              // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
            bl      stackEmpty                          // call stackEmpty function
            cmp     w0, FALSE                           // checks if the stackEmpty function returns false 
            b.eq    pop1                                // if it is false, branch to pop1(else) statement
            adrp    x0, fmt_uw                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_uw                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            bl      printf                              // call printf function
            mov     w0, -1                              // return -1
            b       done1                               // brach to done1
pop1:       adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     w22, w1                          // move value of top into a temporary register
            adrp    base_r, dest                        // get the base address of our pointer
            add     base_r, base_r, :lo12:dest
            ldr     w24, [base_r, w22, SXTW 2]   // load the value of stack at index of top into value
            sub     w22, w22, 1                   // top--
            adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            str     w22, [base_r]                    // store top into memory
            mov     w0, w24                         // return value
done1:      ldp     x29, x30, [sp], 16                    // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

// stackFull()
            .global stackFull                           // Make "stackFull" visible to the OS
stackFull:  stp     x29, x30, [sp, -16]!                  // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov     x29, sp                              // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
            mov     w19, STACKSIZE                      // move the size of the stack into a temporary register
            sub     w19, w19, 1                         // stack size - 1
            adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     w22, w1                          // move top into a temporary register
            cmp     w22, w19                         // compare if top equals ro stack size minus 1
            b.eq    true                                // if equal, branch to true
            mov     w0, FALSE                           // if false, move 0 into return register
            b       done2                               // brach to done2
true:       mov     w0, TRUE                            // if true, move 1 into return register
done2:      ldp     x29, x30, [sp], 16                    // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

// stackEmpty()
            .global stackEmpty                          // Make "stackEmpty" visible to the OS
stackEmpty: stp     x29, x30, [sp, -16]!                  // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov     x29, sp                              // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
            adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     w22, w1                          // move top into a temporary register
            cmp     w22, -1                          // compare top with -1
            b.eq    true1                               // if top equals to -1, beanch to true1
            mov     w0, FALSE                           // if false, move 0 into return register
            b       done3                               // branch to done3
true1:      mov     w0, TRUE                            // if true, move 1 into return register
done3:      ldp     x29, x30, [sp], 16                    // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

// display()
            .global display                             // Make "display" visible to the OS
display:    stp     x29, x30, [sp, -16]!                  // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov     x29, sp                              // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
            bl      stackEmpty                          // call stackEmpty function
            cmp     w0, FALSE                           // check if stack is empty                           
            b.eq    last                                // if return value is 0, it means false, then branch to last
            adrp    x0, fmt_ey                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_ey                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            bl      printf                              // call printf function
            b       done4                               // brach to done4
last:       adrp    x0, fmt_cn                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_cn                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            bl      printf                              // call printf function
            adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     w21, w1                             // i = top
            b       test                                // brach to test
start:      // Start of code inside loop
            adrp    base_r, dest                        // get the base address of our pointer
            add     base_r, base_r, :lo12:dest
            ldr     w24, [base_r, w21, SXTW 2]      // load the value of stack at index of top into value
            adrp    x0, fmt_d                           // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_d                 // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov     w1, w24                         // move value into display register
            bl      printf                              // call printf function
            adrp    base_r, top                         // get the base address of our pointer
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            cmp     w21, w1                             // compare i with top
            sub     w21, w21, 1                         // i--
            b.eq    prinTop                             // if i ==top, branch to prinTop
            b       end                                 // branch to end
prinTop:    adrp    x0, fmt_top                         // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_top               // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            bl      printf                              // call printf function
end:        adrp    x0, fmt_new                         // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add     w0, w0, :lo12:fmt_new               // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            bl      printf                              // call printf function
test:       cmp     w21, 0                              // compare i with 0
            b.ge    start                               // if i smaller than 0, jump out of loop
done4:      ldp     x29, x30, [sp], 16                    // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

