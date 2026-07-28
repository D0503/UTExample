cmake_minimum_required(VERSION 3.5.0)
project(sdl2_gui_validation)

get_filename_component(
    SDL2_ROOT
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

set(CJSON_SOURCE_DIR "${LOCAL_CJSON_SOURCE_DIR}" CACHE PATH "Vendored cJSON source" FORCE)
set(ENABLE_CJSON_TEST OFF CACHE BOOL "" FORCE)
set(ENABLE_CJSON_UTILS OFF CACHE BOOL "" FORCE)
set(ENABLE_TARGET_EXPORT OFF CACHE BOOL "" FORCE)
set(ENABLE_CUSTOM_COMPILER_FLAGS OFF CACHE BOOL "" FORCE)
set(SDL_TEST OFF CACHE BOOL "" FORCE)
set(SDL_STATIC OFF CACHE BOOL "" FORCE)
set(SDL_SHARED ON CACHE BOOL "" FORCE)
add_subdirectory("${SDL2_ROOT}" sdl2)

# The ArkTS module name and dynamically-created XComponent both resolve SDL2.
set_target_properties(SDL2 PROPERTIES DEBUG_POSTFIX "")
install(TARGETS cjson EXPORT SDL2Targets ARCHIVE DESTINATION lib)

add_library(entry SHARED
    gui_state.cpp
    gui_demo.cpp
    napi_init.cpp)

target_compile_features(entry PRIVATE cxx_std_17)
target_include_directories(entry PRIVATE ${SDL2_ROOT}/include)
target_link_libraries(entry PUBLIC SDL2 libace_napi.z.so libhilog_ndk.z.so)
