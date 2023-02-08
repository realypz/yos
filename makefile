OUTPUT_DIR = .output

####### This section is temporary for bazel debugging. #######
BINARIES_FROM_BAZEL = \
	./bazel-bin/boot/bootloader.bin \
	./bazel-bin/kernel/src/kernel.bin

os-image-from-bazel:
	bazel build --config=default_config //boot:bootloader //kernel/main:kernel
	./support/release/make_os_image.py \
    	--bootloader-binary bazel-bin/boot/bootloader.bin \
    	--kernel-binary bazel-bin/kernel/main/kernel.bin\
    	--output-dir ./${OUTPUT_DIR}/make_os_image

bazel_run: os-image-from-bazel
	qemu-system-x86_64 -cdrom ${OUTPUT_DIR}/make_os_image/yos.iso

####### END #######

debug: os-image
	 qemu-system-x86_64 -gdb tcp::1234 -S -fda ${OUTPUT_DIR}/os-image -monitor stdio

clean:
	bazel clean
	rm -r ${OUTPUT_DIR}
