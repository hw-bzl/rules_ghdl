def get_single_file_from(target):
    """
    Retrieves the single file associated with a target.

    Args:
        target: The target from which to extract the file.

    Returns:
        The single `File` object from the target.
    """
    file_list = target.files.to_list()
    return file_list[0]

def get_ghdl_vhdl_libs_and_prefix(ghdl_info, std):
    """
    Finds the GHDL standard libraries for the given VHDL standard and calculates GHDL_PREFIX.

    Args:
        ghdl_info: GhdlToolchainInfo provider.
        std: The VHDL standard string (e.g. '08').

    Returns:
        A tuple of (active_lib_files, prefix_dir).
    """
    active_lib_files = []
    prefix_dir = ""
    for f in ghdl_info.vhdl_libs:
        if "vhdl_libs_v{}".format(std) in f.path:
            active_lib_files.append(f)
            if f.basename.endswith(".cf"):
                prefix_dir = f.path.rsplit("/", 3)[0]
    return active_lib_files, prefix_dir
