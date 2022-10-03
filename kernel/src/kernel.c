#include "kernel/types.h"
#include "kernel/multiply.h"

char change_video_memory()
{
    return '=';
}

int main()
{
    char *video_memory = (char*)0xb8000;
    *video_memory = change_video_memory();
    *video_memory = (char)multiply(3, 17);
    return 0;
}
