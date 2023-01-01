# The implementation fo yos_c_library
# Search https://bazel.build/rules/lib/starlark-overview for API reference.
def _yos_c_library_impl(ctx):
    object_files_map = {
        file: ctx.actions.declare_file(file.basename+ ".obj")
        for file in ctx.files.srcs if file.extension in ["c", "cpp"]
    }
    # [misc comments]:
    # ctx.actions.declare_file declares the placeholder for the file to
    # be generated.

    gcc_default_arg_list = [
        "-fno-PIE",
        "-Wextra",
        "-Wall",
        "-ffreestanding",
        "-I./",
        "-c",   # [misc comments]: Compile or assemble the source files, but do not link.
                # https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html
    ]

    for src_file, obj_file in object_files_map.items():
        # [misc comments]:
        # ctx.actions.run execute the compilation command.
        # The for loop is used to compile multiple files.
        ctx.actions.run(
            inputs = [src_file] + ctx.files.hdrs + ctx.files.deps,
            outputs = [obj_file],
            executable = "/usr/bin/gcc",
            arguments = gcc_default_arg_list + [src_file.path] + ["-o", obj_file.path],
        )

    return [
        DefaultInfo(
            files = depset([obj_file for _, obj_file in object_files_map.items()] +
            ctx.files.hdrs),
        ),
    ]
    # Why add ctx.files.hdrs in the depset?
    # This will allow another library to depend on the header files from this library.

yos_c_library = rule(
    implementation = _yos_c_library_impl,
    attrs = {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True,
        ),
        # Purpose of hdrs:
        # 1. Make the hdrs are foundable when the compilation command is executed
        #    sand box.
        # 2. hdrs are exposed as part of the library output files.
        "hdrs": attr.label_list(
            # When you want multiple files, use attr.label_list.
            mandatory = True,
            allow_files = True,
        ),
        "deps": attr.label_list(
            mandatory = False,
            allow_files = True,
        )
    },
    executable = False,
)
