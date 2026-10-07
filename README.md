# Bazel rules for GHDL

[![Test status](https://github.com/hw-bzl/rules_ghdl/actions/workflows/test.yml/badge.svg)](https://github.com/hw-bzl/rules_ghdl/actions/workflows/test.yml)
[![Publish BCR status](https://github.com/hw-bzl/rules_ghdl/actions/workflows/publish-bcr.yml/badge.svg)](https://github.com/hw-bzl/rules_ghdl/actions/workflows/publish-bcr.yml)
[![Publish status](https://github.com/hw-bzl/rules_ghdl/actions/workflows/publish.yml/badge.svg)](https://github.com/hw-bzl/rules_ghdl/actions/workflows/publish.yml)
[![Tag and Release status](https://github.com/hw-bzl/rules_ghdl/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/hw-bzl/rules_ghdl/actions/workflows/tag-and-release.yml)

This repository contains a [`bazel`][bb] rule set for running [`ghdl`][gg], the
VHDL simulator and synthesizer.

[bb]: https://bazel.build
[gg]: https://github.com/ghdl/ghdl

> **This ruleset moved.** It was previously developed at
> `filmil/bazel_rules_ghdl` and now lives at `hw-bzl/rules_ghdl`, alongside the
> other hardware-design rulesets in the [`hw-bzl`][hb] organization. Version
> `2.0.0` is the first release from the new home; the major bump reflects the
> move, since the release archive is named after the repository and is now
> `rules_ghdl-vX.Y.Z.zip` rather than `bazel_rules_ghdl-vX.Y.Z.zip`. Old links
> and release URLs continue to work through GitHub's redirects.

[hb]: https://github.com/hw-bzl

## Prerequisites

* `bazel` installation via [`bazelisk`][aa]. I recommend downloading `bazelisk`
  and placing it somewhere in your `$PATH` under the name `bazel`.

Everything else will be downloaded for use the first time you run the build.

[aa]: https://hdlfactory.com/note/2024/08/24/bazel-installation-via-the-bazelisk-method/

## Documentation

See [docs/](docs/) for the generated rule documentation, one file per public `.bzl`.

## Architecture & Integration with `rules_vhdl`

This workspace is fully integrated with the foundational [`rules_vhdl`][rv]
graph module. VHDL dependency graphs are declared once using `vhdl_library`, and
the GHDL backend translates this metadata into compilation, elaboration, and test
execution steps.

[rv]: https://github.com/hw-bzl/rules_vhdl

- **`vhdl_library`** (from `@rules_vhdl`): Groups VHDL source files and
  describes dependencies. It generates a transitive `VHDLLibraryProvider`.
- **`ghdl_analyze`**: Consumes `vhdl_library` targets and compiles VHDL files
  using `ghdl -a` into an isolated, hermetic GHDL object directory.
- **`ghdl_elaborate`**: Takes compiled GHDL object targets and elaborates them
  using `ghdl -e`.
- **`ghdl_test`**: Groups compilation, elaboration, and execution into an
  executable test rule using `ghdl -r` inside a sandboxed test runner.

## Hermeticity

This rule set is completely hermetic. All dependencies are set up automatically
by `bazel`. In addition, `ghdl_analyze` automatically rewrites absolute sandbox
execution paths inside generated `.cf` library indexes into relative paths,
enabling robust compilation across different sandboxed actions.

## Examples

In general, see [integration/](integration/) for example use.

The module is published to the [Bazel Central Registry][bcr], so no registry
override is needed:

```starlark
bazel_dep(name = "rules_ghdl", version = "2.0.0")
```

[bcr]: https://registry.bazel.build/modules/rules_ghdl

### Declaring a VHDL Library and Compile Target

```starlark
load("@rules_vhdl//vhdl:defs.bzl", "vhdl_library")
load("@rules_ghdl//ghdl:defs.bzl", "ghdl_analyze")

# 1. Group the sources
vhdl_library(
    name = "lib_src",
    srcs = ["hello.vhdl"],
    library = "lib",
)

# 2. Analyze the library
ghdl_analyze(
    name = "lib",
    library = ":lib_src",
    args = ["--ieee=synopsys"],
)
```

### Running VHDL Tests

```starlark
load("@rules_ghdl//ghdl:defs.bzl", "ghdl_test")

ghdl_test(
    name = "hello_world_test",
    srcs = ["test.vhdl"],
    entity = "hello_world",
)
```

To run tests in the `integration/` directory:

```bash
cd integration && bazel test //...
```

## Notes

* Only Linux host and target are supported for now, although it should be
  straightforward (but not necessarily trivial) to add support for other archs.

## References

* https://github.com/solsjo/rules_ghdl: an alternative rule set, which is not
  hermetic.
