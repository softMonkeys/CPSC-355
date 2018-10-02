// Program to show how to use if/else-is/else inside a loop
// Loops 10 times: says if the current loop# is less than, greater than, or exactly 5.

// Define format string for call toprintf()
less:   .string "Loop #%d: %d is less than 5.\n"
greater:.string "Loop #%d: %d is greater than 5.\n"
equal:  .string "Loop #%d: Exactly 5! (Ya I know this program is stupid too.)\n"

    // Define the main function for our program
        .balign 4                   // Instructions must be word aligned
        .global main                // Make "main" visible to the OS
main:   stp    x29, x30, [sp, -16]! // Save frame pointer (FP, x29) and link register (LR, x30) to stack, allocating 16 bytes, pre-increment SP
        mov    x29, sp              // Update frame pointer (FP) to current stack pointer (SP) (after we've incremented sp in the last step)
        
        mov    x19, 1               // Set x19 general purpose register to 0, this will be the loop counter

        // While loop (pre-test, so check before the first iteration)
        // Let's loop 10 times, printing out each number.
test:   cmp    x19, 10              // Compare loop counter and 10
        b.gt   done                 // If [loop counter] > 10, exit loop and branch to "done"

        // Start of code inside the loop

        // If loop# < 5
        cmp    x19, 5
        b.ge   elseif               // If loop# >= 5, then condition is NOT satisfied, move to next if (elseif)

        adrp   x0, less             // Set the 1st argument of printf(less, var1, var2...) (high-order bits)
        add    x0, x0, :lo12:less   // Set the 1st argument of printf(less, var1, var2...) (lower 12 bits)
        mov    x1, x19              // Set the 2nd argument of printf()
                                    // We are adding one, then saving it to x1 register as 2nd argument
                                    // This is just to print 1-10 instead of 1-9
        mov    x2, x1               // Set the 3rd argument of printf()
        b      next                 // Since

        // Else-if loop# > 5
elseif: cmp    x19, 5
        b.le   else                 // If loop# <= 5, then condition is NOT satisfied, move to next part (else)

        adrp   x0, greater
        add    x0, x0, :lo12:greater
        mov    x1, x19
        mov    x2, x1
        
        b      next

        // Else (loop# == 5)
else:   adrp   x0, equal            // Else catches everything else, if it reaches here then just proceed, no need to compare 
        add    x0, x0, :lo12:equal
        mov   x1, x19

        // In the conditionals we set the arguments for printf(), so let's call it now
next:   bl     printf               // Call the printf() function

        // End of code inside the loop

        add    x19, x19, 1          // Increment loop counter by 1
        b      test

// Return 0 in main, like we did in C
done:   mov    w0, 0

        // Restore registers and return to calling code(OS)
        ldp    x29, x30, [sp], 16   // Restore FP and LR from stack, post-increment sp
        ret                         // REturn to caller




















