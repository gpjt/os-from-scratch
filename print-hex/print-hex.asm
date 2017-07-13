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

    mov bx, HEX_OUT     ; bx is where we store the address of the
    add bx, 5           ; nybble we're working on

    mov cx, 4           ; four nybbles to print

hexloop:
    cmp cx, 0           ; have we written them all yet?
    je endhexloop       ; if so, we're done.

    mov ax, dx          ; get the rightmost nybble
    and ax, 0x000f      ;

    cmp ax, 10          ; if it's a digit, then we need to add
    jl is_digit         ; 48 to get the ASCII representation
    add ax, 39          ; and if it's not we need to add
is_digit:               ; 87 (as 'a' is 10, and character 97)
    add ax, 48          ; 87 - 48 = 39

    mov [bx], al        ; Store our ASCII in the template

    sub bx, 1           ; On to the next byte in the template

    shr dx, 4           ; Shift-right to the next nybble

    sub cx, 1           ; On to the next round in the loop
    jmp hexloop         ;

endhexloop:

    sub bx, 1           ; Ready to print (allow for the '0' -- the loop has already
                        ; got us to the 'x')

    call print_string   ; print it

    popa
    ret


HEX_OUT:
    db '0x0000', 0


%include "print_string.asm"

HELLO_MSG:
    db 'Hello, World!', 0

GOODBYE_MSG:
    db 'Goodbye!', 0

PADDING:
    times 510 - ($-$$) db 0

BOOT_SECTOR_MARKER:
    dw 0xaa55
