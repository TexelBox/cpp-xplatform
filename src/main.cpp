//NOTE: pch include is left in explicitly (even if not needed (i.e. force-include compiler option is set)), to...
//      1. ensure intellisense always works (without needing to enable a setting in your editor/IDE... hopefully)
//      2. keep ability of compiling if force-include is disabled
//      3. keep ability of compiling normally (albeit slower with unused dependencies) without precompiled headers enabled
//NOTE: downside is that you need to manually check if precompiled headers support is actually enabled on your compiler (if not, then you'll be compiling slower than normal due to some unused headers for a particular compilation unit)
#include "pch.h"

#include "utils/string-utils.hpp"

int main() {
    std::cout << prefix::utils::trim_copy(" Hello World! ") << std::endl;

    return 0;
}
