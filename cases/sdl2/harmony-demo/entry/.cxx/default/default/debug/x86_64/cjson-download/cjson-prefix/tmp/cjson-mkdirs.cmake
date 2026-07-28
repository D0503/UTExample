# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-source"
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson"
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix"
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix/tmp"
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix/src/cjson-stamp"
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix/src"
  "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix/src/cjson-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix/src/cjson-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/Users/guoyutong/MyWorkSpace/TestThirdParty/cases/sdl2/harmony-demo/entry/.cxx/default/default/debug/x86_64/cjson-download/cjson-prefix/src/cjson-stamp${cfgdir}") # cfgdir has leading slash
endif()
