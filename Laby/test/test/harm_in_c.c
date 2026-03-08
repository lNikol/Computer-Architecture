#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>

//extern float srednia_harm(float* tablica, unsigned int n);
//extern float nowy_exp(float x);
extern int* szukaj_elem_min(int tab[], int n);
extern float* moving_avg(double* table, unsigned int k, unsigned int m);
int main() {
    //int tab[] = { 1,2,3,4,5 };
    //int nn = 5;
    //szukaj_elem_min(tab, nn);


    /*unsigned int n = 0;
    printf("Podaj liczbê elementów: ");
    scanf("%u", &n);  // U¿ywamy %u dla unsigned int

    // Alokacja dynamicznej pamiêci dla tablicy float
    float* tablica = (float*)malloc(n * sizeof(float));
    if (tablica == NULL) {
        printf("B³¹d alokacji pamiêci!\n");
        return 1;  // Zakoñcz program w przypadku b³êdu alokacji
    }

    printf("Podaj %u wartoœci typu float:\n", n);
    for (unsigned int i = 0; i < n; i++) {
        printf("Element %u: ", i + 1);
        scanf("%f", &tablica[i]);
    }

    printf("\nWprowadzone wartoœci:\n");
    for (unsigned int i = 0; i < n; i++) {
        printf("Element %u: %.2f\n", i + 1, tablica[i]);
    }

    // Obliczenie œredniej harmonicznej
    float harm = srednia_harm(tablica, n);
    printf("Œrednia harmoniczna: %.2f\n", harm);

    // Zwolnienie pamiêci
    free(tablica);
    */
    //printf("%f", nowy_exp(3.0f));
    unsigned int n;
    unsigned int m = 1;
    double tablica[] = {1.0f, 2.0f, 3.0f, 4.0f, 5.0f};
    n = sizeof(tablica) / sizeof(tablica[0]);
    unsigned int rozmiar = n - m + 1;
    //float* wyn = (float*)malloc((rozmiar) * sizeof(float));
    float* wyn = moving_avg(tablica, n, m);

    for (unsigned int i = 0; i < rozmiar; i++) {
        printf("Element %u: %.2f\n", i + 1, wyn[i]);
    }

    free(wyn);
    return 0;
}
