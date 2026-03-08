#include <stdio.h>
extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64
	v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);
int main()
{
	unsigned char p;
	unsigned short int proba = 0x1234;
	unsigned char* wsk =
		(unsigned char*)&proba;
	p = *wsk;


	__int64 suma = 0;
	suma = suma_siedmiu_liczb(11, 1844674403709551603, 3, 4, 5, 6, 7);
	printf("\nSuma wynosi %I64d\n", suma);
	return 0;
}