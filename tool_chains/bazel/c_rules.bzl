BINARY_EXTENSION = "bin"

ELF_EXTENSION = "obj"

NASM_PATH = "/usr/bin/nasm"
NASM_DEFAULT_ARGS = ["-f", "elf64"]
ASSEMBLY_CODE_EXTENSIONS = ["asm"]

GCC_PATH = "/usr/bin/gcc"
GCC_DEFAULT_ARGS = [
    "-fno-PIE",
    "-Wextra",
    "-Wall",
    "-ffreestanding",
    "-I./",
    "-c",  # MISC: Compile or assemble the source files, but do not link.
    # https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html
]
C_CODE_EXTENSIONS = ["cpp", "c"]

# The implementation fo y_cc_library
# Search https://bazel.build/rules/lib/starlark-overview for API reference.
def _yos_c_library_impl(ctx):
    object_files_map = {
        file: ctx.actions.declare_file(file.basename + "." + ELF_EXTENSION)
        for file in ctx.files.srcs
        if file.extension in
           ASSEMBLY_CODE_EXTENSIONS + C_CODE_EXTENSIONS
        # NOTE: Even this rule is called "y_cc_library",
        # assembly code is also supported!
    }
    # MISC:
    # ctx.actions.declare_file declares the placeholder for the file to
    # be generated.

    for src_file, obj_file in object_files_map.items():
        # MISC:
        # ctx.actions.run execute the compilation command.
        # The for loop is used to compile multiple files.
        if src_file.extension in C_CODE_EXTENSIONS:
            ctx.actions.run(
                inputs = [src_file] + ctx.files.hdrs + ctx.files.deps,
                outputs = [obj_file],
                executable = GCC_PATH,
                arguments = GCC_DEFAULT_ARGS + [src_file.path] + ["-o", obj_file.path],
            )
        elif src_file.extension in ASSEMBLY_CODE_EXTENSIONS:
            ctx.actions.run(
                inputs = [src_file] + ctx.files.hdrs + ctx.files.deps,
                outputs = [obj_file],
                executable = NASM_PATH,
                arguments = NASM_DEFAULT_ARGS + [src_file.path] + ["-o", obj_file.path],
            )
        else:
            fail, ctx.attr.name + "has not supported types in srcs."

    return [
        DefaultInfo(
            files = depset([obj_file for _, obj_file in object_files_map.items()] +
                           ctx.files.hdrs + ctx.files.deps),
        ),
    ]
    # Why add ctx.files.hdrs in the depset?
    # This will allow another library to depend on the header files from this library.

y_cc_library = rule(
    implementation = _yos_c_library_impl,
    attrs = {
        # NOTE: Allowed types: *.c, *.cpp, *.asm
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True,
        ),
        # Purpose of hdrs:
        # 1. Make the hdrs are foundable when the compilation command is executed
        #    sand box.
        # 2. hdrs are exposed as part of the library output files.
        #
        # NOTE: Allowed types: *.h, *.asm
        "hdrs": attr.label_list(
            # When you want multiple files, use attr.label_list.
            mandatory = True,
            allow_files = True,
        ),
        "deps": attr.label_list(
            mandatory = False,
            allow_files = True,
        ),
    },
    executable = False,
)

LINKER_PATH = "/usr/bin/ld"
LINKER_DEFALT_ARGS = "-T"

# The implementation of y_cc_library.
def _y_cc_binary_impl(ctx):
    binary_file = ctx.actions.declare_file(ctx.attr.name + "." + BINARY_EXTENSION)

    objs_to_be_linked = [
        file
        for file in ctx.files.deps
        if file.extension == ELF_EXTENSION
    ]

    for src_file in ctx.files.srcs:
        if src_file.extension in ASSEMBLY_CODE_EXTENSIONS + C_CODE_EXTENSIONS:
            obj_file = ctx.actions.declare_file(src_file.basename + "." + ELF_EXTENSION)
            if src_file.extension in C_CODE_EXTENSIONS:
                ctx.actions.run(
                    inputs = [src_file] + ctx.files.srcs + ctx.files.deps,
                    outputs = [obj_file],
                    executable = GCC_PATH,
                    arguments = GCC_DEFAULT_ARGS + [src_file.path] + ["-o", obj_file.path],
                )
            else:
                # src_file.extension in ASSEMBLY_CODE_EXTENSIONS:
                ctx.actions.run(
                    inputs = [src_file] + ctx.files.srcs + ctx.files.deps,
                    outputs = [obj_file],
                    executable = NASM_PATH,
                    arguments = NASM_DEFAULT_ARGS + [src_file.path] + ["-o", obj_file.path],
                )
            objs_to_be_linked.append(obj_file)
        else:
            fail, ctx.label.name + "has not supported types in srcs."

    """ { Debug print
    print("Objects to be linked in", ctx.label.name)
    for obj in objs_to_be_linked:
        print(obj)

    } """

    linker_args = ctx.actions.args()
    if ctx.files.linker_command_file != None:
        linker_args.add_all("-T", ctx.files.linker_command_file)
    linker_args.add_all(objs_to_be_linked)
    linker_args.add_all("-o", [binary_file])

    # Link all objs
    ctx.actions.run(
        inputs = objs_to_be_linked + ctx.files.linker_command_file,
        outputs = [binary_file],
        executable = LINKER_PATH,
        arguments = [linker_args],
    )

    return [
        DefaultInfo(
            files = depset([binary_file]),
        ),
    ]

# Use y_cc_binary when you wants to build a binary file.
y_cc_binary = rule(
    implementation = _y_cc_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            mandatory = False,
            allow_files = True,
        ),
        "deps": attr.label_list(
            mandatory = False,
            allow_files = True,
        ),
        "linker_command_file": attr.label(
            mandatory = False,
            allow_files = True,
        ),
    },
    # TODO: Enable the property below.
    # executable = True,
)
