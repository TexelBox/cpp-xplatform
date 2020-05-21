@echo off

setlocal

title RUN-EXTERNAL-TESTS

set "no_pause="
echo args passed in: %*
for %%a in (%*) do (
    if "%%a" == "--no-pause" (set "no_pause=y")
)

cd .. || goto error

:: RUN x86...
echo RUNNING x86+Debug external tests...
x86\tests\Debug\cpp-xplatform-external-tests.exe || goto error

echo RUNNING x86+MinSizeRel external tests...
x86\tests\MinSizeRel\cpp-xplatform-external-tests.exe || goto error

echo RUNNING x86+Release external tests...
x86\tests\Release\cpp-xplatform-external-tests.exe || goto error

echo RUNNING x86+RelWithDebInfo external tests...
x86\tests\RelWithDebInfo\cpp-xplatform-external-tests.exe || goto error
:: END of running for x86

:: RUN x64...
echo RUNNING x64+Debug external tests...
x64\tests\Debug\cpp-xplatform-external-tests.exe || goto error

echo RUNNING x64+MinSizeRel external tests...
x64\tests\MinSizeRel\cpp-xplatform-external-tests.exe || goto error

echo RUNNING x64+Release external tests...
x64\tests\Release\cpp-xplatform-external-tests.exe || goto error

echo RUNNING x64+RelWithDebInfo external tests...
x64\tests\RelWithDebInfo\cpp-xplatform-external-tests.exe || goto error
:: END of running for x64

:success
:: don't pause if option set (useful for CI to not get hung)
:: stop execution of batch file, until user hits a key
if not defined no_pause (pause)
:: reference: https://ss64.com/nt/endlocal.html
:: note: endlocal will happen implicitly when this script terminates
:: clean-exit (ignore any residual ERRORLEVEL by overriding it with 0)
exit /B 0

:error
echo ERROR
:: don't pause if option set (useful for CI to not get hung)
:: stop execution of batch file, until user hits a key
if not defined no_pause (pause)
:: reference: https://stackoverflow.com/questions/734598/how-do-i-make-a-batch-file-terminate-upon-encountering-an-error
:: reference: https://ss64.com/nt/exit.html
:: using exit /B 1 on specific command failures to fail-fast
:: commands without the conditional are allowed to fail
:: note: lines should only contain single commands to enforce this idiom
exit /B 1
