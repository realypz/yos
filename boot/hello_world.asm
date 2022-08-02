; This file is inspired by
; https://github.com/pritamzope/OS/blob/master/Bootloader/HelloWorld/src/hello_world.asm
; more function will be added when get familiar with the bootloader.

; Always remember that, the *.asm file represents the code stored in the memory.
; Thus, the executable instructions is placed in a certain memory address.
; The assembler directives help the assembler to place the executable instructions
; at the correct memory address when the image is made.

; ## To compile in Linux
; nasm -f bin boot/hello_world.asm -o output/hello.bin

; ## To run in qemu in Linux
; qemu-system-x86_64 output/hello.bin

; ## To run it in Windows
; 1. Download the bin file to Windows folder.
; 2. In cmd (not PowerShell)
;    "C:\Program Files\qemu\qemu-system-x86_64.exe" "D:\qemu\hello.bin"

[bits 16]           ; tell assembler that working in real mode(16 bit mode)
[org 0x7c00]        ; organize from 0x7C00 memory location where BIOS will load us

start:              ; start label from where our code starts
	xor ax,ax           ; set ax register to 0
	mov ds,ax           ; set data segment(ds) to 0
	mov es,ax           ; set extra segment(es) to 0
	mov bx,0x8000

	mov si, hello_world              ; point hello_world to source index
	call print_string				       ; call print different color string function

	hello_world db 'Fuck the world!', 13, 10, 0

%include "boot/print_string.asm"

	times (510 - ($ - $$)) db 0x00     ;set 512 bytes for boot sector which are necessary
	dw 0xAA55                           						   ; boot signature 0xAA & 0x55
