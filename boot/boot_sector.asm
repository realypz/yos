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
; qemu-system-i386 -nographic output/boot_sector.bin

; ## To run it in Windows
; 1. Download the bin file to Windows folder.
; 2. In cmd (not PowerShell)
;    "C:\Program Files\qemu\qemu-system-i386.exe" "\\wsl$\Ubuntu-20.04-ypz\home\realypz\ypz_code\yos\output\os-image"
;
; Run ```bash build.sh``` to quickly generate the image of yos.

[bits 16]           ; tell assembler that working in real mode(16 bit mode)
[org 0x7c00]        ; organize from 0x7C00 memory location where BIOS will load us
KERNEL_OFFSET equ 0x1000 ; This is the memory offset to which we will load our kernel

start:              ; start label from where our code starts
	mov [BOOT_DRIVE], dl	 		; BIOS stores our boot drive in DL, so it 's
										; best to remember this for later.

	mov bp , 0x9000 				; Set-up the stack.
	mov sp , bp

	mov si, MSG_REAL_MODE		; point MSG_REAL_MODE to source index register
	call print_string				; call print different color string function

	call load_kernel

	call switch_to_pm				; switch to the 32-bit protected mode

%include "boot/print_string.asm"
%include "boot/gdt.asm"
%include "boot/load_kernel.asm"
%include "boot/print_string_pm.asm"
%include "boot/switch_to_pm.asm"

; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode :)", 13, 10, 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode :)", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 13, 10, 0

times (510 - ($ - $$)) db 0x00     ;set 512 bytes for boot sector which are necessary
dw 0xAA55                           						   ; boot signature 0xAA & 0x55
