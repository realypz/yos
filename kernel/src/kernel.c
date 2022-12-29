#include "kernel/idt.h"
#include "kernel/multiply.h"

int main()
{
    char *video_memory = (char*)0xb8000;
    *video_memory = (char)multiply(3, 17);
    initIDT();
    return 0;
}
