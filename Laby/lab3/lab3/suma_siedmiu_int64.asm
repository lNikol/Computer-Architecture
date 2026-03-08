public suma_siedmiu_liczb
.code
suma_siedmiu_liczb PROC
	push rbp
	mov rbp, rsp
	; za³o¿enie: pocz¹tkowa wartoœæ rax nie musi zostaæ zachowana
	mov rax, 0
	add rax, rcx
	jc zakoncz
	add rax, rdx
	jc zakoncz
	add rax, r8
	jc zakoncz
	add rax, r9
	jc zakoncz
	add rax, [rbp + 40] ; shadow space (32 bajty) + adres powrotu (8 bajtów)
	jc zakoncz
	add rax, [rbp + 48]
	jc zakoncz
	add rax, [rbp + 56]
	jc zakoncz
	add rax, [rbp + 64]
	jc zakoncz

	pop rbp
	ret

	zakoncz:
	mov rax, 0
	pop rbp
	ret
suma_siedmiu_liczb ENDP
END