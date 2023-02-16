load_image: ; Load an image into memory
    mov bl, [current_page] ; Get current page number

    ; Calculate LBA into img_lba_addr_0 and img_lba_addr_1. LBA start's from 0, and it counts the sectors on drive
    mov al, 219 ; One image is 112.128 byte = 219 sector
    mul bl ; Multiple it by page number. (0th image is gonna be 0, 1th is 219, ...)
    add ax, 5 ; Add +1 for bootloader, +2 for OS, +1 for Strings and +1 for CPU brand printer code
    mov [img_lba_addr_0], ax ; We can only read 128 sectors at once, so calculate another address with +128
    add ax, 128
    mov [img_lba_addr_1], ax

    mov bx, disk_addr_pack ; Setup Disk Address Packet Structure

    mov al, 0x10 ; Size of DAPS (0x10 = 16 byte)
    mov [bx], al
    add bx, 1

    mov al, 0 ; Unused, should be zero
    mov [bx], al
    add bx, 1

    mov ax, 128 ; Number of sectors to read (128)
    mov [bx], ax
    add bx, 2

    mov ax, 0 ; Memory buffer offset, to where we read
    mov [bx], ax
    add bx, 2

    mov ax, image_addr_0 ; Memory buffer segment, to where we read
    mov [bx], ax
    add bx, 2

    mov ax, [img_lba_addr_0] ; LBA lower (4 byte)
    mov [bx], ax
    add bx, 2

    mov ax, 0 ; LBA lower (4 byte)
    mov [bx], ax
    add bx, 2

    mov ax, 0 ; LBA upper (4 byte)
    mov [bx], ax
    add bx, 2

    mov ax, 0 ; LBA upper (4 byte)
    mov [bx], ax
    
    mov si, disk_addr_pack ; Disk Address Packet Structure is at ds:si
    mov dl, [disk_number] ; Disk to read from
    mov ah, 0x42 ; Extended Read Sectors From Drive
    int 0x13 ; Read 128 sectors into memory

    ; Second part of reading (91 more sectors)
    mov bx, disk_addr_pack ; Setup Disk Address Packet Structure
    add bx, 2

    mov ax, 91 ; Sectors to read (91)
    mov [bx], ax
    add bx, 2

    add bx, 2 ; Memory buffer offset, to where we read

    mov ax, image_addr_1 ; Memory buffer segment, to where we read
    mov [bx], ax
    add bx, 2

    mov ax, [img_lba_addr_1] ; LBA lower (4 byte)
    mov [bx], ax

    mov ah, 0x42 ; Extended Read Sectors From Drive
    int 0x13 ; Read 91 sectors into memory

    ret
    