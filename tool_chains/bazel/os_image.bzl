def _y_os_image_impl(ctx):
    os_image = ctx.actions.declare_file(ctx.attr.name)

    ctx.actions.run_shell(
        inputs = ctx.files.bootloader + ctx.files.kernel,
        outputs = [os_image],
        progress_message = "Buidling image %s" % ctx.attr.name,
        command = "cat $1 $2 > $3",
        arguments = [ctx.file.bootloader.path, ctx.file.kernel.path, os_image.path],
    )

    # NOTE: The merged os image file cannot execute by itself.
    #       It needs to be run in a simulator.
    #       Due to the file permission of
    #       bazel sandbox (https://bazel.build/docs/sandboxing),
    #       os_image does not have write permission, and this stops
    #       QEMU to load this image. Thus, an executable script that
    #       calls QEMU on this image is created when this bazel rule
    #       is run. 
    exec_script = ctx.actions.declare_file(ctx.attr.name + ".sh")
    ctx.actions.write(
        exec_script,
        content = """#!/bin/sh
chmod +rwx $(realpath .)/{os_image_path}
qemu-system-x86_64 -fda $(realpath .)/{os_image_path}
""".format(
        os_image_path = os_image.basename,
        ),
        is_executable=True,
    )

    return [
        DefaultInfo(
            runfiles = ctx.runfiles(files = [os_image]),
            executable = exec_script,
        ),
    ]

y_os_image = rule(
    implementation = _y_os_image_impl,
    attrs = {
        "bootloader": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The bootloader binary."
        ),
        "kernel": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The kernel binary."
        ),
    },
    executable = True,
)
