#include <stdio.h>
int sum(int, int);  // function prototype

int main()
{
	int i = 5, j = 10, result;

	result = sum(i, j);
	printf("result = %d\n", result);
	return 0;
}
