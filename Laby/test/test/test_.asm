.686
.model flat
extern _malloc : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC
public _moving_avg

.data
offset_wektora db 2 dup (?)
dana dw 'ab','cd','ef'

pamiec dd 12345678h
napis db 'informatyka', 0, 4 dup (?)

linie dd 421, 422, 443
  dd 442, 444, 427, 432
.code

public _szukaj_elem_min
; int * szukaj_elem_min (int tablica[], int n)
; zwrocic adres najmniejszego elementu tablicy
; tablica = [3,2,1,4,5];
; ecx - tablica, eax - n
.code
_szukaj_elem_min proc
    push edx
    push ebx
    push esi
    
    mov ebx, ecx ; ebx - tab[0]
    mov ecx, 0

    ; edx = max, nastepny element
    ; edi = min, minimalny element
    mov edi, ebx
    ptl:
        mov edx, [ebx + 4*ecx]
        cmp edx, esi
        jle zamien_min ; edx <= edi
        
        ; edi > edx

        inc ecx
        cmp ecx, eax
        jne ptl

    pop esi
    pop ebx
    pop edx
    ret

    zamien_min:
    mov esi, edx
    jmp ptl
_szukaj_elem_min endp


_moving_avg proc

; kod kolo2










mov edx, linie[2]

mov edx, 0F0000000h
mov ebx, 0E0000000h
mov eax, 0D0000000h

mov ecx, 32
bt eax, 31
ptlx:
rcl ebx, 1
rcl edx, 1
rcl eax, 1
loop ptlx




mov ecx, 32
shl eax, 1
ptl1:
rcl ebx, 1
rcl edx, 1
rcl eax, 1
loop ptl1

mov ecx, 32
shl ebx, 1
ptl2:
rcl edx, 1
rcl eax, 1
rcl ebx, 1
loop ptl2

mov ecx, 32
shl edx, 1
ptl3:
rcl eax, 1
rcl ebx, 1
rcl edx, 1
loop ptl3

   mov edx, offset pamiec
mov ebx, pamiec ;zeby sprawdzic co tam jest ladnie
mov ecx, 4
ptl:
mov al, byte ptr [edx+ecx-1]
ror eax, 8 ; przemieszczenie bitow w kierunku od prawej do lewej, cyklicznie
loop ptl
    



    cmp ebx, 0
    ;jge koniec
    not bl  
    add bl, 1

    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    ; Argumenty funkcji:
    ; table: [ebp+8]
    ; k: [ebp+12]
    ; m: [ebp+16]

    ; Rozmiar wyjsciowej tablicy: k - m + 1 (w floatach)
    mov eax, dword ptr [ebp+12]    
    sub eax, dword ptr [ebp+16]    
    add eax, 1                     ; eax = k - m + 1
    test eax, eax                  ; czy rozmiar > 0
    jle error_return               

    ; Ilosc pamieci do alokacji: (k - m + 1) * sizeof(float)
    push eax                       
    shl eax, 2                     ; eax *= 4 (rozmiar float)
    push eax                       
    call _malloc                    
    add esp, 4                     
    test eax, eax                  
    jz error_return                

    ; eax zawiera wskaznik na zaalokowana pamiec
    mov edi, eax                   ; edi = wskaznik na wyjsciowa tablice
    pop ebx                        ; ebx = rozmiar wyjsciowej tablicy (k - m + 1)
    push edi

    ; Obliczanie srednich ruchomych
    mov esi, dword ptr [ebp+8]     ; esi = wskaznik na tablice wejsciowa (table)
    mov ecx, dword ptr [ebp+16]    ; ecx = m (rozmiar okna)

main_loop:
    fldz                           ; st(0) = 0 (inicjalizacja sumy)
    xor eax, eax                   
sum_loop:
    fld qword ptr [esi + eax*8]    ; ladowanie table[eax]
    faddp st(1), st(0)             
    inc eax                        
    cmp eax, ecx                   ; czy ptrzetworzono m elementow?
    jl sum_loop                     

    ; suma / m
    fidiv dword ptr [ebp+16]       ; st(0) = suma / m

    ; wynik w tablicy wyjsciowej
    fstp dword ptr [edi]           ; wyjsciowa_tablica[i] = srednia
    add edi, 4                     

    add esi, 8                     ; wsk wejsc = (table + 1)
    dec ebx                        
    jnz main_loop                  

    pop edi
    ; zwracam wskaznik na tablice wyjsciowa
    mov eax, edi
    jmp clean_exit

error_return:
    xor eax, eax                   ; zwracam NULL

clean_exit:
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret
_moving_avg endp

end
