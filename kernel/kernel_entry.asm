[bits 64]
[extern main]
[global kernel_start]

section .kernel_entry
   kernel_start:
      call main
      jmp $
