%define FREE_SPACE 0x9000

%define PAGE_PRESENT    (1 << 0)
%define PAGE_WRITE      (1 << 1)

section .text
ALIGN 4
IDT:
   .Length       dw 0
   .Base         dd 0

[bits 16]
SwitchToLongMode:
   ; Place di register to a free memroy space.
   mov edi, FREE_SPACE

   ; Zero out the 16KiB buffer.
   ; Since we are doing a rep stosd, count should be bytes/4.   
   push di                           ; REP STOSD alters DI.
   mov ecx, 0x1000
   xor eax, eax
   cld
   rep stosd
   pop di                            ; Get DI back.

   .build_page_table: ; Build the Page Map Level 4.
      lea eax, [es:di + 0x1000]         ; Put the address of the Page Directory Pointer Table in to EAX.
      or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writable flag.
      mov [es:di], eax                  ; Store the value of EAX as the first PML4E.


      ; Build the Page Directory Pointer Table.
      lea eax, [es:di + 0x2000]         ; Put the address of the Page Directory in to EAX.
      or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writable flag.
      mov [es:di + 0x1000], eax         ; Store the value of EAX as the first PDPTE.


      ; Build the Page Directory.
      lea eax, [es:di + 0x3000]         ; Put the address of the Page Table in to EAX.
      or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writeable flag.
      mov [es:di + 0x2000], eax         ; Store to value of EAX as the first PDE.


      push di                           ; Save DI for the time being.
      lea di, [di + 0x3000]             ; Point DI to the page table.
      mov eax, PAGE_PRESENT | PAGE_WRITE    ; Move the flags into EAX - and point it to 0x0000.


   .LoopPageTable:
      mov [es:di], eax
      add eax, 0x1000
      add di, 8
      cmp eax, 0x200000                 ; If we did all 2MiB, end.
      jb .LoopPageTable
   
   pop di                            ; Restore DI.

   ; Disable IRQs (interrupt requests)
   mov al, 0xFF                      ; Out 0xFF to 0xA1 and 0x21 to disable all IRQs.
   out 0xA1, al
   out 0x21, al

   nop
   nop

   lidt [IDT]                        ; Load a zero length IDT so that any NMI causes a triple fault.

   ; See section 14.6.1 Activating Long Mode Step 2 In any order.
   ; Enable physicaladdress extensions by setting CR4.PAE to 1.
   ; {
   mov eax, 10100000b                ; Set the PAE and PGE bit.
   mov cr4, eax

   ; Load CR3 with the physical base-address of the level-4 page-map-table (PML4).
   mov edx, edi
   mov cr3, edx

   ; Enable long mode by setting EFER.LME to 1.
   mov ecx, 0xC0000080
   rdmsr
   or eax, 0x00000100
   wrmsr
   ; }

   ; Enable paging by setting CR0.PG to 1,
   ; At the same time set CR0.PE to 1.
   mov eax, cr0
   or eax, 0x80000001
   mov cr0, eax

   lgdt [GDT.Pointer]                ; Load GDT.Pointer defined below.

   jmp GDT.Code:LongMode             ; Load CS with 64 bit segment and flush the instruction cache


[bits 16]
GDT:
.Null: equ $ - GDT
    dq 0x0000000000000000             ; Null Descriptor - should be present.
 
.Code: equ $ - GDT
    dq 0x00209A0000000000             ; 64-bit code descriptor (exec/read).

.Data: equ $ - GDT
    dq 0x0000920000000000             ; 64-bit data descriptor (read/write).
 
ALIGN 4
    dw 0                              ; Padding to make the "address of the GDT" field aligned on a 4-byte boundary
 
.Pointer:
    dw $ - GDT - 1                    ; 16-bit Size (Limit) of GDT.
    dd GDT                            ; 32-bit Base Address of GDT. (CPU will zero extend to 64-bit)


[bits 64]
LongMode:
    mov ax, GDT.Data
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
 
    ; Blank out the screen to a blue color.
    mov edi, 0xB8000
    mov rcx, 500                      ; Since we are clearing uint64_t over here, we put the count as Count/4.
    mov rax, 0x1F201F201F201F20       ; Set the value to set the screen to: Blue background, white foreground, blank spaces.
    rep stosq                         ; Clear the entire screen. 

    mov rax, MSG_LONG_MODE
    call printString

    ; TODO: Why cannot write `call KERNEL_OFFSET` directly?
    ; Might becasue of `Direct Far Call` is disabled in 64-bit mode.
    mov rbx, KERNEL_OFFSET
    call rbx

.halt:
   hlt
   jmp LongMode.halt


printString:
    mov edi, 0xB8000

    ; Use rax to store the address of the string.
LoopString:
    mov byte bl, [rax]

    cmp bl, 0
    je PrintDone

    mov byte [edi], bl
    add edi, 1

    mov byte [edi], 0x0F
    add edi, 1

    add rax, 0x001

    jmp LoopString

PrintDone:
    ret

section .rodata
MSG_LONG_MODE DB "long mode :)))", 0
