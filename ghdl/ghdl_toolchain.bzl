"""Public entry point for `ghdl_toolchain`."""

load(
    "//ghdl/private:toolchain.bzl",
    _GHDL_TOOLCHAIN_TYPE = "GHDL_TOOLCHAIN_TYPE",
    _ghdl_toolchain = "ghdl_toolchain",
)

ghdl_toolchain = _ghdl_toolchain
GHDL_TOOLCHAIN_TYPE = _GHDL_TOOLCHAIN_TYPE
