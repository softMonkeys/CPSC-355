// Optimized program to create space on the stack to store all local variables, intitalize array to random positive integers, mod 256. Sort the array using a bubble sort and print out the sorted array.

arraybase = 16
i_s       = 176
j_s       = 180
alloc     = -(16 + 160 + 4 + 4) & -16
dealloc   = -alloc

// Define M4 macros
//int
define(loopi_r, w19)                                         // loop counter i register
define(loopj_r, w24)                                         // loop counter j register
define(decrementJ_r, w25)                                    // loop counter j-1 register
define(fp, x29)                                              // frame register
define(lr, x30)                                              // link register
define(SIZE_r, w20)                                          // SIZE register
define(store_r, w21)                                         // storage register
define(vi_r, w23)                                            // v[i] register
define(vj_r, w26)                                            // v[j] register
define(vjDecrement_r, w27)                                   // v[j-1] register
define(temp_r, w22)                                          // temp variable register

// Define format string for call to printf()
fmt_1:      .string "v[%d]: %d\n"
fmt_2:      .string "\nSorted array:\n"

            // Define the main function for our program
            .balign     4                                    // ensure aligned to a 4-byte
            .global     main                                 // make "main" visible to the OS
    
main:       stp         fp, lr, [sp, alloc]!                 // save frame pointer (fp, x29) and link register (lr, x30) to stock, allocating 16 bytes, ore_increment SP
            mov         fp, sp                               // update frame pointer (fp) to current stack pointer (sp) (after we've increment sp in the last step)
            add         x28, fp, arraybase                   // Calculate array base address. This is just 16 bytes after SP, directly after the frame record.

//---LOOP 1: Create an array where array[i] = rand() & 0xFF.---------------------------//
            mov         loopi_r, 0                           // set w19 general purpose register to 0, this will be the loop counter
            str         loopi_r, [fp, i_s]                   // write index i to stack
            mov         SIZE_r, 40                           // set w20 general purpose register to 40, this will be the SIZE defined in the c code
            b           test

loop:       ldr         loopi_r, [fp, i_s]                   // get current index i from the stack       
            bl          rand
            and         vi_r, w0, 0xFF
            str         vi_r, [x28, loopi_r, SXTW 2]         // store the rand() & 0xFF at array[i]
            
            // Print out the result
            adrp        x0, fmt_1                            // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add         w0, w0, :lo12:fmt_1                  // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov         w1, loopi_r
            mov         w2, vi_r
            
            bl          printf                               // call the printf() function

            ldr         loopi_r, [fp, i_s]                   // read index i from the stack
            // End of code inside the loop
            add         loopi_r, loopi_r, 1                  // increment loop by 1
            str         loopi_r, [fp, i_s]                   // write index i back to stack

            // Loop test
test:       cmp         loopi_r, SIZE_r
            b.lt        loop                                 // if [loop counter] >= 40(size), exit the loop and branch to loop2


//---LOOP 2: Nested Loop --------------------------------------------------------------//
// Sort the array using a bubble sort
continue:   sub         loopi_r, SIZE_r, 1                   // set w19 general purpose register to (size - 1), this will be the i counter
            str         loopi_r, [fp, i_s]                   // write index i back to stack
            

            b           test2

loop2:      // Nested loop
            mov         loopj_r, 1                           // set w24 general purpose register to 1, this will be the j counter       
            str         loopj_r, [fp, j_s]
            b           test3
            
nested:     sub         loopj_r, loopj_r, 1                  // j--
            str         loopj_r, [fp, j_s]                   // write index j-1 to stack
            ldr         loopj_r, [fp, j_s]                   // get current index v[j-1] from the stacks
            ldr         vjDecrement_r, [x28, loopj_r, SXTW 2]// load the v[j-1] at array[j-1] 
            
            add         loopj_r, loopj_r, 1                  // j++
            str         loopj_r, [fp, j_s]                   // write index j to stack
            ldr         loopj_r, [fp, j_s]                   // get current index v[j] from the stack
            ldr         vj_r, [x28, loopj_r, SXTW 2]         // load the v[j] at array[j] 

            cmp         vjDecrement_r, vj_r
            b.le        false                                // if v[j-1] <= v[j], dont execute the code below and branch to false
// Compare elements
            add         sp, sp, -4 & -16                     // alloc RAM
            mov         temp_r, vjDecrement_r
            str         temp_r, [fp, -4]                     // get current index temp[x] from the stack
            ldr         loopj_r, [fp, j_s]                   // get current index v[j] from the stacks
            sub         loopj_r, loopj_r, 1                  // j--
            str         vj_r, [x28, loopj_r, SXTW 2]         // store the v[j] at array[j-1]
            
            add         loopj_r, loopj_r, 1                  // j++
            ldr         temp_r, [fp, -4]                     // added line***************************************************
            str         temp_r, [x28, loopj_r, SXTW 2]       // store the v[j] at array[j]

            add         sp, sp, 16

false:      ldr         loopj_r, [fp, j_s]                   // read index j from the stack
            // End of nested loop
            add         loopj_r, loopj_r, 1                  // increment j by 1
            str         loopj_r, [fp, j_s]                   // write index j back to stack
     
          


test3:      ldr         loopj_r, [fp, j_s]
            ldr         loopi_r, [fp, i_s]              
            cmp         loopj_r, loopi_r
            b.le        nested                               // if [loop counter] > i, exit the loop and continue the following code
            
            // End of code inside the loop
            sub         loopi_r, loopi_r, 1                  // decrement loop by 1
            str         loopi_r, [fp, i_s]                   // write index i back to stack

            // Loop test
test2:      ldr         loopi_r, [fp, i_s]      
            cmp         loopi_r, 0
            b.ge        loop2                                // if [loop counter] < 0, exit the loop and branch to done
            

// Print out the sorted array
done:       adrp        x0, fmt_2                            // Set the 1st argument of printf(fmt_2, var1, var2) (high-order bits)
            add         w0, w0, :lo12:fmt_2                  // Set the 1st argument of printf(fmt_2, var1, var2) (lower 12 bits)
            
            bl          printf                               // Call the printf() function

            mov         loopi_r, 0                           // set w19 general purpose register to 0, this will be the loop counter
            str         loopi_r, [fp, i_s]                   // Write index i to stack
            b           testFinal

            
loopFinal:  ldr         loopi_r, [fp, i_s]                   // Get index i to stack
            ldr         vi_r, [x28, loopi_r, SXTW 2]         // Load the number at array[i]

            // Print out the result
            adrp        x0, fmt_1                            // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
            add         w0, w0, :lo12:fmt_1                  // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
            mov         w1, loopi_r
            mov         w2, vi_r
            
            bl          printf                               // Call the printf() function

            // End of code inside the loop
            ldr         loopi_r, [fp, i_s]                   // Get index i from stack    
            add         loopi_r, loopi_r, 1                  // increment loop by 1
            str         loopi_r, [fp, i_s]                   // Save index i back to stack

            // Loop test
testFinal:  ldr         loopi_r, [fp, i_s]                   // Get index i from stack  
            cmp         loopi_r, SIZE_r
            b.lt        loopFinal                            // if [loop counter] >= 40(size), exit the loop
            
            // Return 0 in main
            mov         w0, 0

            // Restore Registers and return to calling code (OS)
            ldp         fp, lr, [sp], dealloc                // Restore FP and LR from stack, post-increment SP
            ret                                              // Return to caller

