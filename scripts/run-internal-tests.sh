#!/usr/bin/env bash

# reference: https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
# reference: https://pubs.opengroup.org/onlinepubs/009695399/utilities/set.html
# reference: https://www.davidpashley.com/articles/writing-robust-shell-scripts/
# (-e) - fail-fast (exit on first simple-command failure)
# (-u) - fail on attempted expansion of uninitialized variables
# note: &&/|| lists should not be used, cause -e only applies to the last statement in them
# note: -o pipefail would be nice to add, but it is not POSIX
set -eu

no_pause="false"
echo "args passed in: $@"
for arg in "$@"
do
    if [ $arg = "--no-pause" ] ; then
        no_pause="true"
    fi
done

cd ..

echo "BUILDING DEBUG INTERNAL TESTS..."
./build/Debug/cpp-xplatform --dt-exit=true --dt-no-run=false

echo "BUILDING MINSIZEREL INTERNAL TESTS..."
./build/MinSizeRel/cpp-xplatform --dt-exit=true --dt-no-run=false

echo "BUILDING RELEASE INTERNAL TESTS..."
./build/Release/cpp-xplatform --dt-exit=true --dt-no-run=false

echo "BUILDING RELWITHDEBINFO INTERNAL TESTS..."
./build/RelWithDebInfo/cpp-xplatform --dt-exit=true --dt-no-run=false

if [ $no_pause = "false" ] ; then
    read -n1 -r -p "Press any key to continue . . . " key
fi