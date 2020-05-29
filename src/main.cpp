//NOTE: pch include is left in explicitly (even if not needed (i.e. force-include compiler option is set)), to...
//      1. ensure intellisense always works (without needing to enable a setting in your editor/IDE... hopefully)
//      2. keep ability of compiling if force-include is disabled
//      3. keep ability of compiling normally (albeit slower with unused dependencies) without precompiled headers enabled
//NOTE: downside is that you need to manually check if precompiled headers support is actually enabled on your compiler (if not, then you'll be compiling slower than normal due to some unused headers for a particular compilation unit)
#include "pch.h"

// reference: https://github.com/onqtam/doctest/blob/master/doc/markdown/configuration.md
// force doctest cmd-line options to have to be prefixed with "--dt-", thus to not interfere with user-specific option naming (e.g. a common option like --version can now be used without doctest option overriding it)
#define DOCTEST_CONFIG_NO_UNPREFIXED_OPTIONS
// implement doctest, but we must specify our own main()
#define DOCTEST_CONFIG_IMPLEMENT
#include <doctest/doctest.h>

#include <cpp-xplatform/utils/string-utils.hpp>

namespace prefix {
    // NAMESPACE GLOBALS...
    //NOTE: these initial values correspond to the relative paths that could be used if the user always ran the executable inside the binary directory (i.e. cwd == binary directory),
    //      this should not be assumed so they will be overwritten properly with absolute paths
    std::string g_pathToAssetsDirectory{"../../assets/"};
    std::string g_pathToBinaryDirectory{""};
    std::string g_pathToProjectRootDirectory{"../../"};

    //NOTE: apparently this is the proper way to forward declare namespaced-functions (you can't do "int prefix::program(int argc, char *argv[]);")
    int program(int argc, char *argv[]);
}

// reference: https://github.com/onqtam/doctest/blob/master/doc/markdown/commandline.md
// reference: https://blog.jetbrains.com/rscpp/better-ways-testing-with-doctest/
// reference: https://github.com/onqtam/doctest/issues/20
// USAGE#1: ./cpp-xplatform (runs just the user-defined program)
// USAGE#2: ./cpp-xplatform --dt-no-run=false (runs internal tests and then runs user-defined program)
// USAGE#3: ./cpp-xplatform --dt-exit=true --dt-no-run=false (runs just the internal tests)
// reminder: argv[0] usually contains the executable name, argv[argc] is always a null pointer
int main(int argc, char *argv[]) {
    // print out macro information...
    #ifdef USING_FILESYSTEM
        #if USING_FILESYSTEM
            std::cout << "USING FILESYSTEM AS std::filesystem" << std::endl;
        #else
            std::cout << "USING FILESYSTEM AS std::experimental::filesystem" << std::endl;
        #endif
    #endif

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
    int const testingResult = ctx.run();

    // if --dt-exit=true or a query flag was passed in by user, force quit application without running user-defined program
    if (ctx.shouldExit()) return testingResult;

    // run user-defined program...
    int const programResult = prefix::program(argc, argv);
    return testingResult + programResult;
}

namespace prefix {
    std::vector<std::string> getProgramArgs(int argc, char *argv[]);

    // user-defined program...
    int program(int argc, char *argv[]) {
        // handle cmd-line args/options...

        // set namespace globals...
        // reference: https://stackoverflow.com/questions/143174/how-do-i-get-the-directory-that-a-program-is-running-from
        // find base paths...
        //NOTE: these aren't given with trailing '\' or '/'
        auto const pathToBinaryDirectoryTemp{std::fs::canonical(std::fs::path(argv[0])).parent_path()};
        auto const pathToProjectRootDirectoryTemp{pathToBinaryDirectoryTemp.parent_path().parent_path()};
        auto const pathToAssetsDirectoryTemp{pathToProjectRootDirectoryTemp / "assets"};
        // append "/" suffix...
        g_pathToBinaryDirectory = pathToBinaryDirectoryTemp.string() + "/";
        g_pathToProjectRootDirectory = pathToProjectRootDirectoryTemp.string() + "/";
        g_pathToAssetsDirectory = pathToAssetsDirectoryTemp.string() + "/";
        // windows paths will be given with the native '\' path separator, so for cleanliness they get replaced with the portable '/'
        std::replace(g_pathToBinaryDirectory.begin(), g_pathToBinaryDirectory.end(), '\\', '/');
        std::replace(g_pathToProjectRootDirectory.begin(), g_pathToProjectRootDirectory.end(), '\\', '/');
        std::replace(g_pathToAssetsDirectory.begin(), g_pathToAssetsDirectory.end(), '\\', '/');
        // print to confirm these paths are accurate...
        std::cout << "PATH TO BINARY DIRECTORY = " << g_pathToBinaryDirectory << std::endl;
        std::cout << "PATH TO PROJECT ROOT DIRECTORY = " << g_pathToProjectRootDirectory << std::endl;
        std::cout << "PATH TO ASSETS DIRECTORY = " << g_pathToAssetsDirectory << std::endl;

        // ignore doctest options (those prefixed with "--dt-"
        std::vector<std::string> const args = getProgramArgs(argc, argv);
        // now, do something specific to your program with args...

        // execute the rest of your program...
        std::cout << prefix::utils::trim_copy(" Hello World! ") << std::endl;
        std::cout << "Enter any non-empty string to exit . . . " << std::endl;
        std::string dummy;
        std::cin >> dummy;

        return EXIT_SUCCESS;
    }

    // removes the doctest options and returns only relevant cmd-line args for user-defined program usage
    std::vector<std::string> getProgramArgs(int argc, char *argv[]) {
        std::vector<std::string> args;
        for (unsigned int i = 0; i < argc; ++i) {
            std::string const nextArg = argv[i];
            std::string const prefix = nextArg.substr(0, 5);
            if ("--dt-" != prefix) args.push_back(nextArg);
        }
        return args;
    }

    TEST_CASE("internal-test-example-0") {
        int const argc = 3;
        char *argv[argc] = {"--dt-exit=true", "--dt-no-run=false", "--version"};
        std::vector<std::string> const args = getProgramArgs(argc, argv);
        //NOTE: you can't do the below, since its too complex for doctest and must be a binary expression
        //CHECK(1 == args.size() && "--version" == args.at(0));
        REQUIRE(1 == args.size());
        CHECK("--version" == args.at(0));
    }
}
