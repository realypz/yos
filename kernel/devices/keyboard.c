#include "kernel/devices/keyboard.h"

#include "kernel/io/io.h"
#include "kernel/devices/pic.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64

#define NUM_SCANCODES 128

uint8_t kKeyboardMap[NUM_SCANCODES] = 
{
	/*
	This function has credit to keyboard_map.h in
	https://stackoverflow.com/questions/37618111/keyboard-irq-within-an-x86-kernel.
	*/

    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',     /* 9 */
  	'9', '0', '-', '=', '\b',     /* Backspace */
  	'\t',                 /* Tab */
  	'q', 'w', 'e', 'r',   /* 19 */
  	't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', /* Enter key */
    0,                  /* 29   - Control */
  	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',     /* 39 */
 	'\'', '`',   0,                /* Left shift */
 	'\\', 'z', 'x', 'c', 'v', 'b', 'n',                    /* 49 */
  	'm', ',', '.', '/',   0,                              /* Right shift */
  	'*',
    0,  /* Alt */
  	' ',  /* Space bar */
    0,  /* Caps lock */
    0,  /* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,  /* < ... F10 */
    0,  /* 69 - Num lock*/
    0,  /* Scroll Lock */
    0,  /* Home key */
    0,  /* Up Arrow */
    0,  /* Page Up */
  	'-',
    0,  /* Left Arrow */
    0,
    0,  /* Right Arrow */
  	'+',
    0,  /* 79 - End key*/
    0,  /* Down Arrow */
    0,  /* Page Down */
    0,  /* Insert Key */
    0,  /* Delete Key */
    0,   0,   0,
    0,  /* F11 Key */
    0,  /* F12 Key */
    0,  /* All other keys are undefined */
};

void init_keyboard()
{
	unsigned char curmask_master = inb(0x21);
    outb(0x21, curmask_master & 0xFD);
}

// https://www.youtube.com/watch?v=QRhFo-CnpvQ&t=452s
void keyboard_isr_handler()
{
	static uint8_t* video_memory = (uint8_t*)0xb8000;
	unsigned char status = inb(KEYBOARD_STATUS_PORT);

	if (status & 0x1)
	{
		uint8_t const keycode = inb(KEYBOARD_DATA_PORT);
		if ((keycode > 0) && (keycode < NUM_SCANCODES))
		{
			// TODO: Figure out how to display the characters from
			//       combined keys, e.g. shitf + 1 to display '!'.
			*video_memory = kKeyboardMap[keycode];
			video_memory = video_memory + 2;
		}
	}

	// HINT: Write end of interrupt (EOI).
	// These two lines are important without which the interrupt handler
	// cannot be fired multiple times.
	outb(PIC1_COMMAND_PORT, PIC2_EOI_CODE);
	outb(PIC2_COMMAND_PORT, PIC2_EOI_CODE);
}
