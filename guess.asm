section .bss
    buffer resb 10
    guess resd 1
    seed resd 1
    rand resd 1

section .data
    msg DB "enter your guess (1-10, 0 to exit)",0xA,">"
    msgLn equ $-msg
    
    win DB "you won",0xA
    winl equ $-win
    
    lost DB "you lost",0xA
    lostl equ $-lost

section .text
    global _start
    
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msgLn
    int 0x80
    
    mov eax, 3
    mov ebx, 1
    mov ecx, buffer
    mov edx, 10
    int 0x80
    
    mov esi, buffer
    xor eax, eax
    xor ebx, ebx
    
    mov al, [buffer]
    cmp al, '0'
    je exit
    
conv_loop:
    mov bl, byte [esi]
    cmp bl, 0xA
    je done
    
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp conv_loop
    
done:
    mov [guess], eax

    mov eax, [seed]
    mov ebx, 1103515245
    imul eax, ebx
    add eax, 12345
    mov [seed], eax
    
    shr eax, 16
    and eax, 0x7FFF
    mov ebx, 10 ; from 1 to this number
    xor edx, edx
    div ebx
    add edx, 1
    mov [rand], edx
    
    mov eax, [rand]
    mov ebx, [guess]
    cmp eax, ebx
    je ok
    
    mov eax, 4
    mov ebx, 1
    mov ecx, lost
    mov edx, lostl
    int 0x80
    
    jmp _start
    
ok:
    mov eax, 4
    mov ebx, 1
    mov ecx, win
    mov edx, winl
    int 0x80
    
    jmp _start
exit:
    mov eax, 1
    mov ebx, 0
    int 0x80