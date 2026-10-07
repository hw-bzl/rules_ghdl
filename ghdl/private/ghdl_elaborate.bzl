load(":utils.bzl", "get_ghdl_vhdl_libs_and_prefix")
load(":providers.bzl", "GhdlLibraryInfo", "GhdlElaborateInfo")
load(":toolchain.bzl", "GHDL_TOOLCHAIN_TYPE", "VHDL_STANDARD_DEFAULT")

def _ghdl_elaborate_impl(ctx):
    ghdl_info = ctx.toolchains[GHDL_TOOLCHAIN_TYPE].ghdl_info
    analyzer = ghdl_info.analyzer.files.to_list()[0]
    std = ctx.attr.standard

    active_libs, prefix_dir = get_ghdl_vhdl_libs_and_prefix(ghdl_info, std)

    out_dir = ctx.actions.declare_directory("{}_elab".format(ctx.attr.name))
    
    ghdl_lib_info = ctx.attr.library[GhdlLibraryInfo]
    library_name = ghdl_lib_info.library_name

    libargs = []
    deps_paths = []
    all_libraries = ghdl_lib_info.libraries
    for name, path in all_libraries:
        if name != library_name:
            libargs += ["-P" + path.path]
            deps_paths.append(path)

    cmd = """
    mkdir -p {outdir}
    cp -r {indir}/* {outdir}/ || true
    {cmd} \
      -e \
      --workdir={outdir} \
      --work={library} \
      --std={std} \
      {libargs} \
      {entity}
      
    # Rewrite absolute sandbox execution paths inside the .cf library index
    # to be relative, enabling seamless cross-sandbox compilation.
    find {outdir} -name "*.cf" -exec sed -i "s|$PWD/||g" {{}} +
    """.format(
        indir = ghdl_lib_info.library_dir.path,
        outdir = out_dir.path,
        cmd = analyzer.path,
        library = library_name,
        std = std,
        libargs = " ".join(libargs),
        entity = ctx.attr.name,
    )

    ctx.actions.run_shell(
        outputs = [out_dir],
        inputs = [ghdl_lib_info.library_dir] + deps_paths + active_libs + ghdl_lib_info.transitive_sources.to_list(),
        tools = [analyzer],
        command = cmd,
        env = {
            "GHDL_PREFIX": prefix_dir,
        },
        progress_message = "GHDL Elaborate: {}.{}".format(library_name, ctx.attr.name),
    )

    runfiles = ctx.runfiles(files = deps_paths + [out_dir] + ghdl_lib_info.transitive_sources.to_list())
    runfiles.merge_all([ctx.attr.library[DefaultInfo].default_runfiles])

    return [
        GhdlLibraryInfo(
            libraries = [(library_name, out_dir)] + [l for l in all_libraries if l[0] != library_name],
            library_name = library_name,
            library_dir = out_dir,
            transitive_sources = ghdl_lib_info.transitive_sources,
        ),
        GhdlElaborateInfo(entity = ctx.attr.name),
        DefaultInfo(
            files = depset([out_dir]),
            runfiles = runfiles,
        )
    ]

ghdl_elaborate = rule(
    implementation = _ghdl_elaborate_impl,
    doc = "Elaborates a VHDL design using GHDL.",
    attrs = {
        "library": attr.label(
            providers = [GhdlLibraryInfo],
            doc = "The ghdl_analyze compiled target to elaborate.",
        ),
        "standard": attr.string(
            default = VHDL_STANDARD_DEFAULT,
            doc = "The VHDL standard to use for elaboration (e.g., '08', '19').",
        ),
    },
    toolchains = [
        GHDL_TOOLCHAIN_TYPE,
    ],
)
