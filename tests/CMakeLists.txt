# explicitly go back to old policy for target names to be able to contain "test" in them, as well as other reserved words
if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
endif()

file(GLOB_RECURSE PREFIX_EXTERNAL_TESTING_SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}" "*.c" "*.cc" "*.cxx" "*.cpp" "*.c++" ".h" ".hh" ".hpp" ".h++")
message(STATUS "external testing source files = ${PREFIX_EXTERNAL_TESTING_SOURCE_FILES}")
add_executable(cpp-xplatform-external-tests ${PREFIX_EXTERNAL_TESTING_SOURCE_FILES})

target_include_directories(cpp-xplatform-external-tests PRIVATE "${PROJECT_SOURCE_DIR}/deps/doctest/doctest" "${PROJECT_SOURCE_DIR}/include" "${PROJECT_SOURCE_DIR}/src")
