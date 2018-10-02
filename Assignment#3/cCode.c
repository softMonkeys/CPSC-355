#include <stdio.h>
#include <stdlib.h>
#define SIZE 40

int main()
{
    int v[SIZE];
    int i;
    int j;

    /* Initialize array to random postive intgers, mod 256 */
    for(i = 0; i < SIZE; i++){
        v[i] = rand() & 0xFF;
        printf("v[%d]: %d\n", i, v[i]);    
    }
    
    /* Sort the array using a bubble sort */
    for(i = SIZE - 1; i >= 0; i--){
        for(j = 1; j <= i; j++){
            /* Compare element */
            if(v[j - 1] > v[j]){
                int temp;
                /* Swap elements */
                temp = v[j - 1];
                v[j -1] = v[j];
                v[j] = temp;
            }    
        }
    }

    /* Print out the sorted array */
    printf("\nSorted array:\n");
    for(i = 0; i < SIZE; i++){
        printf("v[%d}: %d\n", i, v[i]);
    }
    
    return 0;
}
