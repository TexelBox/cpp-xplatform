#ifndef PREFIX_COMMON_TEST_H_
#define PREFIX_COMMON_TEST_H_

/// COMMON HEADER OF EXTERNAL-TESTS EXECUTABLE
/// - #include "common.test.h" should be the first include directive inside all external-test implementation (e.g. .test.cpp) files
/// - this file is similar to a pch.h, but is not precompiled

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

#include <doctest/doctest.h>

#endif // PREFIX_COMMON_TEST_H_
