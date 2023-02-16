save_cpu_info:

    mov eax, 0x80000000 ; Get Highest Extended Function Implemented
    cpuid

    cmp eax, 0x80000004 ; Check if Processor Brand String is implemented
    jl cpu_brand_info_not_implemented

    mov di, cpu_info

    mov ecx, 3
    save_cpu_info_loop: ; 3 cycle, get cpuid with eax=0x80000002,0x80000003,0x80000004. Results are in eax, ebx, ecx, edx
        push ecx

        mov eax, 0x80000005
        sub eax, ecx
        cpuid

        mov [di], eax
        add di, 4

        mov [di], ebx
        add di, 4

        mov [di], ecx
        add di, 4

        mov [di], edx
        add di, 4

        pop ecx
        loop save_cpu_info_loop

        jmp save_cpu_info_end

cpu_brand_info_not_implemented: ; If function isn't implemented, write out "Not implemented." to mem.
    mov di, cpu_info

    mov eax, 0x20746f4e
    mov [di], eax
    add di, 4

    mov eax, 0x6c706d69
    mov [di], eax
    add di, 4

    mov eax, 0x6e656d65
    mov [di], eax
    add di, 4

    mov eax, 0x2e646574
    mov [di], eax
    add di, 4

    mov al, 0
    mov [di], al

save_cpu_info_end:
    ret
    