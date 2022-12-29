#ifndef KERNEL_PROCESS
#define KERNEL_PROCESS


struct Process
{
    int killed;
    int pid;
    uint64_t size;

    pagetable;
};

#endif /* KERNEL_PROCESS */
