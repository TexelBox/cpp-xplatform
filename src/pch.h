#ifndef PREFIX_PCH_H_
#define PREFIX_PCH_H_

// check for support of specific macros...
#if !defined(__has_include)
    #error "ERROR: no __has_include support! Please upgrade to a newer compiler version or try a different compiler."
#endif

#include <algorithm>
#include <cstdlib>

// reference: https://stackoverflow.com/questions/53365538/how-to-determine-whether-to-use-filesystem-or-experimental-filesystem
// reference: https://en.cppreference.com/w/cpp/preprocessor/include
// use whichever version of filesystem is available...
// reference: https://en.cppreference.com/w/cpp/feature_test
//NOTE: the __cpp_lib_filesystem and __cpp_lib_experimental_filesystem checks are probably redundant as they get defined by including the previous header (according to the standard) and will probably be removed
#ifndef USING_FILESYSTEM
    #if __has_include(<filesystem>)
        #include <filesystem>
        #if defined(__cpp_lib_filesystem)
            #define USING_FILESYSTEM 1
        #elif __has_include(<experimental/filesystem>)
            #include <experimental/filesystem>
            #if defined(__cpp_lib_experimental_filesystem)
                #define USING_FILESYSTEM 0
            #endif
        #endif
    #elif __has_include(<experimental/filesystem>)
        #include <experimental/filesystem>
        #if defined(__cpp_lib_experimental_filesystem)
            #define USING_FILESYSTEM 0
        #endif
    #endif

    // declare/define a single alias to access filesystem...
    //WARNING: aliasing std namespaces this way is non-standard (i.e. declaring/defining things inside std may lead to undefined behaviour), but should work on the major compilers
    //NOTE: I will probably change this after I test it on different compilers
    #ifdef USING_FILESYSTEM
        #if USING_FILESYSTEM
            namespace std {
                namespace fs = std::filesystem;
            }
        #else
            namespace std {
                namespace fs = std::experimental::filesystem;
            }
        #endif
    #else
        #error "ERROR: no <filesystem> or <experimental/filesystem> support! Please upgrade to a newer compiler version or try a different compiler."
    #endif
#endif

#include <iostream>
#include <string>
#include <vector>

#include <doctest/doctest.h>

#endif // PREFIX_PCH_H_
