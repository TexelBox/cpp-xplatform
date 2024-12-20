# cpp-xplatform
C++17 cross-platform template repository using CMake + Git Submodules.

---

### Project Status/Info
|                 |                                                                                                       |                                                                                                   |                                                                                                     |
|-----------------|-------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
|**master branch**|![Windows CI](https://github.com/TexelBox/cpp-xplatform/workflows/Windows%20CI/badge.svg?branch=master)|![macOS CI](https://github.com/TexelBox/cpp-xplatform/workflows/macOS%20CI/badge.svg?branch=master)|![Ubuntu CI](https://github.com/TexelBox/cpp-xplatform/workflows/Ubuntu%20CI/badge.svg?branch=master)|
|**dev branch**   |![Windows CI](https://github.com/TexelBox/cpp-xplatform/workflows/Windows%20CI/badge.svg?branch=dev)   |![macOS CI](https://github.com/TexelBox/cpp-xplatform/workflows/macOS%20CI/badge.svg?branch=dev)   |![Ubuntu CI](https://github.com/TexelBox/cpp-xplatform/workflows/Ubuntu%20CI/badge.svg?branch=dev)   |

---

### Index
- **[Preamble](#preamble)**
- **[Contributing](#contributing)**
- **[Summary](#summary)**
- **[Features](#features)**
- **[Requirements](#requirements)**
  - **[Tools](#tools)**
  - **[Supported Compilers](#supported-compilers)**
- **[Cloning](#cloning)**
- **[Building](#building)**
- **[Running](#running)**
  - **[Usage](#usage)**
  - **[Test-Running](#test-running)**
- **[Dependencies](#dependencies)**

---

### Preamble
If you find this repository to be useful, you may show support by starring the repository or contacting me more directly (contact info may be found via my GitHub profile). Please feel free to share any projects you create. I would love to see them, especially if they are other template repositories! Any comments, questions, feedback, or criticisms are welcome as long as they are communicated in a constructive and respectful manner.

**[General Discussion Board](https://github.com/TexelBox/cpp-xplatform/issues/9)**

### Contributing
If you identify any bugs or wish to request a feature, please submit an issue on GitHub after consulting the appropriate template (help document).<br />
<br />
If you wish to fix/implement an issue, please first mention your intentions in the comments section of the issue. Once correctly fixed/implemented, please submit a pull request (PR) on GitHub from your fork into the `dev` branch after consulting the appropriate template (help document). Please do not submit a PR that doesn't have a corresponding issue, as it may be rejected.

**NOTE: a useful contribution would be to add a new script for another build system supported by `cmake -G`. It would also be beneficial to update the CMake scripts with build system specific features.**

---

### Summary
>*"I just want to program!"* - everyone

The main goal of this project is to serve as a well-documented template repository with typical features of a cross-platform open-source C++ project. Hopefully it can aid developers in jump-starting their projects by bypassing the boring, tedious, and often frustrating work of setting up the boilerplate every time they "just want to program!".<br />
<br />
This project may serve as a useful introduction to less-experienced C++ developers wishing to become familiar with common features of a C++ workflow. It may be beneficial to those wanting to try development on a different platform. This project aims in minimizing the intimidation factor of developing in C++.<br />
<br />
The design allows for clear and easy building for both developers and users. It is also easily extensible to other template repositories (e.g. they could feature sets of different dependencies). It can be used for projects of all scales, from "Hello World!" to an expansive team project.

**NOTE: I encourage anyone to try building other template repositories that extend this one with a set of specific dependencies. For example, once I add some more features to this repository, I will be extending it by building an OpenGL template repository (most of the work is already done for this). Although not required, I think it would be beneficial for derivative template repositories to link back to this one in their README to encourage more derivatives.**

**NOTE: alongside reading this README, it is strongly suggested to also read the short documentation files located in the [help](https://github.com/TexelBox/help) repo.**

---

### Features
- [x] Easy project setup (`Git` + `GitHub template repository` cloning)
- [x] Primary support for building executables, but slight modifications should allow for building libraries
- [x] `Core C++17` standards
- [x] Cross-platform (`Windows`, `Linux`, `macOS`)
- [x] Support for generating multiple build systems (`CMake`)
- [x] Simple "up-to-date" dependency tracking/handling (`Git Submodules` / recursive cloning)
- [x] Simple building / test-running ("One-click" `Shell` scripts)
- [x] Pre-written scripts for generating `Visual Studio 2017 solutions` (Windows - x86/x64) and `Unix Makefiles` (Linux/macOS) that can used as a quick way to compile all configurations (Debug, MinSizeRel, Release, RelWithDebInfo) or perform a CMake rebuild
- [x] Semi-standard project file/directory structure/layout
- [x] Consistent line-ending normalization/handling (`Git Attributes`)
- [x] Consistent coding style enforcement (`EditorConfig`)
- [x] Simple source file tracking/handling (add, rename, or delete) (`recursive CMake file globbing` + `touch` workflow)
- [x] Global `PATH` macros are defined and can be used in code as a semi-reliable method of referencing external things such as assets. This prefixing allows a built executable to be run from any directory as long as the macro remains consistent with the path on disk.
- [x] Faster compilation using precompiled headers (via `cotire`) and parallel compilation (`/MP` for MSVC, and `-j` for make)
- [x] Decently strict compiler warning options
- [x] Integrated lightweight/fast testing framework (with classical "external" testing and inline "internal" testing) (via `doctest`)
- [x] Continuous integration (CI) for cross-platform build-testing and test-running (`GitHub Actions`)
- [x] Developer-friendly (permissive) CC0-1.0 license

**NOTE: more specific features may be discovered by reading through specific files such as the CMake scripts.**

---

### Requirements
- A GitHub account is required if you want to take advantage of all the features, but you can still try out the project through git cloning.
- EditorConfig support/extensions in your IDE (Visual Studio 2017/2019 have it by default) or text editor are required if you (and especially your team) want to take advantage of consistent coding standards (e.g. line-endings, indentation (spaces vs. tabs, size), whitespace trimming, etc.).

### Tools
<table>
    <tr>
        <td>
        </td>
        <td>
            Windows
        </td>
        <td>
            Linux/macOS
        </td>
    </tr>
    <tr>
        <td>
            Git
        </td>
        <td>
            yes (with Git Bash)
        </td>
        <td>
            yes
        </td>
    </tr>
    <tr>
        <td>
            Bash or Dash
        </td>
        <td>
        </td>
        <td>
            yes
        </td>
    </tr>
    <tr>
        <td>
            CMake
        </td>
        <td>
            yes (version >= 3.10)
        </td>
        <td>
            yes (version >= 3.10)
        </td>
    </tr>
    <tr>
        <td>
            C++ compiler (see list below)
        </td>
        <td>
            MSVC (via Visual Studio 2017)
        </td>
        <td>
            GCC or Clang or Apple Clang
        </td>
    </tr>
    <tr>
        <td>
            GNU Make
        </td>
        <td>
        </td>
        <td>
            yes
        </td>
    </tr>
    <tr>
        <td>
            nproc
        </td>
        <td>
        </td>
        <td>
            yes (part of GNU coreutils)
        </td>
    </tr>
</table>

### Supported Compilers
#### Minimum Versions
- GCC (libstdc++) 7
- Clang (libc++) 6
- MSVC (MSVC Standard Library) 19.14 (VS 2017 15.7)
- Apple Clang 10.0.0

**[Refer here for a comprehensive overview of which C++ standard features are supported by each compiler.](https://en.cppreference.com/w/cpp/compiler_support)**

**NOTE: all C++17 core language features are supported by these compilers, but some library features are unsupported.**

---

### Cloning
- Easiest (preferred) method...
```
git clone --recursive https://github.com/TexelBox/cpp-xplatform.git
```
- or, if you did a normal clone already (first two lines below)...
```
git clone https://github.com/TexelBox/cpp-xplatform.git
cd cpp-xplatform/
git submodule update --init --recursive
```

---

### Building
#### For Users...
- **TODO - add instructions here after adding the scripts**

#### For Developers...
**NOTE: the enforced generators by the scripts are "Visual Studio 2017"/"Visual Studio 2017 Win64" and "Unix Makefiles" for their respective platforms. I won't be testing this repository with any other generator (use `cmake --help` for a list), but anybody can try using cmake manually to see if another generator works.**
#### Windows
- Use Git Bash to run
```
./scripts/dev/build/vs2017/dev-build-all.sh
```
**NOTE: executing this way defaults to using `bash`.**
- If for some reason the script is non-executable, then run the script through an interpreter (only `bash` and `dash` are tested, but you can try others)...
```
bash scripts/dev/build/vs2017/dev-build-all.sh
```
- or, add executable permission and then run...
```
chmod +x scripts/dev/build/vs2017/dev-build-all.sh
./scripts/dev/build/vs2017/dev-build-all.sh
```
#### Linux/macOS
- Use your favourite terminal to run
```
./scripts/dev/build/unix-makefiles/dev-build-all.sh
```
**NOTE: executing this way defaults to using `bash`.**
- If for some reason the script is non-executable, then run the script through an interpreter (only `bash` and `dash` are tested, but you can try others)...
```
bash scripts/dev/build/unix-makefiles/dev-build-all.sh
```
- or, add executable permission and then run...
```
chmod +x scripts/dev/build/unix-makefiles/dev-build-all.sh
./scripts/dev/build/unix-makefiles/dev-build-all.sh
```

---

### Running
#### For Users...
##### Windows
- For best performance, double-click/run `project-name.exe` in either build/vs2017/x86/Release/ (32-bit) or build/vs2017/x64/Release/ (64-bit).
##### Linux/macOS
- For best performance, double-click/run `project-name` in build/unix-makefiles/default/Release/.

#### For Developers...
##### Windows
- If using `VS 2017`, open either build/vs2017/x86/project-name.sln or build/vs2017/x64/project-name.sln and click the green arrow (you can also change the build config with the drop-down - use Debug when you need the debugger and Release when testing for performance).
##### Linux/macOS
```
make -j$(($(nproc)+1))
./project-name
```
##### Usage
- Only run program: `./project-name`
- Run program and internal tests: `./project-name --dt-no-run=false`
- Only run internal tests: `./project-name --dt-exit=true --dt-no-run=false`
- **TODO: ONCE VERSIONING IS IMPLEMENTED, ADD A --version HERE**

##### Test-Running
- Internal Tests:
  - Single config:
    - `./project-name --dt-exit=true --dt-no-run=false`
  - All configs:
    - `./scripts/dev/test/vs2017/run-internal-tests.sh` (Windows)
    - `./scripts/dev/test/unix-makefiles/run-internal-tests.sh` (Linux/macOS)
- External Tests:
  - Single config:
    - `./project-name-external-tests`
    - or, set the `StartUp Project` to `project-name-external-tests` and run directly in the IDE as usual (Visual Studio only)
  - All configs:
    - `./scripts/dev/test/vs2017/run-external-tests.sh` (Windows)
    - `./scripts/dev/test/unix-makefiles/run-external-tests.sh` (Linux/macOS)

---

### Dependencies
Many thanks to the contributors of the following projects! Please check them out!
- **[cotire - (CMake module to speed up builds.) - MIT licensed.](https://github.com/sakra/cotire)**
- **[doctest - (The fastest feature-rich C++11/14/17/20 single-header testing framework for unit tests and TDD) - MIT licensed.](https://github.com/onqtam/doctest)**

---

Now go make something cool!<br />
:wink:

---
