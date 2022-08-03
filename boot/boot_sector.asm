; This file is inspired by
; https://github.com/pritamzope/OS/blob/master/Bootloader/HelloWorld/src/hello_world.asm
; more function will be added when get familiar with the bootloader.

; Always remember that, the *.asm file represents the code stored in the memory.
; Thus, the executable instructions is placed in a certain memory address.
; The assembler directives help the assembler to place the executable instructions
; at the correct memory address when the image is made.

; ## To compile in Linux
; nasm -f bin boot/boot_sector.asm -o output/boot_sector.bin

; ## To run in qemu in Linux
; qemu-system-x86_64 output/boot_sector.bin

; ## To run it in Windows
; 1. Download the bin file to Windows folder.
; 2. In cmd (not PowerShell)
;    "C:\Program Files\qemu\qemu-system-x86_64.exe" "D:\qemu\boot_sector.bin"

[bits 16]           ; tell assembler that working in real mode(16 bit mode)
[org 0x7c00]        ; organize from 0x7C00 memory location where BIOS will load us

start:              ; start label from where our code starts
	mov si, MSG_REAL_MODE		; point MSG_REAL_MODE to source index register
	call print_string				; call print different color string function

	call switch_to_pm				; switch to the 32-bit protected mode

%include "boot/print_string.asm"
%include "boot/gdt.asm"
%include "boot/disk_load.asm"
%include "boot/print_string_pm.asm"
%include "boot/switch_to_pm.asm"

[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov ebx , MSG_PROT_MODE
	call print_string_pm ; Use our 32-bit print routine.
	jmp $          ;an infinite loop!! ($ evaluates as the current 
						;                     position just before the 
						;                     instruction is assembled, 
						;                     that is, the position where 
						;                     the JMP instruction begins)

; Global variables
MSG_REAL_MODE db "Started in 16-bit Real Mode :)", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode :)", 0

times (510 - ($ - $$)) db 0x00     ;set 512 bytes for boot sector which are necessary
dw 0xAA55                           						   ; boot signature 0xAA & 0x55
