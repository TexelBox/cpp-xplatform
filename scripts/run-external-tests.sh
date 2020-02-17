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

echo "BUILDING DEBUG EXTERNAL TESTS..."
./build/Debug/tests/cpp-xplatform-external-tests

echo "BUILDING MINSIZEREL EXTERNAL TESTS..."
./build/MinSizeRel/tests/cpp-xplatform-external-tests

echo "BUILDING RELEASE EXTERNAL TESTS..."
./build/Release/tests/cpp-xplatform-external-tests

echo "BUILDING RELWITHDEBINFO EXTERNAL TESTS..."
./build/RelWithDebInfo/tests/cpp-xplatform-external-tests

if [ $no_pause = "false" ] ; then
    read -n1 -r -p "Press any key to continue . . . " key
fi
