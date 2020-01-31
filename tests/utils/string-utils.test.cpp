// reference (permalink): https://github.com/onqtam/doctest/blob/503de03ee2cbbfc58c2063dce36dc96f917f2da3/doctest/doctest.h#L5931-L5935
//      #ifdef DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
//      DOCTEST_MSVC_SUPPRESS_WARNING_WITH_PUSH(4007) // 'function' : must be 'attribute' - see issue #182
//      int main(int argc, char** argv) { return doctest::Context(argc, argv).run(); }
//      DOCTEST_MSVC_SUPPRESS_WARNING_POP
//      #endif // DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest.h>

#include <cpp-xplatform/utils/string-utils.hpp>

namespace prefix::utils {
    TEST_CASE("external-test-example-0") {
        CHECK("" == trim_copy(""));
        CHECK(rtrim_copy(ltrim_copy("    hello    ")) == trim_copy("    hello    "));
    }
}
