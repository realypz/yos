# README.md
This is a hobby project of playing with operating system. The development process is totally non-predictable.

When you browse this repo

# How to run simulation?
At the very begining, clone this repo to a Linux environment. My development environment is WSL2 on Windows 11.
The built OS image is run on QEMU for testing purpose. It has never been tested on a real hardware.
## Option 1: via makefile.
```bash
cd <repo_root>
make run
```
The generated files are under directory `<repo_root>/output`.
**NOTE**: make file is not actively maintained. It is still used when the coding in makefile is much easier than bazel.

## Option 2: via bazel.
This is the recomended way. Bazel might be unfamiliar to some viewers, and for me as well. Thus, I try to document
detailed comments when I write my own bazel rules for everyone's convenience. And my current plan is to further
develop the bazel building system.
```bash
# Install bazel on your machine. Commands omitted.

# Build the OS image.
bazel build //:yos

# Build, then run the raw OS image in QEMU. (not recommended)
bazel run //:yos

# First build via bazel, then make a CD-ROM image, and run this CD-ROM image in QEMU.
# Recommended
make bazel_run
```
The bazel system generates files under directory `<repo_root>/bazel-out/k8-fastbuild/bin`.


# Run in bochs
This feature is pending development, and might be removed in the future.
```
bochs

# You might need to install bochs and other dependencies to run bochs.
```

# Comment marker
This repo currently uses three comment markers.

`NOTE: ` is commented where the code logic is explained with details.

`MISC: ` is commented where the explanation is more of prior knowledge to understand the code, and less related to the code logic itself compared with `NOTE: `.

`TODO: ` is commented where a fix or change will happen in the future.

# Useful commands
```sh
# Bazel buildifier
tool_chains/format/bazel-buildifier.sh

# clang-format
tool_chains/format/clang-format.sh
```
