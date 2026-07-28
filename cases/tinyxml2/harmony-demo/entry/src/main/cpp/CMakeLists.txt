cmake_minimum_required(VERSION 3.15)
project(tinyxml2_harmony_demo)

get_filename_component(
    TINYXML2_SOURCE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../library"
    ABSOLUTE
)

set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(tinyxml2_BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(tinyxml2_INSTALL_PKGCONFIG OFF CACHE BOOL "" FORCE)
add_subdirectory("${TINYXML2_SOURCE_DIR}" tinyxml2-build)

add_library(entry SHARED napi_init.cpp)
target_compile_features(entry PRIVATE cxx_std_17)
target_link_libraries(entry PUBLIC tinyxml2 libace_napi.z.so)
