# explicitly go back to old policy for target names to be able to contain "test" in them, as well as other reserved words
if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
endif()

file(GLOB_RECURSE PREFIX_EXTERNAL_TESTING_SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/*.c" "${CMAKE_CURRENT_LIST_DIR}/*.cc" "${CMAKE_CURRENT_LIST_DIR}/*.cxx" "${CMAKE_CURRENT_LIST_DIR}/*.cpp" "${CMAKE_CURRENT_LIST_DIR}/*.c++" "${CMAKE_CURRENT_LIST_DIR}/*.h" "${CMAKE_CURRENT_LIST_DIR}/*.hh" "${CMAKE_CURRENT_LIST_DIR}/*.hpp" "${CMAKE_CURRENT_LIST_DIR}/*.h++")
message(STATUS "external testing source files = ${PREFIX_EXTERNAL_TESTING_SOURCE_FILES}")
add_executable(cpp-xplatform-external-tests ${PREFIX_EXTERNAL_TESTING_SOURCE_FILES})

target_include_directories(cpp-xplatform-external-tests PRIVATE "${PROJECT_SOURCE_DIR}/deps/doctest" "${PROJECT_SOURCE_DIR}/include" "${PROJECT_SOURCE_DIR}/src")

target_compile_definitions(cpp-xplatform-external-tests PRIVATE DOCTEST_CONFIG_USE_STD_HEADERS)
