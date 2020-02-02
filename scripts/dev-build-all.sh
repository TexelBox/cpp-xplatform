#!/usr/bin/env bash
# using the above shebang to be most-portable
# https://stackoverflow.com/questions/10376206/what-is-the-preferred-bash-shebang

# notes:
# mkdir -p creates a nested directory structure
# https://linux.die.net/man/1/mkdir
# && is used to string together commands such that cmd1 && cmd2 will only run cmd2 if cmd1 succeeds
# https://stackoverflow.com/questions/5130847/running-multiple-commands-in-one-line-in-shell
# cmake -G sets the generator to use
# cmake -D sets a variable in the cmake cache (here I set the build config for the specific makefile that gets created)
# I also set the PREFIX_BUILD_EXTERNAL_TESTS=ON so that all targets in tests/ are built
# https://cmake.org/cmake/help/v3.2/manual/cmake.1.html

# execute rest of script from project root directory like it use to
cd ..

echo "BUILDING DEBUG CONFIG..."
mkdir -p build/Debug && cd build/Debug && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../.. && make && cd ../..

echo "BUILDING MINSIZEREL CONFIG..."
mkdir -p build/MinSizeRel && cd build/MinSizeRel && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=MinSizeRel -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../.. && make && cd ../..

echo "BUILDING RELEASE CONFIG..."
mkdir -p build/Release && cd build/Release && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../.. && make && cd ../..

echo "BUILDING RELWITHDEBINFO CONFIG..."
mkdir -p build/RelWithDebInfo && cd build/RelWithDebInfo && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPREFIX_BUILD_EXTERNAL_TESTS=ON ../.. && make && cd ../..

# pause the script at the end, until user wants to close it (analog to DOS-pause)
# https://stackoverflow.com/questions/92802/what-is-the-linux-equivalent-to-dos-pause
read -n1 -r -p "Press any key to continue . . . " key
