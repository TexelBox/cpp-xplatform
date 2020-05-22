:: prevent printing-out the running commands to console
:: note: the '@' causes this command to not print-out as well
@echo off

:: reference: https://superuser.com/questions/316431/temporarily-change-directory-for-single-batch-file-command
:: default batch file behaviour (at least when run by Command Prompt) is to be run/interpreted in parent shell context
:: setlocal/endlocal blocks wrap commands to be run in a local "subshell" context similar to default behaviour of *nix shell scripts
:: this is important for not changing the directory outside of this script context (mostly so AppVeyor doesn't break or have to be written in a more coupled manner)
:: note: setlocal/endlocal doesn't seem to be needed when double-clicking, running w/ PowerShell, running w/ Git Bash (and probably other *nix shells)
setlocal

:: set console title
title DEV-BUILD-ALL

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

:: reference: https://stackoverflow.com/questions/35544871/batchfile-whats-the-best-way-to-declare-and-use-a-boolean-variable
set "no_pause="
:: reference: https://www.robvanderwoude.com/parameters.php
:: note: for command-line options, it would be preferable to use the convention of / as the prefix
:: but, this is problematic since git bash replaces leading / with git paths (for some reason)
:: reference: https://superuser.com/questions/1142397/how-to-run-windows-command-prompt-utilities-options-in-git-bash-how-to-specify
:: reference: https://github.com/bmatzelle/gow/issues/196
:: above links show similar behaviour which can be overcome by using \/ or // to act as one /, but this then is inconsistent with Command Prompt and PowerShell
:: thus, we might as well just use *nix convention of - or -- as the prefix (with added benefit that shell scripts can use the same flags)
:: might as well make options be case-sensitive as well
:: reference: https://stackoverflow.com/questions/28689850/what-does-a-mean-batch
:: reference: https://stackoverflow.com/questions/16144716/what-does-mean-in-a-batch-file
echo args passed in: %*
for %%a in (%*) do (
    if "%%a" == "--no-pause" (set "no_pause=y")
)

:: BUILD x86...
echo BUILDING FOR x86...
:: reference: https://stackoverflow.com/questions/4165387/create-folder-with-batch-but-only-if-it-doesnt-already-exist
if not exist "x86\" (mkdir x86 || goto error)

:: build all the VS2017 stuff (project files, the .sln, etc.)
:: -H<source of CMakeLists.txt>
:: -B<build directory>
:: -G "<generator>"
:: -D<variable to set in cmake cache>
:: I set the PREFIX_BUILD_EXTERNAL_TESTS=ON so that all targets in tests/ are built
cmake -H. -Bx86 -G "Visual Studio 15 2017" -DPREFIX_BUILD_EXTERNAL_TESTS=ON || goto error

:: actually run MSBuild in the x86 build directory to generate all 4 configurations (4 executables)
cmake --build x86 --config Debug || goto error
cmake --build x86 --config MinSizeRel || goto error
cmake --build x86 --config Release || goto error
cmake --build x86 --config RelWithDebInfo || goto error

:: END of building for x86

:: BUILD x64...
echo BUILDING FOR x64...
if not exist "x64\" (mkdir x64 || goto error)
cmake -H. -Bx64 -G "Visual Studio 15 2017 Win64" -DPREFIX_BUILD_EXTERNAL_TESTS=ON || goto error
cmake --build x64 --config Debug || goto error
cmake --build x64 --config MinSizeRel || goto error
cmake --build x64 --config Release || goto error
cmake --build x64 --config RelWithDebInfo || goto error
:: END of building for x64

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
