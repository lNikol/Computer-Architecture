.686
.model flat

public _reverse_string@4
public _liczba_pi
public _suma
extern _wcslen : proc

.data 
dwa dd 2
dol dd 1
licznik dd 1


.code
_reverse_string@4 PROC
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push edx
    push edi
    push esi


    mov eax, dword ptr[1000h]

    ; Pobierz wskaџnik na іaсcuch
    mov edi, [ebp+8]  ; edi = wskaџnik na іaсcuch

    ; Oblicz dіugoњж іaсcucha
    push edi          ; push wskaџnika na іaсcuch
    call _wcslen      ; dіugoњж w eax
    add esp, 4        ; oczyszczenie stosu

    ; Sprawdџ, czy dіugoњж jest mniejsza lub rуwna 1
    cmp eax, 1
    jbe koniec        ; jeњli dіugoњж <= 1, zakoсcz

    ; Zapamiкtaj pierwszy i ostatni znak
    mov bx, [edi]               ; bx = pierwszy znak
    mov dx, [edi + eax * 2 - 2] ; dx = ostatni znak

    ; Zamieс miejscami pierwszy i ostatni znak
    mov [edi], dx               ; pierwszy znak = ostatni znak
    mov [edi + eax * 2 - 2], bx ; ostatni znak = pierwszy znak

    ; Ustaw ostatni znak na NULL (podziaі іaсcucha)
    mov word ptr [edi + eax * 2 - 2], 0

    ; Rekurencyjne wywoіanie na њrodkowej czкњci іaсcucha
    lea esi, [edi + 2]          ; esi = wskaџnik na drugi znak
    push esi
    call _reverse_string@4      ; rekurencyjne wywoіanie

    ; Przywrуж ostatni znak
    mov word ptr [edi + eax * 2 - 2], dx

koniec:
    ; Przywrуж rejestry i zakoсcz funkcjк
    pop esi
    pop edi
    pop edx
    pop ebx
    pop eax
    mov esp, ebp
    pop ebp
    ret 4
_reverse_string@4 ENDP







; Napisaж podprogram w 32 bitowym asemblerze (bez wykorzystania rejestrуw 64-bitowych,
; przystosowany do wywoіania z poziomu jкzyka C, o nastкpuj№cym prototypie
; _shl_128 (_m128 *a, char n);
; ktуry przesunie logicznie 128 bitow№ liczbк o n bitуw w lewo. Podprogram nie moїe
; wykorzystywaж segmentu danych statycznych.

_shl_128 proc
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    push edi

    ; Pobierz wskaџnik do liczby 128-bitowej
    mov edi, [ebp+8]     ; edi = wskaџnik na __m128

    ; Pobierz liczbк bitуw do przesuniкcia
    movzx ecx, byte ptr [ebp+12] ; ecx = n (8-bitowa wartoњж)

    ; Sprawdџ, czy n = 0
    cmp ecx, 0
    jz koniec

    ; Przesuс liczbк 128-bitow№ o n bitуw w lewo
    mov eax, [edi]       ; eax = pierwsze 32 bity
    mov ebx, [edi+4]     ; ebx = drugie 32 bity
    mov edx, [edi+8]     ; edx = trzecie 32 bity
    mov esi, [edi+12]    ; esi = czwarte 32 bity

    ; Przesuniкcie o n bitуw
    shld esi, edx, cl    ; esi = (edx << cl) | (esi >> (32 - cl))
    shld edx, ebx, cl    ; edx = (ebx << cl) | (edx >> (32 - cl))
    shld ebx, eax, cl    ; ebx = (eax << cl) | (ebx >> (32 - cl))
    shl eax, cl          ; eax = eax << cl

    ; Zapisz wynik
    mov [edi], eax
    mov [edi+4], ebx
    mov [edi+8], edx
    mov [edi+12], esi

koniec:
    ; Przywrуж rejestry i zakoсcz funkcjк
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    mov esp, ebp
    pop ebp
    ret 8                ; stdcall: oczyњж stos (8 bajtуw)
_shl_128 endp




_liczba_pi proc
    push ebp
    mov ebp, esp ; [ebp + 8] liczba n
    push ecx


    mov ecx, [ebp + 8] ; liczba n
    cmp ecx, 1
    jl koniec

    finit
    fild dword ptr dwa ; pierwszy_iloczyn

    licz:
    ; obliczenie parzystych elementow, czyli gdzie zwieksza sie gora (2*licznik)
    fild dword ptr dwa
    fild dword ptr licznik; wartosc licznika
    fmul ; st(0) = licznik*dwa
    fild dword ptr dol ; wartosc dol
    ; st(0) = dol, st(1) = licznik*dwa, st(2) = stary_iloczyn
    fdiv ; obliczenie ilorazu , licznik*dwa/dol
    ; st(0) = st(1) / st(0) = licznik*dwa/dol, st(1) = stary_iloczyn
    fmul ; st(0) = nowy_iloczyn
    dec ecx
    jz koniec

    ; obliczenie nieparzystych elementow, czyli gdzie zwieksza sie dol
    add dword ptr dol, 2 ; zwiekszenie dol o 2
    fild dword ptr dwa
    fild dword ptr licznik
    fmul ; st(0) = dwa*licznik
    fild dword ptr dol
    fdiv ; st(0) = dwa*licznik/new_dol
    fmul ; st(0) = nowy_element * stary_iloczyn 
    add dword ptr licznik, 1
    loop licz


    koniec:
    pop ecx
    mov esp, ebp
    pop ebp
    ret
    


_liczba_pi endp



_suma PROC
    push ebp          
    mov ebp, esp        
    push esi           
    push edi           
    push ebx          

    ; Argumenty funkcji
    mov esi, [ebp+8]    ; ESI = (arr)
    mov ecx, [ebp+12]   ; ECX = n

    ; Sprawdzenie warunku zakończenia rekurencji (n == 0)
    cmp ecx, 0
    je zakoncz_rekurencje

    ; Zmniejsz licznik elementów (n-1)
    dec ecx

    ; Przesuń wskaźnik na następny element tablicy (arr + 1)
    add esi, 8          ; long long ma 8 bajtów, więc dodajemy 8

    ; Wywołanie rekurencyjne: suma(arr + 1, n-1)
    push ecx            ; Przekaż n-1 jako argument
    push esi            ; Przekaż arr + 1 jako argument
    call _suma           ; Wywołaj rekurencyjnie
    add esp, 8          ; Oczyść stos z argumentów

    ; Wynik rekurencji jest w EDX:EAX
    ; Bieżący element to [esi - 8] (bo wcześniej dodaliśmy 8 do esi)
    mov ebx, esi        ; EBX = arr + 1
    sub ebx, 8          ; EBX = arr (bieżący element)

    ; Dodaj niższą część (32 bity)
    add eax, [ebx]      ; EAX += arr[0].low
    adc edx, [ebx+4]    ; EDX += arr[0].high + CF (przeniesienie)

    ; Epilog funkcji
    pop ebx            
    pop edi            
    pop esi             
    mov esp, ebp       
    pop ebp             
    ret                 
zakoncz_rekurencje:
    ; Jeśli n == 0, zwróć 0 (EDX:EAX = 0)
    xor eax, eax        
    xor edx, edx        

    ; Epilog funkcji
    pop ebx            
    pop edi             
    pop esi             
    mov esp, ebp       
    pop ebp            
    ret                 
_suma ENDP

end
