/*
 * 	1.Print the program name.
 * 	2.Print the 3rd character of the program name.
 * 	3.Ask the user to enter a character, save it with getchar(),
 * 	  then display it back to the user with putchar().
 * 	4.Ask the user to enter a string, save it with scanf(),
 * 	  then display it back to the user with printf().
 * 	NOTE: In the Output, "k" and "hello" are the echoes. You don't
 * 		see the input since it
*/

#include <stdio.h>

int
main()
{
	int c;				// c is an int value representing a char
	char string_entered[100];	// string_entered is a array of characters
	char *PROGRAM_NAME = "ECHO!";   // string literal for program name
		
	printf("%s\n", PROGRAM_NAME);	// print name of the program
	
	//access one character of the string, using pointers
	printf("THe 3rd character of the program name is: %c\n", *(PROGRAM_NAME+2));
	
	printf("Enter a character to echo: \n");	// ask user for a character
	c = getchar();		// getchar() saves the character's ASCII int value to c
	putchar(c);		// put char() prints the character back to the user 
	putchar('\n');		// new line
	
	printf("Enter a string to echo: \n");	// ask user for a string
	
	// scanf() gets a string from user, saves it to string_entered
	scanf(" %[^\t\n]", string_entered);

	printf("%s\n", string_entered);		// printf() prints the string back to the user		
	printf("Goodbye!\n");	// leave the user happy
	return 0;		// terminate program (main function)

}
