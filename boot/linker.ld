ENTRY(start)
OUTPUT_FORMAT("binary")
phys = 0x7C00;                  /* BIOS (or MBR) puts us at 0x7C00 */

SECTIONS
{
    . = phys;

    .entry              : { *(.entry) }

    .text    : { *(.text) }

    /* Read-only data */
    .rodata  : { *(.rodata) }

    /* Required for the BIOS to boot our OS */
    .bios_footer 0x7DFE : { SHORT(0xAA55) }

    .bss                : { *(.bss) }
}
