cmake_minimum_required(VERSION 3.15)
project(sdl2_harmony_test)

get_filename_component(
    SDL2_SOURCE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../library"
    ABSOLUTE
)
get_filename_component(
    LOCAL_CJSON_SOURCE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../third_party/cjson"
    ABSOLUTE
)

if(NOT EXISTS "${LOCAL_CJSON_SOURCE_DIR}/cJSON.c")
    message(FATAL_ERROR "missing vendored cJSON source: ${LOCAL_CJSON_SOURCE_DIR}")
endif()

# The HarmonyOS SDL2 port otherwise downloads cJSON during CMake configure.
# Pin the case-local v1.7.15 source so automated builds remain offline.
set(CJSON_SOURCE_DIR "${LOCAL_CJSON_SOURCE_DIR}" CACHE PATH "Vendored cJSON source" FORCE)
set(ENABLE_CJSON_TEST OFF CACHE BOOL "" FORCE)
set(ENABLE_CJSON_UTILS OFF CACHE BOOL "" FORCE)
set(ENABLE_TARGET_EXPORT OFF CACHE BOOL "" FORCE)
set(ENABLE_CUSTOM_COMPILER_FLAGS OFF CACHE BOOL "" FORCE)
set(SDL_TEST OFF CACHE BOOL "" FORCE)
set(SDL_STATIC OFF CACHE BOOL "" FORCE)
set(SDL_SHARED ON CACHE BOOL "" FORCE)
add_subdirectory("${SDL2_SOURCE_DIR}" sdl2-test-build)

# The legacy SDL project exports its complete link interface. Add the local
# cJSON target to that export set so CMake can generate SDL2Targets.
install(TARGETS cjson EXPORT SDL2Targets ARCHIVE DESTINATION lib)

add_library(
    entry_test
    SHARED
    native_test_napi.cpp
    tests/sdl_core_tests.cpp
    tests/sdl_gui_state_tests.cpp
    ../../main/cpp/gui_state.cpp
)
target_compile_features(entry_test PRIVATE cxx_std_17)
target_include_directories(
    entry_test
    PRIVATE
    tests
    ../../main/cpp
    "${SDL2_SOURCE_DIR}/include"
)
target_link_libraries(entry_test PUBLIC SDL2 libace_napi.z.so)
