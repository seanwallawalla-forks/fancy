# main.fy
# This file gets run directly from bin/fancy.
# It handles any given built-in ARGV options.
# If any .fy source filename is passed in via ARGV, it is loaded and
# executed, otherwise ifancy, Fancy's REPL, gets loaded.

if: (ARGV size == 1) then: {
  ARGV for_options: ["-v", "--version"] do: {
    "Fancy " ++ FANCY_VERSION println
    "(C) 2010, 2011 Christopher Bertels <chris@fancy-lang.org>" println
    System exit
  }

  ARGV for_options: ["--help", "-h"] do: {
    ["Usage: fancy [option] [programfile] [arguments]",
     "  --help                  Print this output",
     "  -h                      Print this output",
     "  --version               Print Fancy's version number",
     "  -v                      Print Fancy's version number",
     "  -I directory            Add directory to Fancy's LOAD_PATH",
     "  -e 'command'            One line of Fancy code that gets evaluated immediately",
     "  -c [filenames]          Compile given files to Rubinius bytecode",
     "  -cv [filenames]         Compile given files to Rubinius bytecode verbosely (outputting the generated bytecode).",
     "",
     "Fancy package management:",
     "  install   [packagename] Install a Fancy package with a given name to $FANCYPACK_DIR",
     "  uninstall [packagename] Uninstall a Fancy package with a given name from $FANCYPACK_DIR"] println
    System exit # quit when running --help
  }
}

ARGV for_option: "-I" do: |path| {
  Fancy CodeLoader push_loadpath: path
}

ARGV for_option: "-e" do: |eval_string| {
  eval_string eval
  System exit # quit when running with -e
}

ARGV for_option: "-c" do: {
  ARGV index: "-c" . if_true: |idx| {
    ARGV[[idx + 1, -1]] each: |filename| {
      "Compiling " ++ filename println
      Fancy Compiler compile_file: filename to: nil line: 1 print: false
    }
  }
  System exit
}

ARGV for_option: "-cv" do: {
  ARGV index: "-cv" . if_true: |idx| {
    ARGV[[idx + 1, -1]] each: |filename| {
      "Compiling " ++ filename println
      Fancy Compiler compile_file: filename to: nil line: 1 print: true
    }
  }
  System exit
}

ARGV for_option: "install" do: |package_name| {
  Fancy Package install: package_name
  System exit
}

ARGV for_option: "uninstall" do: |package_name| {
  Fancy Package uninstall: package_name
  System exit
}

ARGV for_option: "list-packages" do: {
  Fancy Package list_packages
  System exit
}

# push package install dir to load_path
Fancy Package add_to_loadpath

# Load a source file, if any given:
ARGV first if_true: |file| {
  try {
    Fancy CodeLoader load_compiled_file: file
  } catch Fancy Parser ParseError => e {
    e message println
  }
}

ARGV empty? if_true: {
  require: "../bin/ifancy"
}
