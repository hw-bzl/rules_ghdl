load(":utils.bzl", "get_ghdl_vhdl_libs_and_prefix")
load(":providers.bzl", "GhdlLibraryInfo", "GhdlElaborateInfo")
load(":toolchain.bzl", "GHDL_TOOLCHAIN_TYPE", "VHDL_STANDARD_DEFAULT")
load(":ghdl_analyze.bzl", "ghdl_analyze")
load(":ghdl_elaborate.bzl", "ghdl_elaborate")
load("@rules_vhdl//vhdl:defs.bzl", "vhdl_library")

def _get_ghdl_vhdl_libs_and_prefix_runfiles(ghdl_info, std):
    active_lib_files = []
    prefix_dir = ""
    for f in ghdl_info.vhdl_libs:
        if "vhdl_libs_v{}".format(std) in f.short_path:
            active_lib_files.append(f)
            if f.basename.endswith(".cf"):
                prefix_dir = f.short_path.rsplit("/", 3)[0]
    return active_lib_files, prefix_dir

def _ghdl_internal_test_impl(ctx):
    ghdl_info = ctx.toolchains[GHDL_TOOLCHAIN_TYPE].ghdl_info
    analyzer_x = ghdl_info.analyzer.files.to_list()[0]
    analyzer = analyzer_x.short_path
    
    std = ctx.attr.standard
    active_libs, prefix_dir = _get_ghdl_vhdl_libs_and_prefix_runfiles(ghdl_info, std)
    
    ghdl_lib_info = ctx.attr.entity[GhdlLibraryInfo]
    elaborate_provider = ctx.attr.entity[GhdlElaborateInfo]
    library_name = ghdl_lib_info.library_name
    entity = elaborate_provider.entity
    
    libargs = []
    deps_paths = []
    seen = []
    for name, path in ghdl_lib_info.libraries:
        if name != library_name and name not in seen:
            libargs.append("-P" + path.short_path)
            deps_paths.append(path)
            seen.append(name)
            
    work_library_dir = ghdl_lib_info.library_dir
    
    runfiles = ctx.runfiles(
        files = [work_library_dir] + ctx.files._template + active_libs + deps_paths + [analyzer_x] + ghdl_lib_info.transitive_sources.to_list()
    )
    
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = ctx.outputs.executable,
        substitutions = {
            "{{LIBRARY_NAME}}": library_name,
            "{{ENTITY}}": entity,
            "{{VHDL_STANDARD}}": std,
            "{{GHDL_PREFIX}}": prefix_dir,
            "{{ANALYZER}}": analyzer,
            "{{WORKDIR}}": work_library_dir.short_path,
            "{{LIBRARY_PATHS}}": " ".join(libargs),
            "{{WAVE_FILE}}": "{}.vcd".format(ctx.attr.name),
            "{{EXTRA_ARGS}}": " ".join(ctx.attr.args),
        },
    )
    
    return [
        DefaultInfo(
            runfiles = runfiles,
        )
    ]

_ghdl_internal_test = rule(
    test = True,
    implementation = _ghdl_internal_test_impl,
    attrs = {
        "entity": attr.label(
            providers = [GhdlLibraryInfo, GhdlElaborateInfo],
            doc = "The elaborated entity to test.",
        ),
        "standard": attr.string(
            default = VHDL_STANDARD_DEFAULT,
        ),
        "_template": attr.label(
            default = Label("//ghdl/private:unittest.tpl.sh"),
            allow_single_file = True,
        ),
    },
    toolchains = [
        GHDL_TOOLCHAIN_TYPE,
    ],
)

def ghdl_test(name, srcs, deps = [], standard=VHDL_STANDARD_DEFAULT, args=[], entity=None, entities=[]):
    """
    Defines a GHDL VHDL test target.
    """
    entity_list = []
    if entity:
        entity_list += [entity]
    entity_list += entities

    test_targets = []
    for ent in entity_list:
        vhdl_lib_name = "{name}_{entity}_src_lib".format(name=name, entity=ent)
        vhdl_library(
            name = vhdl_lib_name,
            srcs = srcs,
        )
        
        ghdl_lib_name = "{name}_{entity}_lib".format(name=name, entity=ent)
        ghdl_analyze(
            name = ghdl_lib_name,
            library = ":" + vhdl_lib_name,
            deps = deps,
            standard = standard,
        )
        
        e = "{entity}".format(entity=ent)
        ghdl_elaborate(
            name = e,
            library = ":{}".format(ghdl_lib_name),
            standard = standard,
        )
        test_target_name = "{name}_{entity}_test".format(name=name, entity=ent)
        _ghdl_internal_test(
            name = test_target_name,
            entity = ":{}".format(e),
            args = args,
            standard = standard,
        )
        test_targets.append(":" + test_target_name)

    native.test_suite(
        name = name,
        tests = test_targets,
    )
