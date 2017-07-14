[org 0x7c00]

    mov [BOOT_DRIVE], dl    ; The BIOS has already stored the number of the drive
                            ; we're booting from in DL, so let's stash it away for safety.

    mov bp, 0x8000          ; Put the stack nice and far away.  (NB indirect setting of SP)
    mov sp, bp              ;

    mov bx, 0x9000          ; Load 5 sectors to 0x0000(ES):0x9000(BX)
    mov dh, 5               ;
    mov dl, [BOOT_DRIVE]    ;
    call disk_load          ;

    mov dx, [0x9000]        ; Print out the first loaded word, which we
    call print_hex          ; expect to be 0xdada

    mov dx, [0x9000 + 512]  ; Now print out the word from the second loaded
    call print_hex          ; sector, which should be 0xface

    jmp $


%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

BOOT_DRIVE:
    db 0

    times 510 - ($ - $$) db 0   ; pad out the rest of the sector

    dw 0xaa55                   ; boot sector magic number

; Now let's define some more sectors.  256 words = 512 bytes
times 256 dw 0xdada
times 256 dw 0xface




