<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public entry point for `ghdl_toolchain`.

<a id="ghdl_toolchain"></a>

## ghdl_toolchain

<pre>
load("@rules_ghdl//ghdl:ghdl_toolchain.bzl", "ghdl_toolchain")

ghdl_toolchain(<a href="#ghdl_toolchain-name">name</a>, <a href="#ghdl_toolchain-analyzer">analyzer</a>, <a href="#ghdl_toolchain-vhdl_libs">vhdl_libs</a>)
</pre>

Defines the GHDL toolchain, linking to the GHDL analyzer and standard library.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ghdl_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ghdl_toolchain-analyzer"></a>analyzer |  The GHDL executable.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ghdl_toolchain-vhdl_libs"></a>vhdl_libs |  The standard VHDL libraries for GHDL.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


