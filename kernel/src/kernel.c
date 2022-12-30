#include "kernel/idt.h"
#include "kernel/multiply.h"

void main()
{
    char *video_memory = (char*)0xb8000;
    *video_memory = (char)multiply(3, 17);
    init_idt();

    for(;;)
    {
        asm("hlt");
    }
}
