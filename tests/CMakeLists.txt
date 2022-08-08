cmake_minimum_required(VERSION 3.14)
project(mylib-tests)

#----------------------------------------------------------------------------------------------------------------------
# general settings and options
#----------------------------------------------------------------------------------------------------------------------

string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}" is_top_level)

if(is_top_level)
    enable_testing()
endif()

#----------------------------------------------------------------------------------------------------------------------
# testing framework
#----------------------------------------------------------------------------------------------------------------------

include(FetchContent)
FetchContent_Declare(googletest URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # do not override parent project's runtime settings on Windows
set(INSTALL_GTEST OFF)

FetchContent_MakeAvailable(googletest)

#----------------------------------------------------------------------------------------------------------------------
# tests dependencies
#----------------------------------------------------------------------------------------------------------------------

find_package(mylib REQUIRED)

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

include(GoogleTest)
gtest_discover_tests(mylib-tests)
