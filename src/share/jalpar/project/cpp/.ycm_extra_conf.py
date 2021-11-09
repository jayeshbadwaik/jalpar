import os
import ycm_core
import subprocess
import glob

cxxflags = [
    '-Weverything',
    '-Wno-c++98-compat',
    '-Wno-c++98-compat-pedantic',
    '-Wno-covered-switch-default',
    '-Wno-padded',
    '-Wno-weak-vtables',
    '-Wno-exit-time-destructors',
    '-Wno-global-constructors',
    # You 100% do NOT need -DUSE_CLANG_COMPLETER in your flags; only the YCM
    # source code needs it.
    '-DUSE_CLANG_COMPLETER',
    # THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
    # language to use when compiling headers. So it will guess. Badly. So C++
    # headers will be compiled as C headers. You don't want that so ALWAYS specify
    # a "-std=<something>".
    # For a C project, you would set this to something like 'c99' instead of
    # 'c++11'.
    '-std=c++17',
    # ...and the same thing goes for the magic -x option which specifies the
    # language that the files to be compiled are written in. This is mostly
    # relevant for c++ headers.
    # For a C project, you would set this to 'c' instead of 'c++'.
    '-x',
    'c++',
    '-stdlib=libc++',
    '-Isrc/include/',
    '-I../build/src/gencode/vanmake/include/',
    '-Itest/include/'
]

cflags = [
    '-Wextra',
    '-Wall',
    # You 100% do NOT need -DUSE_CLANG_COMPLETER in your flags; only the YCM
    # source code needs it.
    '-DUSE_CLANG_COMPLETER',
    # THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
    # language to use when compiling headers. So it will guess. Badly. So C++
    # headers will be compiled as C headers. You don't want that so ALWAYS specify
    # a "-std=<something>".
    # For a C project, you would set this to something like 'c99' instead of
    # 'c++11'.
    '-std=c11',
    # ...and the same thing goes for the magic -x option which specifies the
    # language that the files to be compiled are written in. This is mostly
    # relevant for c++ headers.
    # For a C project, you would set this to 'c' instead of 'c++'.
    '-x',
    'c',
    '-Isrc/include/',
    '-Itest/include/'
]



SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm', '.ipp']

def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))


def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def GetUnit(filename):
    # Get the Directory Prefix
    prefix = os.path.dirname(filename)
    # Get the Basename
    basename = os.path.basename(filename)
    # Separate Basename into Name and Extension
    baseroot, ext = os.path.splitext(basename)
    if ext == '.ipp':
        # Residue Base Root
        headerroot = baseroot
        # Header File Name
        headerfilename = headerroot + ".hpp"
        # absolute path for header file
        headerfilepath = os.path.join(prefix, headerfilename)
        if os.path.isfile(headerfilepath):
            #Return headerfilepath
            print(headerfilepath)
            return headerfilepath
    return filename


def GetCompilationInfoForFile(filename):
    # The compilation_commands.json file generated by CMake does not have entries
    # for header files. So we do our best by asking the db for flags for a
    # corresponding source file, if any. If one exists, the flags for that file
    # should be good enough.
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(
                    replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)


def Settings(filename, **kwargs):
    relative_to = DirectoryOfThisScript()
    extension = os.path.splitext(filename)[1]
    flags = []
    print(extension)
    if extension == ".c" or extension == ".h" :
        flags = cflags
    else:
        flags = cxxflags
    final_flags = MakeRelativePathsInFlagsAbsolute(flags, relative_to)
    translation_unit = GetUnit(filename)
    return {
        'flags': final_flags
    }
