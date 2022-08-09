# Overview

Template repository to be used as a base for creating C++ libraries built with CMake. This repository provides:
* Commonly accepted directory layout: `cmake` for CMake utilities and package config, `include/<libname>` for public headers, `src` for library sources and private headers, `examples` and `tests` for library examples and tests correspondingly.
* `CMakeLists.txt` files thoroughly implemented with the following ideas in mind:
  * user should be able to build library both as subproject (probably fetched with CMake's [FetchContent_MakeAvailable](https://cmake.org/cmake/help/latest/module/FetchContent.html)) and as a stand-alone project
  * user should be able to build examples/tests as part of the library build or as a stand-alone projects
  * multi-configuration CMake generators should be supported
  * package systems (conan, vcpkg and others) should be respected, which means that library `CMakeLists.txt` file should contain only **build requirements**, i.e. should not hardcode any compiler/linker flags unless they are absolutely required to build the library
* Basic [preset](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) file `CMakePresets.json` which is a modern way (since CMake 3.19) for specifying build options (instead of hardcoding them in the `CMakeLists.txt` or setting on the command line)
* My personal `.clang-format` for code-style worth trying

Note, that I prefer [googletest](https://github.com/google/googletest) as a testing framework so it's the one used in this repository. Still it's not a big deal to replace it with any other of your choice.
