#!/usr/bin/env bash
# using the above shebang to be most-portable

echo "test script"
mkdir build
cd build
cmake ..

# pause the script at the end, until user wants to close it (analog to DOS-pause)
# https://stackoverflow.com/questions/92802/what-is-the-linux-equivalent-to-dos-pause
read -n1 -r -p "Press any key to continue . . . " key