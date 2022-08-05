# Run the following commands to generate the os image.
# ```output/os-image``` is what you need.

mkdir -p output/

# Build boot sector
nasm -f bin boot/boot_sector.asm -o output/boot_sector.bin

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
gcc -m32 -fno-PIE -Wextra -Wall -ffreestanding -c kernel/kernel.c -o output/kernel.o

# -f elf64
# -f elf32
nasm -f elf32 kernel/kernel_entry.asm -o output/kernel_entry.o

# Pass kernel_entry.o and kernel.o to a linker.
# The linkage order is strictly as the order in the command.
# --oformat=elf32-i386
# -m elf_i386
# -no-pie: ??? https://github.com/cfenollosa/os-tutorial/issues/16
ld -m elf_i386 -no-pie -o output/kernel.bin\
 -Ttext 0x1000 output/kernel_entry.o output/kernel.o\
 --oformat=binary

# Concatenate two binary file into one.
cat output/boot_sector.bin output/kernel.bin > output/os-image
