cmake_minimum_required(VERSION 3.14)
project(mylib-add LANGUAGES CXX)

find_package(mylib REQUIRED)

set(sources main.cpp)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${sources})

add_executable(mylib-add)
target_sources(mylib-add PRIVATE ${sources})
target_link_libraries(mylib-add PRIVATE mylib::mylib)
