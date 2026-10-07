load(":providers.bzl", "GhdlToolchainInfo")

GHDL_TOOLCHAIN_TYPE = Label("//ghdl:toolchain_type")
VHDL_STANDARD_DEFAULT = "08"

def _ghdl_toolchain_impl(ctx):
  toolchain_info = platform_common.ToolchainInfo(
    ghdl_info = GhdlToolchainInfo(
      analyzer = ctx.attr.analyzer,
      vhdl_libs = ctx.files.vhdl_libs,
    ),
  )
  return [toolchain_info]

ghdl_toolchain = rule(
  doc = "Defines the GHDL toolchain, linking to the GHDL analyzer and standard library.",
  implementation = _ghdl_toolchain_impl,
  attrs = {
    "analyzer": attr.label(
        executable = True,
        cfg = "exec",
        doc = "The GHDL executable.",
    ),
    "vhdl_libs": attr.label_list(
        doc = "The standard VHDL libraries for GHDL.",
    ),
  }
)
