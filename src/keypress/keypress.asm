keypress:
    mov ah, 0x0 ; Read key press
    int 0x16

    mov bl, [current_page] ; Load current page number into bl

    cmp bl, 0 ; Check if Home page
    jne keypress_not_home
        cmp al, '1' ; If key '1' pressed
        jne keypress_home_not_1

            mov bl, 1 ; Show about page
            mov [current_page], bl
            call print_image

            jmp keypress ; Return to key listening

        keypress_home_not_1:
            cmp al, '2' ; If key '2' pressed
            jne keypress_home_not_2

            mov bl, 2 ; Show Apple page 1
            mov [current_page], bl
            call print_image
            
            jmp keypress ; Return to key listening

        keypress_home_not_2:
            cmp al, '3' ; If key '3' pressed
            je terminal ; Show terminal page

            jmp keypress ; Return to key listening

    keypress_not_home:
        cmp bl, 1 ; Check if About page
        jne keypress_not_about_page
        cmp al, 27 ; Check if ESC pressed
        jne keypress ; If not, return to key listening

        mov bl, 0 ; Show home page
        mov [current_page], bl
        call print_image
        
        jmp keypress ; Return to key listening

    keypress_not_about_page:
        cmp bl, 2 ; Check if Apple page 1
        jne keypress_not_apple_0
        cmp ah, 0x4d ; Check if right arrow pressed
        jne keypress ; If not, return to key listening

        mov bl, 3 ; Show Apple page 2
        mov [current_page], bl
        call print_image
        
        jmp keypress ; Return to key listening

    keypress_not_apple_0:
        cmp bl, 3 ; Check if Apple page 2
        jne keypress_not_apple_1
        cmp ah, 0x4d ; Check if right arrow pressed
        jne keypress ; If not, return to key listening

        mov bl, 4 ; Show Apple page 3
        mov [current_page], bl
        call print_image
        
        jmp keypress ; Return to key listening

    keypress_not_apple_1:
        cmp bl, 4 ; Check if Apple page 3
        jne keypress_not_apple_2
        cmp ah, 0x4d ; Check if right arrow pressed
        jne keypress ; If not, return to key listening

        mov bl, 5 ; Show Apple page 4
        mov [current_page], bl
        call print_image
        
        jmp keypress ; Return to key listening

    keypress_not_apple_2:
        cmp bl, 5 ; Check if Apple page 4
        jne keypress_not_apple_3
        cmp ah, 0x4d ; Check if right arrow pressed
        jne keypress ; If not, return to key listening

        mov bl, 6 ; Show Apple page 5
        mov [current_page], bl
        call print_image
        
        jmp keypress ; Return to key listening

    keypress_not_apple_3:
        cmp bl, 6 ; Check if Apple page 5
        jne keypress
        cmp ah, 0x4d ; Check if right arrow pressed
        jne keypress

        mov bl, 0 ; Show Home page
        mov [current_page], bl
        call print_image
        
        jmp keypress ; Return to key listening
