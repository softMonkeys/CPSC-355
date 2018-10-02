define(fp, x29)
define(lr, x30)                           // link register
define(flag_r, w19)                       // flag register
define(deltaX, w3)
define(deltaY, w4)
define(deltaZ, w5)
define(factor, w6)

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
main:        stp        fp, lr, [sp, alloc]!
             mov        fp, sp
             add        x8, fp, 16
             bl         newSphere
             add        x8, fp, 32  //x8 onloy in newSphere
             bl         newSphere

             adrp       x0, fmt_init
             add        x0, x0, :lo12:fmt_init
             bl         printf

             adrp       x0, fmt_first       // x1 x, y, z; x0 first
             add        x0, x0, :lo12:fmt_first
             add        x1, fp, 16
             bl         printSphere

             adrp       x0, fmt_second
             add        x0, x0, :lo12:fmt_second
             add        x1, fp, 32
             bl         printSphere
            
             add        x1, fp, 16
             add        x2, fp, 32
             

             bl         equal
             ldr        x20, [fp, result_offset]

             adrp       x0, fmt_check       // x1 x, y, z; x0 first
             add        x0, x0, :lo12:fmt_check
             mov        x1, x20
             bl         printf

             cmp        x20, 0

             b.eq       false
             // Move
             add        x1, fp, 16
             mov        deltaX, -5
             mov        deltaY, 3
             mov        deltaZ, 2
             bl         move
             add        x1, fp, 32
             mov        factor, 8
             bl         expand
             

             // Print final result
false:       adrp       x0, fmt_final
             add        x0, x0, :lo12:fmt_final
             bl         printf

             adrp       x0, fmt_first       // x1 x, y, z; x0 first
             add        x0, x0, :lo12:fmt_first
             add        x1, fp, 16
             bl         printSphere
             


             adrp       x0, fmt_second
             add        x0, x0, :lo12:fmt_second
             add        x1, fp, 32
             bl         printSphere
             
             mov        w0, 0
             ldp        fp, lr, [sp], dealloc
             ret

// struct point
point_alloc = -(16 + int * 3) & -16
point_dealloc = -point_alloc

point:       stp        fp, lr, [sp, point_alloc]!
	         mov        fp, sp
	         str        wzr, [x8, x_offset]
	         str        wzr, [x8, y_offset]
	         str        wzr, [x8, z_offset]
	         ldp        fp, lr, [sp], point_dealloc
	         ret

// struct sphere
sphere_alloc = -(16 + int * 4) & -16
sphere_dealloc = - sphere_alloc

sphere:      stp        fp, lr, [sp, sphere_alloc]!
	         mov        fp, sp 
	         bl         point
	         str        wzr, [x8, radius_offset]
	         ldp        fp, lr, [sp], sphere_dealloc
	         ret

// struct sphere newSphere()
newSphere_alloc = -(16 + struct_first) & -16
newSphere_dealloc = -sphere_alloc

newSphere:   stp        fp, lr, [sp, newSphere_alloc]!
             mov        fp, sp

             bl         sphere
             mov        w0, 0       // x
	         str	    w0, [x8, x_offset]
             
             mov        w0, 0       // y
	         str	    w0, [x8, y_offset]
             
             mov        w0, 0       // z
	         str	    w0, [x8, z_offset]
             
             mov        w0, 1       // radius
	         str	    w0, [x8, radius_offset]

             ldp        fp, lr, [sp], newSphere_dealloc
             ret

// void move(struct sphere *s, int deltaX, int deltaY, int deltaZ)
move_alloc = -(16) & -16
move_dealloc = -move_alloc

move:        stp        fp, lr, [sp, move_alloc]!
             mov        fp, sp

             ldr        w10, [x1, x_offset]
             add        w10, w10, deltaX
             str        w10, [x1, x_offset]

             ldr        w10, [x1, y_offset]
             add        w10, w10, deltaY
             str        w10, [x1, y_offset]

             ldr        w10, [x1, z_offset]
             add        w10, w10, deltaZ
             str        w10, [x1, z_offset]

             ldp        fp, lr, [sp], move_dealloc
             ret

// void expand(struct sphere *s, int factor)
expand_alloc = -(16) & -16
expand_dealloc = -expand_alloc

expand:      stp        fp, lr, [sp, expand_alloc]!
             mov        fp, sp

             ldr        w10, [x1, radius_offset]
             mul        w10, w10, factor
             str        w10, [x1, radius_offset]

             ldp        fp, lr, [sp], expand_dealloc
             ret
// int equal(struct sphere *s1, struct sphere *s2)
equal_alloc = -(16 + int) & -16
equal_dealloc = -equal_alloc

equal:       stp        fp, lr, [sp, equal_alloc]!
             mov        fp, sp
             
             mov        flag_r, 0
             str        flag_r, [fp, result_offset]
             ldr        x0, [fp, result_offset]
             
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

             mov        flag_r, 1
             str        flag_r, [fp, result_offset]
             ldr        x0, [fp, result_offset]
                   
continue:    ldp        fp, lr, [sp], equal_dealloc
             ret

// void printSphere(char *name, struct sphere )
printSphere_alloc = -(16 + char) & -16
printSphere_dealloc = -printSphere_alloc

printSphere: stp        fp, lr, [sp, printSphere_alloc]!
             mov        fp, sp

             ldr	    w2, [x1, x_offset]
	         ldr	    w3, [x1, y_offset]
	         ldr	    w4, [x1, z_offset]
             ldr	    w5, [x1, radius_offset]
             mov        x1, x0
             adrp       x0, fmt_result
             add        x0, x0, :lo12:fmt_result
             bl         printf
             

             ldp        fp, lr, [sp], printSphere_dealloc
             ret

            
