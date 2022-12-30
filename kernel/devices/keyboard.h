#ifndef KERNEL_DEVICES_KEYBOARD
#define KERNEL_DEVICES_KEYBOARD

/// @brief Initialilze keyboard.
void init_keyboard();

/// @brief keyboard isr handler
/// @details This function includes the handling logic of keyboard interrupt.
void keyboard_isr_handler();

#endif /* KERNEL_DEVICES_KEYBOARD */
