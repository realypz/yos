# Run the following commands to generate the os image.
# ```output/os-image``` is what you need.

# Build boot sector
nasm -f bin boot/boot_sector.asm -o output/boot_sector.bin

# Build your own C function to the object file.
gcc -ffreestanding -c kernel/kernel.c -o output/kernel.o

# Pass kernel.o to a linker
ld -o output/kernel.bin -Ttext 0x1000 output/kernel.o --oformat binary

# Concatenate two binary file into one.
cat output/boot_sector.bin output/kernel.bin > output/os-image