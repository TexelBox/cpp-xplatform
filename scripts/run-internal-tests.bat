@echo off

setlocal

title RUN-INTERNAL-TESTS

:: reference: https://stackoverflow.com/questions/17063947/get-current-batchfile-directory
:: reference: https://stackoverflow.com/questions/18309941/what-does-it-mean-by-command-cd-d-dp0-in-windows
:: handle users running this script from any directory
:: get the path to the directory containing this script
set "path_to_script_dir=%~dp0"
echo PATH TO SCRIPT DIRECTORY = %path_to_script_dir%
set "path_to_project_root_dir=%path_to_script_dir%.."
echo PATH TO PROJECT ROOT DIRECTORY = %path_to_project_root_dir%
:: execute rest of script from project root directory...
:: note: /D allows changing the current drive (if needed)
cd /D %path_to_project_root_dir% || goto error

set "no_pause="
echo args passed in: %*
for %%a in (%*) do (
    if "%%a" == "--no-pause" (set "no_pause=y")
)

:: RUN x86...
echo RUNNING x86 INTERNAL TESTS...
echo RUNNING DEBUG INTERNAL TESTS...
x86\Debug\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error

echo RUNNING MINSIZEREL INTERNAL TESTS...
x86\MinSizeRel\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error

echo RUNNING RELEASE INTERNAL TESTS...
x86\Release\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error

echo RUNNING RELWITHDEBINFO INTERNAL TESTS...
x86\RelWithDebInfo\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error
:: END of running for x86

:: RUN x64...
echo RUNNING x64 INTERNAL TESTS...
echo RUNNING DEBUG INTERNAL TESTS...
x64\Debug\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error

echo RUNNING MINSIZEREL INTERNAL TESTS...
x64\MinSizeRel\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error

echo RUNNING RELEASE INTERNAL TESTS...
x64\Release\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error

echo RUNNING RELWITHDEBINFO INTERNAL TESTS...
x64\RelWithDebInfo\cpp-xplatform.exe --dt-exit=true --dt-no-run=false || goto error
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
