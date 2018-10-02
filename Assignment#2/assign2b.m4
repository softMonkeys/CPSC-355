// Optimized program to implement the integer multiplication program in c Code by using 32-bit register for variables declared using int, and 64-bit register for variables declared using long int.

// Define M4 macros
// int
define(loop_r, w19)                                     // loop counter register
define(fp, x29)                                         // frame pointer
define(lr, x30)                                         // link register
define(muler_r, w20)                                    // multiplier register
define(mulcand_r, w21)                                  // multiplicand register
define(product_r, w22)                                  // product register
define(flag_r, w26)                                     // flag register
define(muler1_r, w27)                                   // true or false (1 or 0) register
//long int
define(result_r, x23)                                   // result register
define(temp1_r, x24)                                    // temperate value 1 register
define(temp2_r, x25)                                    // temperate value 2 register
define(casting_r, x28)                                  // casting register

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

main:       stp         fp, lr, [sp, -16]!              // Save frame pointer (fp, x29) and link register (lr, x30) to stock, allocating 16 bytes, ore_increment SP
            mov         fp, sp                          // Update frame pointer (fp) to current stack pointer (sp) (after we've increment sp in the last step)
        
            mov         loop_r, 0                       // Set w19 general purpose register to 0, this will be the loop counter
            mov         muler_r, 100
            mov         mulcand_r, 268435455
            mov         product_r, 0
            mov         flag_r, 0

            // Print out the initial values of variables
            adrp        x0, fmt_1                       // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add         x0, x0, :lo12:fmt_1             // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov         w1, muler_r
            mov         w2, muler_r
            mov         w3, mulcand_r
            mov         w4, mulcand_r
        
            bl          printf                          // Call the printf() function

            // Determine if multiplier is negative
            cmp         muler_r, 0                      
            b.ge        false                           // If multiplier >= 0, it will return false
            mov         muler1_r, 1                     // If it is true, make true/false register to 1
            b           true                    

false:      mov         muler1_r, 0                     // If it is false, make true/false register to 0
            

true:       // Do repeated add and shift
            b           test                            // Branch to loop test at bottom

top:        // Start of code inside loop
            ands        flag_r, muler_r, 0x1
            b.eq        continue                        // If = 0, go to continue
            add         product_r, product_r, mulcand_r


continue:   // Arithmetic shift right the combined product and multiplier
            asr         muler_r, muler_r, 1
            ands        flag_r, product_r, 0x1
            b.eq        continue1           
        
            orr         muler_r, muler_r, 0x80000000
            b           next            

continue1:  and         muler_r, muler_r, 0x7FFFFFFF
            


next:       asr         product_r, product_r, 1
     
            // End of code inside the loop
            add         loop_r, loop_r, 1               // Increment loop by 1

            // Loop test
test:       cmp         loop_r, 32
            b.lt        top                             // If [loop counter] >= 32, exit loop and branch to "done"

done:       // Determine if multiplier is negative
            cmp         muler1_r, 0
            b.eq        else                            // If muler1_r == 0 (false condition), branch to else
            sub         product_r, product_r, mulcand_r // run if it is true
       
else:       // Print out product and multiplier   
            adrp        x0, fmt_2                       // Set the 1st argument of printf(fmt_2, var1, var2) (high-order bits)
            add         x0, x0, :lo12:fmt_2             // Set the 1st argument of printf(fmt_2, var1, var2) (lower 12 bits)
            mov         w1, product_r
            mov         w2, muler_r

            bl          printf                          // Call the printf() function
    
            // Combine product and multiplier together
            sxtw        x28, w22
            and         temp1_r, x28, 0xFFFFFFFF          
            lsl         temp1_r, temp1_r, 32
            sxtw        x28, w20
            and         temp2_r, x28, 0xFFFFFFFF
            add         result_r, temp1_r, temp2_r

            // Print out 64-bit result
            adrp        x0, fmt_3                       // Set the 1st argument of printf(fmt_3, var1, var2) (high-order bits)
            add         x0, x0, :lo12:fmt_3             // Set the 1st argument of printf(fmt_3, var1, var2) (lower 12 bits)
            mov         x1, result_r
            mov         x2, result_r

            bl          printf                          // Call the printf() function

            // Return 0 in main
            mov         w0, 0

            // Restore Registers and return to calling code (OS)
            ldp         fp, lr, [sp], 16                // Restore FP and LR from stack, post-increment SP
            ret                                         // Return to caller

