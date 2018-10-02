#include <stdio.h>
#include <string.h>

int main()
{
	char src[40];		// char array of size 40
	char dest[100];		// char array of size 100

	// fill the dest array with nul (\0), specifying the end of the string
	memset(dest, '\0', sizeof(dest));

	// copy a string literal into src 
	strcpy(src, "This string is 34 characters long.");
	
	strcpy(dest, src);	// now copy src into dest

	printf("src string : %s\n", src);	// display src
	printf("dest string : %s\n", dest);	// display dest

	// use strlen() to find the length of dest
	printf("Length of dest : %d", strlen(dest));
	printf("\n");	

	return(0);
} 
