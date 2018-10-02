fmt_1:      .string "array[%d] is %d.\n"

size      = 10
arraybase = 16                               // This is the base address of the array, which is stored directly after the 16 bytes allocated for the frame record (x29 and x30).
i_s       = 56                               // This is the address of our index i, directly after our array in memory.

alloc     = -(16 + 40 + 4) & -16
dealloc   = -alloc
// x29 and x30 are known collectively as the frame record.
// We store the frame record on the stack, along with any
// additional stack variable. To do this, we first need to
// calculate the amount of space required for all these
// variables. The frame record has two registers, and
// each register is 8 bytes (64-bits), hence by default
// we decrement sp by 16. The reason we decrement is because
// stack memory grows backwards (addresses become smaller).
// Next, we need to allocate space for the array as well as
// the index i_s. We will use words (4 bytes), and the array
// size is 10, so the array will take 4*10 = 40 bytes. The
// index will take another 4 bytes, so we need to allocate
// 16+40+4 = 60 bytes. However, the stack must be quadword
// alligned, meaning addresses must be divisible by 16.
// To guarantee this, we take -(60) and perform a bitwise
// AND with -16. The last 4 bits of -16 are 0s, and doing
// a bitwise AND with -16 will clear the last 4 bits of -60.
// The result is -60&-16 = -64, which is divisible by 16.

// .req is Register EQuate, which is similar to using macros
// .req is built into ARMv8, you don't need to use m4

fp          .req      x29
lr          .req      x30

            .balign   4                      // Stack addresses must be divisible by 16, so we quadword align all the instructions. A quadword is 16 bytes (1 word = 4 bytes).
            .global   main
main:       stp       x29, x30, [sp, alloc]!
            mov       fp, sp

            add       x28, fp, arraybase     // Calculate array base address. This is just 16 bytes after SP, directly after the frame record.

//---LOOP 1: Create an array where array[i] = i*2.---------------------------//
//---The resulting array is [0, 2, 4, 6, 8, 10, 12, 14, 16, 18].-------------//
            mov       w19, 0                 // Initialize index i to 0
            str       w19, [fp, i_s]         // Write index i to stack
            b         test                   // Branch to optimized pre-test
            
loop:       mov       w21, 2                 // 2x multipler for i
            ldr       w19, [fp, i_s]         // Get current index i from the stack
            mul       w20, w19, w21          // Calculate i*2
            str       w20, [x28, w19, SXTW 2]// We want to store i*2 at array[i]; x21 = $fp + 16, the base address. 
                                                //"w19, SXTW 2" does two things:
					                            //      1. SXTW w19 to x19, since our addresses are 64 bits. 
                                                //      2. the "2" after SXTW performs an LSL, shifting the numbers left by 2. That's the same as scaling by 4.
            ldr       w19, [fp, i_s]         // Read index i from stack
            add       w19, w19, 1            // i++
            str       w19, [fp, i_s]         // Write index i back to stack


test:       cmp       w19, size              // if i < 10 ...
            b.lt      loop                   // ... do loop.     

//---LOOP 1 END--------------------------------------------------------------//
//---LOOP 2: Iterate through the loop and print out the numbers.-------------//
            mov       w19, 0                 // Initialize index i to 0 again
            str       w19, [fp, i_s]         // write index i to stack
            b         test2                  // Branch to optimized pre-test

loop2:      ldr       w19, [fp, i_s]         // Get index i to stack
            ldr       w20, [x28, w19, SXTW 2]// Load the number at array[i].
					                         // x28 is the base address of the array.
					                         // Offset by i*4 bytes.
					                         // Same as above, SXTW 2 to sign extend
					                         // w19 to x19, then left-shift by 2
					                         // to scale w19 by 4, giving us the
					                         // correct offset in bytes.
            adrp      x0, fmt_1
            add       w0, w0, :lo12:fmt_1
            mov       w1, w19
            mov       w2, w20

            bl        printf
            
            ldr       w19, [fp, i_s]         // Get index i from stack
            add       w19, w19, 1            // i++
            str       w19, [fp, i_s]         // Save index i back to stack

test2:      ldr       w19, [fp, i_s]         // Get index i from stack
            cmp       w19, size              // If i < 10 ...
            b.lt      loop2                  // ... do loop.

//---LOOP 2 END-----------------------------------------------------------------//
done:       mov       w0, 0                  // Return 0 to OS
            
            ldp       fp, lr, [sp], dealloc  // Deallocate stack memory
            ret                              // Return to calling code in OS
