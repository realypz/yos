#include "syscall.h"

#include "msr.h"
#include "segments.h"

// TODO: Finish
void syscall_init()
{
    // TODO: Read Intel manual 5-22 Vol. 3A
    // wrmsr IA323_STAR with the privilege-level 0 code segment.
    wrmsr(IA32_STAR, 0, (0 | (GDT_ENTRY_KERNEL_CS << 3)));

    // wrmsr IA32_LSTAR with the syscall entry point address.
}
