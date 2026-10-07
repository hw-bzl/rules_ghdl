<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Providers exported by rules_ghdl.

<a id="GhdlElaborateInfo"></a>

## GhdlElaborateInfo

<pre>
load("@rules_ghdl//ghdl:ghdl_info.bzl", "GhdlElaborateInfo")

GhdlElaborateInfo(<a href="#GhdlElaborateInfo-entity">entity</a>)
</pre>

Provides information about an elaborated VHDL entity.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="GhdlElaborateInfo-entity"></a>entity |  string: The name of the elaborated entity.    |


<a id="GhdlLibraryInfo"></a>

## GhdlLibraryInfo

<pre>
load("@rules_ghdl//ghdl:ghdl_info.bzl", "GhdlLibraryInfo")

GhdlLibraryInfo(<a href="#GhdlLibraryInfo-libraries">libraries</a>, <a href="#GhdlLibraryInfo-library_name">library_name</a>, <a href="#GhdlLibraryInfo-library_dir">library_dir</a>, <a href="#GhdlLibraryInfo-transitive_sources">transitive_sources</a>)
</pre>

Contains the information about the binary files in a compiled GHDL library.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="GhdlLibraryInfo-libraries"></a>libraries |  List[(string, File)]: A mapping from a library name to its directory location. Contains both this library and its dependencies, ensuring no duplicate keys.    |
| <a id="GhdlLibraryInfo-library_name"></a>library_name |  string: The name of the library (e.g., `ieee`, `work`).    |
| <a id="GhdlLibraryInfo-library_dir"></a>library_dir |  File: The container directory where the library is located.    |
| <a id="GhdlLibraryInfo-transitive_sources"></a>transitive_sources |  depset[File]: All transitive VHDL source files of this library and its dependencies.    |


<a id="GhdlToolchainInfo"></a>

## GhdlToolchainInfo

<pre>
load("@rules_ghdl//ghdl:ghdl_info.bzl", "GhdlToolchainInfo")

GhdlToolchainInfo(<a href="#GhdlToolchainInfo-analyzer">analyzer</a>, <a href="#GhdlToolchainInfo-vhdl_libs">vhdl_libs</a>)
</pre>

Information on how to run GHDL for VHDL analysis, elaboration and simulation.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="GhdlToolchainInfo-analyzer"></a>analyzer |  The GHDL executable file.    |
| <a id="GhdlToolchainInfo-vhdl_libs"></a>vhdl_libs |  The standard VHDL libraries for GHDL.    |


