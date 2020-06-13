# explicitly go back to old policy for target names to be able to contain "test" in them, as well as other reserved words
if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
endif()

file(GLOB_RECURSE ${PROJECT_NAME}_EXTERNAL_TESTING_SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/*.c" "${CMAKE_CURRENT_LIST_DIR}/*.cc" "${CMAKE_CURRENT_LIST_DIR}/*.cxx" "${CMAKE_CURRENT_LIST_DIR}/*.cpp" "${CMAKE_CURRENT_LIST_DIR}/*.c++" "${CMAKE_CURRENT_LIST_DIR}/*.h" "${CMAKE_CURRENT_LIST_DIR}/*.hh" "${CMAKE_CURRENT_LIST_DIR}/*.hpp" "${CMAKE_CURRENT_LIST_DIR}/*.h++")
message(STATUS "external testing source files = ${${PROJECT_NAME}_EXTERNAL_TESTING_SOURCE_FILES}")
add_executable(${PROJECT_NAME}-external-tests ${${PROJECT_NAME}_EXTERNAL_TESTING_SOURCE_FILES})

target_include_directories(${PROJECT_NAME}-external-tests PRIVATE "${PROJECT_SOURCE_DIR}/tests" "${PROJECT_SOURCE_DIR}/deps/doctest" "${PROJECT_SOURCE_DIR}/include" "${PROJECT_SOURCE_DIR}/src")

# overwrite this variable locally with the binary directory for this tests target
# the other two paths are the same
set(PATH_TO_BUILD_SYSTEM_DIRECTORY "\"${CMAKE_CURRENT_BINARY_DIR}/\"")

message(STATUS "WARNING: these paths are constant from the latest CMake build.\n
                They may be used as macros inside the program (e.g. for finding assets).\n
                Thus, a CMake rebuild is needed if the paths on disk have changed (e.g. renaming a directory in the chain, moving the project, etc.).\n"
)
message(STATUS "setting macros for paths...\n
                PATH_TO_ASSETS_DIRECTORY = ${PATH_TO_ASSETS_DIRECTORY}\n
                PATH_TO_BUILD_SYSTEM_DIRECTORY = ${PATH_TO_BUILD_SYSTEM_DIRECTORY}\n
                PATH_TO_PROJECT_ROOT_DIRECTORY = ${PATH_TO_PROJECT_ROOT_DIRECTORY}\n"
)

target_compile_definitions(${PROJECT_NAME}-external-tests PRIVATE DOCTEST_CONFIG_NO_SHORT_MACRO_NAMES DOCTEST_CONFIG_USE_STD_HEADERS PATH_TO_ASSETS_DIRECTORY=${PATH_TO_ASSETS_DIRECTORY} PATH_TO_BUILD_SYSTEM_DIRECTORY=${PATH_TO_BUILD_SYSTEM_DIRECTORY} PATH_TO_PROJECT_ROOT_DIRECTORY=${PATH_TO_PROJECT_ROOT_DIRECTORY})

if(CMAKE_GENERATOR MATCHES "Visual Studio")
    set_property(TARGET ${PROJECT_NAME}-external-tests PROPERTY VS_DEBUGGER_WORKING_DIRECTORY "$<TARGET_FILE_DIR:${PROJECT_NAME}-external-tests>")
endif()
