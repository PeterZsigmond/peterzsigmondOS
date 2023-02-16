; Include memory addresses
%include "src/bootloader/mem_addr.asm"

; Set Data and Stack segments to zero
mov ax, 0
mov ds, ax
mov ss, ax

; Set Stack address
mov ax, stack_base
mov sp, ax
mov bp, ax

; Save the drive number, that was booted
mov [disk_number], dl

; Set current page to home
mov bl, 0
mov [current_page], bl

; Load code into memory (OS: 2 sector, String consts: 1 sector, CPU brand printer: 1 sector)
mov ax, 0x7e0 ; Load code into es:bx (It's the second usable sector, first is the bootloader. First 31kB of mem. is used by BIOS. (0x7e00=31*1024+512))
mov es, ax
mov bx, 0
mov ah, 0x2 ; Read sectors
mov ch, 0 ; Cylinder number
mov cl, 2 ; Sector number (First is the bootloader)
mov dh, 0 ; Head number
mov dl, [disk_number] ; Disk number
mov al, 4 ; Number of sectors to read
int 0x13 ; Call disk services

; Bootloader finished, jump to main
jmp main

times 0x200-0x2-($-$$) db 0 ; Add zero padding to bootloader, to make up 512 bytes
db 0x55, 0xaa ; Add MBR signature
