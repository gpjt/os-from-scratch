; load DH sectors to ES:BX from drive DL
disk_load:
    push dx         ; Stash DX so that later we can easily find out
                    ; the contents of DH and check the right number of
                    ; sectors were loaded
    mov ah, 0x02    ; BIOS read sector function
    mov al, dh      ; read DH sectors
    mov ch, 0x00    ; select cylinder 0
    mov dh, 0x00    ; head 0
    mov cl, 0x02    ; start reading from the second sector (after the boot sector, 1-indexed)

    int 0x13        ; BIOS interrupt

    jc disk_error   ; Carry flag signals an error

    pop dx          ; Restore DX so that we can...
    cmp dh, al      ; ...compare al (sectors read) with dh (sectors we wanted to read)
    jne disk_error

    ret


disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $


DISK_ERROR_MSG db   "Disk read error!", 0
