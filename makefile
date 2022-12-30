# set(${OUTPUT_DIR} "output")
OUTPUT_DIR = "output"

_create_output_dir:
	mkdir -p ${OUTPUT_DIR}/

boot_sector.o: _create_output_dir
	nasm -f elf64 boot/boot_sector.asm -o ${OUTPUT_DIR}/boot_sector.o

boot_sector.bin: boot_sector.o
	ld -T boot/linker.ld ${OUTPUT_DIR}/boot_sector.o -o ${OUTPUT_DIR}/boot_sector.bin


# Build your own C function to the object file.
#
# -ffreestanding: Assert that compilation targets a freestanding environment.
#                 The most obvious example is an OS kernel.
# https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html#C-Dialect-Options
#
# -c: Compile or assemble the source files, but do not link.
# -m32: Generate the elf32-i386 object file.
# -g: Produce debugging information in the operating system’s native format.
# -o1: the optimization level.
# -fno-PIE: ??? https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html#Code-Gen-Options
# -I./ allows gcc to search the header files under the current directory ./


# -f elf64
# -f elf32
# nasm -f elf64 kernel/src/kernel_entry.asm -o ${OUTPUT_DIR}/kernel_entry.o

### Compile {
kernel_objs: _create_output_dir
	gcc -fno-PIE -Wextra -Wall -ffreestanding -I./ -c kernel/src/main.c -o ${OUTPUT_DIR}/main.o
	gcc -fno-PIE -Wextra -Wall -ffreestanding -I./ -c kernel/interrupt/idt.c -o ${OUTPUT_DIR}/idt.o
	gcc -fno-PIE -Wextra -Wall -ffreestanding -I./ -c kernel/devices/keyboard.c -o ${OUTPUT_DIR}/keyboard.o
	gcc -fno-PIE -Wextra -Wall -ffreestanding -I./ -c kernel/devices/pic.c -o ${OUTPUT_DIR}/pic.o

	nasm -f elf64 kernel/io/io.asm -o ${OUTPUT_DIR}/io.o
	nasm -f elf64 kernel/src/kernel_entry.asm -o ${OUTPUT_DIR}/kernel_entry.o
	nasm -f elf64 kernel/interrupt/isr.asm -o ${OUTPUT_DIR}/isr.o
	nasm -f elf64 kernel/interrupt/idt.asm -o ${OUTPUT_DIR}/idt_asm.o
### }


OBJS = \
	${OUTPUT_DIR}/io.o \
	${OUTPUT_DIR}/main.o \
	${OUTPUT_DIR}/kernel_entry.o \
	${OUTPUT_DIR}/keyboard.o \
	${OUTPUT_DIR}/isr.o \
	${OUTPUT_DIR}/idt.o \
	${OUTPUT_DIR}/idt_asm.o \
	${OUTPUT_DIR}/pic.o

# Pass kernel_entry.o and main.o to a linker.
# The linkage order is strictly as the order in the command.
# --oformat=elf32-i386
# -m elf_x86_64
# -no-pie: ??? https://github.com/cfenollosa/os-tutorial/issues/16
kernel.bin: kernel_objs
	ld -T kernel/linker.ld  $(OBJS) \
	   -o ${OUTPUT_DIR}/kernel.bin

# The order below is important!
BINARIES = \
	${OUTPUT_DIR}/boot_sector.bin \
	${OUTPUT_DIR}/kernel.bin

# Concatenate two binary file into one.
os-image: boot_sector.bin kernel.bin
	cat ${BINARIES} > ${OUTPUT_DIR}/os-image
	dd if=${OUTPUT_DIR}/os-image of=${OUTPUT_DIR}/os-image.img bs=512 count=1 conv=notrunc

run: os-image
	 qemu-system-x86_64 -fda ${OUTPUT_DIR}/os-image

clean:
	rm -f ${OUTPUT_DIR}/*
