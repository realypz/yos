[bits 16]           ; tell assembler that working in real mode(16 bit mode)
[org 0x7c00]        ; organize from 0x7C00 memory location where BIOS will load us

jmp 0x0: start		  ; Make a far jump to explicitly set CS register to 0x0.

start:              ; start label from where our code starts
	mov [BOOT_DRIVE], dl	 		; BIOS stores our boot drive in DL, so it 's
										; best to remember this for later.

	; Initalize segment registers
	mov bp, 0x0007FFF0 			; Set up the base pointer and stack pointer.
	mov sp, bp						; Refer to https://wiki.osdev.org/Memory_Map_(x86)
										; to make sure the stack memory does not overwrite
										; the unusable memory.	
	mov ax, 0x0
	mov ss, ax						; Set up stack segment register.
	mov ds, ax
	mov es, ax

	mov si, MSG_REAL_MODE		; point MSG_REAL_MODE to source index register
	call print_string				; call print different color string function

	call load_kernel				; Load the kernel from disk. The kernel code is beyond the
										; first sector (first 512 bytes), and B
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
