#!/usr/bin/env bash
# using the above shebang to be most-portable
# https://stackoverflow.com/questions/10376206/what-is-the-preferred-bash-shebang

# reference: https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
# reference: https://pubs.opengroup.org/onlinepubs/009695399/utilities/set.html
# reference: https://www.davidpashley.com/articles/writing-robust-shell-scripts/
# (-e) - fail-fast (exit on first simple-command failure)
# (-u) - fail on attempted expansion of uninitialized variables
# note: &&/|| lists should not be used, cause -e only applies to the last statement in them
# note: -o pipefail would be nice to add, but it is not POSIX
set -eu

# reference: https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
# handle users running this script from any directory
# get the path to the directory containing this script
# note: this solution is good enough (POSIX + works on multiple interpreters like sh/bash/dash)
# note: there are flaws such as not handling symlinks or newline characters at end of directory names (very rare)
path_to_script_dir="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
echo "PATH TO SCRIPT DIRECTORY = $path_to_script_dir"
path_to_project_root_dir="$path_to_script_dir/../../../.."
echo "PATH TO PROJECT ROOT DIRECTORY = $path_to_project_root_dir"
# execute rest of script from project root directory...
cd "$path_to_project_root_dir"

no_pause="false"

# reference: https://stackoverflow.com/questions/9994295/what-does-mean-in-a-shell-script
# reference: https://unix.stackexchange.com/questions/258341/echo-a-string-with-a-variable-in-it-without-expanding-evaluating-it
# reference: https://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-a-bash-script
# reference: https://stackoverflow.com/questions/9727695/bash-scripting-if-arguments-is-equal-to-this-string-define-a-variable-like-thi
# reference: https://stackoverflow.com/questions/2953646/how-can-i-declare-and-use-boolean-variables-in-a-shell-script
echo "args passed in: $@"
for arg in "$@"
do
    if [ $arg = "--no-pause" ] ; then
        no_pause="true"
    fi
done

# notes:
# mkdir -p creates a nested directory structure
# https://linux.die.net/man/1/mkdir
# && is used to string together commands such that cmd1 && cmd2 will only run cmd2 if cmd1 succeeds
# https://stackoverflow.com/questions/5130847/running-multiple-commands-in-one-line-in-shell

# BUILD x86...
echo "BUILDING ALL CONFIGS FOR x86..."
mkdir -p build/vs2017/x86

# build all the VS2017 stuff (project files, the .sln, etc.)
# -H<source of CMakeLists.txt>
# -B<build directory>
# -G "<generator>"
# -D<variable to set in cmake cache>
# I set the project-name_BUILD_EXTERNAL_TESTS=ON so that all targets in tests/ are built
cmake -H. -Bbuild/vs2017/x86 -G "Visual Studio 15 2017" -Dproject-name_BUILD_EXTERNAL_TESTS=ON

# actually run MSBuild in the build directory to generate all 4 configurations (4 executables)
echo "COMPILING DEBUG CONFIG..."
cmake --build build/vs2017/x86 --config Debug
echo "COMPILING MINSIZEREL CONFIG..."
cmake --build build/vs2017/x86 --config MinSizeRel
echo "COMPILING RELEASE CONFIG..."
cmake --build build/vs2017/x86 --config Release
echo "COMPILING RELWITHDEBINFO CONFIG..."
cmake --build build/vs2017/x86 --config RelWithDebInfo

# END of building for x86

# BUILD x64...
echo "BUILDING ALL CONFIGS FOR x64..."
mkdir -p build/vs2017/x64
cmake -H. -Bbuild/vs2017/x64 -G "Visual Studio 15 2017 Win64" -Dproject-name_BUILD_EXTERNAL_TESTS=ON
echo "COMPILING DEBUG CONFIG..."
cmake --build build/vs2017/x64 --config Debug
echo "COMPILING MINSIZEREL CONFIG..."
cmake --build build/vs2017/x64 --config MinSizeRel
echo "COMPILING RELEASE CONFIG..."
cmake --build build/vs2017/x64 --config Release
echo "COMPILING RELWITHDEBINFO CONFIG..."
cmake --build build/vs2017/x64 --config RelWithDebInfo
# END of building for x64

# reference: https://stackoverflow.com/questions/92802/what-is-the-linux-equivalent-to-dos-pause
# reference: https://unix.stackexchange.com/questions/53036/read-a-single-key-gives-an-error
# reference: https://stackoverflow.com/questions/15744421/read-command-doesnt-wait-for-input
# pause the script at the end (unless --no-pause option is set), until user wants to close it (analog to DOS-pause)
# note: -r is the only POSIX option for read utility, whereas most solutions are bash-only
# reference: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/read.html
if [ $no_pause = "false" ] ; then
    # prompt user
    printf "Press [ENTER] to continue . . . "
    # read raw (-r) input into a dummy variable (_)
    read -r _
fi
