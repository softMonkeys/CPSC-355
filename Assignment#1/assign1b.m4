// (Optimized version) Program to show the minimum of y = 5x^3 + 27x^2 - 27x - 43 in the range -6 <= x <= 6, by stepping through the range one by one in a loop and testing using M4 macros, place loop at end of pre-loop (to save one instruction)

// Define M4 macros
define(loop_r, x19)                             // loop counter register
define(fp, x29)                                 // frame pointer
define(lr, x30)                                 // link register
define(number_r, x20)                           // number (5, 27, -27, -43)  register
define(x_r, x21)                                // x register
define(variable_r, x22)                         // variable (5x^3, 27x^2, -27x) register
define(y_r, x23)                                // y register
define(minimum_r, x24)                          // minimum register

// Define format string for call to printf()
fmt_x:    .string "when x = %d, "
fmt_y:    .string "y = %d, "
fmt_min:  .string "current minimum = %d\n"
fmt_fmin: .string "********************************\nThe minimum of the function = %d\n********************************\n"

        // Define the main function for our program
        .balign 4                               // Instruction must be word aligned
        .global main                            // Make "main" visible to the OS
main:   stp    fp, lr, [sp, -16]!               // Save frame pointer (fp, x29) and link register (lr, x30) to stock, allocating 16 bytes, ore-increment SP
        mov    fp, sp                           // Update frame pointer (fp) to current stack pointer (sp) (after we've increment sp in the last step)

        mov    loop_r, -7                       // Set x19 general purpose register to -6, this will be the loop counter


        mov    number_r, 0 
        mov    x_r, 0               
        mov    variable_r, 0          
        mov    y_r, 0
        mov    minimum_r, 100

        b      test                             // Branch to loop test at bottom
        
top:    // Start of code inside loop
        // Calculating x
        adrp   x0, fmt_x                        // Set the 1st argument of printf(fmt_x, var1, var2) (high-order bits)
        add    x0, x0, :lo12:fmt_x              // Set the 1st argument of printf(fmt_x, var1, var2) (lower 12 bits)
        add    x1, loop_r, 1                    // Set the 2nd argument of printf(), we are adding one, then saving it to x1 registeras 2nd argument
        add    x_r, loop_r, 1
                                                // This is just to print -6-6, instead of -7-5.
        bl     printf                           // Call the printf() function
        // Calculating y
        adrp   x0, fmt_y                        // Set the 1st argument of printf(fmt_x, var1, var2) (high-order bits)
        add    x0, x0, :lo12:fmt_y              // Set the 1st argument of printf(fmt_x, var1, var2) (lower 12 bits)
        // 5x^3
        mul    variable_r, x_r, x_r             // x22 = x * x
        mul    variable_r, variable_r, x_r      // x22 = x^2 * x
        mov    number_r, 5                      // x20 = 5
        mul    variable_r, variable_r, number_r // x22 = x^3 * 5
        mov    y_r, variable_r                  // x23 = 5x^3
        // 27x^2
        mul    variable_r, x_r, x_r             // x22 = x * x
        mov    number_r, 27                     // x20 = 27
        madd   y_r, variable_r, number_r, y_r   // x23 = 5x^3 + (x^2 * 27)
        // -27x
        mov    number_r, -27                    // x20 = -27
        madd   y_r, number_r, x_r, y_r          // x23 = 5x^3 + 27x^2 + (-27 * x)
        // 5x^3 + 27x^2 - 27x - 43
        mov    number_r, -43                    // x20 = -43
        add    y_r, y_r, number_r               // x23 = 5x^3 + 27x^2 - 27x -43

        add    x1, y_r, 0                       // Pass the value of y to the display register x1

        bl     printf                           // Call the printf() function

        // Calculating the minimum value
        cmp    y_r, minimum_r
        b.ge   else                             // If y >= x24, move to else
        
        adrp   x0, fmt_min                      // Set the 1st argument of printf(fmt_min, var1, var2) (high-order bits)
        add    x0, x0, :lo12:fmt_min            // Set the 1st argument of printf(fmt_min, var1, var2) (lower 12 bits)
        
        mov    minimum_r, y_r                   // Overwrites the minimum value to y
        mov    x1, minimum_r                    // Pass the minimum value to the display register x1
        
else:   adrp   x0, fmt_min                      // Set the 1st argument of printf(fmt_min, var1, var2) (high-order bits)
        add    x0, x0, :lo12:fmt_min            // Set the 1st argument of printf(fmt_min, var1, var2) (lower 12 bits)

        mov    x1, minimum_r                    // Pass the minimum value to the display register x1

        bl     printf                           // Call the printf() function
       
        //End of codeinside the loop

        add    loop_r, loop_r, 1                // Increment loop by 1


        // Loop test        
test:   cmp    loop_r, 6
        b.lt   top                              // If [loop counter] >= 6, exit loop and branch to "done"


done:   // Prints the final minimum value
        adrp   x0, fmt_fmin                     // Set the 1st argument of printf(fmt_fmin, var1, var2) (high-order bits)
        add    x0, x0, :lo12:fmt_fmin           // Set the 1st argument of printf(fmt_fmin, var1, var2) (lower 12 bits)

        mov    x1, minimum_r                    // Set the final minimum value to the display register x1

fResult:bl     printf                           // Call the printf() function

        // Return 0 in main
        mov    w0, 0

        // Restore Registers and return to calling code (OS)
        ldp    fp, lr, [sp], 16                 // Restore FP and LR from stack, post-increment SP
        ret                                     // Return to caller
   
