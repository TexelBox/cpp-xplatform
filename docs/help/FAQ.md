# FREQUENTLY ASKED QUESTIONS & OTHER USEFUL TIPS/REMINDERS

- **[HOW DO I ADD A NEW GIT SUBMODULE?](#how-do-i-add-a-new-git-submodule)**
- **[HOW DO I ADD TESTS?](#how-do-i-add-tests)**
- **[HOW DO I GET CMAKE TO RECOGNIZE AN ADDED/RENAMED/DELETED FILE?](#how-do-i-get-cmake-to-recognize-an-addedrenameddeleted-file)**
- **[HOW DO I INITIALIZE/UPDATE ALL GIT SUBMODULES RECURSIVELY?](#how-do-i-initializeupdate-all-git-submodules-recursively)**
- **[HOW DO I SKIP CONTINUOUS INTEGRATION ON THE NEXT COMMIT?](#how-do-i-skip-continuous-integration-on-the-next-commit)**
- **[HOW DO I STAGE A NEW SHELL SCRIPT WITH EXECUTABLE PERMISSION?](#how-do-i-stage-a-new-shell-script-with-executable-permission)**
- **[HOW DO I UPGRADE GIT SUBMODULES TO THEIR LATEST COMMITS?](#how-do-i-upgrade-git-submodules-to-their-latest-commits)**
- **[HOW DO I VIEW THE ENTIRE PROJECT DIRECTORY STRUCTURE IN VISUAL STUDIO?](#how-do-i-view-the-entire-project-directory-structure-in-visual-studio)**
- **[I JUST ADDED A NEW GIT SUBMODULE THAT USES GIT SUBMODULES ITSELF. WHY ARE THEY MISSING AND HOW DO I FIX THIS?](#i-just-added-a-new-git-submodule-that-uses-git-submodules-itself-why-are-they-missing-and-how-do-i-fix-this)**
- **[SOURCE CODE FILE TEMPLATE (PRIVATE)](#source-code-file-template-private)**
- **[WHAT ARE pch.h AND pch.cpp / WHAT ARE PRECOMPILED HEADERS (PCH)?](#what-are-pchh-and-pchcpp--what-are-precompiled-headers-pch)**
- **[WHAT IS .appveyor.yml?](#what-is-appveyoryml)**
- **[WHAT IS .editorconfig?](#what-is-editorconfig)**
- **[WHAT IS .gitattributes?](#what-is-gitattributes)**
- **[WHAT IS .gitignore?](#what-is-gitignore)**
- **[WHAT IS .gitmodules?](#what-is-gitmodules)**
- **[WHAT IS .travis.yml?](#what-is-travisyml)**
- **[WHAT IS CMakeLists.txt?](#what-is-cmakeliststxt)**

---

#### HOW DO I ADD A NEW GIT SUBMODULE?
1. Copy the URL of the dependency's repository.
2. From the project root directory, execute...
```
git submodule add -b <branch> <url> <path>
```
where `<branch>` is the branch name of the dependency repository to clone from (usually `master`), `<url>` is obviously the URL copied in step 1 and `<path>` is the path to a new directory that will act as the root directory for the clone. For example...
```
git submodule add -b master https://github.com/onqtam/doctest deps/doctest
```
will clone the latest master branch commit of the doctest repository into the deps/doctest directory that gets created.

**NOTE: this will populate `.gitmodules` with a new entry with hard-tab indentation. If you wish to enforce soft-tab (space) indentation, you may edit the file directly, restage, and commit/push as usual.**

#### HOW DO I ADD TESTS?
- Tests are separated into two categories: internal tests and external tests. In other testing frameworks, test code is usually written in other files external to the source code being tested. Doctest still allows this external paradigm. External test code should be placed in the `tests/` directory under the extension `.test.cpp` and should mainly focus on testing public headers inside the `include/project-name/` directory, but could also be used conventionally to test code inside `src/`.
- Internal tests: The main power of doctest is the convenience of being able to write fast/lightweight test code inside the same file being tested. This should be prioritized over writing external tests for private source code inside `src/` and completely avoided for public code (i.e. test code should not be exposed to public users). Writing the test cases next to the implementation is useful since it allows for easier test-driven development (TDD) and serves as a form of documentation.

#### HOW DO I GET CMAKE TO RECOGNIZE AN ADDED/RENAMED/DELETED FILE?
**NOTE: this section is very important if working in a team!**
- Both the main CMakeLists.txt and tests/CMakeLists.txt use recursive file globbing to gather all source files with standard extensions in the src/ and include/project-name/ directories or tests/ directory respectively. All of these files will be sent to the compiler.

**NOTE: headers aren't explicitly needed to be specified in the glob to the target since they will be found anyway through the `#include` preprocessor directives, but it's convenient to include them anyway since it allows IDEs to list them in their explorers.**
- The benefit of globbing is that developers don't have to modify the CMakeLists.txt everytime they modify a file (add, rename, or delete). The downside is that the timestamp of whichever CMakeLists.txt never gets changed and thus CMake cannot automatically trigger a rebuild of the build system. This can lead to confusing compiler errors, especially when you pull changes from the remote repository (e.g. another developer added a new file).
- The solution to this is fairly simple. Just update the timestamp of the respective CMakeLists.txt with...
```
touch CMakeLists.txt
```
which triggers a CMake rebuild the next time you open up your IDE (e.g. Visual Studio will issue a message about reloading the solution) or run `make`. After the touch, you can also rebuild all configs by executing the respective build script in scripts/.

#### HOW DO I INITIALIZE/UPDATE ALL GIT SUBMODULES RECURSIVELY?
```
git submodule update --init --recursive
```

#### HOW DO I SKIP CONTINUOUS INTEGRATION ON THE NEXT COMMIT?
- Skip all...
```
git commit -m "[skip ci] message"
```
- Skip AppVeyor only...
```
git commit -m "[skip appveyor] message"
```
- Skip Travis CI only...
```
git commit -m "[skip travis] message"
```

#### HOW DO I STAGE A NEW SHELL SCRIPT WITH EXECUTABLE PERMISSION?
- If the file is untracked, stage for the first time with...
```
git add --chmod=+x <path/to/script>
```
- If the file is already tracked, you can update the permission with...
```
git update-index --chmod=+x <path/to/script>
```

#### HOW DO I UPGRADE GIT SUBMODULES TO THEIR LATEST COMMITS?
- Upgrade one...
```
cd deps/<submodule root>
git checkout <submodule branch>
git pull
cd ../..
git commit -am "upgraded <submodule> to latest commit"
git push origin <branch>
```
- Upgrade all...
```
git submodule update --remote --merge
git commit -am "upgraded all submodules to latest commits"
git push origin <branch>
```
**NOTE: maintainers of template repositories should keep an eye on new releases of dependencies and upgrade frequently to stable versions.**

#### HOW DO I VIEW THE ENTIRE PROJECT DIRECTORY STRUCTURE IN VISUAL STUDIO?
- By default, a CMake generated solution will be opened in 'solution/filters view'. You can click the folder/swap icon at the top of the solution explorer (`Solution Explorer -> Solutions and Folders`) to toggle into 'folder view'. The downside of this action is that the built-in CMake extension might trigger a completely separate build somewhere else on disk (e.g. a Ninja build inside C:\Users\Username\CMakeBuilds\). There might be a solution to fix this, but I simply ignore it.

#### I JUST ADDED A NEW GIT SUBMODULE THAT USES GIT SUBMODULES ITSELF. WHY ARE THEY MISSING AND HOW DO I FIX THIS?
- After adding a new submodule, it seems like recursive submodules simply exist as commit references and still require initialization/updating to be cloned properly. Fix this by running...
```
git submodule update --init --recursive
```

#### SOURCE CODE FILE TEMPLATE (PRIVATE)
- e.g. src/n0/temp.h
```cpp
// UNIQUE INCLUDE-GUARD (ifndef/define pair)
#ifndef PROJECT_NAME_N0_TEMP_H_
#define PROJECT_NAME_N0_TEMP_H_
// FULL LICENSE TEXT OR SHORTER NOTICE (e.g. MIT, BSD-3, GPLv3, DUAL/CUSTOM, etc.)
/// FILE INFO/DESCRIPTION
// ANY INCLUDES
#include "foo.h"
// ANY FORWARD DECLARATIONS
namespace project_name {
    class Bar;
}
// NAMESPACE STATEMENT (BEGIN)
namespace project_name::n0 {
// DECLARATIONS (CLASSES, STRUCTS, etc.)
    class Temp {
        public:
            // static member function
            inline static unsigned int Count() { return s_count; }

            // constructor
            explicit Temp(Foo const& f);
            // destructor
            ~Temp();
        private:
            // static member
            inline static unsigned int s_count{0};

            // non-static members
            std::unique_ptr<project_name::Bar> m_b{nullptr};
            Foo m_f;
    };
// NAMESPACE STATEMENT (END)
}
// UNIQUE INCLUDE-GUARD (endif)
#endif // PROJECT_NAME_N0_TEMP_H_
```
- e.g. src/n0/temp.cpp
```cpp
// #include "pch.h" must be the first line of code (previous lines get silently ignored)
#include "pch.h"
// include the matching header
#include "temp.h"
// FULL LICENSE TEXT OR SHORTER NOTICE (e.g. MIT, BSD-3, GPLv3, DUAL/CUSTOM, etc.)
/// FILE INFO/DESCRIPTION
// ANY INCLUDES
#include "bar.h"
// ANY FORWARD DECLARATIONS
// NAMESPACE STATEMENT (BEGIN)
namespace project_name::n0 {
// DEFINITIONS (CLASSES, STRUCTS, etc.)
    Temp::Temp(Foo const& f)
        : m_f{f}
    {
        m_b = std::make_unique<project_name::Bar>(f);
        ++s_count;
    }

    Temp::~Temp() { --s_count; }
// ANY INTERNAL TESTS
// NAMESPACE STATEMENT (END)
}
```

#### WHAT ARE pch.h AND pch.cpp / WHAT ARE PRECOMPILED HEADERS (PCH)?
- C++ is notorious for its slow compilation speeds. Precompiled headers are a technique for speeding up overall compilation by caching an intermediate binary file called the procompiled header that gets compiled once and then simply passed to the linker whenever the main program must recompile.
- `pch.h` should include all headers that never (or rarely) change (e.g. system headers, dependency headers, etc.). If you include headers that frequently change, the precompiled header will have to be recompiled which is slow and defeats the purpose. If nothing changes, it will only have to be compiled once.
- `pch.cpp` serves the purpose of including `pch.h` to act together as the translation unit of the precompiled header.
- `#include "pch.h"` must be the first line of code (previous lines get silently ignored) in a .cpp file wishing to use the precompiled header.
- CMake automatically force-includes `pch.h` so that you don't have to write the include directive in every file, but I still recommend to explicitly do so. Being explicit ensures IntelliSense recognizes includes and allows the code to remain buildable if force-including was disabled or PCH was disabled. 

**NOTE: they should only be used in private source code in src/. Otherwise (publicly), either you would be exposing many unnecessary includes or the user would be missing includes due to them not having force-include of the precompiled header.**

#### WHAT IS .appveyor.yml?
**[Read this](APPVEYOR.md)**
#### WHAT IS .editorconfig?
**[Read this](EDITORCONFIG.md)**
#### WHAT IS .gitattributes?
**[Read this](GIT_ATTRIBUTES.md)**
#### WHAT IS .gitignore?
**[Read this](GIT_IGNORE.md)**
#### WHAT IS .gitmodules?
**[Read this](GIT_MODULES.md)**
#### WHAT IS .travis.yml?
**[Read this](TRAVIS_CI.md)**
#### WHAT IS CMakeLists.txt?
**[Read this](CMAKE.md)**
