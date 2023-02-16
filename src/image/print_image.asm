print_image: ; Print out an image to screen
    call load_image ; First load the whole image into memory (0x0af10 - 0x2650f)

    push ds ; Store segment address

    mov si, 0 ; X coord on screen (0 - 639)
    mov di, 0 ; Y coord on screen (0 - 349)
    mov ax, image_addr_0 ; Image's starting address
    mov ds, ax
    mov bx, 0 ; Read image from from ds:bx 
    mov cx, 2 ; Use 2 cycle to read the whole image, because it wouldn't fit into one segment

    print_img_halves:
        push cx

        ; One image is 640 * 350 = 224.000 pixels
        ; Div it by 2, because we read 2 * 56.000 pixels, because of segmentation
        ; Div it by 2, because we store 2 pixel in one byte
        ; And div it by 2, because we read 2 byte in 1 cycle
        mov cx, (640 * 350 / 2 / 2 / 2) ; = 28.000
        print_img_loop:
            push cx

            mov ax, [bx] ; Read 2 byte from [ds:bx]

            mov cx, 4 ; Print out 4 pixels from 2 byte
            rol ax, 8 ; Move first pixel into position
            print_pixels_loop:
                push cx

                rol ax, 4 ; Rotate pixels to the left
                call print_pixel ; Print out the pixel
                inc si ; Increment X coord

                pop cx
                loop print_pixels_loop

            cmp si, 640 ; If X coord is reached 640, start new row
            jl print_continue
            mov si, 0
            inc di ; Increment Y coord
            print_continue:

            add bx, 2 ; Step to the next 4 pixels

            pop cx
            loop print_img_loop

        mov ax, print_img_addr_1 ; Read the second half of the image
        mov ds, ax
        mov bx, 0

        pop cx
        loop print_img_halves

    pop ds
    ret