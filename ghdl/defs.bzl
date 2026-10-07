"""Bulk re-export of the public rules_ghdl API."""

load("//ghdl/private:macros.bzl", _wave_view = "wave_view")
load(":ghdl_analyze.bzl", _ghdl_analyze = "ghdl_analyze")
load(":ghdl_elaborate.bzl", _ghdl_elaborate = "ghdl_elaborate")
load(
    ":ghdl_info.bzl",
    _GhdlElaborateInfo = "GhdlElaborateInfo",
    _GhdlLibraryInfo = "GhdlLibraryInfo",
    _GhdlToolchainInfo = "GhdlToolchainInfo",
)
load(":ghdl_test.bzl", _ghdl_test = "ghdl_test")
load(
    ":ghdl_toolchain.bzl",
    _GHDL_TOOLCHAIN_TYPE = "GHDL_TOOLCHAIN_TYPE",
    _ghdl_toolchain = "ghdl_toolchain",
)
load(":ghdl_verilog.bzl", _ghdl_verilog = "ghdl_verilog")

# Rules
ghdl_analyze = _ghdl_analyze
ghdl_elaborate = _ghdl_elaborate
ghdl_test = _ghdl_test
ghdl_verilog = _ghdl_verilog

# Toolchain
ghdl_toolchain = _ghdl_toolchain
GHDL_TOOLCHAIN_TYPE = _GHDL_TOOLCHAIN_TYPE

# Providers
GhdlToolchainInfo = _GhdlToolchainInfo
GhdlLibraryInfo = _GhdlLibraryInfo
GhdlElaborateInfo = _GhdlElaborateInfo

# Macros
wave_view = _wave_view
