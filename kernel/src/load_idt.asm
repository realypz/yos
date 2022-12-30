[bits 64]

global load_idt

load_idt:
    ; push rbp
    ; mov rbp, rsp
    mov rax, rdi
    lidt[rax]
    sti
    ; pop rbp
    ret
