"""Providers exported by rules_ghdl."""

load(
    "//ghdl/private:providers.bzl",
    _GhdlElaborateInfo = "GhdlElaborateInfo",
    _GhdlLibraryInfo = "GhdlLibraryInfo",
    _GhdlToolchainInfo = "GhdlToolchainInfo",
)

GhdlToolchainInfo = _GhdlToolchainInfo
GhdlLibraryInfo = _GhdlLibraryInfo
GhdlElaborateInfo = _GhdlElaborateInfo
