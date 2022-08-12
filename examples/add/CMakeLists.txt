cmake_minimum_required(VERSION 3.14)
project(mylib-add LANGUAGES CXX)
include("../../cmake/utils.cmake")

if(NOT DEFINED PROJECT_IS_TOP_LEVEL AND "${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
    # support older CMake versions (prior 3.21) which do not define this variable
    set(PROJECT_IS_TOP_LEVEL YES)
endif()

if(PROJECT_IS_TOP_LEVEL)
    find_package(mylib REQUIRED)
endif()

set(sources main.cpp)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${sources})

add_executable(mylib-add)
target_sources(mylib-add PRIVATE ${sources})
target_link_libraries(mylib-add PRIVATE mylib::mylib)

if(NOT PROJECT_IS_TOP_LEVEL)
    win_copy_deps_to_target_dir(mylib-add mylib::mylib)
endif()
