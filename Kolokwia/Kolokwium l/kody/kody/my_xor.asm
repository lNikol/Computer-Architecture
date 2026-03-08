.686
.model flat

public _my_xor
; .data
; wyniki DB 512 dup (–1)
; c_Eulera DT 0.577215 ; stala Eulera
; DT oznacza Data Type
; DT - 10 bajtow
; tword (80 bitow)

; Deklaracje stalych umozliwiaja przypisanie nazw
; symbolicznych do okreslonych wartosci, np.
; num1 EQU 18H ; zamiast pisac 18H mozna napisac num1
; i wtedy zostanie wpisana liczba 18H

; blok_sys dd ? ; zmienna 32-bitowa
; — — — — — — — — —
; mov cx, word PTR blok_sys
; mov dx, word PTR blok_sys+2


; movzx - move with zero extension
; movsx - move with sign flag extension
; czyli zachowuje ujemnosc argumentu
; 
 
; 00 02 00 01
.data 
stale DW 2,1
napis DW 10 dup (3),2
tekst DB 7
DQ 1

pamiec dd 12345678h
const2 db ?

wskaznik dd ?

.code
_my_xor PROC
; xor eax, edx -> eax = eax xor edx
	mov eax, 1011b
	mov edx, 1101b
	mov ebx, eax

	and ebx, edx ; ebx = eax and edx
	not ebx ; ebx = not (eax and edx)
	
	and eax, ebx
	not eax ; eax = not (eax and not (eax and edx))
	
	and edx,ebx
	not edx; edx = not (edx and not (eax and edx))
	
	and edx, eax
	not edx ; result xor in edx
	mov ebx, edx

	mov eax, 1011b
	mov edx, 1101b
	xor eax, edx
	
	cmp ebx, eax
	je equal
	mov eax, 0000b
	ret


	equal:
		mov eax, 1111b
		ret

_my_xor ENDP



_main PROC
mov const2, 255
; bswap
;mov edx, offset pamiec
;mov ebx, pamiec
;mov eax, 0
;mov ecx, 4
;ptl: mov al, byte ptr [edx + ecx-1]
;ror eax, 8
;loop ptl


; mov eax, 0
; mov ebx, 10
; mov eax, 11
; mul ebx


; liczba jedynek w rejestrze eax
;mov ebx, 0
;mov eax, 11111111111111111111111110011101b
;mov ecx, 32
;mov edx, 32
;ptl: dec edx
;bt eax, edx
;jc jeden
;loop ptl
;jmp ennd

;jeden: inc bl
	;loop ptl
;ennd:	mov cl, bl
	
; wskaznik = [wskaznik]

	loop oblicz
	oblicz: add dh, 7


	mov dword ptr [ebx], 0aabbccddh

	mov al, [ebx + 3]
	mov ah, [ebx + 2]
	shl eax, 16
	mov ah, [ebx + 1]
	mov al, [ebx]

	;xchg bh, bl
	;mov ax, bx
	;shr ebx, 16
	;xchg bh, bl
	;shl eax, 16
	;mov ax, bx

	;mov edx, 0f1f2e1e2H ; mam otrzymac e1e2f1f2
	;xchg dh, dl
	;bswap edx
	;xchg dh, dl

	;mov eax, 0FFFFFFFFH ; -1
	;mov ebx, 0FFFFFFFFH ; -1
	;imul ebx; wynik w edx:eax
	; ffff fffe 0000 0001 -> wynik dla mul, na liczbach bez znaku
	; edx       eax

	; u2
	; 0000 0000 - edx, 0000 0001 - eax

	mov ecx,0
	mov ebx, 0
	MOV CX, napis-1 ; wczytano do cx 00 (mlodszy) 03 (starszy), ale w cx to bedzie 03 00 (little endian)
	SUB tekst, CH
	MOV EDI,1
	MOV tekst[4*EDI],CH
	MOV EBX, DWORD PTR tekst+1 ; zadajemy poczatek odczytu danych z pamieci
	call _my_xor
	
	
	ret
_main ENDP

END _main