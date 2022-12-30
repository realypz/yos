#include "kernel/io.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64

// https://www.youtube.com/watch?v=QRhFo-CnpvQ&t=452s
void keyboard_isr_handler()
{
	static char *video_memory = (char*)0xb8000;
	unsigned char status = inb(KEYBOARD_STATUS_PORT);

	if (status & 0x1)
	{
		char keycode = (char)inb(KEYBOARD_DATA_PORT);
		if ((keycode > 0) && (keycode <= 0x128))
		{
			// TODO: Figure what is keycode (or key scancode),
			//       and how to mapping it to the desired characters
			//       on display.
			*video_memory = keycode;
			video_memory = video_memory + 2;
		}
	}

	// Write end of interrupt (EOI)
	outb(PIC1_COMMAND_PORT, PIC2_EOI_CODE);
	outb(PIC2_COMMAND_PORT, PIC2_EOI_CODE);
}
