.686
.model flat


extern  _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc
extern _MessageBoxA@16 : proc

.code
_main PROC	
	

	push  4   ; utype
	push OFFSET tytul
	push OFFSET tekst
	push  0 ; hwnd
	call _MessageBoxA@16
	
	mov ah,0  ; mov ax,0
	mov ecx,16
	mov esi,0
	mov edi,0
; konwersja podstawowych znakow ACSII -> utf-16
et:    
	mov al,bufor[esi]	   ; odczyt pierwszego bajtu znaku utf-8
	add esi,1
	;mov byte ptr bufor[0],al
	;mov byte bufor[1],0
	cmp al,7fh
	ja  znak_wielobajtowy
	
	mov ah,0  ; mov ax,0
	mov output[edi],ax
	add edi,2



znak_wielobajtowy:
	
	loop et


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

output  dw 48 dup (?)

  db 'A'
  db 41h
  dw 'AB'  ; dw 4142h


  db 90h
  dw 90h


  db 90h
  db 123

END