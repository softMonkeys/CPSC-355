
                           // link register
                       // flag register





x_offset = 0
y_offset = 4
z_offset = 8
radius_offset = 12
result_offset = 28
int = 4
char = 2

struct_first = int * 4
struct_second = int * 4
alloc    = -(16 + struct_first + struct_second) & -16
dealloc  = -alloc

fmt_result:  .string "Sphere %s origin = (%d, %d, %d)  radius = %d\n"
fmt_init:    .string "\nInitial sphere values:\n"
fmt_final:   .string "\nChanged sphere values:\n"
fmt_first:   .string "first"
fmt_second:  .string "second"
fmt_check:   .string "%d"
// main()
             .balign    4
             .global    main
main:        stp        x29, x30, [sp, alloc]!
             mov        x29, sp
             add        x8, x29, 16
             bl         newSphere
             add        x8, x29, 32  //x8 onloy in newSphere
             bl         newSphere

             adrp       x0, fmt_init
             add        x0, x0, :lo12:fmt_init
             bl         printf

             adrp       x0, fmt_first       // x1 x, y, z; x0 first
             add        x0, x0, :lo12:fmt_first
             add        x1, x29, 16
             bl         printSphere

             adrp       x0, fmt_second
             add        x0, x0, :lo12:fmt_second
             add        x1, x29, 32
             bl         printSphere
            
             add        x1, x29, 16
             add        x2, x29, 32
             

             bl         equal
             ldr        x20, [x29, result_offset]

             adrp       x0, fmt_check       // x1 x, y, z; x0 first
             add        x0, x0, :lo12:fmt_check
             mov        x1, x20
             bl         printf

             cmp        x20, 0

             b.eq       false
             // Move
             add        x1, x29, 16
             mov        w3, -5
             mov        w4, 3
             mov        w5, 2
             bl         move
             add        x1, x29, 32
             mov        w6, 8
             bl         expand
             

             // Print final result
false:       adrp       x0, fmt_final
             add        x0, x0, :lo12:fmt_final
             bl         printf

             adrp       x0, fmt_first       // x1 x, y, z; x0 first
             add        x0, x0, :lo12:fmt_first
             add        x1, x29, 16
             bl         printSphere
             


             adrp       x0, fmt_second
             add        x0, x0, :lo12:fmt_second
             add        x1, x29, 32
             bl         printSphere
             
             mov        w0, 0
             ldp        x29, x30, [sp], dealloc
             ret

// struct point
point_alloc = -(16 + int * 3) & -16
point_dealloc = -point_alloc

point:       stp        x29, x30, [sp, point_alloc]!
	         mov        x29, sp
	         str        wzr, [x8, x_offset]
	         str        wzr, [x8, y_offset]
	         str        wzr, [x8, z_offset]
	         ldp        x29, x30, [sp], point_dealloc
	         ret

// struct sphere
sphere_alloc = -(16 + int * 4) & -16
sphere_dealloc = - sphere_alloc

sphere:      stp        x29, x30, [sp, sphere_alloc]!
	         mov        x29, sp 
	         bl         point
	         str        wzr, [x8, radius_offset]
	         ldp        x29, x30, [sp], sphere_dealloc
	         ret

// struct sphere newSphere()
newSphere_alloc = -(16 + struct_first) & -16
newSphere_dealloc = -sphere_alloc

newSphere:   stp        x29, x30, [sp, newSphere_alloc]!
             mov        x29, sp

             bl         sphere
             mov        w0, 0       // x
	         str	    w0, [x8, x_offset]
             
             mov        w0, 0       // y
	         str	    w0, [x8, y_offset]
             
             mov        w0, 0       // z
	         str	    w0, [x8, z_offset]
             
             mov        w0, 1       // radius
	         str	    w0, [x8, radius_offset]

             ldp        x29, x30, [sp], newSphere_dealloc
             ret

// void move(struct sphere *s, int w3, int w4, int w5)
move_alloc = -(16) & -16
move_dealloc = -move_alloc

move:        stp        x29, x30, [sp, move_alloc]!
             mov        x29, sp

             ldr        w10, [x1, x_offset]
             add        w10, w10, w3
             str        w10, [x1, x_offset]

             ldr        w10, [x1, y_offset]
             add        w10, w10, w4
             str        w10, [x1, y_offset]

             ldr        w10, [x1, z_offset]
             add        w10, w10, w5
             str        w10, [x1, z_offset]

             ldp        x29, x30, [sp], move_dealloc
             ret

// void expand(struct sphere *s, int w6)
expand_alloc = -(16) & -16
expand_dealloc = -expand_alloc

expand:      stp        x29, x30, [sp, expand_alloc]!
             mov        x29, sp

             ldr        w10, [x1, radius_offset]
             mul        w10, w10, w6
             str        w10, [x1, radius_offset]

             ldp        x29, x30, [sp], expand_dealloc
             ret
// int equal(struct sphere *s1, struct sphere *s2)
equal_alloc = -(16 + int) & -16
equal_dealloc = -equal_alloc

equal:       stp        x29, x30, [sp, equal_alloc]!
             mov        x29, sp
             
             mov        w19, 0
             str        w19, [x29, result_offset]
             ldr        x0, [x29, result_offset]
             
             ldr        w10, [x1, x_offset]
             ldr        w11, [x2, x_offset]
             cmp        w10, w11
             b.ne       continue

             ldr        w10, [x1, y_offset]
             ldr        w11, [x2, y_offset]
             cmp        w10, w11  
             b.ne       continue

             ldr        w10, [x1, z_offset]
             ldr        w11, [x2, z_offset]
             cmp        w10, w11  
             b.ne       continue

             ldr        w10, [x1, radius_offset]
             ldr        w11, [x2, radius_offset]
             cmp        w10, w11  
             b.ne       continue

             mov        w19, 1
             str        w19, [x29, result_offset]
             ldr        x0, [x29, result_offset]
                   
continue:    ldp        x29, x30, [sp], equal_dealloc
             ret

// void printSphere(char *name, struct sphere )
printSphere_alloc = -(16 + char) & -16
printSphere_dealloc = -printSphere_alloc

printSphere: stp        x29, x30, [sp, printSphere_alloc]!
             mov        x29, sp

             ldr	    w2, [x1, x_offset]
	         ldr	    w3, [x1, y_offset]
	         ldr	    w4, [x1, z_offset]
             ldr	    w5, [x1, radius_offset]
             mov        x1, x0
             adrp       x0, fmt_result
             add        x0, x0, :lo12:fmt_result
             bl         printf
             

             ldp        x29, x30, [sp], printSphere_dealloc
             ret

            
