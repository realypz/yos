[bits 64]

global loadIDTImpl

loadIDTImpl:
    ; push rbp
    ; mov rbp, rsp
    mov rax, rdi
    lidt[rax]
    sti
    ; pop rbp
    ret
