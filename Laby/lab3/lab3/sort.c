#include <stdio.h>
void przestaw(int tab[], int length);
int main()
{
	int tab[] = { 3,2,5,1, 10, 22, 33, 1, 0, -2 };
	int length = sizeof(tab) / sizeof(tab[0]);
	for (int i = 0; i < length - 1; i++) {
		przestaw(tab, length - i);
	}

	for (int i = 0; i < length; i++) {
		printf("%d ", tab[i]);
	}
	return 0;

}
