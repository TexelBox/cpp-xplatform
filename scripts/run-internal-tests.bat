@echo off

setlocal

title RUN-INTERNAL-TESTS

set "no_pause="
echo args passed in: %*
for %%a in (%*) do (
    if "%%a" == "--no-pause" (set "no_pause=y")
)

cd ..

:: RUN x86...
echo RUNNING x86+Debug internal tests...
x86\Debug\cpp-xplatform.exe --dt-exit=true --dt-no-run=false

echo RUNNING x86+MinSizeRel internal tests...
x86\MinSizeRel\cpp-xplatform.exe --dt-exit=true --dt-no-run=false

echo RUNNING x86+Release internal tests...
x86\Release\cpp-xplatform.exe --dt-exit=true --dt-no-run=false

echo RUNNING x86+RelWithDebInfo internal tests...
x86\RelWithDebInfo\cpp-xplatform.exe --dt-exit=true --dt-no-run=false
:: END of running for x86

:: RUN x64...
echo RUNNING x64+Debug internal tests...
x64\Debug\cpp-xplatform.exe --dt-exit=true --dt-no-run=false

echo RUNNING x64+MinSizeRel internal tests...
x64\MinSizeRel\cpp-xplatform.exe --dt-exit=true --dt-no-run=false

echo RUNNING x64+Release internal tests...
x64\Release\cpp-xplatform.exe --dt-exit=true --dt-no-run=false

echo RUNNING x64+RelWithDebInfo internal tests...
x64\RelWithDebInfo\cpp-xplatform.exe --dt-exit=true --dt-no-run=false
:: END of running for x64

if defined no_pause (goto after_pause)
pause
:after_pause

endlocal
