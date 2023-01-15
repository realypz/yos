#ifndef KERNEL_IO_IO
#define KERNEL_IO_IO

#include <stdint.h>

/// @brief Read the a word to the designated port.
/// @param port the 16-bit port number.
/// @return The 8-bit data read from the port.
// TODO: Figure out whether `extern` is necessary for the function defined in assembly code.
uint8_t inb(uint16_t port);

/// @brief Write a byte to the port.
/// @param port the 16-bit port number.
/// @param data The byte to be written.
void outb(uint16_t port, uint8_t data);

/// @brief IO wait function
void io_wait();

#endif /* KERNEL_IO_IO */
