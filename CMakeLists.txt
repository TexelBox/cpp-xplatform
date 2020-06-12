# v3.2 is the largest required cmake minimum version for my dependencies
# if the user is using a lower-version cmake, then they will receive a more instructive message (fail-early rather than continuing processing/generation and getting to an unsupported feature somewhere down the list)
# https://stackoverflow.com/questions/35550116/which-cmake-version-as-the-minimum
# v3.10 required for C++17 MSVC fix
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# reference: https://cmake.org/cmake/help/v3.0/policy/CMP0025.html#policy:CMP0025
if(POLICY CMP0025)
    # compiler id for AppleClang is now 'AppleClang' rather than OLD (default) policy of 'Clang'
    cmake_policy(SET CMP0025 NEW)
endif()

# notably sets the PROJECT_NAME variable, C/CXX as default build-languages, but i'll overwrite it to just target CXX
# https://cmake.org/cmake/help/latest/command/project.html
# note: including 'C' as a language is necessary to prevent some "CMAKE MISSING INTERNAL VARIABLES ERRORS" that can occur (has happened on Linux before)
# reference: https://github.com/google/iree/issues/229
project(cpp-xplatform LANGUAGES CXX C)

# reference: https://cmake.org/cmake/help/v3.16/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html
# generates a 'compile_commands.json' for each config that contains compile information for all translation units
# this allows some tools to function better (e.g. VS Code can now detect a compile_commands.json, reference it in a .vscode/c_cpp_properties.json and allow the IntelliSense to find missing compile information such as compile-definitions / macros)
# implemented by 'Makefile Generators' and 'Ninja', ignored otherwise
# WARNING: this may conflict with unity builds
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# note: if ccache is installed as a wrapper around the compiler, it must have its SLOPPINESS config setting set (ENV vars are the highest priority scope way of doing this)
# otherwise, cotire will complain and not generate the precompiled header (.pch/.gch), but it does issue this way of fixing it (thankfully!)
if(${CMAKE_HOST_SYSTEM_NAME} MATCHES "Darwin" OR ${CMAKE_HOST_SYSTEM_NAME} MATCHES "Linux")
    message(STATUS "HOST SYSTEM NAME is Darwin or Linux. Searching for (optional) ccache...")
    find_program(CCACHE_PROGRAM ccache)
    if(CCACHE_PROGRAM)
        message(STATUS "ccache found! Setting ENV variable (CCACHE_SLOPPINESS) so that cotire can build .pch/.gch")
        # reference: https://ccache.dev/manual/latest.html#_configuration_settings
        set(ENV{CCACHE_SLOPPINESS} "pch_defines,time_macros")
    else()
        message(STATUS "ccache not found! Nothing changes.")
    endif()
endif()

# use C++17 features (globally, for all subsequent targets)
# https://crascit.com/2015/03/28/enabling-cxx11-in-cmake/
# https://stackoverflow.com/questions/44960715/how-to-enable-stdc17-in-vs2017-with-cmake
set(CMAKE_CXX_STANDARD 17) # C++17 MSVC fix in CMake 3.10
set(CMAKE_CXX_STANDARD_REQUIRED ON) # prevent default fallback to an older standard if compiler doesn't support C++17
set(CMAKE_CXX_EXTENSIONS OFF) # only use the official standards (e.g. for g++, -std=c++17 and not -std=gnu++17)

# add cmake/ directory to PATH variable where CMake looks for modules (.cmake files)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# add path to cotire module
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/deps/cotire/CMake")
# searches module path for a 'cotire.cmake' and includes its defined macros
include(cotire)

# https://docs.microsoft.com/en-us/cpp/build/reference/md-mt-ld-use-run-time-library?view=vs-2019
# https://stackoverflow.com/questions/14172856/compile-with-mt-instead-of-md-using-cmake
# https://stackoverflow.com/questions/20800166/cmake-compile-with-mt-instead-of-md
# https://stackoverflow.com/questions/31037882/whats-the-cmake-syntax-to-set-and-use-variables
# https://cmake.org/cmake/help/v3.0/command/set.html
# for MSVC, switch to multi-threaded static linking of MSVCRT runtime library
if(MSVC)
    # init CompilerFlags variable as a list of these terms found in the cmake cache file
    set(CompilerFlags
        CMAKE_CXX_FLAGS
        CMAKE_CXX_FLAGS_DEBUG
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
    )
    # check each of these cache entries and replace any /MD with /MT and /MDd with /MTd
    # note: since these variables are already in the cache, the pattern set(... CACHE ... FORCE) must be used to overwrite it
    foreach(CompilerFlag ${CompilerFlags})
        if(${CompilerFlag} MATCHES "/MD")
            string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
            set(${CompilerFlag} "${${CompilerFlag}}" CACHE STRING "msvc compiler flags" FORCE)
        endif()
        if(${CompilerFlag} MATCHES "/MDd")
            string(REPLACE "/MDd" "/MTd" ${CompilerFlag} "${${CompilerFlag}}")
            set(${CompilerFlag} "${${CompilerFlag}}" CACHE STRING "msvc compiler flags" FORCE)
        endif()
    endforeach()
endif()

# reference: https://stackoverflow.com/questions/35411489/add-all-files-under-a-folder-to-a-cmake-glob
# reference: https://stackoverflow.com/questions/7533502/how-can-i-merge-multiple-lists-of-files-together-with-cmake
# reference: https://stackoverflow.com/questions/15550777/how-do-i-exclude-a-single-file-from-a-cmake-fileglob-pattern
# note: headers aren't explicitly needed to be specified here to the target since they will be found anyway, but it's convenient to include them since it allows IDEs to see them
# reference: https://cmake.org/cmake/help/v3.0/command/file.html
# reference: https://stackoverflow.com/questions/1027247/is-it-better-to-specify-source-files-with-glob-or-each-file-individually-in-cmak/18538444
# VERY IMPORTANT note: globbing source files is not recommended by cmake since your build system won't be able to detect a change to this file's timestamp when a new source file is added
# thus, your build system won't automatically regenerate to recognize the new file
# this is especially problematic if you are working with other devs and pull down their changes (where they added new files), resulting in unintuitive build errors
# the fix for this is to manually run "touch CMakeLists.txt" to update the timestamp yourself after you create new source files or after you pull down changes from other devs (if they added new files)
# MY RATIONALE FOR DOING IT THIS WAY RATHER THAN MANUALLY LISTING ALL SOURCE FILES...
# 1. it seems like the most "automatic" way of working, albeit not 100% automatic (only problem is to remember to run touch utility)
# 2. the file name exists only in 1 place (on disk), so renaming/deleting a file won't have to also be done in this script
# 3. way shorter cmake script, especially for many source file projects
# 4. in both ways, you have to do something manually, and I feel a "touch" is easier than writing a bunch of filenames here in this script
# 5. globbing could result in false positives, but these could be rare and can be fixed with REMOVE_ITEM or partial manual listing
# note: apparently cmake 3.12 added a CONFIGURE_DEPENDS option that reruns cmake when glob value changes, but this seems like it could be problematic with different generators and could slow down the build pipeline a bit
file(GLOB_RECURSE PREFIX_SOURCE_FILES_IN_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cxx" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c++" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hh" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h++")
list(REMOVE_ITEM PREFIX_SOURCE_FILES_IN_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/pch.cpp")
file(GLOB_RECURSE PREFIX_SOURCE_FILES_IN_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.cc" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.cxx" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.c++" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.hh" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.hpp" "${CMAKE_CURRENT_SOURCE_DIR}/include/cpp-xplatform/*.h++")
# note: according to cotire manual, the pch.cpp file must be the first listed source file for out target
# reference: https://github.com/sakra/cotire/blob/master/MANUAL.md#using-a-manually-maintained-prefix-header-instead-of-the-automatically-generated-one
# note: you will also have to add paths to any dependency sources only when they are required to be built directly with your files
list(APPEND PREFIX_ALL_SOURCE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/src/pch.cpp" ${PREFIX_SOURCE_FILES_IN_SRC_DIR} ${PREFIX_SOURCE_FILES_IN_INCLUDE_DIR})
message(STATUS "main target source files = ${PREFIX_ALL_SOURCE_FILES}")
# adds an executable target called <cpp-xplatform> to be built from the source files listed
# the source files can be removed from here and specified later using target_sources()
# https://cmake.org/cmake/help/latest/command/add_executable.html
# warning: use CMAKE_CURRENT_SOURCE_DIR rather than CMAKE_SOURCE_DIR since the the latter points to the src directory of the parent project. So, if my project is a sub-project of another then mine won't build
# https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/issues/1428
add_executable(cpp-xplatform ${PREFIX_ALL_SOURCE_FILES})

# reference: https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/
# SCOPE SPECIFIERS...
# PRVATE - for internal building of target
# INTERFACE - for external users (usage requirements) of target
# PUBLIC = both PRIVATE and INTERFACE
# thus the include/ directory is PUBLIC since it is needed for both internally building target and external users to possess
# and src/ is PRIVATE since only private headers reside here and are only needed for internal building
# note: it seems like include paths must be absolute, except for INSTALL_INTERFACE which allows relative paths (also BUILD_INTERFACE paths can't be quoted without error (for a reason unknown to me))
# reference: https://cmake.org/cmake/help/v3.2/prop_tgt/INTERFACE_INCLUDE_DIRECTORIES.html
target_include_directories(cpp-xplatform
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/deps/doctest"
)

# set the path macros that can be used inside the program (e.g. for finding assets)
# this is useful since it allows finding assets with absolute paths (thus the CWD when running the executable doesn't matter)
# the downside is that if these paths were to change on disk, the program would fail and a CMake rebuild is required to update the macros
# note: CMake path macros are absolute paths that use '/' as the path separator regardless of platform and don't have a trailing '/'
# note: the paths are surrounded with quotes in order for the macros to be passed in as strings (and thus not have to be stringified through another macro in the code)
# WARNING: if a CMake error ever occurs due to the quotes, you can fix this by consulting this issue...
# reference: https://github.com/LLNL/lbann/issues/117
set(PATH_TO_ASSETS_DIRECTORY "\"${CMAKE_CURRENT_SOURCE_DIR}/assets/\"")
# e.g. the path to the directory containing the .vcxproj for Visual Studio generator, or the directory containing the Makefile for Unix Makefiles generator
set(PATH_TO_BUILD_SYSTEM_DIRECTORY "\"${CMAKE_CURRENT_BINARY_DIR}/\"")
set(PATH_TO_PROJECT_ROOT_DIRECTORY "\"${CMAKE_CURRENT_SOURCE_DIR}/\"")

message(STATUS "WARNING: these paths are constant from the latest CMake build.\n
                They may be used as macros inside the program (e.g. for finding assets).\n
                Thus, a CMake rebuild is needed if the paths on disk have changed (e.g. renaming a directory in the chain, moving the project, etc.).\n"
)
message(STATUS "setting macros for paths...\n
                PATH_TO_ASSETS_DIRECTORY = ${PATH_TO_ASSETS_DIRECTORY}\n
                PATH_TO_BUILD_SYSTEM_DIRECTORY = ${PATH_TO_BUILD_SYSTEM_DIRECTORY}\n
                PATH_TO_PROJECT_ROOT_DIRECTORY = ${PATH_TO_PROJECT_ROOT_DIRECTORY}\n"
)

# set universal compile-definitions / macros...
# reference: https://github.com/onqtam/doctest/blob/master/doc/markdown/configuration.md
# globally defining DOCTEST_CONFIG_NO_SHORT_MACRO_NAMES forces the use of prefixed macros (safer)
# globally defining DOCTEST_CONFIG_USE_STD_HEADERS is required to make our application compliant to C++ standards
# it forces doctest to include the relevant std headers (notably std::ostream) rather than using doctest's custom forward declarations
# the downside is that compilation will be slower (hopefully minimized by pch usage though)
# the main reason why i'm defining this though is that it seems to fix macOS build failures due to a weird bug, that I don't fully understand...
# the following links contain some discussion about it...
# note: it might be better to only define this on macOS/AppleClang, but i'm not sure the actual bug cause, so I define it universally to be consistent/safe
# reference: https://github.com/onqtam/doctest/issues/126
# TODO: the above link might suggest that other definitions are needed (to fix other linker errors) like DOCTEST_CONFIG_ASSERTION_PARAMETERS_BY_VALUE, but I will only add those if needed frequently or for good reason
# reference: https://github.com/onqtam/doctest/issues/183
target_compile_definitions(cpp-xplatform PRIVATE DOCTEST_CONFIG_NO_SHORT_MACRO_NAMES DOCTEST_CONFIG_USE_STD_HEADERS PATH_TO_ASSETS_DIRECTORY=${PATH_TO_ASSETS_DIRECTORY} PATH_TO_BUILD_SYSTEM_DIRECTORY=${PATH_TO_BUILD_SYSTEM_DIRECTORY} PATH_TO_PROJECT_ROOT_DIRECTORY=${PATH_TO_PROJECT_ROOT_DIRECTORY})

# https://foonathan.net/blog/2018/10/17/cmake-warnings.html
# set the warning flags for the respective compilers using cmake generator expressions
# (removed, since this causes build nightmares when using warning-heavy libs) using -Werror and /WX to treat warnings as compile errors (ensures warnings get either fixed or suppressed right away rather than getting hidden in files that never get compiled again)
# using -Wall + -Wextra and /W4 to provide a sufficient amount of general warnings
# note: /Wall on MSVC is practically unusable due to the enormous amount of warnings generated by the standard library
# note: if additional warning flags are to be added, I believe the project would have to be clean-rebuilt to apply the new warning detection to previously compiled files
# note: for some reason, the cmakecache file doesn't reflect these changes (e.g. still says default of /W3), but they seem to still apply correctly
# DEPRECATED (cotire doesn't work well will some generator expressions, like the ones below...)
#target_compile_options(cpp-xplatform PRIVATE
#    $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
#        -Wall -Wextra>
#        # opt. could add -Werror (if your libs don't throw so many warnings or you have good warning policy handling)
#    $<$<CXX_COMPILER_ID:MSVC>:
#        /W4>
#        # opt. could add /WX (if your libs don't throw so many warnings or you have good warning policy handling)
#)

# reference: https://stackoverflow.com/questions/10046114/in-cmake-how-can-i-test-if-the-compiler-is-clang
if(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(cpp-xplatform PRIVATE -Wall -Wextra)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # reference: https://devblogs.microsoft.com/cppblog/recommendations-to-speed-c-builds-in-visual-studio/
    # reference: https://docs.microsoft.com/en-us/cpp/build/reference/mp-build-with-multiple-processes?view=vs-2019
    # /MP is used for parallel compilation (automatically figures out number of effective processors on your system)
    # note: /MP is incompatible with some compilation options, but they seem to have lesser value
    target_compile_options(cpp-xplatform PRIVATE /MP /W4)
endif()

# reference: https://stackoverflow.com/questions/26836361/check-if-generating-a-visual-studio-solution-or-makefile-from-cmake
if(CMAKE_GENERATOR MATCHES "Visual Studio")
    # reference: https://stackoverflow.com/questions/7304625/how-do-i-change-the-startup-project-of-a-visual-studio-solution-via-cmake
    # sets the startup project in the Visual Studio solution (so that user doesn't have to explicitly right click target and set option)
    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY VS_STARTUP_PROJECT cpp-xplatform)

    # reference: https://stackoverflow.com/questions/23950887/does-cmake-offer-a-method-to-set-the-working-directory-for-a-given-build-system
    # reference: https://stackoverflow.com/questions/55713475/correct-use-of-vs-debugger-working-directory-etc
    # sets the working directory root for all relative paths (e.g. for asset referencing) when running in Visual Studio
    # by setting this to the same directory as where the executable is built, the program can be run either directly with the .exe or in VS
    set_property(TARGET cpp-xplatform PROPERTY VS_DEBUGGER_WORKING_DIRECTORY "$<TARGET_FILE_DIR:cpp-xplatform>")
endif()

# cotire stuff (must go below target (cpp-xplatform) configuration above)
# disable automatic UNITY (JUMBO) builds
set_target_properties(cpp-xplatform PROPERTIES COTIRE_ADD_UNITY_BUILD FALSE)
# enable manual prefix header that we must maintain, rather than the automatic one generated by cotire
set_target_properties(cpp-xplatform PROPERTIES COTIRE_CXX_PREFIX_HEADER_INIT "${CMAKE_CURRENT_SOURCE_DIR}/src/pch.h")
# must call this after setting all target properties of cpp-xplatform
# apply cotire function on our target
cotire(cpp-xplatform)

if(NOT DEFINED PREFIX_BUILD_EXTERNAL_TESTS)
    message(STATUS "(default) - setting PREFIX_BUILD_EXTERNAL_TESTS=OFF")
    set(PREFIX_BUILD_EXTERNAL_TESTS OFF)
endif()

if(PREFIX_BUILD_EXTERNAL_TESTS)
    message(STATUS "Building external tests...")
    add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/tests")
endif()
