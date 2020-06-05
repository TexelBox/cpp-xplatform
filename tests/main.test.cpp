//NOTE: this is the main file that runs all linked external tests, which can be filtered (see doctest manual for instructions) to only run specific pattern matched test cases
// reference (permalink): https://github.com/onqtam/doctest/blob/503de03ee2cbbfc58c2063dce36dc96f917f2da3/doctest/doctest.h#L5931-L5935
//      #ifdef DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
//      DOCTEST_MSVC_SUPPRESS_WARNING_WITH_PUSH(4007) // 'function' : must be 'attribute' - see issue #182
//      int main(int argc, char** argv) { return doctest::Context(argc, argv).run(); }
//      DOCTEST_MSVC_SUPPRESS_WARNING_POP
//      #endif // DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest/doctest.h>

#include <fstream>
#include <string>

// fail compilation if these macros are undefined
// also test asset-finding using the macro as prefix
// this test-case also illustrates the usage of the macro
#ifdef PATH_TO_ASSETS_DIRECTORY
    #ifdef PATH_TO_BUILD_SYSTEM_DIRECTORY
        #ifdef PATH_TO_PROJECT_ROOT_DIRECTORY
            TEST_CASE("external-test-macros-and-asset-finding") {
                std::ifstream ifs;
                std::string filePath{PATH_TO_ASSETS_DIRECTORY};
                filePath += "test-files/test-asset-finding.txt";
                ifs.open(filePath);
                CHECK(ifs);
            }
        #else
            #error "ERROR: PATH_TO_PROJECT_ROOT_DIRECTORY macro is not defined! Please make sure your build-system/generator (e.g. CMake) sets it properly."
        #endif
    #else
        #error "ERROR: PATH_TO_BUILD_SYSTEM_DIRECTORY macro is not defined! Please make sure your build-system/generator (e.g. CMake) sets it properly."
    #endif
#else
    #error "ERROR: PATH_TO_ASSETS_DIRECTORY macro is not defined! Please make sure your build-system/generator (e.g. CMake) sets it properly."
#endif

namespace prefix {

}
