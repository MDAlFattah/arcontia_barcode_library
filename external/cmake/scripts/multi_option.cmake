# =================================================================================================
# multi_option.cmake
# v 0.1
#
# add_multi_option(<option name> [options...])
#   Add an option that can be one of a list of values. The possibles values are passed as arguments
#   to the function.
#
#   If the user does not provide a value for the option it will default to the first provided value.
#
#   If the user provides a value that is not in the list, an error will be raised.
#
#   The function will create 1 variable per option that indicates if the value if set. The variable
#   is named <optional name>_<option>. For example:
#
#   set(OPTION OPT1)
#   add_multi_option(OPTION OPT1 OPT2 OPT3)
#
#   after this call, the following variables will be set:
#
#   OPTION_OPT1 ON
#   OPTION_OPT2 OFF
#   OPTION_OPT3 OFF
# =================================================================================================

function(add_multi_option name)
  if(ARGC LESS 2)
    message(FATAL_ERROR "add_multi_name requires an argument list")
  endif()

  if(DEFINED ${name})
    list(FIND ARGV ${${name}} _found)

    if(_found EQUAL -1)
      message(FATAL_ERROR "Invalid value for ${name}: ${${name}}. Expected one of ${ARGV}")
    endif()
  else()
    set(${name} ${ARGV1})
    set(${name} ${ARGV1} PARENT_SCOPE)
  endif()

  foreach(_value ${ARGN})
    set(_var ${name}_${_value})
    if (${_value} STREQUAL ${name})
      set(${_var} ON PARENT_SCOPE)
    else()
      set(${_var} OFF PARENT_SCOPE)
    endif()
  endforeach()
endfunction()
