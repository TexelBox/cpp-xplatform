#!/usr/bin/env bash

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
echo "args passed in: $@"
for arg in "$@"
do
    if [ $arg = "--no-pause" ] ; then
        no_pause="true"
    fi
done

# RUN x86...
echo "RUNNING x86 EXTERNAL TESTS..."
echo "RUNNING DEBUG EXTERNAL TESTS..."
./build/vs2017/x86/tests/Debug/project-name-external-tests.exe

echo "RUNNING MINSIZEREL EXTERNAL TESTS..."
./build/vs2017/x86/tests/MinSizeRel/project-name-external-tests.exe

echo "RUNNING RELEASE EXTERNAL TESTS..."
./build/vs2017/x86/tests/Release/project-name-external-tests.exe

echo "RUNNING RELWITHDEBINFO EXTERNAL TESTS..."
./build/vs2017/x86/tests/RelWithDebInfo/project-name-external-tests.exe
# END of running for x86

# RUN x64...
echo "RUNNING x64 EXTERNAL TESTS..."
echo "RUNNING DEBUG EXTERNAL TESTS..."
./build/vs2017/x64/tests/Debug/project-name-external-tests.exe

echo "RUNNING MINSIZEREL EXTERNAL TESTS..."
./build/vs2017/x64/tests/MinSizeRel/project-name-external-tests.exe

echo "RUNNING RELEASE EXTERNAL TESTS..."
./build/vs2017/x64/tests/Release/project-name-external-tests.exe

echo "RUNNING RELWITHDEBINFO EXTERNAL TESTS..."
./build/vs2017/x64/tests/RelWithDebInfo/project-name-external-tests.exe
# END of running for x64

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
