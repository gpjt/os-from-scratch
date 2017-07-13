[org 0x7c00]

    mov bx, HELLO_MSG
    call print_string

    mov bx, GOODBYE_MSG
    call print_string

    jmp $

%include "print_string.asm"

HELLO_MSG:
    db 'Hello, World!', 0

GOODBYE_MSG:
    db 'Goodbye!', 0

PADDING:
    times 510 - ($-$$) db 0

BOOT_SECTOR_MARKER:
    dw 0xaa55
