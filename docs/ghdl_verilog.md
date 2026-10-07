<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public entry point for `ghdl_verilog`.

<a id="ghdl_verilog"></a>

## ghdl_verilog

<pre>
load("@rules_ghdl//ghdl:ghdl_verilog.bzl", "ghdl_verilog")

ghdl_verilog(<a href="#ghdl_verilog-name">name</a>, <a href="#ghdl_verilog-deps">deps</a>, <a href="#ghdl_verilog-arch">arch</a>, <a href="#ghdl_verilog-args">args</a>, <a href="#ghdl_verilog-generics">generics</a>, <a href="#ghdl_verilog-lib">lib</a>, <a href="#ghdl_verilog-standard">standard</a>, <a href="#ghdl_verilog-unit">unit</a>, <a href="#ghdl_verilog-vendor">vendor</a>)
</pre>

Synthesizes a GHDL library into a Verilog netlist.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ghdl_verilog-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ghdl_verilog-deps"></a>deps |  A list of GHDL compiled libraries created using ghdl_analyze   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ghdl_verilog-arch"></a>arch |  The architecture to use for the entity, if there are multiple available   | String | optional |  `""`  |
| <a id="ghdl_verilog-args"></a>args |  Additional arguments to pass to GHDL   | List of strings | optional |  `[]`  |
| <a id="ghdl_verilog-generics"></a>generics |  A map of string to string, defining the top level unit generic parameters   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="ghdl_verilog-lib"></a>lib |  The target GHDL compiled library to synthesize.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ghdl_verilog-standard"></a>standard |  The VHDL language standard to use.   | String | optional |  `"08"`  |
| <a id="ghdl_verilog-unit"></a>unit |  The top level unit to elaborate.   | String | optional |  `""`  |
| <a id="ghdl_verilog-vendor"></a>vendor |  A list of libraries to be treated as vendor library black boxes   | List of strings | optional |  `[]`  |


