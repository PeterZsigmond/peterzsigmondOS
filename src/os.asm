%include "src/bootloader/bootloader.asm"

; The main function of the OS starts here
main:
    call save_cpu_info

; Print out the Home page
homepage:
    call set_video_mode

    call print_image

    jmp keypress


%include "src/image/set_video_mode.asm"
%include "src/image/load_image.asm"
%include "src/image/print_image.asm"
%include "src/image/print_pixel.asm"
%include "src/keypress/keypress.asm"
%include "src/terminal/terminal.asm"
%include "src/cpu_info/save_cpu_info.asm"

times 0x600-($-$$) db 0 ; Add zero padding into OS. It's gonna be 2 sector (1024 byte)

; String constants will start here
db "Write hex coded x86 instructions here, then press ENTER to run them.", 0
db "Press ESC to go back. (Maximum 100 byte allowed.)", 0

times 0x800-($-$$) db 0 ; Add zero padding for string consts. It's gonna be 1 sector (512 byte)

%include "src/cpu_info/print_cpu_info.asm" ; Print CPU info function will start from here

times 0xa00-($-$$) db 0 ; Add zero padding for Print CPU info. It's gonna be 1 sector (512 byte)

%include "src/image/images.asm" ; Include images
