#ifndef KERNEL_IO_IO
#define KERNEL_IO_IO

#include <stdint.h>

/// @brief Read the a word to the designated port.
/// @param port the 16-bit port number.
/// @return The 8-bit data read from the port.
extern uint8_t inb(uint16_t port);

/// @brief Write a byte to the port.
/// @param port the 16-bit port number.
/// @param data The byte to be written.
extern void outb(uint16_t port, uint8_t data);

#endif /* KERNEL_IO_IO */
