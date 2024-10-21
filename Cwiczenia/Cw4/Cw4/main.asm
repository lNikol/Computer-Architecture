.686
.model flat


extern  _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc
extern _MessageBoxA@16 : proc


Comment |
W 48-bajtowej tablicy bufor znajduje sie tekst np. "Polaczenia kolejowo – autobusowe"
zakodowany w formacie UTF-8. W tekscie wystepuje takze symbole parowozu i autobusu. 
Napisac program w asemblerze, ktory wyswietli ten tekst na ekranie w postaci komunikatu typu MessageBoxW. 
W ponizszej tablicy wystêpuja ciagi UTF-8  1-, 2-, 3 i 4-bajtowe
| 

.code
_main PROC	
	

	push  4   ; utype
	push OFFSET tytul
	push OFFSET tekst
	push  0 ; hwnd
	call _MessageBoxA@16
	
	mov ah,0  ; mov ax,0
	mov ecx,48
	mov esi,0
	mov edi,0
; konwersja podstawowych znakow ACSII -> utf-16
et:    
	mov al,bufor[esi]	   ; odczyt pierwszego bajtu znaku utf-8
	add esi,1
	cmp al,7fh
	ja znak_wielobajtowy
	
	mov ah,0  ; mov ax,0
	mov output[edi], ax
	add edi,2
	jmp cycle



znak_wielobajtowy:
	bt ax, 5
	jb three_or_four_bytes; if CF = 1, 3 or 4 bytes
	shl al, 3
	shr al, 3 ; al = 000xxxxx
	mov ah, al
	mov al, bufor[esi]
	add esi, 1
	shl al, 2 ; al = xxxxxx00
	shr ax, 2 ; ax = 00000xxx xxxxxxxx
	mov output[edi], ax
	add edi, 2
	sub ecx, 1
	jmp cycle

three_or_four_bytes:
	bt ax, 4
	jb four_bytes ; if CF = 1, 4 bytes
	shl al, 4 ; al = xxxx0000
	shr al, 4 ; al = 0000xxxx
	mov bh, al ; bh = 0000xxxx
	mov al, bufor[esi]
	add esi, 1
	shl al, 2 ; al = xxxxxx00
	mov bl, al ; bl = xxxxxx00; bx = 0000xxxx xxxxxx00
	shr bx, 2 ; bx = 000000xx xxxxxxxx
	shl ebx, 8 ; ebx = 0*8 000000xx x*8 0*8
	mov eax, ebx ; eax = 0*16 000000xx xxxxxxxx ; 2 first bytes
	mov al, bufor[esi] ; al = 10xxxxxx
	add esi, 1
	shl al, 2 ; al = xxxxxx00
	;eax = 0*6xx xxxxxxxx xxxxxx00 00000000
	shr eax, 2

	mov output[edi], ax
	add edi, 2
	mov ebx, 0
	sub ecx, 2
	jmp cycle




four_bytes:
 ; al = 11110xxx
 shl al, 5 ; al = xxx00000
 shr al, 5 ; al = 00000xxx
 mov bh, al ; bh = 00000xxx
 mov al, bufor[esi]
 add esi, 1
 shl al, 2 ; al = xxxxxx00
 mov bl, al
 shr bx, 2 ; bx = 00?*14 0000000x xxxxxxxx ; pierwsze 2 bajty
 shl ebx, 16; ebx = 0000000x xxxxxxxx 0*16
 mov al, bufor[esi]
 add esi, 1
 shl al, 2 ; al = xxxxxx00
 shr al, 2 ; al = 00xxxxxx
 mov bh, al ; bh = 00xxxxxx ; trzeci bajt
 ; bx = 00xxxxxx 0*8
 mov al, bufor[esi]
 add esi, 1
 shl al, 2 ; al = xxxxxx00
 mov bl, al ; ebx = 0000000x x*8 00xxxxxx xxxxxx00 0*8
 shr bx, 2 ; bx = 0000xxxx xxxxxxxx
 shl bx, 4 ; bx = xxxxxxxx xxxx0000
 shr ebx, 4 ; ebx = 00000000 000xxxxx xxxxxxxx xxxxxxxx
 sub ebx, 10000h; ebx = 0*8 0000xxxx x*8 x*8
 mov eax, ebx ;
 shr ebx, 10 ; ebx = 0*8 0*8 000000xx xxxxxxxx
 add bx, 1101100000000000b ; bx = 110110xx x*8
 mov output[edi], bx
 add edi, 2
 ; eax = 0*8 0000xxxx x*8 x*8
 shl eax, 22 ; eax = y*8 yy000000 00000000 0*8
 shr eax, 22 ; eax = 0*8 0*8 000000yy y*8
 add ax, 1101110000000000b ; ax = 110111yy y*8
 mov output[edi], ax
 add edi, 2
 mov ebx, 0
 sub ecx, 3
 jmp cycle

cycle:
 mov eax, 0
 sub ecx, 1
 jnz et



	push  4   ; utype
	push OFFSET tytulW
	push OFFSET output
	push  0 ; hwnd
	call _MessageBoxW@16


	push 0  ; exit code
	call _ExitProcess@4
_main ENDP

  
.data
tekst db "Czy lubisz AKO?",0

bufor2 dw 16 dup (?)


tytul db "Pytanie",0
		dw 'P','y','t','a','n','i','e'
zmA     db  'P',0,   'y',0,  't',0, 'a',0, 'n',0, 'i',0, 'e',0,  0,0
tytulW 		dd  00790050h,0h


; bufor ze znakami wejsciowymi w utf-8
bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parowoz
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; pulpauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus

output  dw 80 dup (0)

  db 'A'
  db 41h
  dw 'AB'  ; dw 4142h


  db 90h
  dw 90h


  db 90h
  db 123

END