print_string:
    pusha

    mov ah, 0x0e  ; int 0x10 with ah = 0x0e is the BIOS call for "teletype print"

loop:
    mov al, [bx]
    cmp al, 0
    je done

    int 0x10

    add bx, 1
    jmp loop

done:
    mov al, 10
    int 0x10
    mov al, 13
    int 0x10

    popa
    ret