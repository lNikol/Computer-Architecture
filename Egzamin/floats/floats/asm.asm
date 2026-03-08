.686
.model flat

extern _MessageBoxA@16 : proc


.data
byte_ db 'a', 'b', 'd', 'f', 'l'
byte2 dw 'x', 'y', 'u', 'ab', 'cd', 0 
word_ dw 'ad','s', 'ou','i', 0
word2 dw 'as', 'df', 'km', 'ol', 0


stale dw 2, 1
napis dw 10 dup(3), 2
tekst db 7
	  dq 1

.code


_month proc
push ebp
mov ebp, esp
push ebx
push ecx
push edx



mov ebx, 32
mov edx, 2
ptl_1:
mov eax, 514
div ebx
sub edx, 1
jnz ptl_1





; eax = int*
; edx nr miesiaca
xor ecx, ecx

mov ebx, [eax +4*edx] ; odpowiedni miesiac
; wstepnie miesiac = 16bit
mov ecx, 32

ptl:
ror ebx, 1
jc zapisz
loop ptl
jmp po_zapisie


zapisz:



po_zapisie:






pop edx
pop ecx
pop ebx
mov esp, ebp
pop ebp
ret

_month endp 




; [ebp + 8] pierwszy float
; [ebp + 12] drugi float
_fadd PROC
	push ebp
	mov ebp, esp
	push edi
	push esi
	push ebx
; koniec prologu 





;;

xor eax, eax
sub eax, 0ffffffffh

xor ecx, ecx

mov cx, napis-1
sub tekst, ch
mov edi, 1
mov tekst[4*edi], ch
mov ebx, dword ptr tekst +1

push 0
push offset byte_ ; tytul
lea eax, dword ptr [byte2]
push eax ; tresc
push 0
call _MessageBoxA@16

;;




mov eax, 10
mov ebx, eax


	; najpierw porownamy wykladniki, zeby stwierdzic
	; ktora liczba jest wieksza; chcemy, zeby
	; wieksza liczba byla w [ebp + 8]
	mov eax, [ebp + 8]
	mov ebx, [ebp + 12]
	shr eax, 23
	shr ebx, 23
	cmp eax, ebx
	jae numbers_ordered_correctly
	; w przeciwnym razie odwracamy je w pamieci
	mov ecx, [ebp + 12]
	xchg ecx, [ebp + 8]
	mov [ebp + 12], ecx
	xchg eax, ebx

numbers_ordered_correctly:
	; sprawdzamy, czy mniejsz¹ licz¹ jest zero, jeœli tak,
	; to zwracamy liczbe wieksza
	cmp dword ptr [ebp + 12], 0
	jne continue_nonzero
	mov eax, dword ptr [ebp + 8]
	jmp return_value_in_eax

continue_nonzero:
	; w eax i ebx dalej mamy wykladniki liczb (w eax wiekszej)
	; liczymy o ile wiekszej i dzielimy ni¿ej mantyse (przez bitshift)
	mov ecx, eax
	sub ecx, ebx
	; jesli ecx >= 30, to i tak druga liczba jest za mala, by byc
	; zauwazona w dodawaniu; zeby nie zepsuc `shr edx, cl` capujemy
	; ecx do poziomu 30
	cmp ecx, 30
	jb ecx_normalised
	mov ecx, 30
ecx_normalised:
	; ladujemy liczby do esi i edi (odpowiednio: wieksza, mniejsza)
	mov esi, [ebp + 8]
	mov edi, [ebp + 12]
	; usuwanie zbednych bitow po lewej dzieki bitmaskom
	; dzieki temu w esi, edi mamy tylko mantysy
	and esi, 007FFFFFh
	and edi, 007FFFFFh
	; dodajemy jedynki, ktore byly niejawne, tez dzieki bitmaskom
	or esi, 00800000h
	or edi, 00800000h
	; shiftujemy mniejsza liczbe w prawo (nie tracimy na precyzji
	; poniewaz w dodawaniu wykladnik moze tylko wzrasnac, nie zmalec)
	shr edi, cl
	; dodajemy dwie mantysy
	add esi, edi
	; testujemy czy doszlo do przepelnienia (z 24 na 25 bitów)
	bt esi, 24 ; (pamietajcie ze w notacji intela lecimy od zera)
	jnc merge_number
	; skoro sie tu spotykamy to trzeba zwiekszyc wykladnik
	inc eax
	; a takze przesunac liczbe w prawo
	shr esi, 1

merge_number:
	; skladamy liczbe do kupy, najpierw usuwamy wiodaca jedynke mantysy
	and esi, 007FFFFFh
	; przesuwamy wykladnik w miejsce wykladnika
	shl eax, 23
	; no i konkatenacja z mantys¹
	or eax, esi

return_value_in_eax:
	; zwracany wynik, zgodnie ze standardem C,
	; musi byæ pozostawiony na wierzcho³ku stosu koprocesora
	push eax
	finit
	fld dword ptr [esp]
	add esp, 4

; epilog
	pop ebx
	pop esi
	pop edi
	mov esp, ebp
	pop ebp
	ret
_fadd ENDP

; [ebp + 8] pierwszy float
; [ebp + 12] drugi float
_fmul PROC
	push ebp
	mov ebp, esp
	push edi
	push esi
	push ebx
; koniec prologu 

; logika programu jest taka, ¿e traktujemy mantyse jako
; liczbe ca³kowit¹, w zwi¹zku z tym musimy odj¹æ od obu
; wyk³adników symbolicznie po 23:
; 1.xyz * 2^a = 1xyz... * 2^(a - 23)
; nastêpnie mno¿ymy mantysy, a nastêpnie bitshiftujemy,
; ¿eby znormalizowaæ mantysê; ka¿dy bitshift w prawo
; dodaje 1 do wyk³adnika:
; xyz * 2^a ~= xy * 2^(a+1)
; gdy to ju¿ siê dokona to dodajemy 23 do mianownika,
; gdy¿ stawiamy wirtualn¹ kropkê po wiod¹cej jedynce

	; najpierw mnozymy mantysy, musimy jednak usunac zbedne
	; bity po lewo i dodac jawn¹ jedynkê dziêki bitmaskom
	mov eax, [ebp + 8]
	mov ebx, [ebp + 12]
	and eax, 007FFFFFh
	and ebx, 007FFFFFh
	or eax, 00800000h
	or ebx, 00800000h
	mul ebx
	; teraz w pêtli bitshiftujemy dwie liczby na raz, zliczaj¹c
	; jednoczeœnie obiegi pêtli w ebx
	; taki bitshift mo¿na wykonaæ w pêtli przy u¿yciu carry flag:
	; abcd:efgh => abc:efgh (d w carry) => abc:defg (h w carry)
	; warunek stopu -> edx:eax musi siê pokryæ z mask¹ 
	; 00 00 00 00 : 00 FF FF FF
	; czyli cmp edx, 0 => equal, cmp eax, 00 FF FF FF H => below/equal
	mov ebx, 0
shift_edx_eax:
	shr edx, 1
	rcr eax, 1
	inc ebx
	cmp edx, 0
	jne shift_edx_eax
	cmp eax, 00FFFFFFh
	ja shift_edx_eax
	; zliczylismy ju¿ obiegi pêtli, w eax znajduje siê
	; teraz mantysa z jawn¹ jedynk¹, któr¹ teraz usuwamy
	and eax, 007FFFFFh
	; teraz matematycznie wyprowadŸmy wzór na wyk³adnik
	; patrz¹c po tym, co zrobiliœmy:
	; (x * 2^a) * (y * 2^b) = x...(l.ca³k.) * 2^(a-23) * y...(l.ca³k.) * 2^(b-23) =
	; = xy (ca³kowite) * 2^(a+b-46) = xy (24-cyfrowa l.ca³k.) * 2^(a+b-46 + (liczba bitshiftów))
	; = xy (1...) * 2^(a+b-46+EBX+23) = xy * 2^(a+b-23+EBX)
	
	; wystarczy wiêc, ¿e wyk³adniki dodamy do siebie,
	; odejmiemy 23 i dodamy EBX; nale¿y jednak pamiêtaæ
	; ¿e w standardzie IEEE wyk³adniki s¹ powiêkszone o 127,
	; wiêc a+b to de facto a+b+2*127; nasza wynikowa wartoœæ
	; powinna byæ w takim razie pomniejszona o 127, co razem
	; z pomniejszeniem o 23 daje pomniejszenie o 150
	mov esi, [ebp + 8]
	mov edi, [ebp + 12]
	; przy okazji usuwania znaków z esi i edi
	; okreœlimy znak wyniku mno¿enia w ecx (na MSB)
	mov ecx, 0
	shl esi, 1
	adc ecx, 0
	shl edi, 1
	adc ecx, 0
	shl ecx, 31
	; wykladniki na miejsce do wykonywania arytmetyki
	shr esi, 24
	shr edi, 24
	; a + b
	add esi, edi
	; - 150
	sub esi, 150
	; + EBX
	add esi, ebx
	; no i przesuwamy w odpowiednie miejsce
	shl esi, 23

	; sk³adamy teraz liczbê w ca³oœæ, 
	or eax, ecx ; znak
	or eax, esi ; wykladnik

	; zwracany wynik, zgodnie ze standardem C,
	; musi byæ pozostawiony na wierzcho³ku stosu koprocesora
	push eax
	finit
	fld dword ptr [esp]
	add esp, 4

; epilog
	pop ebx
	pop esi
	pop edi
	mov esp, ebp
	pop ebp
	ret
_fmul ENDP

; [ebp + 8] pierwszy float
; [ebp + 12] drugi float
_fdiv PROC
	push ebp
	mov ebp, esp
	push edi
	push esi
	push ebx
; koniec prologu 

; logika programu jest podobna jak przy mno¿eniu, jednak
; zamiast dodawaæ wyk³adniki, tutaj je odejmujemy,
; natomiast do mantys nalezy zastosowac rozkaz div, jednak
; zeby nie stracic precyzji nalezy przesunac dla dzialania
; a / b, liczbê a o 24 bity w lewo, gdyz wtedy zachowujemy
; cala precyzje, jaka jest nam potrzebna we floatach
; jednoczesnie unikaj¹c przepelnienia (polecam to sprawdziæ
; w kalkulatorze, maksymalna liczba / minimalna: 
; FF FF FF 00 00 00 / 80 00 00, mieœci siê w 32-bitach,
; a na odwrót 80 00 00 00 00 00 / FF FF FF, zajmuje
; 24 bity, czyli ca³¹ precyzjê floata)

	; najpierw dzielimy mantysy, musimy jednak usunac zbedne
	; bity po lewo i dodac jawn¹ jedynkê dziêki bitmaskom
	; a takze przesunac w lewo o 24 razy, zeby pierwsza
	; liczba znalaz³a siê w rejestrze edx:eax
	mov edx, 0
	mov eax, [ebp + 8]
	mov ebx, [ebp + 12]
	and eax, 007FFFFFh
	and ebx, 007FFFFFh
	or eax, 00800000h
	or ebx, 00800000h
	; przesuwanie w lewo przez carry w pêtli,
	; podobnie jak przy mno¿eniu
	mov ecx, 24
shift_edx_eax:
	shl eax, 1
	rcl edx, 1
	loop shift_edx_eax
	; teraz mozemy dzielic
	div ebx
	; teraz normalizujemy mantysê, by zajmowa³a 24 bity
	; podobnie jak przy mno¿eniu, ale bez koniecznoœci
	; przesuwania rejestru edx (zliczamy obiegi do ebx)
	mov ebx, 0
	cmp eax, 00FFFFFFh
	jbe build_exponent
shift_eax:
	shr eax, 1
	inc ebx
	cmp eax, 00FFFFFFh
	ja shift_edx_eax
	
build_exponent:
	; matematyczne wyprowadzenie wzoru na wyk³adnik
	; znajduje siê na kanale discord, w skrócie:
	; uwzglêdniamy to, ¿e przesunêlismy na poczatku liczbê
	; o 24 w lewo, nastêpnie uwzglêdniamy normalizacjê
	; mantysy (liczba obiegów ebx), a tak¿e wirtualn¹
	; kropkê (+23), a tak¿e standard IEEE (+127)
	mov esi, [ebp + 8]
	mov edi, [ebp + 12]
	; przy okazji usuwania znaków z esi i edi
	; okreœlimy znak wyniku dzielenia w ecx (na MSB)
	mov ecx, 0
	shl esi, 1
	adc ecx, 0
	shl edi, 1
	adc ecx, 0
	shl ecx, 31
	; wykladniki na miejsce do wykonywania arytmetyki
	shr esi, 24
	shr edi, 24
	; a - b, w tym kroku znosz¹ siê równie¿ dodane 127 
	; dodane do wykladnikow, wymuszone przez standard IEEE
	sub esi, edi
	; -1, ale powiekszone o 127 ze wzgledu na standard IEEE
	add esi, 126
	; + EBX
	add esi, ebx
	; no i przesuwamy w odpowiednie miejsce
	shl esi, 23

	; sk³adamy teraz liczbê w ca³oœæ
	and eax, 007FFFFFh ; usuwanie wiodacej jedynki
	or eax, ecx ; znak
	or eax, esi ; wykladnik

	; zwracany wynik, zgodnie ze standardem C,
	; musi byæ pozostawiony na wierzcho³ku stosu koprocesora
	push eax
	finit
	fld dword ptr [esp]
	add esp, 4

; epilog
	pop ebx
	pop esi
	pop edi
	mov esp, ebp
	pop ebp
	ret
_fdiv ENDP

END
