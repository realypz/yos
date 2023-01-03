#ifndef KERNEL_DEVICES_PIC
#define KERNEL_DEVICES_PIC

/* Programmable interupt controller */
#include <stdint.h>

/// { 8259 common definitions
// https://wiki.osdev.org/8259_PIC
#define PIC1_COMMAND_PORT 0x20
#define PIC1_DATA_PORT 0x21
#define PIC2_COMMAND_PORT 0xA0
#define PIC2_DATA_PORT 0xA1
#define PIC2_EOI_CODE 0x20
#define PIC2_EOI_CODE 0x20
/// }

/// @brief IO wait function
void io_wait();

/// @brief Initialize the programmable interrupt controller 8259.
void init_pic();

#endif /* KERNEL_DEVICES_PIC */
