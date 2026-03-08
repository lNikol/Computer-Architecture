.686
.model flat
extern _ExitProcess@4 : PROC
.code
_dodaj PROC
	mov esi, [esp]
	mov eax, [esi]
	add eax, [esi+4]
	add byte ptr [esp], 8
	ret
_dodaj ENDP



_main PROC


mov eax, 10

mov ebx, eax



call _dodaj
dd 5
dd 7
jmp ciag_dalszy

ciag_dalszy:
mov ecx, 85 
push 0
call _ExitProcess@4

_main ENDP
END _main