terminal: ; A terminal, where hex coded x86 instructions will run
    mov al, 03h ; Set to text mode (80 x 25)
    mov ah, 0
    int 10h

    mov si, 0 ; Char counter
print_text_1:
    mov di, string_const ; Address of String consts
    add di, si ; Add char counter
    mov al, [di] ; Read actual char

    cmp al, 0 ; If char is zero, go to newline
    je print_text_newline

    mov bh, 0 ; Print char
    mov bl, 0x02
    mov cx, 1
    mov ah, 0x09
    int 0x10

    mov ah, 0x03 ; Move cursor
    int 0x10
    mov ah, 0x02
    inc dl
    int 0x10

    inc si ; Increment cursor
    jmp print_text_1

print_text_newline:
    mov ah, 0x03 ; Add new line
    int 0x10
    mov ah, 0x02
    mov dl, 0
    inc dh
    int 0x10

print_text_2:
    inc si

    mov di, string_const ; Continue reading the next line
    add di, si
    mov al, [di]

    cmp al, 0 ; If string ended, end printing texts
    je print_text_end

    mov bh, 0 ; Print char
    mov bl, 0x02
    mov cx, 1
    mov ah, 0x09
    int 0x10

    mov ah, 0x03 ; Move cursor
    int 0x10
    mov ah, 0x02
    inc dl
    int 0x10

    jmp print_text_2

print_text_end:
    mov ah, 0x03 ; Move cursor down by 3 line
    int 0x10
    mov ah, 0x02
    mov dl, 0
    add dh, 3
    int 0x10


    mov di, 0 ; Memory counter
    mov si, 0 ; This counts whether the upper or the lower part of a byte is coming

read_key:
    mov ah, 0x0 ; Read key press
    int 0x16

    cmp ah, 0x01 ; Check if ESC is pressed
    je esc_pressed

    cmp ah, 0x1c ; Check if Enter is pressed
    je enter_pressed

    cmp di, 100 ; Check if we reached 100 byte
    jge read_key

    cmp al, 48 ; If pressed char is less than '0', go back to key listening
    jl read_key

    cmp al, 57 ; If numeric char pressed, go further
    jle key_pressed

    cmp al, 97 ; If pressed char is less than 'a', go back to key listening
    jl read_key

    cmp al, 102 ; If char pressed, go further
    jle key_pressed

    jmp read_key ; Go back to key listening

key_pressed: ; If valid char pressed (0-9, a-f)
    cmp al, 97 ; If numeric char pressed, go to write_char
    jl write_char
    sub al, 32 ; Else switch lower-case chars to upper-case
    jmp write_char

write_char: ; Write out char to terminal
    mov bh, 0
    mov bl, 0x0f
    mov cx, 1
    mov ah, 0x09
    int 0x10

    ; Convert ASCII chars to bytes 
    sub al, 48
    cmp al, 10 ; If it was 0-9 char, go to write_byte
    jl write_byte_to_mem
    sub al, 7 ; But if it was A-F, sub 7 more

write_byte_to_mem: ; Write out the instructions into memory
    cmp si, 0 ; If it's the upper part of a byte (1 byte = 2 alphanumeric char)
    je write_byte_to_mem_upper

    mov bx, terminal_code_addr ; If it's the lower part of a byte
    add bx, di ; Add memory counter to it
    add [bx], al ; Write out lower part of the byte
    
    mov si, 0 ; Next char is gonna be the upper part
    inc di ; Increment memory counter

    jmp write_byte_end

write_byte_to_mem_upper: ; Write out the upper part of a byte
    mov bx, terminal_code_addr
    add bx, di ; Add memory counter to it
    shl al, 4 ; Shift 4 bits to the upper part of the byte
    mov [bx], al ; Write out upper part of the byte
    mov si, 1 ; Next char is gonna be the lower part

write_byte_end: ; Writing out a byte is finished, move cursor
    mov ah, 0x03 ; Get cursor position
    mov bh, 0
    int 0x10
    inc dl ; Move cursor to the right

    ; If column reached 80, add new line
    cmp dl, 80
    jl set_cursor
    mov dl, 0
    inc dh

set_cursor:
    mov ah, 0x02 ; Set cursor position
    int 10h

    jmp read_key ; Read next key press

esc_pressed: ; If ESC pressed, jump to Home page
    jmp homepage

enter_pressed: ; If ENTER pressed, execute the instructions
    mov ax, terminal_code_addr
    jmp ax
