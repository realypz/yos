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
kernel.o: _create_output_dir
	gcc -fno-PIE -Wextra -Wall -ffreestanding -I./ -c kernel/src/kernel.c -o ${OUTPUT_DIR}/kernel.o

# -f elf64
# -f elf32
kernel_entry.o: _create_output_dir
	nasm -f elf64 kernel/src/kernel_entry.asm -o ${OUTPUT_DIR}/kernel_entry.o

multiply.o: _create_output_dir
	nasm -f elf64 kernel/src/multiply.asm -o ${OUTPUT_DIR}/multiply.o

OBJS = \
	${OUTPUT_DIR}/kernel.o \
	${OUTPUT_DIR}/kernel_entry.o \
	${OUTPUT_DIR}/multiply.o 

# Pass kernel_entry.o and kernel.o to a linker.
# The linkage order is strictly as the order in the command.
# --oformat=elf32-i386
# -m elf_x86_64
# -no-pie: ??? https://github.com/cfenollosa/os-tutorial/issues/16
kernel.bin: kernel_entry.o kernel.o multiply.o
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
