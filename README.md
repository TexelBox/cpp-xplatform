# cpp-xplatform

C++17 cross-platform template repository using CMake + Git Submodules.

# WORK-IN-PROGRESS
- this repository is currently a learning experience for myself, but is intended to act as a small tutorial in the future. It will hopefully act as useful boilerplate that I can use for some personal projects. It can be extended into other templates as well.
- the goal is to provide a well-documented template repository with typical features of an open source project (e.g. project structure/layout, submodule dependencies, build/utility scripts, testing, continous integration (CI), simple whitespace/eol handling, and more...).
- TODO: provide a short concise explanation of the purpose of these features so that this repository doesn't look intimidating to unfamiliar eyes. This is very important since, from experience, many repos do a terrible job of explaining themselves :(.

---

<a href="https://ci.appveyor.com/project/TexelBox/cpp-xplatform" target="_blank">AppVeyor CI project page</a>
<br />
<a href="https://travis-ci.org/TexelBox/cpp-xplatform" target="_blank">Travis CI project page</a>

<table>
    <tr>
        <td>
            master branch
        </td>
        <td>
            Windows <a href="https://ci.appveyor.com/project/TexelBox/cpp-xplatform/branch/master" target="_blank"><img src="https://ci.appveyor.com/api/projects/status/9q38si39i32fd8d9/branch/master?svg=true"></a>
        </td>
        <td>
            Linux/macOS <a href="https://travis-ci.org/TexelBox/cpp-xplatform/branches" target="_blank"><img src="https://travis-ci.org/TexelBox/cpp-xplatform.svg?branch=master"></a>
        </td>
    </tr>
    <tr>
        <td>
            dev branch
        </td>
        <td>
            Windows <a href="https://ci.appveyor.com/project/TexelBox/cpp-xplatform/branch/dev" target="_blank"><img src="https://ci.appveyor.com/api/projects/status/9q38si39i32fd8d9/branch/dev?svg=true"></a>
        </td>
        <td>
            Linux/macOS <a href="https://travis-ci.org/TexelBox/cpp-xplatform/branches" target="_blank"><img src="https://travis-ci.org/TexelBox/cpp-xplatform.svg?branch=dev"></a>
        </td>
    </tr>
</table>

---

### Supported compilers
#### Minimum versions:
- GCC (libstdc++) 7
- Clang (libc++) 6
- MSVC (MSVC Standard Library) 19.14 (VS 2017 15.7)
- Apple Clang 10.0.0
###### [Refer here for a comprehensive overview of which C++ standard features are supported by each compiler.](https://en.cppreference.com/w/cpp/compiler_support)
- note: all C++17 core language features are supported by these compilers, but some library features are unsupported.

---

### Cloning
easiest (preferred) method:
```
git clone --recursive https://github.com/TexelBox/cpp-xplatform.git
```
or (if you did a normal clone already (first two lines below)...)
```
git clone https://github.com/TexelBox/cpp-xplatform.git
cd cpp-xplatform/
git submodule update --init --recursive
```

---

### Building (currently for developers only)
- note: the enforced generators by the scripts are "Visual Studio 2017"/"Visual Studio 2017 Win64" and "Unix Makefiles" for their respective platforms. I won't be testing this repository with any other generator (use `cmake --help` for a list), but anybody can try using cmake manually to see if another generator works.
#### Windows:
- double-click or use your favourite terminal to run
```
dev-build-all.bat
```
- note: you may have to run `./dev-build-all.bat` or `.\dev-build-all.bat` instead (depending on your shell).
#### Linux/macOS:
- use your favourite terminal to run
```
./dev-build-all.sh
```
- note: executing this way defaults to using `bash`.
- note: if for some reason the script is non-executable, then run the script through an interpreter (only `bash` and `dash` are tested, but you can try others).
```
bash dev-build-all.sh
```
or add executable permissions and then run
```
chmod +x dev-build-all.sh
./dev-build-all.sh
```

---

### Running
#### For users...
##### Windows:
- for best performance, double-click/run `cpp-xplatform.exe` in either x86/Release (32-bit) or x64/Release (64-bit).
##### Linux/macOS:
- for best performance, double-click/run `cpp-xplatform` in build/Release.

#### For developers...
##### Windows:
- if using `VS2017`, open either x86/cpp-xplatform.sln or x64/cpp-xplatform.sln and click the green arrow (you can also change the build config with the drop-down - use Debug when you need the debugger and Release when testing for performance).
##### Linux/macOS:
```
make -j$(($(nproc)+1))
./cpp-xplatform
```
##### Different cmd-line options:
- only run program: `./cpp-xplatform`
- run program and internal tests: `./cpp-xplatform --dt-no-run=false`
- only run tests: `./cpp-xplatform --dt-exit=true --dt-no-run=false`

---

### Dependencies
Many thanks to the contributors of the following projects! Please check them out!
- <a href="https://github.com/sakra/cotire" target="_blank">cotire - (CMake module to speed up builds.) - MIT licensed.</a>
- <a href="https://github.com/onqtam/doctest" target="_blank">doctest - (The fastest feature-rich C++11/14/17/20 single-header testing framework for unit tests and TDD) - MIT licensed.</a>

---

now go make something cool!<br />
:wink:

---
