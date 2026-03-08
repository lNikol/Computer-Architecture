.686
.model flat
public _odejmij_jeden
.code
_odejmij_jeden PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX
	push eax
	; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
	; w kodzie w jêzyku C
	mov ebx, [ebp + 8] ; adres wskaŸnika (int **)
	mov eax, [ebx] ; adres zmiennej (wartoœæ wskaŸnika)
	dec dword ptr [eax]
	pop eax
	pop ebx
	pop ebp
ret
_odejmij_jeden ENDP
END