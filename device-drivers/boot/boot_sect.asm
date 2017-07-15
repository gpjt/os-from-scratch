[org 0x7c00]
[bits 16]

; This is where we want our kernel to be loaded; it's also
; where we tell LD to put base the code in the Makefile
KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl  	; BIOS stores the boot drive in DL, so
	                      	; we remember that for later use

	mov bp, 0x9000		    ; set up the stack
	mov sp, bp				;

	mov bx, MSG_REAL_MODE	; announce that we're booting from 16-bit
	call print_string		; real mode

	call load_kernel		; load the kernel

	call switch_to_pm		; our non-returning call to protected mode

	jmp $					; Should never get here.

%include "print_string.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL	; print a message to say we're loading
	call print_string   	; the kernel

	mov bx, KERNEL_OFFSET	; set up the parameters for disk_load --
	mov dh, 15 				; load 15 sectors from the boot disk to 
	mov dl, [BOOT_DRIVE]	; the KERNEL_OFFSET
	call disk_load

	ret

[bits 32]
BEGIN_PM:					; this is where switch_to_pm will dump us

	mov ebx, MSG_PROT_MODE	; Announce we're in protected mode
	call print_string_pm	;

	call KERNEL_OFFSET		; Call the kernel

	jmp $					; hang


BOOT_DRIVE 			db 0
MSG_REAL_MODE		db "Started in 16-bit real mode", 0
MSG_PROT_MODE		db "Successfully landed in 32-bit protected mode", 0
MSG_LOAD_KERNEL		db "Loading kernel into memory", 0

; Boot sector padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55


