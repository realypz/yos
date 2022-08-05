# README.md

## Build everything
Run ```bash build.sh``` to quickly generate the image of yos.

## To run in Linux
```bash
qemu-system-i386 -fda output/os-image

# If GUI is not supported, then add '-nographic' flag.
```

## To run in Windows
1. Download the bin file to Windows folder.
2. In cmd (not PowerShell)
```bash
# -fda: load from floppy disk A.
"C:\Program Files\qemu\qemu-system-i386.exe" "-fda" "\\wsl$\Ubuntu-20.04-ypz\home\realypz\ypz_code\yos\output\os-image"
```
