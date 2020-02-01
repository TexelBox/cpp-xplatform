#include <doctest.h>

#include <cpp-xplatform/utils/string-utils.hpp>

namespace prefix::utils {
    TEST_CASE("external-test-example-0") {
        CHECK("" == trim_copy(""));
        CHECK(rtrim_copy(ltrim_copy("    hello    ")) == trim_copy("    hello    "));
    }
}
