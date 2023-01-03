#include "kernel/devices/pic.h"

#define UNUSED_PORT 0x80

void io_wait()
{
    outb(UNUSED_PORT, 0);
}

void init_pic()
{
    // Standard ISA IRQs:
    // https://wiki.osdev.org/index.php?title=Interrupts#Standard_ISA_IRQs
    // https://gist.github.com/Sachin-Tharaka/e1d7ec022a1868c5ad7d1557e3319b0a
    outb(PIC1_COMMAND_PORT, 0x11);
    outb(PIC2_COMMAND_PORT, 0x11);
    io_wait();

    outb(PIC1_DATA_PORT, 0x20);
    outb(PIC2_DATA_PORT, 0x28);
    io_wait();

    outb(PIC1_DATA_PORT, 0x04);
    outb(PIC2_DATA_PORT, 0x02);
    io_wait();

    outb(PIC1_DATA_PORT, 0x01);
    outb(PIC2_DATA_PORT, 0x01);
    io_wait();

    outb(PIC1_DATA_PORT, 0xff);
    outb(PIC2_DATA_PORT, 0xff);
    io_wait();
}
