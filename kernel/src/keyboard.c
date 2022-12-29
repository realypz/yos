#include "kernel/io.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64

// https://www.youtube.com/watch?v=QRhFo-CnpvQ&t=452s
void keyboard_isr_handler()
{
	unsigned char status = inb(KEYBOARD_STATUS_PORT);
	// Lowest bit of status will be set if buffer not empty
	// (thanks mkeykernel)
	if (status & 0x1)
	{
		char keycode = (char)inb(KEYBOARD_DATA_PORT);
		if (keycode < 0 || keycode >= 0x128)
		{
			return; // how did they know keycode is signed?
		}

		char *video_memory = (char*)0xb8000;
		*video_memory = keycode;
	// print_char_with_asm(keyboard_map[keycode],0,cursor_pos);
	// cursor_pos++;
	}

	// Write end of interrupt (EOI)
	outb(PIC1_COMMAND, 0x20);
	outb(PIC2_COMMAND, 0x20);
}
