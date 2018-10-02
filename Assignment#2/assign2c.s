// Optimized program to implement the integer multiplication program in c Code by using 32-bit register for variables declared using int, and 64-bit register for variables declared using long int.

// Define M4 macros
// int
                                     // loop counter register
                                         // frame pointer
                                         // link register
                                    // multiplier register
                                  // multiplicand register
                                  // product register
                                     // flag register
                                   // true or false (1 or 0) register
//long int
                                   // result register
                                    // temperate value 1 register
                                    // temperate value 2 register
                                  // casting register

// Define format string for call to printf()
// print out initial values of variables
fmt_1:      .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
// print out product and multiplier
fmt_2:      .string "product = 0x%08x multiplier = 0x%08x \n"
// print out 64-bit result
fmt_3:      .string "64_bit result = 0x%016lx (%ld)\n"

            // Define the main function for our program
            .balign 4                                   // Instruction must be word aligned
            .global main                                // Make "main" visible to the OS

main:       stp         x29, x30, [sp, -16]!              // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov         x29, sp                          // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
        
            mov         w19, 0                       // Set w19 general purpose register to 0, this will be the loop counter
            mov         w20, -4096
            mov         w21, -16777216
            mov         w22, 0
            mov         w26, 0

            // Print out the initial values of variables
            adrp        x0, fmt_1                       // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add         x0, x0, :lo12:fmt_1             // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov         w1, w20
            mov         w2, w20
            mov         w3, w21
            mov         w4, w21
        
            bl          printf                          // Call the printf() function

            // Determine if multiplier is negative
            cmp         w20, 0                      
            b.ge        false                           // If multiplier >= 0, it will return false
            mov         w27, 1                     // If it is true, make true/false register to 1
            b           true                    

false:      mov         w27, 0                     // If it is false, make true/false register to 0
            

true:       // Do repeated add and shift
            b           test                            // Branch to loop test at bottom

top:        // Start of code inside loop
            ands        w26, w20, 0x1
            b.eq        continue                        // If = 0, go to continue
            add         w22, w22, w21


continue:   // Arithmetic shift right the combined product and multiplier
            asr         w20, w20, 1
            ands        w26, w22, 0x1
            b.eq        continue1           
        
            orr         w20, w20, 0x80000000
            b           next            

continue1:  and         w20, w20, 0x7FFFFFFF
            


next:       asr         w22, w22, 1
     
            // End of code inside the loop
            add         w19, w19, 1               // Increment loop by 1

            // Loop test
test:       cmp         w19, 32
            b.lt        top                             // If [loop counter] >= 32, exit loop and branch to "done"

done:       // Determine if multiplier is negative
            cmp         w27, 0
            b.eq        else                            // If w27 == 0 (false condition), branch to else
            sub         w22, w22, w21 // run if it is true
       
else:       // Print out product and multiplier   
            adrp        x0, fmt_2                       // Set the 1st argument of printf(fmt_2, var1, var2) (high-order bits)
            add         x0, x0, :lo12:fmt_2             // Set the 1st argument of printf(fmt_2, var1, var2) (lower 12 bits)
            mov         w1, w22
            mov         w2, w20

            bl          printf                          // Call the printf() function
    
            // Combine product and multiplier together
            sxtw        x28, w22
            and         x24, x28, 0xFFFFFFFF          
            lsl         x24, x24, 32
            sxtw        x28, w20
            and         x25, x28, 0xFFFFFFFF
            add         x23, x24, x25

            // Print out 64-bit result
            adrp        x0, fmt_3                       // Set the 1st argument of printf(fmt_3, var1, var2) (high-order bits)
            add         x0, x0, :lo12:fmt_3             // Set the 1st argument of printf(fmt_3, var1, var2) (lower 12 bits)
            mov         x1, x23
            mov         x2, x23

            bl          printf                          // Call the printf() function

            // Return 0 in main
            mov         w0, 0

            // Restore Registers and return to calling code (OS)
            ldp         x29, x30, [sp], 16                // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

