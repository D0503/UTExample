cmake_minimum_required(VERSION 3.15)
project(libuv_harmony_demo)

get_filename_component(LIBUV_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../library" ABSOLUTE)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(LIBUV_BUILD_SHARED OFF CACHE BOOL "" FORCE)
set(LIBUV_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(LIBUV_BUILD_BENCH OFF CACHE BOOL "" FORCE)
add_subdirectory("${LIBUV_SOURCE_DIR}" libuv-build)

add_library(entry SHARED napi_init.cpp libuv_checks.cpp)
target_compile_features(entry PRIVATE cxx_std_17)
target_include_directories(entry PRIVATE "${LIBUV_SOURCE_DIR}/include")
target_link_libraries(entry PUBLIC uv_a libace_napi.z.so)
