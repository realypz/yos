/* NOTE: Specifying ENTRY can be redundant. */
/* ENTRY(start) */
OUTPUT_FORMAT("binary")

kernel_start_address = 0x1000;

SECTIONS
{
    . = kernel_start_address;
    .kernel_entry       : { *(.kernel_entry) }
    .text               : { *(.text) }
    .rodata             : { *(.rodata) }
    .data               : { *(.data) }
    .bss                : { *(.bss) }
}
