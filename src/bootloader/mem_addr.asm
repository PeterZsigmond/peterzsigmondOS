; String consts address
string_const        equ 0x8200

; General purpose memory addresses
disk_number         equ 0x8600 ; (1 byte)   (number of the disk that booted, eg. 0x80)
current_page        equ 0x8601 ; (1 byte)   (current page on the screen)
disk_addr_pack      equ 0x8602 ; (16 byte)  (Disk Address Packet Structure, for loading the images)
img_lba_addr_0      equ 0x8612 ; (2 byte)   (Calculate the LBA addr. of images here)
img_lba_addr_1      equ 0x8614 ; (2 byte)   (The img's second part's LBA addr.)
cpu_info            equ 0x8616 ; (48 byte)  (Null-terminated string of the processor's brand)
terminal_code_addr  equ 0x8646 ; (100 byte) (For code written in terminal) (0x8646 - 0x86a9)

; Stack's base address (Stack: 0x8800 - 0xaf0f)
stack_base          equ 0xaf0f

; Images' addresses (These are segment addresses)
image_addr_0        equ 0x0af1 ; (128 sector) (Image's memory segment address 1)
image_addr_1        equ 0x1af1 ; (91 sector)  (Image's memory segment address 2)
print_img_addr_1    equ 0x189d ; (image_addr_0 + (img.size / 2)) (Image's mem. area's second half)
