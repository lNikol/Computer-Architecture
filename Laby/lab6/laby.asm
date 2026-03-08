; Program gwiazdki.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

kwadrat PROC
    push ax
    push bx
    push cx
    push dx
    push es

    ; Ustawienie segmentu pamięci wideo
    mov ax, 0A000H
    mov es, ax

    ;xor dx, dx
    ;mov dx, cs:top_piksel
    ; Sprawdzenie warunku końcowego
    ;cmp dx, cs:low_piksel
    ;jge koniec


    mov bx, cs:top_piksel
maluj_gore:
    mov cs:adres_piksela, bx
    mov al, cs:kolor
    mov es:[bx], al
    inc bx
    cmp bx, cs:prawy_piksel
    jle maluj_gore

    ; Dolna linia pozioma
    mov bx, cs:low_piksel
maluj_dol:
    mov cs:adres_piksela, bx
    mov al, cs:kolor
    mov es:[bx], al
    inc bx
    cmp bx, cs:prawy_piksel
    jle maluj_dol


maluj_lewo:
    mov cs:adres_piksela, bx
    mov al, cs:kolor
    mov es:[bx], al
    add bx, 320
    cmp bx, cs:low_piksel
    jle maluj_lewo

    ; Prawa linia pionowa
    mov bx, cs:prawy_piksel

koniec:
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    jmp dword PTR cs:wektor8

    ; Zmienne procedury
    kolor db 2               
    adres_piksela dw 0       ; Adres bieżącego piksela
    top_piksel dw 0          ; Górna granica prostokąta
    low_piksel dw 320 * 199  ; Dolna granica prostokąta
    prawy_piksel dw 319      ; Prawa granica prostokąta
    wektor8 dd ?             ; Adres starego wektora przerwania
kwadrat ENDP

zacznij:
    ; Ustawienie trybu graficznego 13H
    mov ah, 0
    mov al, 13H
    int 10H

    ; Zapamiętanie oryginalnego wektora przerwań
    mov ax, 0
    mov es, ax
    mov eax, es:[32]
    mov cs:wektor8, eax

    ; Ustawienie własnego przerwania zegarowego
    mov ax, SEG kwadrat
    mov bx, OFFSET kwadrat
    cli
    mov es:[32], bx
    mov es:[32+2], ax
    sti

czekaj:
    ; Oczekiwanie na klawisz 'x'
    mov ah, 1
    int 16H
    cmp al, 'x'
    jne czekaj

    ; Powrót do trybu tekstowego
    mov ah, 0
    mov al, 3H
    int 10H

    ; Przywrócenie oryginalnego wektora przerwań
    mov eax, cs:wektor8
    mov es:[32], eax

    ; Zakończenie programu
    mov ax, 4C00H
    int 21H
rozkazy ENDS

stosik SEGMENT stack
db 256 dup (?)
stosik ENDS

END zacznij
