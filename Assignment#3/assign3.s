// Optimized program to create space on the stack to store all local variables, intitalize array to random positive integers, mod 256. Sort the array using a bubble sort and print out the sorted array.

arraybase = 16
i_s       = 176
j_s       = 180
alloc     = -(16 + 160 + 4 + 4) & -16
dealloc   = -alloc

// Define M4 macros
//int
                                         // loop counter i register
                                         // loop counter j register
                                    // loop counter j-1 register
                                              // frame register
                                              // link register
                                          // SIZE register
                                         // storage register
                                            // v[i] register
                                            // v[j] register
                                   // v[j-1] register
                                          // temp variable register

// Define format string for call to printf()
fmt_1:      .string "v[%d]: %d\n"
fmt_2:      .string "\nSorted array:\n"

            // Define the main function for our program
            .balign     4                                    // ensure aligned to a 4-byte
            .global     main                                 // make "main" visible to the OS
    
main:       stp         x29, x30, [sp, alloc]!                 // save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
            mov         x29, sp                               // update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
            add         x28, x29, arraybase                   // Calculate array base address. This is just 16 bytes after SP, directly after the frame record.

//---LOOP 1: Create an array where array[i] = rand() & 0xFF.---------------------------//
            mov         w19, 0                           // set w19 general purpose register to 0, this will be the loop counter
            str         w19, [x29, i_s]                   // write index i to stack
            mov         w20, 40                           // set w20 general purpose register to 40, this will be the SIZE defined in the c code
            b           test

loop:       ldr         w19, [x29, i_s]                   // get current index i from the stack       
            bl          rand
            and         w23, w0, 0xFF
            str         w23, [x28, w19, SXTW 2]         // store the rand() & 0xFF at array[i]
            
            // Print out the result
            adrp        x0, fmt_1                            // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add         w0, w0, :lo12:fmt_1                  // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov         w1, w19
            mov         w2, w23
            
            bl          printf                               // call the printf() function

            ldr         w19, [x29, i_s]                   // read index i from the stack
            // End of code inside the loop
            add         w19, w19, 1                  // increment loop by 1
            str         w19, [x29, i_s]                   // write index i back to stack

            // Loop test
test:       cmp         w19, w20
            b.lt        loop                                 // if [loop counter] >= 40(size), exit the loop and branch to loop2


//---LOOP 2: Nested Loop --------------------------------------------------------------//
// Sort the array using a bubble sort
continue:   sub         w19, w20, 1                   // set w19 general purpose register to (size - 1), this will be the i counter
            str         w19, [x29, i_s]                   // write index i back to stack
            

            b           test2

loop2:      // Nested loop
            mov         w24, 1                           // set w24 general purpose register to 1, this will be the j counter       
            str         w24, [x29, j_s]
            b           test3
            
nested:     sub         w24, w24, 1                  // j--
            str         w24, [x29, j_s]                   // write index j-1 to stack
            ldr         w24, [x29, j_s]                   // get current index v[j-1] from the stacks
            ldr         w27, [x28, w24, SXTW 2]// load the v[j-1] at array[j-1] 
            
            add         w24, w24, 1                  // j++
            str         w24, [x29, j_s]                   // write index j to stack
            ldr         w24, [x29, j_s]                   // get current index v[j] from the stack
            ldr         w26, [x28, w24, SXTW 2]         // load the v[j] at array[j] 

            cmp         w27, w26
            b.le        false                                // if v[j-1] <= v[j], dont execute the code below and branch to false
// Compare elements
            add         sp, sp, -4 & -16                     // alloc RAM
            mov         w22, w27
            str         w22, [x29, -4]                     // get current index temp[x] from the stack
            ldr         w24, [x29, j_s]                   // get current index v[j] from the stacks
            sub         w24, w24, 1                  // j--
            str         w26, [x28, w24, SXTW 2]         // store the v[j] at array[j-1]
            
            add         w24, w24, 1                  // j++
            ldr         w22, [x29, -4]
            str         w22, [x28, w24, SXTW 2]       // store the v[j] at array[j]

            add         sp, sp, 16

false:      ldr         w24, [x29, j_s]                   // read index j from the stack
            // End of nested loop
            add         w24, w24, 1                  // increment j by 1
            str         w24, [x29, j_s]                   // write index j back to stack
     
          


test3:      ldr         w24, [x29, j_s]
            ldr         w19, [x29, i_s]              
            cmp         w24, w19
            b.le        nested                               // if [loop counter] > i, exit the loop and continue the following code
            
            // End of code inside the loop
            sub         w19, w19, 1                  // decrement loop by 1
            str         w19, [x29, i_s]                   // write index i back to stack

            // Loop test
test2:      ldr         w19, [x29, i_s]      
            cmp         w19, 0
            b.ge        loop2                                // if [loop counter] < 0, exit the loop and branch to done
            

// Print out the sorted array
done:       adrp        x0, fmt_2                            // Set the 1st argument of printf(fmt_2, var1, var2) (high-order bits)
            add         w0, w0, :lo12:fmt_2                  // Set the 1st argument of printf(fmt_2, var1, var2) (lower 12 bits)
            
            bl          printf                               // Call the printf() function

            mov         w19, 0                           // set w19 general purpose register to 0, this will be the loop counter
            str         w19, [x29, i_s]                   // Write index i to stack
            b           testFinal

            
loopFinal:  ldr         w19, [x29, i_s]                   // Get index i to stack
            ldr         w23, [x28, w19, SXTW 2]         // Load the number at array[i]

            // Print out the result
            adrp        x0, fmt_1                            // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add         w0, w0, :lo12:fmt_1                  // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov         w1, w19
            mov         w2, w23
            
            bl          printf                               // Call the printf() function

            // End of code inside the loop
            ldr         w19, [x29, i_s]                   // Get index i from stack    
            add         w19, w19, 1                  // increment loop by 1
            str         w19, [x29, i_s]                   // Save index i back to stack

            // Loop test
testFinal:  ldr         w19, [x29, i_s]                   // Get index i from stack  
            cmp         w19, w20
            b.lt        loopFinal                            // if [loop counter] >= 40(size), exit the loop
            
            // Return 0 in main
            mov         w0, 0

            // Restore Registers and return to calling code (OS)
            ldp         x29, x30, [sp], dealloc                // Restore FP and LR from stack, post-increment SP
            ret                                              // Return to caller

