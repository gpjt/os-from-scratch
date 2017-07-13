mov ah, 0x0e  ; int 0x10 with ah = 0x0e is the BIOS call for "teletype print"

mov al, "H"
int 0x10
mov al, "e"
int 0x10
mov al, "l"
int 0x10
mov al, "l"
int 0x10
mov al, "o"
int 0x10

jmp $

times 510 - ($-$$) db 0

dw 0xaa55
