// #include "common.test.h" should be the first include directive inside all external-test implementation (e.g. .test.cpp) files
#include "common.test.h"

// include the implementation file we are testing...
#include <project-name/utils/string-utils.hpp>

namespace project_name::utils {
    DOCTEST_TEST_CASE("external-test-example-0") {
        DOCTEST_CHECK("" == trim_copy(""));
        DOCTEST_CHECK(rtrim_copy(ltrim_copy("    hello    ")) == trim_copy("    hello    "));
    }
}
