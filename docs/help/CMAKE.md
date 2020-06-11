- CMake is a build system generator (e.g. it can generate build systems such as Visual Studio solutions/projects, Unix Makefiles, etc.). The CMake executable processes one or more `CMakeLists.txt` (scripts) with the main one being located in the project root directory.
- If you were to manually generate a build system, you would want to perform an "out-of-source" build (i.e. the build system files get generated into a separate directory than the "CMake source directory" (directory containing the main `CMakeLists.txt`)). An example process would be...
```
cd <CMake source directory>
mkdir -p build/Release
cd build/Release
cmake -G "<build system>" -DCMAKE_BUILD_TYPE=Release ../..
```
**NOTE: `cmake --help` can be used to list all the supported build systems (under "Generators").**
