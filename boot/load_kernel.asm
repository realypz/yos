[bits 16]
load_kernel:
	mov si, MSG_LOAD_KERNEL 	; Print a message to say we are loading the kernel
	call print_string

	mov dh, 15 						; that we load the first 15 sectors (excluding
	mov dl, [BOOT_DRIVE] 		; the boot sector) from the boot disk (i.e. our

   push dx           ; Store DX on stack so later we can recall
                     ; how many sectors were request to be read ,
                     ; even if it is altered in the meantime
   mov ah , 0x02     ; BIOS read sector function
   mov al , dh       ; Read DH sectors
   mov ch , 0x00     ; Select cylinder 0
   mov dh , 0x00     ; Select head 0
   mov cl , 0x02     ; Start reading from second sector (i.e.
                     ; after the boot sector)
	mov bx, KERNEL_OFFSET 		; Set-up parameters for our disk_load routine, so
   int 0x13          ; BIOS interrupt

   jc disk_error     ; Jump if error (i.e. carry flag set)

   pop dx            ; Restore DX from the stack
   cmp dh , al       ; if AL (sectors read) != DH (sectors expected)
   jne disk_error    ; display error message
   ret

disk_error:
   mov bx , DISK_ERROR_MSG
   call print_string
   jmp $

; Variables
DISK_ERROR_MSG db " Disk read error !", 0
