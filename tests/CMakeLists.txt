cmake_minimum_required(VERSION 3.14)
project(mylib-tests)
include("../cmake/utils.cmake")

#----------------------------------------------------------------------------------------------------------------------
# general settings and options
#----------------------------------------------------------------------------------------------------------------------

if(NOT DEFINED PROJECT_IS_TOP_LEVEL AND "${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
    # support older CMake versions (prior 3.21) which do not define this variable
    set(PROJECT_IS_TOP_LEVEL YES)
endif()

if(PROJECT_IS_TOP_LEVEL)
    enable_testing()
endif()

#----------------------------------------------------------------------------------------------------------------------
# testing framework
#----------------------------------------------------------------------------------------------------------------------

include(FetchContent)
FetchContent_Declare(googletest URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # do not override parent project's runtime settings on Windows
set(INSTALL_GTEST OFF)

# For simplicity, always build googletest as static library. This prevents mylib-tests executable from
# complaining about missing googletest DLLs on Windows.
set(BUILD_SHARED_LIBS OFF)

FetchContent_MakeAvailable(googletest)

#----------------------------------------------------------------------------------------------------------------------
# tests dependencies
#----------------------------------------------------------------------------------------------------------------------

if(PROJECT_IS_TOP_LEVEL)
    find_package(mylib REQUIRED)
endif()

#----------------------------------------------------------------------------------------------------------------------
# tests sources
#----------------------------------------------------------------------------------------------------------------------

set(sources
    add_test.cpp)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${sources})

#----------------------------------------------------------------------------------------------------------------------
# tests target
#----------------------------------------------------------------------------------------------------------------------

add_executable(mylib-tests)
target_sources(mylib-tests PRIVATE ${sources})

target_link_libraries(mylib-tests
    PRIVATE
        mylib::mylib
        gtest_main)

if(NOT PROJECT_IS_TOP_LEVEL)
    win_copy_deps_to_target_dir(mylib-tests mylib::mylib)
endif()

include(GoogleTest)
gtest_discover_tests(mylib-tests)
