.686
.model flat
public _avg_wd
public _szukaj_elem_min
public _kwadrat
public _kwadrat_recursive
public _iteracja
public _test_kodowania
public _zmien_wskaznik
public _kopia_tablicy
public _roznica
public _komunikat
public _szyfruj
public _zera
public _zaokrg
public _fstp

extern _ExitProcess@4 : PROC
extern _malloc : proc

.data
float2 dd 2.0
tryb_pracy dw 037Eh


; int * szukaj_elem_min (int tablica[], int n)
; zwrocic adres najmniejszego elementu tablicy
; tablica = [3, 4, 2, 1, 5];
; ecx - tablica, eax - n
.code
_szukaj_elem_min proc
    push edx
    push ebx
    push ebp
    push edi

    mov ebx, ecx ; ebx - tab[0]
    mov ecx, 0

    ; edx = max, nastepny element
    ; ebp = min, minimalny element
    mov ebp, [ebx]
    ptl:
        mov edx, [ebx + 4*ecx]
        cmp edx, ebp
        jle zamien_min ; edx <= ebp
        dalej:
        ; ebp > edx

        inc ecx
        cmp ecx, eax
        jne ptl

    mov eax, edi

    pop edi
    pop ebp
    pop ebx
    pop edx
    ret

    zamien_min:
    mov ebp, edx
    lea edi, [ebx + 4*ecx]
    jmp dalej
_szukaj_elem_min endp




_kwadrat proc
    push ebp
    mov ebp, esp
    push ecx
    push edx
    push esi

    ; ebp + 8 = a
    mov esi, [ebp + 8]
    cmp esi, 0
    je zero
    cmp esi, 1
    je jeden
    ; a > 1

    ; a^2 = (a-2)^2 + 4*a - 4
    ; nie mozna mnozyc i przesuwac bitow
    ; eax - tymczasowy wynik i konieczny wynik

    mov ebx, 2
    mov edx, esi ; esi = a
    sub edx, ebx ; edx = a - 2
    mov ebx, edx

    mov ecx, 1 ; ecx = 1
    licz_kwadrat:
        add edx, ebx
        inc ecx
        cmp ecx, ebx
        jne licz_kwadrat
        ; edx = edx^2 = (a-2)^2
    
    mov ecx, 3
    mov ebx, esi ; ebx = esi = a
    licz_razy_4:
        add ebx, esi
        dec ecx
        jnz licz_razy_4
        ; ebx = 4*a
    add edx, ebx ; edx = (a-2)^2+4*a
    mov ebx, 4
    sub edx, 4 ; edx = (a-2)^2+4*a-4
    mov eax, edx

  koniec:
    pop esi
    pop edx
    pop ecx
    pop ebp
    ret

  zero:
    mov eax, 0
    jmp koniec

  jeden:
    mov eax, 1
    jmp koniec
_kwadrat endp


_kwadrat_recursive PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    mov esi, [ebp+8] ; argument a
    cmp esi, 0
    je koniec
    cmp esi, 1
    je koniec
    ; wywolanie rekurencyjne
    mov eax, esi
    add eax, eax ; 2*eax
    add eax, eax ; 4*eax
    mov edi, eax ; w EDI wynik mnozenia
    sub esi, 2
    push esi
    call _kwadrat_recursive
    add esp, 4
    mov esi, eax ; w ESI wynik rekunrecji
    add esi, edi
    sub esi, 4
    koniec:
        mov eax, esi
        pop edi
        pop esi
        pop ebp
        ret
_kwadrat_recursive ENDP



_iteracja PROC
    push ebp
    mov ebp, esp
    mov al, [ebp+8] ; wartosc parametru
    sal al, 1 ; mnozenie argumentu przez 2
    ; sal - przesuniecie logiczne w lewo
    jc zakoncz
    inc al ; al = 2*parametr + 1
    push eax
    call _iteracja
    add esp, 4
    pop ebp
    ret
    zakoncz:
        rcr al, 1
        ; rcr - przesuniecie cykliczne w prawo przez cf
        pop ebp
        ret
_iteracja ENDP


_pole_kola proc
    push ebp
    mov ebp, esp
    finit
    push esi
    mov esi, dword ptr [ebp+8]
    fldpi
    fld dword ptr [esi]
    fld dword ptr [esi]
    fmulp
    fmulp
    fstp dword ptr [esi]


    pop esi
    mov esp, ebp
    pop ebp
    ret
_pole_kola endp


_avg_wd proc
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ecx

    mov ecx, [ebp + 8] ; n
    mov edi, [ebp + 12] ; wskaznik na tab
    mov esi, [ebp + 16] ; wskaznik na wagi

    mov eax, 0

    finit
    fldz
    ; obliczenie sredniej wazonej
    ptl:
    fld dword ptr [esi + eax*4]
    fld dword ptr [edi + eax*4]
    fmulp
    faddp
    inc eax
    cmp eax, [ebp + 8]
    jne ptl
    ; st(0) - wagi[i]*t[i]; suma wazonych elementow

    ; obliczenie sredniej wag
    mov eax, 0
    fldz
    ptl2:
    fld dword ptr [esi + eax*4]
    faddp
    inc eax
    cmp eax, [ebp + 8]
    jne ptl2
    ; na st(0) suma wag
    ; na st(1) suma wazonych elementow
    fdivp


    pop ecx
    pop esi
    pop edi
    mov esp,ebp
    pop ebp
    ret
_avg_wd endp



_test_kodowania proc
    push eax
    push ebx

    mov eax, ebx
    and al, 0FH
    xor edx, ecx
    inc esi
    dec edi

    mov bl, 45H
    cmp al, bl
    jne skip_label
    add ah, 2
    skip_label: sub ax, bx

    push eax
    pop ebx
    lea esi, [edi+4]
    movzx ecx, bx
    imul eax, edx



    mov eax, 1
    mov ebx, 2
    dw 8900h, 1444h
    mov [1444h], eax
    mov ebx, eax
    db 8bh, 0c3h
    db 89h, 03h
    db 89h, 43h, 04h



    pop ebx
    pop eax
    ret
_test_kodowania endp




_test_float proc
    finit
    fld dword ptr float2
    ret
_test_float endp




_zmien_wskaznik proc
    push ebp
    mov ebp, esp
    push eax
    push ebx


    mov eax, 0
    mov eax, [ebp + 8] ; t2
    mov ebx, [eax] ; wartosc t

    finit
    fld dword ptr [eax] ; zawartosc spod adresu t1
    fld float2
    faddp
    fstp dword ptr [eax] ; zaladuj do adresu z t1 wartosc

    pop ebx
    pop eax
    mov esp, ebp
    pop ebp
    ret
_zmien_wskaznik endp


_kopia_tablicy PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    mov esi, [ebp+8] ; adres pierwszej tablicy
    xor ebx, ebx ; iterator na obie tablice
    mov edi, [ebp+12] ; ilosc elementow
    imul edi, 4 ; int jest na 4 bajtach
    push edi
    call _malloc ; EAX wskazuje na miejsce w pamieci z nowa tablica
    add esp, 4
    cmp eax, 0
    je koniec
    mov ecx, [ebp+12]
    petla:
        mov edx, [esi+4*ebx]
        bt edx, 0
        jc nieparzysta
        mov [eax+4*ebx], edx
        inc ebx
        loop petla
    jmp koniec
    nieparzysta:
        mov edx, 0
        mov [eax+4*ebx], edx
        inc ebx
        loop petla
    koniec:
        pop ebx
        pop edi
        pop esi
        pop ebp
        ret
_kopia_tablicy ENDP


_roznica PROC
    push ebp
    mov ebp, esp
    push ebx
    ; a = 21; by = 25;
    ; *wsk = &b
    ; roznica(&a, &wsk);
    mov eax, [ebp+8]
    mov eax, [eax]
    mov ebx, [ebp+12]
    mov ebx, [ebx]
    mov ebx, [ebx]
    sub eax, ebx
    pop ebx
    pop ebp
    ret
_roznica ENDP



_komunikat PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    mov esi, [ebp+8] ; tekst zrodlowy
    xor ebx, ebx ; iterator zrodlowego i docelowego
    xor ecx, ecx ; iterator tablic
    ileWyrazow:
        mov dl, [esi][ecx]
        cmp dl, 0
        je dalej
        inc ecx
        jmp ileWyrazow
    dalej:
        cmp ecx, 0
        je koniec
        ; rezerwacja miejsca
        add ecx, 5
        push ecx
        call _malloc
        pop ecx
        sub ecx, 5
    petla:
        mov dl, [esi][ebx]
        mov [eax][ebx], dl
        inc ebx
        loop petla
    mov [eax][ebx], byte ptr 'B'
    inc ebx
    mov [eax][ebx], byte ptr 'l'
    inc ebx
    mov [eax][ebx], byte ptr 'a'
    inc ebx
    mov [eax][ebx], byte ptr 'd'
    inc ebx
    mov [eax][ebx], byte ptr '.'
    inc ebx
    koniec:
        pop ebx
        pop edi
        pop esi
        pop ebp
        ret
_komunikat ENDP


_szyfruj PROC
    push ebp
    mov ebp, esp
    push esi
    push ebx
    push edi
    mov edx, 52525252h ; liczba losowa
    mov esi, [ebp+8] ; wskaznik na source tekst
    xor ecx, ecx ; dlugosc tekstu
    xor ebx, ebx ; iterator tekstu
    dlugosc:
        mov al, [esi][ecx]
        cmp al, 0
        je dalej
        inc ecx
        jmp dlugosc
    dalej:
        mov al, [esi]
        xor al, dl
        mov [esi], al
        inc ebx
        dec ecx
        cmp ecx, 0
        je koniec
    petla:
        ; szyfrowanie
        mov eax, 80000000h ; maska na 31 bit
        and eax, edx ; w eax jest 31 bit
        mov edi, 40000000h ; maska na 30 bit
        and edi, edx ; w edi jest 30 bit
        rol edi, 1
        xor eax, edi
        bt eax, 31
        rcl edx, 1
        mov al, [esi][ebx]
        xor al, dl
        mov [esi][ebx], al
        inc ebx
        loop petla
    koniec:
        pop edi
        pop ebx
        pop esi
        pop ebp
        ret
_szyfruj ENDP



_zera proc
; przykladowa wartosc
    mov ebx, 00400080h
    ror ebx, 7
    mov ecx, 24
    petla:
        bt ebx, ecx
        jc nieZero
        loop petla
        bt ebx, ecx
        jc nieZero
        jmp zero
    nieZero:
        rol ebx, 7
        stc
        jmp koniec
    zero:
        rol ebx, 7
        clc
    koniec:
        push 0
        call _ExitProcess@4
_zera endp


_zaokrg PROC
; przykladowa wartosc
    mov edx, 000100FAh
    bt edx, 6
    jc doGory
    bt edx, 31
    jc dodaj
    jmp odejmij
    doGory:
        bt edx, 31
        jc odejmij
    dodaj:
        add edx, 80h
        jmp koniec
    odejmij:
        sub edx, 80h
        jmp koniec
    koniec:
        and edx, 0FFFFFF80h
        push 0
        call _ExitProcess@4
_zaokrg ENDP


_fstp proc
    finit
    fldcw tryb_pracy
    fldz
    fld1
    fsub
    fsqrt
    fistp dword ptr [eax]
    ret
_fstp endp

end
