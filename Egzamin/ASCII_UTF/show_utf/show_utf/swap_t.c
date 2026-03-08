#include <stdio.h>
#include <xmmintrin.h>
//void shl_128(__m128* a, char n);

//extern void _stdcall reverse_string(wchar_t*);
//float liczba_pi(unsigned int n);

long long suma(long long[], unsigned int n);

void main()
{
	//wchar_t input[] = L"2 muiwkolok OKA";
	//reverse_string(input);
	//printf("%ls\n", input);

	//__m128 a[1] = { 4.0f, 0.0f, 0.0f, 0.0f };
	//shl_128(a, 1);
	//printf("");
	long long tab[] = { 1,2,3,4,5,100,200,300 };
	unsigned int n = sizeof(tab) / sizeof(tab[0]);
	long long sum = suma(tab, n);
	printf("sum = %lli", sum);

	//float pi = liczba_pi(2);
	//printf("Twoje piekne inzynierskie pi = %f", pi);
	return 0;
}