#include <stdio.h>
#include <math.h>

#define FADD(a, b) a, b, (float)a + (float)b, fadd, '+', "add"
#define FMUL(a, b) a, b, (float)a * (float)b, fmul, '*', "mul"
#define FDIV(a, b) a, b, (float)a / (float)b, fdiv, '/', "div"

// Ustaw ROUNDING_ERROR na 1, ¿eby dostawaæ
// informacje o b³êdach dotycz¹cych zaokr¹glania,
// w przeciwnym razie ustaw ROUNDING_ERROR na 0
#define ROUNDING_ERROR 1

// Dzia³a jedynie dla floatów >= ni¿ zero
extern float fadd(float, float);

// Dzia³a dla wszystkich floatów reprezentuj¹cych liczbê,
// dla których wynik równie¿ mieœci siê we floacie
extern float fmul(float, float);

// Dzia³a dla wszystkich floatów reprezentuj¹cych liczbê,
// dla których wynik równie¿ mieœci siê we floacie
extern float fdiv(float, float);
extern char* month(int*, short int );

void test(float a, float b, float true_val, float (*fun)(float, float), char fun_symbol, char *fun_name) {
	float val = fun(a, b);
	int bit_rep_val = *(int*)&val;
	int bit_rep_true_val = *(int*)&true_val;
	int bit_diff = abs(bit_rep_val - bit_rep_true_val);
	printf("Test %f %c %f\nWynik: %f\nC-%s: %f\n", a, fun_symbol, b, val, fun_name, true_val);
#if ROUNDING_ERROR
	printf("Roznica w bitach wynikajaca\nz innego zaokraglania: %d\n", bit_diff);
#endif
	printf("\n");
}

int main() {
	int a[] = { 0xffff,0xf0ff,0xff0f,0xfff0,0xfaaf,0xaffa,0xaeda,0xdead,0xabba,0xcaca,0xaaaa,0xdfac };
	printf("%s",month(a, 1));


	test(FADD(53749, 135897283));
	test(FADD(957.8525, 84.188));
	test(FADD(17, pow(2, 74)));
	test(FMUL(53749, 135897283));
	test(FMUL(957.8525, 84.188));
	test(FMUL(17, pow(2, 74)));
	test(FDIV(53749, 135897283));
	test(FDIV(957.8525, 84.188));
	test(FDIV(17, pow(2, 74)));
	test(FDIV(pow(2, 74), 613.138));
	return 0;
}
