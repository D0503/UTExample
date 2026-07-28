cmake_minimum_required(VERSION 3.15)
project(tinyxml2_harmony_test)

get_filename_component(
    TINYXML2_SOURCE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../library"
    ABSOLUTE
)

set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(tinyxml2_BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(tinyxml2_INSTALL_PKGCONFIG OFF CACHE BOOL "" FORCE)
add_subdirectory("${TINYXML2_SOURCE_DIR}" tinyxml2-test-build)

add_library(
    entry_test
    SHARED
    native_test_napi.cpp
    tests/tinyxml2_tests.cpp
)
target_compile_features(entry_test PRIVATE cxx_std_17)
target_include_directories(entry_test PRIVATE tests)
target_link_libraries(entry_test PUBLIC tinyxml2 libace_napi.z.so)
