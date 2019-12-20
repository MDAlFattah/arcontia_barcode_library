
include(${CMAKE_CURRENT_LIST_DIR}/../find_host.cmake)

set (valid_level_list "_VERSION_MAJOR;_VERSION_MINOR;_VERSION_PATCH;_VERSION_TWEAK")

macro(version_unset_variables)
  unset(${prefix}_VERSION_MAJOR PARENT_SCOPE)
  unset(${prefix}_VERSION_MINOR PARENT_SCOPE)
  unset(${prefix}_VERSION_PATCH PARENT_SCOPE)
  unset(${prefix}_VERSION_TWEAK PARENT_SCOPE)
  unset(${prefix}_VERSION PARENT_SCOPE)
endmacro()

function(pad_number variable size)
  set (DEBUG_CMAKE OFF)

  if(size GREATER 0)
    string(LENGTH ${${variable}} _length)
    if(_length LESS size)
      print_message("Padding ${variable} from ${_length} to ${size}")
      set(temp ${${variable}})
      while(_length LESS size)
        string(CONCAT temp "0" ${temp})
        string(LENGTH ${temp} _length)
      endwhile()
      set(${variable} ${temp} PARENT_SCOPE)
    elseif(_length GREATER size)
      message(FATAL_ERROR "${variable} is too long. Expected ${size} digits but has ${_length}.")
    else()
      print_message("${variable} is the right size.")
    endif()
  endif()
endfunction()

##
# Checks that the amount of levels e.g MAJOR, MINOR, PATCH etc falls between 1 and 4.
#
# count The amount of levels entered .
# outvar Variable containg result of this function execution.
##
function(is_part_count_ok count outvar)
  if(${count} LESS 1 OR ${count} GREATER 4)
    set(${outvar} "FALSE; Part count \"${${count}}\" is not in range [1 - 4]" PARENT_SCOPE)
  else()
    set(${outvar} "TRUE" PARENT_SCOPE)
  endif()
endfunction()

##
# Checks that the required parent level of a child level is defined
# e.g VERSION_MINOR child level requires that parent level VERSION_MAJOR is defined.
#
# given_level_list A list containing the provided version levels.
# outvar Variable containing result of this function execution.
##
function(is_levels_order_ok given_level_list outvar)
  list(LENGTH ${given_level_list} count)
  math(EXPR len "${count} - 1}")
  set(${outvar} "TRUE" PARENT_SCOPE)

  foreach(index RANGE ${len} )
    list(GET valid_level_list ${index} level)
    string(FIND "${${given_level_list}}" "${prefix}${level}" found)
    if(found EQUAL -1)
      set(${outvar} "FALSE; \"${prefix}${level}\" needs to be defined before lower levels are defined" PARENT_SCOPE)
    endif()
  endforeach()
endfunction()

##
# In the case where EXACT is set to ON. This function checks that the number of
# levels defined e.g MAJOR, MINOR, PATCH etc is equal to required level count.
#
# level_count The amount of levels defined .
# required_count The required levels.
# exact A is either ON or OFF.
# outvar Variable containing result of this function execution.
##
function(required_levels_given level_count required_count exact outvar)
  if(${exact} AND NOT ${${level_count}} EQUAL ${${required_count}} )
     set(${outvar} "FALSE; Version number needed \"${${required_count}}\" levels but has \"${${level_count}}\"" PARENT_SCOPE)
  else()
    set(${outvar} "TRUE" PARENT_SCOPE)
  endif()
endfunction()

##
# Checks if the given level count is more than the actual level count to be used.
#
# given_level_count The given level count
# used_level_count The actual level count to be used.
# outvar Variable containg result of this function execution
##
function(is_levels_count_ok given_level_count used_level_count outvar)
  if( ${given_level_count} GREATER ${used_level_count} )
    set(${outvar} "FALSE; Given levels \"${${given_level_count}}\" cannot be more than \"${${used_level_count}}\"" PARENT_SCOPE)
  else()
    set(${outvar} "TRUE" PARENT_SCOPE)
  endif()
endfunction()

##
# It unifies the different forms versions are given by extracting the different version
# data provided and storing them in PARENT_SCOPE variables.
#
##
function(parse_version_params)
  if(DEFINED ${prefix}_VERSION)
    string(REPLACE "." ";" version_list "${${prefix}_VERSION}")
    list(LENGTH version_list version_list_length)
    math(EXPR len "${version_list_length} - 1")

    foreach(list_val RANGE ${len} )
      list(GET version_list ${list_val} version_value)
      list(GET valid_level_list ${list_val} version_level)
      set(${prefix}${version_level} ${version_value} PARENT_SCOPE)
      if(${version_level} STREQUAL "_VERSION_MAJOR")
        set(version "${prefix}${version_level}")
      else()
        set(version "${version};${prefix}${version_level}")
      endif()
    endforeach()
  else()
    list(LENGTH valid_level_list level_list_length)
    math(EXPR len2 "${level_list_length} - 1")

    foreach(list_val RANGE ${len2} )
      list(GET valid_level_list ${list_val} version_level)
      if(DEFINED ${prefix}${version_level})
        if(${version_level} STREQUAL "_VERSION_MAJOR")
          set(version "${prefix}${version_level}")
        else()
          set(version "${version};${prefix}${version_level}")
        endif()
      endif()
    endforeach()
  endif()

  set(${prefix}_VERSION "${version}" PARENT_SCOPE)
endfunction()

##
# Get version
#
# prefix The prefix is which version levels are prefixed with
# part_count The maximum amount of version levels to return
# ${ARGN} this is an optional third variable entered to the function
#
# outvar Variable containing result of this function execution
##
function(get_version_impl prefix part_count outvar)
  is_part_count_ok(part_count result)
  list(GET result 0 ok)
  if(NOT ${ok})
    set(${outvar} ${result} PARENT_SCOPE)
    version_unset_variables()
    return()
  endif()

  set(_optional "${ARGN}")
  get_optional_flag(_exact "EXACT" _optional _optional)
  get_optional(_size_major "SIZE_MAJOR" "0" _optional _optional)
  get_optional(_size_minor "SIZE_MINOR" "0" _optional _optional)
  get_optional(_size_patch "SIZE_PATCH" "0" _optional _optional)
  get_optional(_size_tweak "SIZE_TWEAK" "0" _optional _optional)

  parse_version_params()
  set(version_list "${${prefix}_VERSION}")

  list(LENGTH version_list version_list_count)
  required_levels_given(version_list_count part_count _exact result_2)
  list(GET result_2 0 ok_2)
  if(NOT ${ok_2})
    set(${outvar} ${result_2} PARENT_SCOPE)
    version_unset_variables()
    return()
  endif()

  is_levels_count_ok(version_list_count part_count result_3)
  list(GET result_3 0 ok_3)
  if(NOT ${ok_3})
    set(${outvar} ${result_3} PARENT_SCOPE)
    version_unset_variables()
    return()
  endif()

  is_levels_order_ok(version_list result_4)
  list(GET result_4 0 ok_4)
  if(NOT ${ok_4})
    set(${outvar} ${result_4} PARENT_SCOPE)
    version_unset_variables()
    return()
  endif()

  foreach(entry ${version_list} )
    if(${entry} STREQUAL ${prefix}_VERSION_MAJOR)
      pad_number(${entry} ${_size_major})
      set(temp_outvar ${${entry}})
      set(${entry} ${${entry}} PARENT_SCOPE)
    elseif(${entry} STREQUAL ${prefix}_VERSION_MINOR)
      pad_number(${entry} ${_size_minor})
      set(temp_outvar ${temp_outvar}.${${entry}})
      set(${entry} ${${entry}} PARENT_SCOPE)
    elseif(${entry} STREQUAL ${prefix}_VERSION_PATCH)
      pad_number(${entry} ${_size_patch})
      set(temp_outvar ${temp_outvar}.${${entry}})
      set(${entry} ${${entry}} PARENT_SCOPE)
    elseif(${entry} STREQUAL ${prefix}_VERSION_TWEAK)
      pad_number(${entry} ${_size_tweak})
      set(temp_outvar ${temp_outvar}.${${entry}})
      set(${entry} ${${entry}} PARENT_SCOPE)
    endif()
  endforeach()

  set(${prefix}_VERSION "${temp_outvar}" PARENT_SCOPE)
  set(${outvar} "TRUE;${temp_outvar}" PARENT_SCOPE)
endfunction()
