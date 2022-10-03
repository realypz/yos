[bits 64]

global multiply

multiply:
    push rbp
    mov rbp, rsp
    mov eax, edi
    imul eax, esi
    pop rbp
    ret
