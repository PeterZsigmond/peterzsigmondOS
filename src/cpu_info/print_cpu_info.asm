    mov bh, 0 ; Get cursor position
    mov ah, 3
    int 0x10
    mov bh, 0
    mov dl, 0
    add dh, 2 ; Move cursor down by 2 line
    mov ah, 2 ; Set cursor position
    int 0x10
    
    mov di, cpu_info
print_cpu_info_loop:
    mov al, [di]

    cmp al, 0
    je print_cpu_finish

    mov ah, 0x0a ; Print char from al
    mov bh, 0
    mov cx, 1
    int 0x10

    mov ah, 0x03 ; Increment cursor
    int 0x10
    mov ah, 0x02
    inc dl
    int 0x10

    inc di
    jmp print_cpu_info_loop

print_cpu_finish:
    mov ah, 0 ; Wait for any keypress
    int 0x16

    jmp homepage ; Go back to home
