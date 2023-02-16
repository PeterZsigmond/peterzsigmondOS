set_video_mode: ; Set video mode (640 * 350, 16 color mode)
    mov ah, 0x0
    mov al, 0x10
    int 0x10

    ret
