.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main
.data
znaki db 32 dup (?)
obszar db 32 dup (?)
dziesiec dd 10 ; mno¿nik

.code

wyswietl_EAX PROC
	pusha

	mov esi, 10 ;indeks wypisywania
	mov ebx, 10 ;dzielnik
	lp: mov edx, 0 ;zerujemy reszte
	div ebx ; edx:eax / ebx = eax, edx:eax % ebx = edx

	;konwersja do ASCII
	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
	mov znaki [esi], dl ; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu

	cmp eax, 0
	jne lp

	wypeln: or esi, esi
	jz wyswietl ; skok, gdy ESI = 0
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln

	wyswietl: ;wypisywanie zawartosci EAX
	mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [31], 0AH ; kod nowego wiersza
	; wyswietlenie cyfr na ekranie
	push dword PTR 32 ; liczba wyswietlanych znakow
	push dword PTR OFFSET znaki ; adres wysw. obszaru
	push dword PTR 1; numer urzadzenia (ekran ma numer 1)

	call __write ; wyswietlenie liczby na ekranie
	add esp,12
	popa
	ret
wyswietl_EAX ENDP


wczytaj_do_EAX PROC
	;zapis rejestrow, ktore trzeba zachowac, na stos
	push ebx
	push ecx

	; wczytywanie liczby dziesiêtnej z klawiatury – po
	; wprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter
	; liczba po konwersji na postaæ binarn¹ zostaje wpisana
	; do rejestru EAX
	; deklaracja tablicy do przechowywania wprowadzanych cyfr
	; (w obszarze danych)

	; max iloœæ znaków wczytywanej liczby
	push dword PTR 32
	push dword PTR OFFSET obszar ; adres obszaru pamiêci
	push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	; (dwa znaki podkreœlenia przed read)
	add esp, 12 ; usuniêcie parametrów ze stosu
	; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
	mov eax, 0
	mov ebx, OFFSET obszar ; adres obszaru ze znakami

	pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
	inc ebx ; zwiêkszenie indeksu
	cmp cl,10 ; sprawdzenie czy naciœniêto Enter
	je byl_enter ; skok, gdy naciœniêto Enter
	sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry

	; mno¿enie wczeœniej obliczonej wartoœci razy 10



	zapisz:
	movzx ecx, cl ; przechowanie wartoœci cyfry w
	; rejestrze ECX
	; mno¿enie wczeœniej obliczonej wartoœci razy 10
	mul dword PTR dziesiec
	;l of zmiana starszego bitu na 1
	jc overflow_detected ; skok, gdy wykryto nadmiar podczas mno¿enia

	test edx, edx ; sprawdzenie, czy rejestr EDX jest ró¿ny od zera
	jnz overflow_detected ; jeœli EDX jest ró¿ne od zera, nadmiar wyst¹pi³
	bt eax, 31
	jc overflow_detected

	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na pocz¹tek pêtli

	jmp zapisz


	overflow_detected:
	; w przypadku nadmiaru ustawienie CF i wyzerowanie EAX
	stc ; ustawienie CF na 1
	mov eax, 0
	jmp byl_enter

	byl_enter:
	; wartosc binarna wprowadzonej liczby znajduje sie teraz w rejestrze EAX

	;odtwarzanie wartosci rejestrow
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

_main PROC
	call wczytaj_do_EAX
	call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END