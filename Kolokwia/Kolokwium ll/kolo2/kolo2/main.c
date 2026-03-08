#include <stdio.h>
extern int* szukaj_elem_min(int tab[], int n);
extern unsigned int kwadrat(unsigned int n);
extern unsigned int kwadrat_recursive(unsigned int n);
unsigned char iteracja(unsigned char a);
void pole_kola(float* pr);
float avg_wd(int n, float* tab, float* wagi);
void test_kodowania();
void test_float();
void zmien_wskaznik(float** t2);
int* kopia_tablicy(int tab1[], unsigned int n);
int roznica(int* odjemna, int** odjemnik);
char* komunikat(char* tekst);
void szyfruj(char* tekst);
void zera();
void zaokrg();
void fstp();
int main() {

    int tab[] = { 3, 4, 2, 1, 5 };
    int nn = 8;
    unsigned int wynik = 0;
    int* p;
    //p = szukaj_elem_min(tab, nn);


    wynik = kwadrat(nn);
    printf("\nkwadrat = %d\n", wynik);
    printf("\kwadrat_recursive = %d\n", kwadrat_recursive(nn));

    unsigned char w = iteracja(20); // zwraca parametr + parametr*x + x, gdzie x - liczba wywolan
    printf("Znak : %c", w);


    float pr = 3.0f;
    float* ww = &pr;
    printf("\npole_kola : %f\n", *ww);
    pole_kola(ww);
    // naprawic pobierania wyniku z st(0) do ww
    printf("\npole_kola : %f, promien - %f\n", *ww, pr);

    float t[] = { 1,2,3,4,5 };
    float wagi[] = { 2,4,6,8,10 };
    float srednia_wazona = avg_wd(5, t, wagi);
    printf("\nsrednia_wazona: %f\n", srednia_wazona);
    
//    test_float();

//    test_kodowania();


    int tab1[5] = { 5, 4, 3, 2, 1 };
    int* tab2 = kopia_tablicy(tab1, 5);
    for (int i = 0; i < 5; i++) {
        printf(" %d", *(tab2 + i));
    }


    int a, b, * wsk, wynik2;
    wsk = &b;
    a = 21; b = 25;
    wynik2 = roznica(&a, &wsk);
    printf("\nwynik = %d\n", wynik2);


    char* tekst1 = "To jest moj tekst.";
    int dlugosc = 18;
    char* tekst2 = komunikat(tekst1);
    for (int i = 0; i < (dlugosc + 5); i++) {
        printf("%c", *(tekst2 + i));
    }


    char tekst[] = "To jest tekst bump";
    szyfruj(tekst);
    for (int i = 0; i < sizeof(tekst) / sizeof(tekst[0]); ++i) {
        printf("%c", *(tekst + i));

    }

    zaokrg();

    float tt = 3.5;
    float* t1 = &tt;
    float* t2 = &tt;
    zmien_wskaznik(t2);
    printf("\ntt = %f\n", tt);
    return 0;
}
