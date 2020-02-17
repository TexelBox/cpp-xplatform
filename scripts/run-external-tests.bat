@echo off

setlocal

title RUN-EXTERNAL-TESTS

set "no_pause="
echo args passed in: %*
for %%a in (%*) do (
    if "%%a" == "--no-pause" (set "no_pause=y")
)

cd ..

:: RUN x86...
echo RUNNING x86+Debug external tests...
x86\tests\Debug\cpp-xplatform-external-tests.exe

echo RUNNING x86+MinSizeRel external tests...
x86\tests\MinSizeRel\cpp-xplatform-external-tests.exe

echo RUNNING x86+Release external tests...
x86\tests\Release\cpp-xplatform-external-tests.exe

echo RUNNING x86+RelWithDebInfo external tests...
x86\tests\RelWithDebInfo\cpp-xplatform-external-tests.exe
:: END of running for x86

:: RUN x64...
echo RUNNING x64+Debug external tests...
x64\tests\Debug\cpp-xplatform-external-tests.exe

echo RUNNING x64+MinSizeRel external tests...
x64\tests\MinSizeRel\cpp-xplatform-external-tests.exe

echo RUNNING x64+Release external tests...
x64\tests\Release\cpp-xplatform-external-tests.exe

echo RUNNING x64+RelWithDebInfo external tests...
x64\tests\RelWithDebInfo\cpp-xplatform-external-tests.exe
:: END of running for x64

if defined no_pause (goto after_pause)
pause
:after_pause

endlocal
