#ifndef KERNEL_INTERRUPT_ISR
#define KERNEL_INTERRUPT_ISR

/* Interrupt service routine */

#include <stdint.h>

/// @brief Interrupt service routine code for keyboard
/// @return Interrupt return code
uint64_t keyboard_isr();

#endif /* KERNEL_INTERRUPT_ISR */
