print_pixel:
    push ax
    push bx

    mov cx, si ; X coord
    mov dx, di ; Y coord
    and al, 0x0f ; Zero out al's upper 4 bits. It's gonna be the color
    mov ah, 0x0c ; Write graphics pixel function
    mov bh, 0 ; Page number
    int 0x10

    pop bx
    pop ax

    ret
