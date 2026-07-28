#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "SDL2::SDL2" for configuration "Debug"
set_property(TARGET SDL2::SDL2 APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(SDL2::SDL2 PROPERTIES
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "m;/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos/libace_napi.z.so;/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos/libhilog_ndk.z.so;/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos/libace_ndk.z.so;/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos/librawfile.z.so;/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos/libpixelmap_ndk.z.so;SDL2::cjson;/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos/libohaudio.so;-Wl,--no-undefined;-lpthread"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libSDL2.so"
  IMPORTED_SONAME_DEBUG "libSDL2.so"
  )

list(APPEND _cmake_import_check_targets SDL2::SDL2 )
list(APPEND _cmake_import_check_files_for_SDL2::SDL2 "${_IMPORT_PREFIX}/lib/libSDL2.so" )

# Import target "SDL2::SDL2main" for configuration "Debug"
set_property(TARGET SDL2::SDL2main APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(SDL2::SDL2main PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libSDL2maind.a"
  )

list(APPEND _cmake_import_check_targets SDL2::SDL2main )
list(APPEND _cmake_import_check_files_for_SDL2::SDL2main "${_IMPORT_PREFIX}/lib/libSDL2maind.a" )

# Import target "SDL2::cjson" for configuration "Debug"
set_property(TARGET SDL2::cjson APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(SDL2::cjson PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "m"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libcjson.a"
  )

list(APPEND _cmake_import_check_targets SDL2::cjson )
list(APPEND _cmake_import_check_files_for_SDL2::cjson "${_IMPORT_PREFIX}/lib/libcjson.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
