.686
.model flat

extern _MessageBoxA@16 : proc

.data
dwa dd 25.0
a dd 2.0
b dd 2.5
suma dd 0.0
obszar dw 2 dup (?)

text dd 'ar', 'ch', 'it', 'ek', 'tu', 'ra', 0
m = $ - text


co dw 4, 2 dup(1)
dq 'A'
to db 4*5
jest dd 0ffh, ?
ako dt 0

temp db ?

.code
_main PROC

mov al, 128
mov bl, 129
add al, bl 
sbb ebx, ebx
neg ebx
bts eax, ebx


mov temp, ax
mov eax, [esp + 8]
mov eax, [1*ebx +edx +12]

mov ebx, 1
mov edx, 4

stc
sbb edx, edx
neg edx
bts ebx, edx


mov eax, et
mov eax, offset et


fld dword ptr dwa
push 10
fild dword ptr [esp]
fdiv
fist dword ptr [123456h]







mov eax, ako - co
mov ebx, 4001h
test eax, ebx


mov eax, text
mov eax, text -1
mov eax, offset text ; zawartosc textu, el[0]
mov ebx, eax
mov ebx, [eax]
 add eax, 050000000h


mov ecx, 6
mov bx, word ptr text[4*ecx-3]
z2: shl word ptr text[4*ecx-3], 8
loop z2
push 0
push 0
lea eax, text[m-14]
push eax
push 0
call _MessageBoxA@16

	mov ebx, -1
	mov bx, 2
	mov edx, dalej
et:
	sub bx, 1
	jz dalej
	call et ; [esp] = et


dalej:
	lea ebx, offset dalej
	sub ebx, [esp]

ret
_main endp

_skok proc
	mov edi, [esp]
	add [esp], dword ptr 8
	mov ebx, 22
	mov bh, [edi+5]
	add bh, [edi+3]
	ret
_skok endp



END _main