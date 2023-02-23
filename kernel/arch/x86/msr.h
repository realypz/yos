#ifndef KERNEL_ARCH_X86_MSR
#define KERNEL_ARCH_X86_MSR

#include <stdint.h>

#define IA32_STAR 0xc0000081
#define IA32_LSTAR 0xc0000082 // See Figure 5-14. MSRs Used by SYSCALL and SYSRET.

__attribute__((always_inline)) static inline void __wrmsr(uint32_t const msr, uint32_t const low, uint32_t const high)
{
    __asm__ volatile("mov %0, %%eax;"
                     "mov %1, %%ecx;"
                     "mov %2, %%edx;"
                     "wrmsr"
                     :
                     : "r"(low), "r"(msr), "r"(high)
                     : "%eax", "%ecx", "%edx");
}

static inline void wrmsrl(uint32_t const msr, uint64_t const val)
{
    __wrmsr(msr, (uint32_t)(val & 0xffffffffULL), (uint32_t)(val >> 32));
}

static inline void wrmsr(uint32_t const msr, uint32_t const low, uint32_t high)
{
    __wrmsr(msr, low, high);
}

#endif /* KERNEL_ARCH_X86_MSR */
