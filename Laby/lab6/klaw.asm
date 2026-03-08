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
; podprogram 'wyswietl_AL' wyświetla zawartość rejestru AL
; w postaci liczby dziesiętnej bez znaku
wyswietl_AL PROC
	; wyświetlanie zawartości rejestru AL na ekranie wg adresu
	; podanego w ES:BX
	; stosowany jest bezpośredni zapis do pamięci ekranu
	; przechowanie rejestrów
	push ax
	push cx
	push dx
	mov cl, 10 ; dzielnik
	mov ah, 0 ; zerowanie starszej części dzielnej
	; dzielenie liczby w AX przez liczbę w CL, iloraz w AL,
	; reszta w AH (tu: dzielenie przez 10)
	div cl
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+4], ah ; cyfra jedności
	mov ah, 0
	div cl ; drugie dzielenie przez 10
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+2], ah ; cyfra dziesiątek
	add al, 30H ; zamiana na kod ASCII
	mov es:[bx+0], al ; cyfra setek
	; wpisanie kodu koloru (intensywny biały) do pamięci ekranu
	mov al, 00001111B
	mov es:[bx+1],al
	mov es:[bx+3],al
	mov es:[bx+5],al
	; odtworzenie rejestrów
	pop dx
	pop cx
	pop ax
	ret ; wyjście z podprogramu
wyswietl_AL ENDP


obsluga_klawiatury PROC
	; przechowanie uzywanych rejestrow
	push ax
	push bx
	push es
	; wpisanie adresu pamieci ekranu do rejestru ES
	; pamiec ekranu dla trybu tekstowego zaczyna sie od adresu B8000H
	; jednak do rejestru ES wpisujemy wartosc B800H bo w trakcie obliczenia adresu procesor
	; kazdorazowo mnozy zawartosc rejestru ES przez 16
	mov ax, 0B800h
	mov es, ax
	mov bx, 0
	in al, 60h
	call wyswietl_AL
	pop es
	pop bx
	pop ax
	jmp dword ptr cs:wektor9
	wektor9 dd ?
obsluga_klawiatury ENDP


;============================================================
; program główny - instalacja i deinstalacja procedury
; obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
; ustalenie strony nr 0 dla trybu tekstowego
	zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds, ax
	; odczytanie zawartosci wektora nr 9 i zapisanie go w zmiennej wektor9
	mov eax, ds:[36] ; adres fizyczny 2*16+4 = 36
	mov cs:wektor9, eax
	; wpisanie do wektora nr 9 adresu procedury 'obsluga_klawiatury'
	mov ax, SEG obsluga_klawiatury
	mov bx, offset obsluga_klawiatury
	cli ; zablokowanie przerwan
	mov ds:[36], bx
	mov ds:[38], ax
	sti ; odblokowanie przerwan
	aktywne:
	mov ah, 1
	int 16h
	jz aktywne
	mov ah, 0
	int 16h
	cmp ah, 1 ; scan code ESC
	jne aktywne
	; deinstalacja procedury obslugi przerwania zegarowego
	mov eax, cs:wektor9
	cli
	mov ds:[36], eax
	sti
	; zakonczenie programu
	mov al, 0
	mov ah, 4Ch
	int 21h

rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS
END zacznij