[bits 16]           ; tell assembler that working in real mode(16 bit mode)

%define BOOT_DRIVE 0

%define KERNEL_OFFSET 0x1000 ; This is the memory offset to which we will load our kernel

section .entry
	global start

	start:
		jmp 0x0:.FlushCS		  ; Make a far jump to explicitly set CS register to 0x0.

	.FlushCS:              ; start label from where our code starts
		mov [BOOT_DRIVE], dl	 		; BIOS stores our boot drive in DL, so it 's
											; best to remember this for later.

		; Initalize segment registers
		mov bp, start 					; Set up the base pointer and stack pointer.
		mov sp, start					; Refer to https://wiki.osdev.org/Memory_Map_(x86)
											; to make sure the stack memory does not overwrite
											; the unusable memory.

		xor ax, ax						; equal to mov ax. 0, but fewer clock cycle.

		mov ss, ax						; Set up stack segment register.
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax

		call load_kernel				; Load the kernel from disk. The kernel code is beyond the
											; first sector (first 512 bytes), and B

		cld
		call SwitchToLongMode		; switch to the 32-bit protected mode

%include "boot/load_kernel.asm"
%include "boot/switch_to_long_mode.asm"
