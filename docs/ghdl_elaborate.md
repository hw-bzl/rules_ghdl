<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public entry point for `ghdl_elaborate`.

<a id="ghdl_elaborate"></a>

## ghdl_elaborate

<pre>
load("@rules_ghdl//ghdl:ghdl_elaborate.bzl", "ghdl_elaborate")

ghdl_elaborate(<a href="#ghdl_elaborate-name">name</a>, <a href="#ghdl_elaborate-library">library</a>, <a href="#ghdl_elaborate-standard">standard</a>)
</pre>

Elaborates a VHDL design using GHDL.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ghdl_elaborate-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ghdl_elaborate-library"></a>library |  The ghdl_analyze compiled target to elaborate.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ghdl_elaborate-standard"></a>standard |  The VHDL standard to use for elaboration (e.g., '08', '19').   | String | optional |  `"08"`  |


