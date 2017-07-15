; Code to print a string in protected mode
[bits 32]
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK_FLAGS equ 0x0f

print_string_pm:
    pusha

    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx]                   ; Get the character to print

    cmp al, 0x0                     ; Last character?
    je print_string_pm_done

    mov ah, WHITE_ON_BLACK_FLAGS    ; set the flags

    mov [edx], ax                   ; store the character in video memory

    add ebx, 1                      ; on to the next char in the string

    add edx, 2                      ; and the next word in the video memory

    jmp print_string_pm_loop

print_string_pm_done:

    popa
    ret

