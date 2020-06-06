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
path_to_project_root_dir="$path_to_script_dir/.."
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
# cmake -G sets the generator to use
# cmake -D sets a variable in the cmake cache (here I set the build config for the specific makefile that gets created)
# I also set the PREFIX_BUILD_EXTERNAL_TESTS=ON so that all targets in tests/ are built
# https://cmake.org/cmake/help/v3.2/manual/cmake.1.html

echo "BUILDING DEBUG CONFIG..."
mkdir -p build/Debug
cd build/Debug
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../..
echo "COMPILING DEBUG CONFIG..."
# reference: https://unix.stackexchange.com/questions/208568/how-to-determine-the-maximum-number-to-pass-to-make-j-option
# reference: https://unix.stackexchange.com/questions/519092/what-is-the-logic-of-using-nproc-1-in-make-command
# reference: https://stackoverflow.com/questions/15289250/make-j4-or-j8
# reference: https://github.com/memkind/memkind/issues/33
# -j$(($(nproc)+1)) is used to run multiple make jobs in parallel (nproc returns the number of logical processing units/cores)
# note: nproc should be installed by default on most Linux systems (part of coreutils), but macOS users will probably get an error here and should install it
make -j$(($(nproc)+1))
cd ../..

echo "BUILDING MINSIZEREL CONFIG..."
mkdir -p build/MinSizeRel
cd build/MinSizeRel
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=MinSizeRel -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../..
echo "COMPILING MINSIZEREL CONFIG..."
make -j$(($(nproc)+1))
cd ../..

echo "BUILDING RELEASE CONFIG..."
mkdir -p build/Release
cd build/Release
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../..
echo "COMPILING RELEASE CONFIG..."
make -j$(($(nproc)+1))
cd ../..

echo "BUILDING RELWITHDEBINFO CONFIG..."
mkdir -p build/RelWithDebInfo
cd build/RelWithDebInfo
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../..
echo "COMPILING RELWITHDEBINFO CONFIG..."
make -j$(($(nproc)+1))
cd ../..

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
