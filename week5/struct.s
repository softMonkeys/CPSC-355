//struct planet{
//	int id;
//	int radius;	//km
//	int mass;	//10^20 kg
//};
planet_id_offset     = 0
planet_radius_offset = 4
planet_mass_offset   = 8

planet_struct_size   = 12

fmt:	.string "Planet id: %d\nPlanet radius: %d"
alloc 	= -(16 + 1 * planet_struct_size) & -16
dealloc = - alloc

	.balign 4
        .global main
main:   stp     x29, x30, [sp, alloc]!
        mov     x29, sp

        add     x8, x29, 16
        bl      get_mars

	add	x0, x29, 16
	bl	print_planet
        // exit
        mov     w0, 0
        ldp     x29, x30, [sp], dealloc 
        ret

//struct planet get_mars(){
//	struct planet p;
//	// set up with values
//	return p;
//}
mars_alloc 	     = -(16 + planet_struct_size) & -16
mars_dealloc	     = -alloc

get_mars:
	stp	x29, x30, [sp, mars_alloc]!
	mov	x29, sp

	mov	w0, 3			//planet #3
	str	w0, [x29, 16 + planet_id_offset]

	mov	w0, 3386		//radius
	str	w0, [x29, 16 + planet_radius_offset]

	mov	w0, 6417		//mass
	str	w0, [x29, 16 + planet_mass_offset]

	// copy local variable to return value
	ldr	w0, [x29, 16 + planet_id_offset]
	str	w0, [x8, planet_id_offset]
	ldr	w0, [x29, 16 + planet_radius_offset]
	str	w0, [x8, planet_radius_offset]
 	ldr	w0, [x29, 16 + planet_mass_offset]
	str	w0, [x8, planet_mass_offset]


	ldp	x29, x30, [sp], dealloc
	ret

//void print_planet(struct planet* p){
//	printf("%d %d %d", s->id, s->radius, s->mass);
print_planet:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	ldr	w1, [x0, planet_id_offset]
	ldr	w2, [x0, planet_radius_offset]
	ldr	w3, [x0, planet_mass_offset]

	adrp	x0, fmt
	add	x0, x0, :lo12:fmt
	mov	w1, w1
	mov	w2, w2
	mov	w3, w3
	bl	printf

	ldp	x29, x30, [sp], 16
	ret



//int main(){
//	struct planet p = get_mars();
//	print_planet(&p);
//	return 0;
//}
