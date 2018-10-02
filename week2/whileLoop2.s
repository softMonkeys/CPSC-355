// Shows how to optimize the whileloop.s code.
// Loops ten times, prints the loop # each iteration.
// Uses M4 macros, places loop at end of pre-test loop (to save one instruction)
// Don't forget to optimize your assignment with instructions like madd or msub

// Define M4 macros
 // loop counter register
     // frame pointer
     // link register

// Define format string for call to printf()
whileLoop2: .string "Loop: %d\n"

      // Define the main function for our program
      .balign 4                        // Instructions must be word aligned
      .global main                     // Make "main" visible to the OS
main: stp  x29, x30, [sp, -16]!          // Save frame pointer (x29, x29) and link register (x30, x30) to stack, allocating 16 bytes, pre-increment SP
      mov  x29, sp                      // Update frame pointer (x29) to current stack pointer (sp) (after we've incremented sp in the last step)

      mov  x19, 0                   // Set x19 general purpose register to 0, this will be the loop counter

      // Optimized While loop (pre-test, so check before the first iteration)
      // By placing the test at the bottom, we save one instruction
      // Let's loop 10 times, printing out each number.

      b    test                        // Branch to loop test at bottom
                                       // NOTICE how this branch instruction only happens ONCE, OUTSIDE THE LOOP.
                                       // In the unoptimized version, this instruction is executed in every iteration.
                                       // Even though the test code is below the loop code, this is still a pre-test loop
                                       // because we branch directly to the loop, before executing the loop (if the loop
                                       // condition is satisfied).

top:  // Start of code inside the loop
      adrp x0, whileLoop2                     // Set the 1st argument of printf(fmt, var1, var2...) (high-order bits)
      add  x0, x0, :lo12:whileLoop2           // Set the 1st argument of printf(fmt, var1, var2...) (lower 12 bits)
      add  x1, x19, 1               // Set the 2nd argument of printf(). 
                                       // We are adding one, then saving it to x1 register as 2nd argument
                                       // This is just to print 1-10, instead of 0-9
      bl   printf                      // Call the printf() function
      // End of code inside the loop

      add  x19, x19, 1           // Increment loop counter by 1

      // Loop test
test: cmp  x19, 10                  // Compare loop counter and 10
      b.lt top                         // If [loop counter]>=10, exit loop and branch to "done"

      // Return 0 in main, like we did in C
done: mov  w0, 0

      // Restore registers and return to calling code (OS)
      ldp  x29, x30, [sp], 16            // Restore x29 and x30 from stack, post-increment sp
      ret                              // Return to caller
