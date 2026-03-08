.686
.model flat
public _szukaj_max
public _szukaj4_max
.code
_szukaj_max PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP
	mov eax, [ebp+8] ; liczba x
	cmp eax, [ebp+12] ; porownanie liczb x i y
	jge x_wieksza ; skok, gdy x >= y
	; przypadek x < y
	mov eax, [ebp+12] ; liczba y
	cmp eax, [ebp+16] ; porownanie liczb y i z
	jge y_wieksza ; skok, gdy y >= z
	; przypadek y < z
	; zatem z jest liczb¹ najwieksz¹
	wpisz_z: mov eax, [ebp+16] ; liczba z
	zakoncz:
	pop ebp
	ret
	x_wieksza:
	cmp eax, [ebp+16] ; porownanie x i z
	jge zakoncz ; skok, gdy x >= z
	jmp wpisz_z
	y_wieksza:
	mov eax, [ebp+12] ; liczba y
	jmp zakoncz
_szukaj_max ENDP


_szukaj4_max PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP
	mov eax, [ebp+8] ; liczba x
	cmp eax, [ebp+12] ; porownanie liczb x i y
	jge x_wieksza ; skok, gdy x >= y

	; przypadek x < y
	mov eax, [ebp+12] ; liczba y
	cmp eax, [ebp+16] ; porownanie liczb y i z
	jge y_wieksza ; skok, gdy y >= z

	; przypadek y < z
	; zatem z jest liczb¹ najwieksz¹
	mov eax, [ebp+16] ; liczba z
	cmp eax, [ebp+20] ; porownanie liczb z i w
	; z >= w
	jge z_wieksza
	; z < w
	wpisz_w: mov eax, [ebp+20] ; liczba w

	zakoncz:
	pop ebp
	ret

	x_wieksza:
	cmp eax, [ebp+16] ; porownanie x i z
	; x < z, zostalo w do sprawdzenia
	jl z_wieksza
	; przypadek x >= z, zostalo w do sprawdzenia
	cmp eax, [ebp+20] ; porownanie x z w
	jge zakoncz ; x >= w
	jmp wpisz_w ; x < w

	y_wieksza:
	cmp eax, [ebp+20] ; porownywanie y i w
	jge zakoncz ; y >= w
	jmp wpisz_w ; y < w

	z_wieksza:
	mov eax, [ebp+16] ; liczba z
	cmp eax, [ebp+20] ; porownanie z i w
	jge zakoncz ; z >= w
	jmp wpisz_w ; z < w

_szukaj4_max ENDP
END