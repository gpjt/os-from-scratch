[org 0x7c00]

    mov bx, HELLO_MSG
    call print_string

    mov dx, 0x1fb6
    call print_hex

    mov bx, GOODBYE_MSG
    call print_string

    jmp $

print_hex:
    pusha

    mov bx, HEX_OUT
    add bx, 6

    mov ax, dx
    and ax, 0x000f
    cmp ax, 10
    jl digit1
    add ax, 39
digit1:
    add ax, 48
    mov [HEX_OUT + 5], al
    sub bx, 1

    shr dx, 4
    mov ax, dx
    and ax, 0x000f
    cmp ax, 10
    jl digit1
    add ax, 39
digit2:
    add ax, 48
    mov [HEX_OUT + 4], al
    sub bx, 1

    shr dx, 4
    mov ax, dx
    and ax, 0x000f
    cmp ax, 10
    jl digit3
    add ax, 39
digit3:
    add ax, 48
    mov [HEX_OUT + 3], al
    sub bx, 1

    shr dx, 4
    mov ax, dx
    and ax, 0x000f
    cmp ax, 10
    jl digit4
    add ax, 39
digit4:
    add ax, 48
    mov [HEX_OUT + 2], al
    sub bx, 1

    mov bx, HEX_OUT
    call print_string

    popa
    ret


HEX_OUT:
    db '0x0000' ,0


%include "print_string.asm"

HELLO_MSG:
    db 'Hello, World!', 0

GOODBYE_MSG:
    db 'Goodbye!', 0

PADDING:
    times 510 - ($-$$) db 0

BOOT_SECTOR_MARKER:
    dw 0xaa55
