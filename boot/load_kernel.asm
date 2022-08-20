[bits 16]
load_kernel:
	mov dh, 15 						; that we load the first 15 sectors (excluding

   push dx           ; Store DX on stack so later we can recall
                     ; how many sectors were request to be read ,
                     ; even if it is altered in the meantime

   ; Set the following 7 registers for interrupt 13h: low level disk service.
   ; https://en.wikipedia.org/wiki/INT_13H
   mov ah , 0x02     ; INT 13h AH=02h: Read Sectors From Drive
   mov al , dh       ; Read DH sectors
   mov ch , 0x00     ; Select cylinder 0
   mov cl , 0x02     ; Start reading from second sector (i.e.
                     ; after the boot sector)
   mov dh , 0x00     ; Select head 0
   mov dl, [BOOT_DRIVE] 		; the boot sector) from the boot disk.
	mov bx, KERNEL_OFFSET 		; Set-up parameters for our disk_load routine, so

   int 0x13          ; Call BIOS interrupt 13: low level disk service.

   jc disk_error     ; Jump if error (i.e. carry flag set)

   pop dx            ; Restore DX from the stack
   cmp dh , al       ; if AL (sectors read) != DH (sectors expected)
   jne disk_error    ; display error message
   ret

disk_error:
   jmp $

DISK_ERROR_MSG db " Disk read error !", 0
