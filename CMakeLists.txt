cmake_minimum_required(VERSION 3.14)
project(mylib
    VERSION 1.0.0
    DESCRIPTION "Template for C++ library built with CMake"
    LANGUAGES CXX)

#----------------------------------------------------------------------------------------------------------------------
# general settings and options
#----------------------------------------------------------------------------------------------------------------------

include(cmake/utils.cmake)
include(GNUInstallDirs)

string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}" is_top_level)

# MYLIB_SHARED_LIBS option (undefined by default) can be used to force shared/static build
option(MYLIB_BUILD_TESTS "Build mylib tests" OFF)
option(MYLIB_BUILD_EXAMPLES "Build mylib examples" OFF)
option(MYLIB_BUILD_DOCS "Build mylib documentation" OFF)
option(MYLIB_INSTALL "Generate target for installing mylib" ${is_top_level})

if(NOT DEFINED CMAKE_BUILD_TYPE AND NOT DEFINED CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

if(DEFINED MYLIB_SHARED_LIBS)
    set(BUILD_SHARED_LIBS ${MYLIB_SHARED_LIBS})
endif()

set_if_undefined(CMAKE_CXX_VISIBILITY_PRESET hidden)
set_if_undefined(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

set_if_undefined(MYLIB_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/mylib-${PROJECT_VERSION}" CACHE
    STRING "Install path for mylib package-related CMake files")

add_library(mylib) # initialized below
add_library(mylib::mylib ALIAS mylib)

# make 'find_package(mylib)' do nothing in subprojects because target is already defined
list(APPEND defined_targets mylib)

#----------------------------------------------------------------------------------------------------------------------
# mylib dependencies
#----------------------------------------------------------------------------------------------------------------------

# Search for your dependencies here

#----------------------------------------------------------------------------------------------------------------------
# mylib sources
#----------------------------------------------------------------------------------------------------------------------

include(GenerateExportHeader)
set(export_file_name "export_shared.h")

if(NOT BUILD_SHARED_LIBS)
    set(export_file_name "export_static.h")
endif()

generate_export_header(mylib EXPORT_FILE_NAME include/mylib/${export_file_name})

set(public_headers
    include/mylib/export.h
    include/mylib/mylib.h)
set(sources
    ${public_headers}
    src/mylib.cpp)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${sources})

list(APPEND public_headers "${CMAKE_CURRENT_BINARY_DIR}/include/mylib/${export_file_name}")
list(APPEND sources "${CMAKE_CURRENT_BINARY_DIR}/include/mylib/${export_file_name}")

#----------------------------------------------------------------------------------------------------------------------
# mylib target
#----------------------------------------------------------------------------------------------------------------------

include(CMakePackageConfigHelpers)

target_sources(mylib PRIVATE ${sources})
target_compile_definitions(mylib PUBLIC "$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:MYLIB_STATIC_DEFINE>")

target_include_directories(mylib
    PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/src")

set_target_properties(mylib PROPERTIES
    PUBLIC_HEADER "${public_headers}"
    SOVERSION ${PROJECT_VERSION_MAJOR}
    VERSION ${PROJECT_VERSION})

if(MYLIB_INSTALL)
    configure_package_config_file(cmake/mylib-config.cmake.in mylib-config.cmake
        INSTALL_DESTINATION "${MYLIB_INSTALL_CMAKEDIR}")

    write_basic_package_version_file(mylib-config-version.cmake
        COMPATIBILITY SameMajorVersion)

    install(TARGETS mylib EXPORT mylib_export
        RUNTIME COMPONENT mylib
        LIBRARY COMPONENT mylib NAMELINK_COMPONENT mylib-dev
        ARCHIVE COMPONENT mylib-dev
        PUBLIC_HEADER COMPONENT mylib-dev DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/mylib")

    set(export_file "mylib-shared-export.cmake")

    if(NOT BUILD_SHARED_LIBS)
        set(export_file "mylib-static-export.cmake")
    endif()

    install(EXPORT mylib_export
        COMPONENT mylib-dev
        FILE "${export_file}"
        DESTINATION "${MYLIB_INSTALL_CMAKEDIR}"
        NAMESPACE mylib::)

    install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/mylib-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/mylib-config-version.cmake"
        COMPONENT mylib-dev
        DESTINATION "${MYLIB_INSTALL_CMAKEDIR}")

    if(MSVC)
        set(pdb_file "")
        set(pdb_file_destination "")

        if(BUILD_SHARED_LIBS)
            set(pdb_file "$<TARGET_PDB_FILE:mylib>")
            set(pdb_file_destination "${CMAKE_INSTALL_BINDIR}")
        else()
            # TARGET_PDB_FILE does not work for pdb file generated for static library build, determining it manually
            set(pdb_file "$<TARGET_FILE_DIR:mylib>/$<TARGET_FILE_PREFIX:mylib>$<TARGET_FILE_BASE_NAME:mylib>.pdb")
            set(pdb_file_destination "${CMAKE_INSTALL_LIBDIR}")
        endif()

        install(FILES "${pdb_file}"
            COMPONENT mylib-dev
            CONFIGURATIONS Debug RelWithDebInfo
            DESTINATION "${pdb_file_destination}"
            OPTIONAL)
    endif()
endif()

#----------------------------------------------------------------------------------------------------------------------
# other targets
#----------------------------------------------------------------------------------------------------------------------

# makes 'find_package' skip search for already defined targets in subdirectories
macro(find_package)
    string(TOLOWER "${ARG0}" name)

    if(NOT ${name} IN_LIST ${defined_targets})
        _find_package(${ARGV})
    endif()
endmacro()

if(MYLIB_BUILD_TESTS)
    if(${is_top_level})
        enable_testing()
    endif()

    add_subdirectory(tests)
endif()

if(MYLIB_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

if(MYLIB_BUILD_DOCS)
    find_package(Doxygen REQUIRED)
    doxygen_add_docs(docs include)
endif()
