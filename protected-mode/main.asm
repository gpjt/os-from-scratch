[org 0x7c00]

    mov bp, 0x9000          ; Set the stack base (BP) to 0x9000 and the
    mov sp, bp              ; stack pointer to the same

    mov bx, MSG_REAL_MODE   ; Print out that we're in real mode
    call print_string

    call switch_to_pm       ; Switch to protected (32-bit) mode.  This
                            ; "subroutine" will never return.

    jmp $                   ; Should never happen.

%include "print_string.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 32]                   ; code from here on is 32-bit

BEGIN_PM:                   ; known label -- switch_to_pm should land us here.

    mov ebx, MSG_PROT_MODE  ; print out that we're in protected mode, using
    call print_string_pm    ; our protected-mode print function

    jmp $                   ; loop forever


MSG_REAL_MODE   db "Started in 16-bit Real mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit protected mode", 0


    times 510 - ($ - $$) db 0   ; bootsector padding
    dw 0xaa55                   ; bootsector magic number



