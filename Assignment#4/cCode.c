#include <stdio.h>
#include <stdlib.h>
#define FALSE 0
#define TRUE  1

struct point{
    int x, y, z;
};

struct sphere{
    struct point origin;
    int radius;
};

struct sphere newSphere(){
    struct sphere s;
     
    s.origin.x = s.origin.y = s.origin.z = 0;
    s.radius = 1;

    return s;
};

void move(struct sphere *s, int deltaX, int deltaY, int deltaZ){
    s->origin.x += deltaX;
    s->origin.y += deltaY;
    s->origin.z += deltaZ;
}

void expand(struct sphere *s, int factor){
    s->radius *= factor;
}

int equal(struct sphere *s1, struct sphere *s2){
    int result = FALSE;
    
    if(s1->origin.x == s2->origin.x){
        if(s1->origin.y == s2->origin.y){
            if(s1->origin.z == s2->origin.z){
                if(s1->radius == s2->radius){
                    result = TRUE;
                }
            }
        }
    }
    return result;
}

void printSphere(char *name, struct sphere *s){
    printf("Sphere %s origin = (%d, %d, %d)  radius = %d\n",
            name, s->origin.x, s->origin.y, s->origin.z, s->radius);
}

void main(){
    struct sphere first, second;

    first = newSphere();
    second = newSphere();

    printf("\nInitial sphere values: \n");
    printSphere("first", &first);
    printSphere("second", &second);

    if(equal(&first, &second)){
        move(&first, -5, 3, 2);
        expand(&second, 8);
    }

    printf("\nChanged sphere values:\n");
    printSphere("first", &first);
    printSphere("second", &second);
}        
     
