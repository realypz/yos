[bits 16]

%define BOOT_DRIVE 0

section .text
load_kernel:
   ; Set the following 7 registers for interrupt 13h: low level disk service.
   ; https://en.wikipedia.org/wiki/INT_13H
   mov ah , 0x02     ; INT 13h AH=02h: Read Sectors From Drive
   mov al , 15       ; Read 15 sectors
   mov ch , 0     ; Select cylinder 0
   mov cl , 0x02     ; Start reading from second sector (i.e.
                     ; after the boot sector)
   mov dh , BOOT_DRIVE     ; Select head 0
   mov dl, dh		; the boot sector) from the boot disk.

   xor bx, bx
	mov bx, KERNEL_OFFSET 		; Set-up parameters for our disk_load routine, so

   int 0x13          ; Call BIOS interrupt 13: low level disk service.

   jc disk_error     ; Jump if error (i.e. carry flag set)

   ret

disk_error:
   jmp $

section .rodata
DISK_ERROR_MSG db " Disk read error !", 0
