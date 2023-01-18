#!/usr/bin/python3

# How to run
"""
<dirs...>/make_os_image.py \
    --bootloader-binary bazel-bin/boot/bootloader.bin \
    --kernel-binary bazel-bin/kernel/src/kernel.bin\
    --output-dir ./tmp2
"""
import os
import argparse

parser = argparse.ArgumentParser("This py file generate all the python files you will need.")

parser.add_argument("--bootloader-binary", required=True, type=str)
parser.add_argument("--kernel-binary", required=True)
parser.add_argument("--output-dir", required=True)

args = parser.parse_args()

os.makedirs(args.output_dir, exist_ok=True)
# Put the files being part of the CD-ROM image in ISO_CONTENT_DIR.
ISO_CONTENT_DIR = os.path.join(args.output_dir, "iso")
os.makedirs(ISO_CONTENT_DIR, exist_ok=True)

OS_BIN = os.path.join(args.output_dir, "yos.bin")
FLOPPY_IMG = os.path.join(ISO_CONTENT_DIR, "floppy.img")
OS_ISO = os.path.join(args.output_dir, "yos.iso")

# Concatenate two binary files, bootloader first, kernel second.
os.system("cat {booloader} {kernel} > {output}".format(
    booloader=args.bootloader_binary,
    kernel=args.kernel_binary,
    output=OS_BIN))

# Make a floppy disk image.
# NOTE: The size must be 1440*1024 bytes.
# Read https://stackoverflow.com/questions/34268518/creating-a-bootable-iso-image-with-custom-bootloader
os.system(f"dd if=/dev/zero of={FLOPPY_IMG} bs=1024 count=1440")
# TODO: Now we copy 1024 sectors, it should be reserved large enough at this moment.
os.system(f"dd if={OS_BIN} of={FLOPPY_IMG} seek=0 count=1024 conv=notrunc")

# Generate the CD-ROM bootable image.
# NOTE: You must provide the ISO_CONTENT_DIR, under which files are burnt to a CD.
# NOTE: FLOPPY_IMG must exist under ISO_CONTENT_DIR.
# NOTE: "-b" needs the relative path under ISO_CONTENT_DIR, not the shell terminal's path.
os.system(f"genisoimage -quiet -V 'MYOS' -input-charset iso8859-1 \
           -o {OS_ISO} -b {os.path.basename(FLOPPY_IMG)} \
           -hide {os.path.basename(FLOPPY_IMG)} \
           {ISO_CONTENT_DIR}/")
