# cpp-xplatform

C++17 cross-platform sample project using CMake + Git Submodules.

WORK-IN-PROGRESS
- this repository is currently a learning experience for myself, but is intended to act as a small tutorial in the future.

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

### Building (currently for developers only)
- note: the enforced generators by the scripts are "Visual Studio 2017"/"Visual Studio 2017 Win64" and "Unix Makefiles" for their respective platforms. I won't be testing this repository with any other generator (use ```cmake --help``` for a list), but anybody can try using cmake manually to see if another generator works.
#### Windows:
- double-click or use your favourite terminal to run
```
dev-build-all.bat
```
#### Linux/Mac:
- use your favourite terminal to run
```
./dev-build-all.sh
```
- note: if for some reason the script is non-executable, then run the script through an interpreter (only bash is tested, but you can try another)
```
bash dev-build-all.sh
```
or add executable permissions and then run
```
chmod +x dev-build-all.sh
./dev-build-all.sh
```

---
