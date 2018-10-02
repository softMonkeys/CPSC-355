// ARMv8 assembly labguage program to accept as command line arguments three strings representing data in the format mm dd yyyy.
// Program will print the data with the name of month as well as the correct suffix.
                                     // frame pointer
                                     // link register
                                // month register
                                  // day register
                                 // year register

i_r     .req w19                                    // index for our loop (integer)
base_r  .req x20                                    // bass address for the month
argc_r  .req w21                                    // arg-count, or number of arguments passed into main() (integer)

        .text                                       // Program code is read-only, goes in .text
// Define strings
fmt_rd: .string "rd, "
fmt_nd: .string "nd, "
fmt_st: .string "st, "
fmt_th: .string "th, "
fmt_dy: .string " %d"
fmt_yr: .string "%d\n"
fmt_mh: .string "%s"
fmt_err:.string "invalid input\n"
// Each string is pointed to by its label
null_m: .string ""
jan_m:  .string "January"
feb_m:  .string "February"
mar_m:  .string "March"
apr_m:  .string "April"
may_m:  .string "May"
jun_m:  .string "June"
jul_m:  .string "July"
aug_m:  .string "August"
sep_m:  .string "September"
oct_m:  .string "October"
nov_m:  .string "November"
dec_m:  .string "December"

        .data
// Create an array of pointers. Each pointer (label) points to a string.
// Because addresses in ARMv8 are 64-bits, we need to use dwords (8 bytes = 64 bits).
month_m:.dword null_m, jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m

        .text                                       // Program code is read-only, goes in .text
        // Define the main function for our program
        .balign 4                                   // Instruction must be word aligned
        .global main                                // Make "main" visible to the OS
main:   stp     x29, x30, [sp, -16]!                  // Save frame pointer (x29, x29) and link register (x30, x30) to stock, allocating 16 bytes, ore_increment SP
        mov     x29, sp                              // Update frame pointer (x29) to current stack pointer (sp) (after we've increment sp in the last step)
        mov     i_r, 1                              // the 1st arg (index 0) is the program name we want the 2nd arg, the number entered
        mov     argc_r, w0                          // copy argc (number of pointers)
        sub     argc_r, argc_r, 1                   // argc_r--
        b       check                               // branch to check
false:  adrp    x0, fmt_err                         // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_err               // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        bl      printf                              // Call the printf() function
        bl      done                                // Call done
check:  // Checks if arguments are equal to 3  
        cmp     argc_r, 3                           // user has to input 3 arguments
        b.ne    false                               // if user inputs are not equal to 3, branch to false
        // Checks if month is between 1 - 12
        mov     x28, x1                             // move the base address to x28 
        ldr     x0, [x28, i_r, SXTW 3]              // x1 is the base address to the external pointer array containing pointers to all our args w19 (1) is the index, 
                                                    // SXTW 3 to calculate offset convert ASCII string to integer, result in w0
        bl      atoi                                // Call atoi function to convert string to integer 
        mov     w22, w0                         // move the ingeter value into month register
        // User month input needs to be between 1 - 12; if not, branch to false 
        cmp     w22, 12
        b.gt    false                               // if user input is greater than 12, branch to false
        cmp     w22, 0
        b.le    false                               // if user input is less than 1, branch to false
        add     i_r, i_r, 1                         // i++
        
        ldr     x0, [x28, i_r, SXTW 3]
        bl      atoi                                // Call atoi function to convert string to integer 
        // User day input needs to be between 1 - 31; if not, branch to false 
        mov     w23, w0                           // move the ingeter value into month register
        cmp     w23, 31
        b.gt    false                               // if user input is greater than 31, branch to false
        cmp     w23, 0
        b.le    false
        add     i_r, i_r, 1                         // i++
        // User month input needs to be between 1 - 9999; if not, branch to false
        ldr     x0, [x28, i_r, SXTW 3]
        bl      atoi                                // Call atoi function to convert string to integer 
        mov     w24, w0                          // move the ingeter value into month register
        cmp     w24, 0
        b.lt    false                               // if user input is less than 0, branch to false
//--MONTH----------------------------------------------------------------------------------------------------------------------------------------------------------
        adrp    x0, fmt_mh                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_mh                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        adrp    base_r, month_m                     // get the base address of our pointer array
        add     base_r, base_r, :lo12:month_m
        ldr     x1, [base_r, w22, SXTW 3]       // Use loop index to calculate offset, SXTW (sign extend), then LSL 3 (multiply by 8)
                                                    // Each address is 8 bytes hence multiply by 8
        bl      printf                              // call printf function
//--DAY----------------------------------------------------------------------------------------------------------------------------------------------------------
        adrp    x0, fmt_dy                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_dy                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        mov     w1, w23                           // Move day to the first display register
        bl      printf                              // call printf function
        // Decide if the day ends with "st", "nd", "rd" or "th"
        // st
        cmp     w23, 1
        b.eq    first                               // if user input equals to 1, branch to first
        cmp     w23, 21
        b.eq    first                               // if user input equals to 21, branch to first
        cmp     w23, 31
        b.eq    first                               // if user input equals to 31, branch to first
        // nd
        cmp     w23, 2
        b.eq    second                              // if user input equals to 2, branch to second
        cmp     w23, 22
        b.eq    second                              // if user input equals to 22, branch to second
        // rd
        cmp     w23, 3
        b.eq    third                               // if user input equals to 3, branch to third
        cmp     w23, 23
        b.eq    third                               // if user input equals to 23, branch to third
        // If user input equals non of above, it's suffix must be "th" 
        // th
        adrp    x0, fmt_th                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_th                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        bl      printf                              // call printf function
        b       year                                // branch to year
first:  adrp    x0, fmt_st                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_st                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        bl      printf                              // call printf function
        b       year                                // branch to year
second: adrp    x0, fmt_nd                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_nd                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        bl      printf                              // call printf function
        b       year                                // branch to year
third:  adrp    x0, fmt_rd                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_rd                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        bl      printf                              // call printf function

//--YEAR----------------------------------------------------------------------------------------------------------------------------------------------------------
year:   adrp    x0, fmt_yr                          // Set the 1st argument of printf(fmt_1, var1, var2) (high-order bits)
        add     x0, x0, :lo12:fmt_yr                // Set the 1st argument of printf(fmt_1, var1, var2) (lower 12 bits)
        mov     w1, w24                          // Move year to the first display register
        bl      printf                              // call printf function

done:   mov     w0, 0                               // Return 0 in main
        // Restore Registers and return to calling code (OS)
        ldp     x29, x30, [sp], 16                    // Restore FP and LR from stack, post-increment SP
        ret                                         // Return to caller

        
