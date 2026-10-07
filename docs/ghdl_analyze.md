<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public entry point for `ghdl_analyze`.

<a id="ghdl_analyze"></a>

## ghdl_analyze

<pre>
load("@rules_ghdl//ghdl:ghdl_analyze.bzl", "ghdl_analyze")

ghdl_analyze(<a href="#ghdl_analyze-name">name</a>, <a href="#ghdl_analyze-deps">deps</a>, <a href="#ghdl_analyze-args">args</a>, <a href="#ghdl_analyze-library">library</a>, <a href="#ghdl_analyze-standard">standard</a>)
</pre>

Analyzes a vhdl_library target to produce a GHDL library object directory.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ghdl_analyze-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ghdl_analyze-deps"></a>deps |  A list of other compiled ghdl_analyze targets that this library depends on.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ghdl_analyze-args"></a>args |  Additional arguments to pass to GHDL.   | List of strings | optional |  `[]`  |
| <a id="ghdl_analyze-library"></a>library |  The vhdl_library target to compile/analyze.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="ghdl_analyze-standard"></a>standard |  The VHDL standard to use for compilation (e.g., '08', '19'). If empty, defaults to the standard specified in the library, or '08'.   | String | optional |  `""`  |


