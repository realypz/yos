#include "kernel/io/io.h"

#define UNUSED_PORT 0x80

void io_wait()
{
    outb(0, 0);
}
