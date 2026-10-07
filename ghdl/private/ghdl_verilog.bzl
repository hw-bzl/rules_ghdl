load(":utils.bzl", "get_ghdl_vhdl_libs_and_prefix")
load(":providers.bzl", "GhdlLibraryInfo")
load(":toolchain.bzl", "GHDL_TOOLCHAIN_TYPE", "VHDL_STANDARD_DEFAULT")

def _ghdl_verilog_impl(ctx):
    ghdl_info = ctx.toolchains[GHDL_TOOLCHAIN_TYPE].ghdl_info
    analyzer = ghdl_info.analyzer.files.to_list()[0]
    
    name = ctx.label.name
    lib = ctx.attr.lib
    ghdl_lib_info = lib[GhdlLibraryInfo]
    lib_name = ghdl_lib_info.library_name
    workdir = ghdl_lib_info.library_dir

    output_file = ctx.actions.declare_file("{}/{}.v".format(name, lib_name))
    output_dir = ctx.actions.declare_directory("{}.build".format(name))
    cache_dir = ctx.actions.declare_directory("{}.cache".format(name))
    outputs = [output_file, output_dir, cache_dir]

    libargs = []
    inputs = [workdir] + ghdl_lib_info.transitive_sources.to_list()
    libraries = []
    
    # Process library itself
    libargs += ["-P{}".format(workdir.path)]
    
    # Process deps
    seen = []
    for dep in ctx.attr.deps:
        dep_provider = dep[GhdlLibraryInfo]
        for name, path in dep_provider.libraries:
            if name not in seen:
                libargs += ["-P{}".format(path.path)]
                libraries += [path]
                seen.append(name)

    generics = [
        "-g{key}={value}".format(key=k, value=v)
            for (k, v) in ctx.attr.generics.items()]
    vendor = [ "--vendor-library={}".format(s) for s in ctx.attr.vendor]

    arch = ctx.attr.arch or ""

    active_libs, prefix_dir = get_ghdl_vhdl_libs_and_prefix(ghdl_info, ctx.attr.standard)

    ctx.actions.run_shell(
        progress_message = "GHDL Synth: {}.{}".format(lib_name, ctx.attr.unit),
        inputs = inputs + libraries + active_libs,
        outputs = outputs,
        tools = [analyzer],
        mnemonic = "GHDLSYNTH",
        env = {
            "GHDL_PREFIX": prefix_dir,
        },
        command = """
          mkdir -p $(dirname {output})
          {cmd} \
          synth \
          {libargs} \
          {generics} \
          {vendor} \
          {rule_args} \
          --workdir={workdir} \
          --work={library} \
          --out=verilog \
          --std={std} \
          {unit} \
          {arch}  \
          > {output}
        """.format(
            cmd=analyzer.path,
            library=lib_name,
            workdir=workdir.path,
            libargs=" ".join(libargs),
            unit=ctx.attr.unit,
            arch=arch,
            output=output_file.path,
            std=ctx.attr.standard,
            generics=" ".join(generics),
            vendor=" ".join(vendor),
            rule_args=" ".join(ctx.attr.args),
        ),
    )

    return [
        DefaultInfo(
            files=depset([output_file]),
        ),
    ]

ghdl_verilog = rule(
    implementation = _ghdl_verilog_impl,
    doc = "Synthesizes a GHDL library into a Verilog netlist.",
    attrs = {
        "lib": attr.label(
            providers = [ GhdlLibraryInfo ],
            doc = "The target GHDL compiled library to synthesize.",
        ),
        "deps": attr.label_list(
            providers = [ GhdlLibraryInfo ],
            doc = "A list of GHDL compiled libraries created using ghdl_analyze",
        ),
        "unit": attr.string(
            doc = "The top level unit to elaborate."
        ),
        "arch": attr.string(
            default = "",
            doc = "The architecture to use for the entity, if there are multiple available",
        ),
        "standard": attr.string(
            default = VHDL_STANDARD_DEFAULT,
            doc = "The VHDL language standard to use.",
        ),
        "generics": attr.string_dict(
            allow_empty = True,
            doc = "A map of string to string, defining the top level unit generic parameters",
        ),
        "vendor": attr.string_list(
            doc = "A list of libraries to be treated as vendor library black boxes",
        ),
        "args": attr.string_list(
            doc = "Additional arguments to pass to GHDL",
        ),
    },
    toolchains = [
        GHDL_TOOLCHAIN_TYPE,
    ],
)
