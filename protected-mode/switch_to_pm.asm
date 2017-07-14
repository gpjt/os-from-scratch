; Code to switch to protected mode

[bits 16]
switch_to_pm:

    cli                     ; disable all interrupts

    lgdt [gdt_descriptor]   ; load the GDT using the descriptor (all defined in gdt.asm)

    mov eax, cr0            ; We need to switch on bit 1 in the control register cr0,
    or eax, 0x1             ; which can't be done directly, so we use eax (NB 32-bit register
    mov cr0, eax            ; even though we're in 16-bit more) as an intermediary.

    jmp CODE_SEG:init_pm    ; A long jump (with a segment specified) is something that can't
                            ; be pipelined, so doing one -- even though it's of no distance
                            ; makes sure that all 16-bit stuff is properly flushed from the
                            ; pipeline.

[bits 32]

init_pm:
    mov ax, DATA_SEG        ; Now that we're in protected mode, we set all of our segment
    mov ds, ax              ; registers to the data segment.
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; Move the stack way up
    mov esp, ebp

    call BEGIN_PM           ; call back to our code in main.asm.

