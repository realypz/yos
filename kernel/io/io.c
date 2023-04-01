#include "kernel/io/io.h"

#define UNUSED_PORT 0x80

// NOTE: Read the assembly version of the two functions below
// at `kernel/io/ARCHIVED_io.asm`.
uint8_t inb(uint16_t)
{
    __asm__("push %%rdx;"
            "mov %%rdi, %%rdx;"
            "mov $0x00, %%rax;"
            "in %%dx, %%al;"
            "pop %%rdx;"
            :
            :
            : "%rdx", "%rax", "%rdi", "%al");

    // The equivalent Intel syntax is as below.
    /***
    asm(".intel_syntax noprefix");
    asm("push rdx");
    asm("mov rdx, rdi");
    asm("mov rax, 0x0");
    asm("in al, dx");
    asm("pop rdx");
    asm(".att_syntax prefix");
    // MISC: This line tells the compiler that the intel syntax section ends here,
    // now switch back to the default att_syntax.
    ***/
}

void outb(uint16_t port, uint8_t data)
{
    __asm__("push %%rax;"
            "push %%rdx;"
            "mov %%rdi, %%rdx;" // MISC: rdi stores the first arg `port` in x86_64 Linux calling
                                // convention.
            "mov %%rsi, %%rax;" // MISC: rsi stores the second arg `data` in x86_64 Linux calling
                                // convention.
            "out %%al, %%dx;"
            "pop %%rdx;"
            "pop %%rax;"
            :
            :
            : "%rdx", "%rax", "%rdi", "%rsi");
}

void io_wait()
{
    outb(UNUSED_PORT, 0);
}
