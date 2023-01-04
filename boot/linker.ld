/* NOTE: Specifying ENTRY can be redundant. */
/* ENTRY(start) */
OUTPUT_FORMAT("binary")

phys = 0x7C00;                  /* BIOS (or MBR) puts us at 0x7C00 */
bios_footer_address = 0x7DFE;  /* Required for the BIOS to boot our OS. 0x7DFE = 0x7C00 + 0x01FE(510) */

SECTIONS
{
    /* NOTE: .entry section must be put as the first section, since bios will read
              the instruction placed exactly at 0x7C00.
    */
    . = phys;
    .entry              : { *(.entry) }

    .text    : { *(.text) }

    /* Read-only data */
    .rodata  : { *(.rodata) }

    /* .bss section does not exist for bootloader, thus commented out. */
    /* .bss  : { *(.bss) } */

    /* Required for the BIOS to boot our OS. 0x7DFE = 0x7C00 + 0x01FE */
    .bios_footer bios_footer_address : { SHORT(0xAA55) }
}
