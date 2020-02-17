#!/usr/bin/env bash

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
