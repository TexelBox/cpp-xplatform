# explicitly go back to old policy for target names to be able to contain "test" in them, as well as other reserved words
if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
endif()

add_executable(utils-string-utils-test "${CMAKE_CURRENT_LIST_DIR}/utils/string-utils.test.cpp")

list(APPEND COMMON_TARGET_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/deps/doctest/doctest" "${PROJECT_SOURCE_DIR}/include" "${PROJECT_SOURCE_DIR}/src")
target_include_directories(utils-string-utils-test PRIVATE ${COMMON_TARGET_INCLUDE_DIRS})
