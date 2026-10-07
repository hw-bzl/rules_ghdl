load(":utils.bzl", "get_ghdl_vhdl_libs_and_prefix")
load(":providers.bzl", "GhdlLibraryInfo")
load("@rules_vhdl//vhdl:defs.bzl", "VhdlInfo")
load(":toolchain.bzl", "GHDL_TOOLCHAIN_TYPE", "VHDL_STANDARD_DEFAULT")

def _ghdl_analyze_impl(ctx):
    ghdl_info = ctx.toolchains[GHDL_TOOLCHAIN_TYPE].ghdl_info
    analyzer = ghdl_info.analyzer.files.to_list()[0]
    
    # Resolve library target
    vhdl_info = ctx.attr.library[VhdlInfo]
    library_name = vhdl_info.library
    std = ctx.attr.standard or vhdl_info.standard or VHDL_STANDARD_DEFAULT

    active_libs, prefix_dir = get_ghdl_vhdl_libs_and_prefix(ghdl_info, std)

    output_dir = ctx.actions.declare_directory("{}_obj".format(ctx.attr.name))
    
    # Local sources from the vhdl_library
    srcs = vhdl_info.srcs.to_list()
        
    all_libraries = []
    libargs = []
    deps_files = []
    seen = []
    transitive_src_depsets = [vhdl_info.srcs]
    for dep in ctx.attr.deps:
        ghdl_lib_info = dep[GhdlLibraryInfo]
        transitive_src_depsets.append(ghdl_lib_info.transitive_sources)
        for name, path in ghdl_lib_info.libraries:
            if name not in seen:
                libargs += ["-P" + path.path]
                seen.append(name)
                deps_files.append(path)
                all_libraries.append((name, path))

    all_transitive_sources = depset(transitive = transitive_src_depsets)

    cmd = """
    mkdir -p {outdir}
    {cmd} \
      -a \
      --workdir={outdir} \
      --work={library} \
      --std={std} \
      --warn-library \
      {libargs} \
      {rule_args} \
      {files}
    
    # Rewrite absolute sandbox execution paths inside the .cf library index
    # to be relative, enabling seamless cross-sandbox compilation.
    find {outdir} -name "*.cf" -exec sed -i "s|$PWD/||g" {{}} +
    """.format(
        outdir = output_dir.path,
        cmd = analyzer.path,
        library = library_name,
        std = std,
        libargs = " ".join(libargs),
        rule_args = " ".join(ctx.attr.args),
        files = " ".join([f.path for f in srcs])
    )
    
    ctx.actions.run_shell(
        outputs = [output_dir],
        inputs = deps_files + active_libs + all_transitive_sources.to_list(),
        tools = [analyzer],
        command = cmd,
        env = {
            "GHDL_PREFIX": prefix_dir,
        },
        progress_message = "GHDL Library Analyze: {}".format(library_name),
    )
    
    return [
        GhdlLibraryInfo(
            libraries = [(library_name, output_dir)] + all_libraries,
            library_name = library_name,
            library_dir = output_dir,
            transitive_sources = all_transitive_sources,
        ),
        DefaultInfo(
            files = depset([output_dir]),
            runfiles = ctx.runfiles(files = [output_dir]),
        )
    ]

ghdl_analyze = rule(
    implementation = _ghdl_analyze_impl,
    doc = "Analyzes a vhdl_library target to produce a GHDL library object directory.",
    attrs = {
        "library": attr.label(
            providers = [VhdlInfo],
            mandatory = True,
            doc = "The vhdl_library target to compile/analyze.",
        ),
        "deps": attr.label_list(
            providers = [GhdlLibraryInfo],
            doc = "A list of other compiled ghdl_analyze targets that this library depends on.",
        ),
        "standard": attr.string(
            default = "",
            doc = "The VHDL standard to use for compilation (e.g., '08', '19'). If empty, defaults to the standard specified in the library, or '08'.",
        ),
        "args": attr.string_list(
            doc = "Additional arguments to pass to GHDL.",
        ),
    },
    toolchains = [
        GHDL_TOOLCHAIN_TYPE,
    ],
)
