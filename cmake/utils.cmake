# set_if_undefined(<variable> [<value>]...)
#
# Set variable if it is not defined.
macro(set_if_undefined variable)
    if(NOT DEFINED "${variable}")
        set("${variable}" ${ARGN})
    endif()
endmacro()
