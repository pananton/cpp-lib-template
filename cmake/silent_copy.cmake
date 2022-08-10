# Script which does not fail when some of the files to be copied are missing.
#
# Usage: cmake -P silent_copy.cmake [files]... [dest]

math(EXPR dir_idx "${CMAKE_ARGC} - 1")
set(first_file_idx ${dir_idx})

foreach(i RANGE ${dir_idx})
    if ("${CMAKE_ARGV${i}}" STREQUAL "-P")
        math(EXPR first_file_idx "${i} + 2")
        break()
    endif()
endforeach()

if(first_file_idx GREATER_EQUAL dir_idx)
    return()
endif()

math(EXPR last_file_idx "${dir_idx} - 1")
set(dest ${CMAKE_ARGV${dir_idx}})
set(files "")

foreach(i RANGE ${first_file_idx} ${last_file_idx})
    list(APPEND files "${CMAKE_ARGV${i}}")
endforeach()

execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different ${files} "${dest}" ERROR_QUIET)
