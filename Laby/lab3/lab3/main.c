#include <stdio.h>
int szukaj_max(int a, int b, int c);
int szukaj4_max(int a, int b, int c, int d);
int main()
{
	int x, y, z, w, wynik, wynik2;
	/*printf("\nProszê podaæ trzy liczby ca³kowite ze znakiem: ");
	scanf_s("%d %d %d", &x, &y, &z, 32);
	wynik = szukaj_max(x, y, z);
	printf("\nSpoœród podanych liczb %d, %d, %d, \
liczba %d jest najwiêksza\n", x, y, z, wynik);*/

	printf("\nProszê podaæ cztery liczby ca³kowite ze znakiem: ");
	scanf_s("%d %d %d %d", &x, &y, &z, &w, 32);
	wynik2 = szukaj4_max(x, y, z, w);
	printf("\nSpoœród podanych liczb %d, %d, %d, %d, \
liczba %d jest najwiêksza\n", x, y, z, w, wynik2);
	return 0;

}
