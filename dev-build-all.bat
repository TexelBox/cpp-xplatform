:: prevent printing-out the running commands to console
:: note: the '@' causes this command to not print-out as well
@echo off

:: set console title
title DEV-BUILD-ALL

:: BUILD x86...
echo BUILDING FOR x86...
:: note: if x86 directory already exists then it will just echo an error and the batch file will continue executing
mkdir x86

:: build all the VS2017 stuff (project files, the .sln, etc.)
:: -H<source of CMakeLists.txt>
:: -B<build directory>
:: -G "<generator>"
cmake -H. -Bx86 -G "Visual Studio 15 2017"

:: actually run MSBuild in the x86 build directory to generate all 4 configurations (4 executables)
cmake --build x86 --config Debug
cmake --build x86 --config MinSizeRel
cmake --build x86 --config Release
cmake --build x86 --config RelWithDebInfo

:: END of building for x86

:: BUILD x64...
echo BUILDING FOR x64...
mkdir x64
cmake -H. -Bx64 -G "Visual Studio 15 2017 Win64"
cmake --build x64 --config Debug
cmake --build x64 --config MinSizeRel
cmake --build x64 --config Release
cmake --build x64 --config RelWithDebInfo
:: END of building for x64

:: stop execution of batch file, until user hits a key
pause
