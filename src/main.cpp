/// this is the main file that defines the entry point (main()) of our program

// reference: https://stackoverflow.com/questions/54121917/what-is-pch-h-and-why-is-it-needed-to-be-included-as-the-first-header-file
// #include "pch.h" must be the first line of code inside all private implementation (e.g. .cpp) files (previous lines get silently ignored)
//NOTE: pch include is left in explicitly (even if not needed (i.e. force-include compiler option is set)), to...
//      1. ensure intellisense always works (without needing to enable a setting in your editor/IDE... hopefully)
//      2. keep ability of compiling if force-include is disabled
//      3. keep ability of compiling normally (albeit slower with unused dependencies) without precompiled headers enabled
//NOTE: downside is that you need to manually check if precompiled headers support is actually enabled on your compiler (if not, then you'll be compiling slower than normal due to some unused headers for a particular compilation unit)
#include "pch.h"

// reference: https://github.com/onqtam/doctest/blob/master/doc/markdown/configuration.md
// include the implementation of doctest (interface was already included via pch.h's #include <doctest/doctest.h>)
// implement doctest, but we must specify our own main()
// this of course must be done only in a single translation unit (otherwise the linker will die of duplicated symbol errors)
#define DOCTEST_CONFIG_IMPLEMENT
// force doctest cmd-line options to have to be prefixed with "--dt-", thus to not interfere with user-specific option naming (e.g. a common option like --version can now be used without doctest option overriding it)
#define DOCTEST_CONFIG_NO_UNPREFIXED_OPTIONS
#include <doctest/doctest.h>

// forward declarations...
//NOTE: apparently this is the proper way to forward declare namespaced-functions (you can't do "int prefix::program(int argc, char *argv[]);")
namespace prefix {
    int program(int argc, char *argv[]);
}

// test asset-finding using the macro as prefix
// this test-case also illustrates the usage of the macro
DOCTEST_TEST_CASE("internal-test-asset-finding") {
    std::ifstream ifs;
    std::string filePath{PATH_TO_ASSETS_DIRECTORY};
    filePath += "test-files/test-asset-finding.txt";
    ifs.open(filePath);
    DOCTEST_CHECK(ifs);
}

// reference: https://github.com/onqtam/doctest/blob/master/doc/markdown/commandline.md
// reference: https://blog.jetbrains.com/rscpp/better-ways-testing-with-doctest/
// reference: https://github.com/onqtam/doctest/issues/20
// USAGE#1: ./cpp-xplatform (runs just the user-defined program)
// USAGE#2: ./cpp-xplatform --dt-no-run=false (runs internal tests and then runs user-defined program)
// USAGE#3: ./cpp-xplatform --dt-exit=true --dt-no-run=false (runs just the internal tests)
// reminder: argv[0] usually contains the executable name, argv[argc] is always a null pointer
int main(int argc, char *argv[]) {
    doctest::Context ctx;
    // default behaviour (cmd-line options) specify to just run the user-defined program
    // this behaviour can be overriden by explicitly passing in cmd-line options (as shown above by the usage scenarios)
    // don't force exit (i.e. don't force shouldExit() to return true) by default, unless overriden on cmd-line by "--dt-exit=true"
    ctx.setOption("--dt-exit", false);
    // don't run internal tests by default, unless overriden on cmd-line by "--dt-no-run=false"
    ctx.setOption("--dt-no-run", true);
    // have doctest parse options that it recognizes
    ctx.applyCommandLine(argc, argv);
    // run doctest test runner
    //NOTE: run() returns 0 if --dt-no-run=true, otherwise returns either 0 (if all tests succeeded) or 1 (any test failed)
    int const testingResult{ctx.run()};

    // if --dt-exit=true or a query flag was passed in by user, force quit application without running user-defined program
    if (ctx.shouldExit()) return testingResult;

    // run user-defined program...
    int const programResult{prefix::program(argc, argv)};
    return testingResult + programResult;
}

namespace prefix {
    // forward declarations...
    std::vector<std::string> getProgramArgs(int const argc, char const*const argv[]);

    // user-defined program...
    int program(int argc, char *argv[]) {
        // handle cmd-line args/options...
        // ignore doctest options (those prefixed with "--dt-"
        std::vector<std::string> const args{getProgramArgs(argc, argv)};
        // now, do something specific to your program with args...

        // execute the rest of your program...
        std::cout << prefix::utils::trim_copy(" Hello World! ") << std::endl;
        std::cout << "Enter any non-empty string to exit . . . " << std::endl;
        std::string dummy;
        std::cin >> dummy;

        return EXIT_SUCCESS;
    }

    // removes the doctest options and returns only relevant cmd-line args for user-defined program usage
    std::vector<std::string> getProgramArgs(int const argc, char const*const argv[]) {
        std::vector<std::string> args;
        for (unsigned int i{0}; i < argc; ++i) {
            std::string const arg{argv[i]};
            std::string const prefix{arg.substr(0, 5)};
            if ("--dt-" != prefix) args.push_back(arg);
        }
        return args;
    }

    DOCTEST_TEST_CASE("internal-test-example-0") {
        int const ARGC{3};
        char const*const ARGV[ARGC]{"--dt-exit=true", "--dt-no-run=false", "--version"};
        std::vector<std::string> const args{getProgramArgs(ARGC, ARGV)};
        //NOTE: you can't do the below, since its too complex for doctest and must be a binary expression
        //DOCTEST_CHECK(1 == args.size() && "--version" == args.at(0));
        DOCTEST_REQUIRE(1 == args.size());
        DOCTEST_CHECK("--version" == args.at(0));
    }
}
