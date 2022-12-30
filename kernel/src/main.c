#include "kernel/devices/keyboard.h"
#include "kernel/devices/pic.h"
#include "kernel/interrupt/idt.h"
#include "kernel/multiply.h"

int main()
{
    init_idt();
    init_pic();
    init_keyboard();

    for(;;)
    {
        asm("hlt");
    }

    return 0;
}
