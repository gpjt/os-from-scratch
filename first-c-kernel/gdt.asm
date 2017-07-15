; Global Descriptor table for a completely flat memory model, with two segments,
; code and data, both covering 4GB all of the memory
gdt_start:

gdt_null:   ; a segment of zero must be an error (to handle empty pointers)
    dd 0x0  ; so we define an empty one.  dd == 4 bytes, so two of them will
    dd 0x0  ; fill up the 8 bytes a segment descriptor should take up.

gdt_code:   ; Our code segment
    ; base=0x0, limit = 0xfffff
    ; 1st flags:
    ;   present: 1 (in memory -- not swapped out)
    ;   privilege: 00 (highest)
    ;   descriptor type: 1 (code or data -- 0 would mean "trap", no idea what that is)
    ; --- these all combine to 1001b
    ; type flags:
    ;   code: 1 (because it's a code segment)
    ;   conforming: 0 (lower-privilege code can't execute here -- presumably this is how
    ;                  system calls, called by user-mode code, are able to call the limited
    ;                  amount of the kernel that they're allowed to -- which would be conforming 1
    ;                  which then raises privileges and then jumps into conforming-0 proper kernel code)
    ;   readable: 1 (readable, not execute-only.  0 might be better for code, but we're mixing code and
    ;                data in our assembly code with wild abandon, so...)
    ;   accessed: 0 (for virtual memory, the CPU would set it alter)
    ; --- these all combine to 1010b
    ; 2nd flags:
    ;   granularity: 1 (so, limit 0xfffff is multiplied by 4096, so the limit is 0xFFFFF000 -- almost 4GB.
    ;   32-bit default: 1 (because it will contain 32-bit code)
    ;   64-bit segment: 0 (because it's not 64-bit)
    ;   AVL: 0 (some kind of debugging thing, not sure what)
    ; --- these all combine to 1100b
    dw 0xffff           ; limit -- bits 0-15
    dw 0x0              ; base -- bits 0-15
    db 0x0              ; base -- bits 16-23
    db 10011010b        ; 1st flags then type flags
    db 11001111b        ; 2nd flags then bits 16-19 of the limit
    db 0x0              ; base -- bits 24-31

gdt_data:    ; data segment
    ; Same as the code segment, apart from type flags
    ;   code: 0 (because it's a data segment -- this means that the two flags below change their meaning)
    ;   expand down: 0 (no idea)
    ;   writable: 1 (because you can have readable)
    ;   accessed: 0 (same as with the code segment)
    ; -- these all combine to 0010b
    dw 0xffff           ; limit -- bits 0-15
    dw 0x0              ; base -- bits 0-15
    db 0x0              ; base -- bits 16-23
    db 10010010b        ; 1st flags then type flags
    db 11001111b        ; 2nd flags then bits 16-19 of the limit
    db 0x0              ; base -- bits 24-31

gdt_end:                ; label so that we can calculate sizes

gdt_descriptor:
    dw gdt_end - gdt_start - 1      ; The size of our GDT (minus 1 for reasons)
    dd gdt_start                    ; The GDT start address


; Segment registers in protected mode refer to the number of bytes into
; the GDT where the segment is defined.   So we can define them simply
; as constants with a bit of label arithmetic.
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start




