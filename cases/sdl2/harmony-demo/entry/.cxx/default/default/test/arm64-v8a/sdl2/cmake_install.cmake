# Install script for directory: /Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/llvm/bin/llvm-objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/build/default/intermediates/cmake/default/obj/arm64-v8a/libSDL2.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libSDL2.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libSDL2.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/native/llvm/bin/llvm-strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libSDL2.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/libSDL2maind.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2/SDL2Targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2/SDL2Targets.cmake"
         "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/CMakeFiles/Export/f084604df1a27ef5b4fef7c7544737d1/SDL2Targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2/SDL2Targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2/SDL2Targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2" TYPE FILE FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/CMakeFiles/Export/f084604df1a27ef5b4fef7c7544737d1/SDL2Targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2" TYPE FILE FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/CMakeFiles/Export/f084604df1a27ef5b4fef7c7544737d1/SDL2Targets-debug.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2" TYPE FILE FILES
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/SDL2Config.cmake"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/SDL2ConfigVersion.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/SDL2" TYPE FILE FILES
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_assert.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_atomic.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_audio.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_bits.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_blendmode.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_clipboard.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_android.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_iphoneos.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_macosx.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_minimal.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_ohos.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_os2.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_pandora.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_psp.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_windows.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_winrt.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_config_wiz.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_copying.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_cpuinfo.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_egl.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_endian.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_error.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_events.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_filesystem.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_gamecontroller.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_gesture.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_haptic.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_hints.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_joystick.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_keyboard.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_keycode.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_loadso.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_log.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_main.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_messagebox.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_metal.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_mouse.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_mutex.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_name.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengl.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengl_glext.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengles.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengles2.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengles2_gl2.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengles2_gl2ext.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengles2_gl2platform.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_opengles2_khrplatform.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_pixels.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_platform.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_power.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_quit.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_rect.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_render.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_revision.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_rwops.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_scancode.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_sensor.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_shape.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_stdinc.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_surface.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_system.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_syswm.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_assert.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_common.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_compare.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_crc32.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_font.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_fuzzer.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_harness.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_images.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_log.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_md5.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_memory.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_test_random.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_thread.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_timer.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_touch.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_types.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_version.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_video.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/SDL_vulkan.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/begin_code.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/include/close_code.h"
    "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/include/SDL_config.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/sdl2.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE PROGRAM FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/sdl2/sdl2-config")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/aclocal/sdl2.m4")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/share/aclocal" TYPE FILE FILES "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/library/sdl2.m4")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/test/arm64-v8a/cjson/cmake_install.cmake")

endif()

