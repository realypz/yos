[bits 16]
; Switch to protected mode
switch_to_pm:
   cli   ; We must switch of interrupts until we have
         ; setup the protected mode interrupt vector
         ; otherwise interrupts will run riot.

   lgdt[gdt_descriptor]   ; Load our global descriptor table, which defines
                           ; the protected mode segments ( e.g. for code and data )
   mov eax, cr0            ; To make the switch to protected mode, we set
   or eax, 0x1             ; the first bit of CR0, a control register
   mov cr0, eax            ; After this instruction, we get into 32-bit protected mode.

   jmp CODE_SEG:init_pm    ; Make a far jump ( i.e. to a new segment ) to our 32-bit
                           ; code. This also forces the CPU to flush its cache of
                           ; pre-fetched and real-mode decoded instructions, which can
                           ; cause problems.

[bits 32]
; Initialise registers and the stack once in PM.
init_pm:
   mov ax, DATA_SEG     ; Now in PM, our old segments are meaningless,
   mov ds, ax           ; so we point our segment registers to the
   mov ss, ax           ; data selector we defined in our GDT
   mov es, ax
   mov fs, ax
   mov gs, ax

   mov ebp, 0x90000     ; Update our stack position so it is right
   mov esp, ebp         ; at the top of the free space.

   call BEGIN_PM ; Finally, call some well-known label

; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm    ; Use our 32-bit print routine.
	call KERNEL_OFFSET      ; Call void main() in kernel/kernel.c.
	jmp $                   ;an infinite loop!! ($ evaluates as the current 
                              ;                     position just before the 
                              ;                     instruction is assembled, 
                              ;                     that is, the position where 
                              ;                     the JMP instruction begins)
