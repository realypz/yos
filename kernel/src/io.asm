[bits 64]

global outb
global inb

inb:
    push rdx

    mov rdx, rdi;  di stores the first input arg (port).
    mov rax, 0
    in al, dx;  Read byte from I/O port in DX, and stores to AX.

    pop rdx
    ret

outb:
    push rax ; TODO(yang.peizheng): Necessasry to push rax?
    push rdx

    mov rdx, rdi;  di stores the first arg-in.
    mov rax, rsi;  si stores the second arg-in.

    out dx, al;  Output byte stored in AL to I/O port address stored in DX.

    pop rdx
    pop rax
    ret

; HINT: Please read
; https://github.com/kkamagui/mint64os/blob/master/02.Kernel64/Source/AssemblyUtility.asm
; for inspiration of writing the correct read_port function.
