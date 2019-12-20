# =================================================================================================
# get_optional.cmake
# v 0.1
#
# Defines helper functions for getting optional input in functions.
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/debug.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/var_to_string.cmake)

function(get_optional outvar tag default inputlist outlist)
  set(DEBUG_CMAKE OFF)

  unset(${outvar} PARENT_SCOPE)
  unset(${outlist} PARENT_SCOPE)

  var_to_string(${inputlist} inputlist)

  list(FIND inputlist ${tag} _found)
  if("${_found}" LESS 0)
    set(${outvar} "${default}" PARENT_SCOPE)
  else()
    list(LENGTH inputlist _length)
    print_message("Found the tag ${tag} at index ${_found} of ${_length}")
    if("${_length}" GREATER "${_found}")
      list(REMOVE_AT inputlist "${_found}")
      list(GET inputlist "${_found}" _value)
      print_message("Tag had value '${_value}'")
      list(REMOVE_AT inputlist "${_found}")
      set(${outvar} "${_value}" PARENT_SCOPE)
    else()
      message(FATAL_ERROR "${tag} requires an argument")
    endif()
  endif()

  set(${outlist} "${inputlist}" PARENT_SCOPE)
endfunction()

function(get_optional_flag outvar tag inputlist outlist)
  set(DEBUG_CMAKE OFF)

  set(${outvar} OFF PARENT_SCOPE)
  unset(${outlist} PARENT_SCOPE)

  var_to_string(${inputlist} inputlist)

  list(FIND inputlist ${tag} _found)
  if(NOT "${_found}" LESS 0)
    set(${outvar} ON PARENT_SCOPE)
    list(REMOVE_AT inputlist "${_found}")
  endif()

  set(${outlist} "${inputlist}" PARENT_SCOPE)
endfunction()
