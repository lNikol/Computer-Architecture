.686
.model flat

extern  _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc
extern _MessageBoxA@16 : proc

.data


CO       dw     4,2 dup (1) ; 6
         dq     'A' ; 8 
TO       db     4*5 ; 1
JEST     dd     0FFH,? ; 8
AKO      dt     0 ; 10 suma = 33


bufor2 dw 16 dup (?)
zmienna dw ?
tryb_pracy dw 037Eh
; bufor ze znakami wejsciowymi w utf-8
bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parowoz
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; polpauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus

output  dw 48 dup (?)

tekst dd 'ar', 'ch','it', 'ek','tu','raxy', 0
m  = $ - tekst ; 7*4 = 28


.code
_show_utf PROC

	push eax
	push ebx
	push ecx
	push edx
	push esi

	pushfd
	pushfd
	xor dword ptr [esp],00200000h
	popfd
	pushfd
	pop eax
	xor eax,[esp]
	popfd
	and eax,00200000h










	finit 
	fldcw tryb_pracy    ; tryb_pracy dw 037Eh  - zdefiniowane w segmencie .data
	fldz
	fld1
	fsqrt
	fistp zmienna


	mov ecx, 48
	mov eax, 0
	mov edx, 0
	mov ebx, 0
	mov esi, 0
	wczytuj:

	; wczytywanie pierwszego bitu
	; czy trzeba dodawac bit zerowy do utf w jednym bicie
	mov eax, 0
	mov al, bufor[edx]

	cmp al, 07FH
	ja dwa_lub_wicej
	; jeden bit
	mov output[esi], ax
	jmp koncz

	dwa_lub_wicej:
	bt ax, 5 ; bt ustawia CF na 1 gdy = 1 , 0 w przecywnym razie
	jc trzy_lub_wiecej ; ax[5] = 1
	; w al starsza czesc utf 2-bajtowego
	; kontynuajca, bo utf8 jest dwubajtowy

	shl ax, 11 ; w ax xxxxx000 00000000
	shr ax, 3 ; w ah 000xxxxx

	mov al, bufor[edx + 1] ; al = 10xxxxxx
	shl al, 2 ; ax 000xxxxx xxxxxx00
	shr ax, 2 ; ax 00000xxx xxxxxxxx
	; teraz w ax 2 bity z utf


	mov output[esi], ax
	inc edx
	jmp koncz

	trzy_lub_wiecej:
	bt ax, 4
	jc cztery ; bit jest = 1
	; utf 3-bajtowy
	shl al, 4 ; al = xxxx0000
	shr al, 4; al = 0000xxxx
	shl ax, 8 ; ax = 0000xxxx 00000000
	mov al, bufor [edx + 1]
	shl al, 2 ; al = xxxxxx00
	; ax = 0000xxxx xxxxxx00
	shr ax, 2 ; ax = 000000xx xxxxxxxx
	shl ax, 6 ; ax = xxxxxxxx xx000000

	mov bl, bufor [edx + 2] ; trzeci bit utf
	shl bl, 2
	shr bl, 2 ; bl = 00xxxxxx
	mov al, bl
	; ax = xxxxxxxx xxxxxxxx
	mov output[esi], ax
	add edx, 2
	jmp koncz

	cztery:
	; zle kodowanie do utf-16 4-bajtowego


	; w al bit 11110xxx
	shl al, 5
	shr al, 5 ; al = 00000xxx
	shl ax, 8 ; ax = 000000xxx 0*8
	
	mov al, bufor [edx + 1]
	shl al, 2 ; ax = 00000xxx xxxxxx00
	shl eax, 21; eax = xxxxxxxx x0000000 0*8 0*8
	shr eax, 8 ; eax = 0*8 x*8 x0000000 0*8
	; w eax 2 pierwsze bity utf
	mov ebx, 0
	mov bl, bufor [edx + 2]
	shl bl, 2
	shr bl, 2 ; bl = 00xxxxxx
	shl bx, 8 ; bx = 00xxxxxx 0*8
	mov bl, bufor [edx + 3]
	; sprawdzic jak dziala shl i shr, czy bity z bx przenosza sie do starszej czesci rejestru

	shr bl, 2 ; bl = xxxxxx00
	shl ebx, 1
	; ebx = 0*8 0*8 0xxxxxxx xxxxx000
	add eax, ebx
	shr eax, 3 ; eax = 0*8 00000xxx x*8 x*8
	add edx, 3

	mov dword ptr output[esi], eax



	koncz:
	inc edx
	add esi, 2
	dec ecx
	jnz wczytuj

	push 4
	push offset bufor
	push offset bufor
	push 0
	call _MessageBoxW@16

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	call _ExitProcess@4
_show_utf ENDP

END _show_utf