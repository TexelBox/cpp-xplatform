#ifndef PREFIX_PCH_H_
#define PREFIX_PCH_H_

/// COMMON HEADER OF MAIN EXECUTABLE / LIBRARY
/// - reference: https://stackoverflow.com/questions/54121917/what-is-pch-h-and-why-is-it-needed-to-be-included-as-the-first-header-file
/// - #include "pch.h" must be the first line of code inside all private implementation (e.g. .cpp) files (previous lines get silently ignored)
/// - this file is similar to a common.h, but has the special purpose of precompiled header

// check macros...
// fail compilation if any of these macros is not defined
#ifndef PATH_TO_ASSETS_DIRECTORY
    #error "ERROR: PATH_TO_ASSETS_DIRECTORY macro is not defined! Please make sure your build-system/generator (e.g. CMake) sets it properly."
#endif

#ifndef PATH_TO_BUILD_SYSTEM_DIRECTORY
    #error "ERROR: PATH_TO_BUILD_SYSTEM_DIRECTORY macro is not defined! Please make sure your build-system/generator (e.g. CMake) sets it properly."
#endif

#ifndef PATH_TO_PROJECT_ROOT_DIRECTORY
    #error "ERROR: PATH_TO_PROJECT_ROOT_DIRECTORY macro is not defined! Please make sure your build-system/generator (e.g. CMake) sets it properly."
#endif

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include <doctest/doctest.h>

#include <cpp-xplatform/utils/string-utils.hpp>

#endif // PREFIX_PCH_H_
