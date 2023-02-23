#ifndef KERNEL_ARCH_X86_SEGMENTS
#define KERNEL_ARCH_X86_SEGMENTS

#define NUM_GDT_ENTRIES 16

// GDT entries
#define NULL_SEG 0

#define GDT_ENTRY_KERNEL32_CS 1
#define GDT_ENTRY_KERNEL_CS 2
#define GDT_ENTRY_KERNEL_DS 3
#define GDT_ENTRY_USER32_CS 4
#define GDT_ENTRY_USER_DS 5
/*
 * GDT_ENTRY_USER_CS must be placed at two entries higher than GDT_ENTRY_USER32_CS, enforced by `SYSRET `.
 */
#define GDT_ENTRY_USER_CS 6

#define GDT_ENTRY_SIZE 8

#endif /* KERNEL_ARCH_X86_SEGMENTS */
