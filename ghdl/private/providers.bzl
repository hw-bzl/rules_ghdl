GhdlToolchainInfo = provider(
    doc = "Information on how to run GHDL for VHDL analysis, elaboration and simulation.",
    fields = {
      "analyzer": "The GHDL executable file.",
      "vhdl_libs": "The standard VHDL libraries for GHDL.",
    }
)

GhdlLibraryInfo = provider(
    doc = "Contains the information about the binary files in a compiled GHDL library.",
    fields = {
        "libraries": "List[(string, File)]: A mapping from a library name to its directory location. Contains both this library and its dependencies, ensuring no duplicate keys.",
        "library_name": "string: The name of the library (e.g., `ieee`, `work`).",
        "library_dir": "File: The container directory where the library is located.",
        "transitive_sources": "depset[File]: All transitive VHDL source files of this library and its dependencies.",
    },
)

GhdlElaborateInfo = provider(
    doc = "Provides information about an elaborated VHDL entity.",
    fields = {
        "entity": "string: The name of the elaborated entity.",
    }
)
