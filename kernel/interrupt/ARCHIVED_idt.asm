[bits 64]

global load_idt_impl
load_idt_impl:
    push rbp
    mov rbp, rsp
    mov rax, rdi
    lidt[rax]
    sti
    pop rbp
    ret
