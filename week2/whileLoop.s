// Program to show how to use a while-loop. (unoptimized)
// Loops 10 times, prints the loop # each iteration.

// Define format string for call to printf()
whileLoop: .string "Loop: %d\n"

        // Define the main function for our program
        .balign 4                       // Instructions must be word aligned
        .global main                    // Make "main" visible to the OS
main:   stp  x29, x30, [sp, -16]!       // Save frame pointer (FP, x29) and link register (LS, x30) to stack, allocating 16 bytes, pre-increment SP
        mov  x29, sp                    // Update frame pointer (FP) to current stack pointer (SP) (after we've incremented SP in the last step)

        mov  x19, 0                     // Set x19 general purpose register to 0, this will be the loop counter

        // While loop (pre-test, so check before the first iteration)
        // Let's loop 10 times, printing out each number
test:   cmp  x19, 10                    // Compare loop counter and 10
        b.ge done                       // If [loop counter] >= 10, exit loop branch to "done"

        // Start of code inside the loop
        adrp x0, whileLoop              // Set the 1st argument of printf(whileLoop, var1, var2...) (high-order bits)
        add  x0, x0, :lo12: whileLoop   // Set the 1st argument of printf(whileLoop, var1, var2...) (lower 12 bits)
        add  x1, x19, 1                 // Set the 2nd argument of printf().
                                        // We are adding one, then saving it to x1 register as 2nd argument
                                        // This is just to print 1-10, instead of 0-9
        bl   printf                     // Call the printf() function
        // End of code inside the loop

        add  x19, x19, 1                // Increment loop counter by 1
        b    test                       // Loop iteration has ended, goto test to see if we should execute loop again

        // Return 0 in main, like we did in C
done:   mov  w0, 0

        // Restore register and return to calling code (OS)
        ldp  x29, x30, [sp], 16         // Restore FP and LP from stack, post-increment SP
        ret                             // Return to caller
