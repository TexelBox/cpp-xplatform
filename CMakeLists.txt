# v3.2 is the largest required cmake minimum version for my dependencies
# if the user is using a lower-version cmake, then they will receive a more instructive message (fail-early rather than continuing processing/generation and getting to an unsupported feature somewhere down the list)
# https://stackoverflow.com/questions/35550116/which-cmake-version-as-the-minimum
# v3.10 required for C++17 MSVC fix
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# notably sets the PROJECT_NAME variable, C/CXX as default build-languages, but i'll overwrite it to just target CXX
# https://cmake.org/cmake/help/latest/command/project.html
project(cpp-xplatform LANGUAGES CXX)

# use C++17 features (globally, for all subsequent targets)
# https://crascit.com/2015/03/28/enabling-cxx11-in-cmake/
# https://stackoverflow.com/questions/44960715/how-to-enable-stdc17-in-vs2017-with-cmake
set(CMAKE_CXX_STANDARD 17) # C++17 MSVC fix in CMake 3.10
set(CMAKE_CXX_STANDARD_REQUIRED ON) # prevent default fallback to an older standard if compiler doesn't support C++17
set(CMAKE_CXX_EXTENSIONS OFF) # only use the official standards (e.g. for g++, -std=c++17 and not -std=gnu++17)

# adds an executable target <cpp-xplatform> to be built from the source files listed <main.cpp>
# the source files can be removed from here and specified later using target_sources()
# https://cmake.org/cmake/help/latest/command/add_executable.html
# warning: use CMAKE_CURRENT_SOURCE_DIR rather than CMAKE_SOURCE_DIR since the the latter points to the src directory of the parent project. So, if my project is a sub-project of another then mine won't build
# https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/issues/1428
add_executable(cpp-xplatform ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp)