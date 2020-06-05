/// this is the main file that runs all linked external-tests
/// - these tests can be filtered (see doctest manual for instructions) to only run specific pattern-matched test cases

// reference: https://github.com/onqtam/doctest/blob/master/doc/markdown/configuration.md
// include both the interface and implementation of doctest
// implement doctest, with main() defined for us
// this of course must be done only in a single translation unit (otherwise the linker will die of duplicated symbol errors)
// reference (permalink): https://github.com/onqtam/doctest/blob/503de03ee2cbbfc58c2063dce36dc96f917f2da3/doctest/doctest.h#L5931-L5935
//      #ifdef DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
//      DOCTEST_MSVC_SUPPRESS_WARNING_WITH_PUSH(4007) // 'function' : must be 'attribute' - see issue #182
//      int main(int argc, char** argv) { return doctest::Context(argc, argv).run(); }
//      DOCTEST_MSVC_SUPPRESS_WARNING_POP
//      #endif // DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
//NOTE: this macro must be defined before #include <doctest/doctest.h> (via #include "common.test.h")
#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
// #include "common.test.h" should be the first include directive inside all external-test implementation (e.g. .test.cpp) files
#include "common.test.h"

#include <fstream>
#include <string>

// test asset-finding using the macro as prefix
// this test-case also illustrates the usage of the macro
TEST_CASE("external-test-asset-finding") {
    std::ifstream ifs;
    std::string filePath{PATH_TO_ASSETS_DIRECTORY};
    filePath += "test-files/test-asset-finding.txt";
    ifs.open(filePath);
    CHECK(ifs);
}

namespace prefix {

}
