.686
.model flat

public _suma


.data 
dane db ?
x dd 512 dup(?)

.code
_suma PROC
    push ebp          
    mov ebp, esp        
    push esi           
    push edi           
    push ebx
    

    xor ebx, ebx
    mov esi, ebx
    mov ecx, 256
    et: mov eax, x[4*esi]
    mul dword ptr x[4*esi+1024]
    add ebx, eax
    inc esi
    loop et
    mov eax, 0ffffh
mov eax, 30h

    mov cl, 10
    sub esp, 4
    mov [esp], cl
    mov eax, 0
    mov ecx, 10
    mov ebx, 1000h
    mov eax, [ebx - 8]
    mov eax, 0fff8h
    ptl23: in al, 71h
    loop ptl23


    mov ecx,1000000h
    mov cx, 8
    movsx ecx, cx
    lp: dec ecx
    jnz lp

    mov esi, [ebp+8]    
    mov ecx, [ebp+12]   

    
    cmp ecx, 0
    je zakoncz_rekurencje

    
    dec ecx

    
    add esi, 8          

    
    push ecx            
    push esi            
    call _suma          
    add esp, 8          

    mov ebx, esi        
    sub ebx, 8          

    
    add eax, [ebx]      
    adc edx, [ebx+4]    

    
    pop ebx            
    pop edi            
    pop esi             
    mov esp, ebp       
    pop ebp             
    ret                 
zakoncz_rekurencje:
    xor eax, eax        
    xor edx, edx        


    pop ebx            
    pop edi             
    pop esi             
    mov esp, ebp       
    pop ebp            
    ret                 
_suma ENDP

end