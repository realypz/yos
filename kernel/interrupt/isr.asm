[bits 64]

%macro PUSHALL 0
    push rax
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
%endmacro

%macro POPALL 0
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rax
%endmacro

global keyboard_isr
[extern keyboard_isr_handler]

keyboard_isr:
    PUSHALL
    call keyboard_isr_handler
    POPALL
    iretq
