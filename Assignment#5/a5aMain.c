#include <stdio.h>
#include <stdlib.h>

/* Fuction Prototype */
void push(int value);
int pop();
int stackFull();
int stackEmpty();
void display();

int main(){
	
	int operation, value;
	
	do{
		system("clear");
		printf("### Stack Operations ###\n\n");
		printf("Press 1 - Push, 2 - Pop, 3 - Display, 4 - Exit\n");
		printf("Your option? ");
		scanf("%d", &operation);
		switch (operation){
			case 1:
				printf("\nEnter the positive interger value to be pushed: ");
				scanf("%d", &value);
				push(value);
				break;
			case 2:
				value = pop();
				if (value != -1)
					printf("\nPopped value is %d\n", value);
				break;
			case 3:
				display();
				break;
			case 4:
				printf("\nTerminating program\n");
				exit(0);
			default:
				printf("\nInvalid option! Try again.\n");
				break;
		}
		printf("\nPress the return key to continue . . .");
		getchar();
		getchar();
	} while (operation != 4);
	
	return 0;
}
