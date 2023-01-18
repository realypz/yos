# TODO: Is it necessary to keep this provider?
CToolchainInfo = provider(
    doc = "Information about how to invoke the barc compiler.",
    # In the real world, compiler_path and system_lib might hold File objects,
    # but for simplicity they are strings for this example. arch_flags is a list
    # of strings.
    fields = ["compiler_path", "system_lib", "compiler_args", "arch_flags"],
)

def _c_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        ctoolchaininfo = CToolchainInfo(
            compiler_path = ctx.attr.compiler_path,
            system_lib = ctx.attr.system_lib,
            compiler_args = ctx.attr.compiler_args,
            arch_flags = ctx.attr.arch_flags,
        ),
    )
    return [toolchain_info]

c_toolchain = rule(
    implementation = _c_toolchain_impl,
    attrs = {
        "compiler_path": attr.string(),
        "system_lib": attr.string(),
        "compiler_args": attr.string_list(),
        "arch_flags": attr.string_list(),
    },
)
