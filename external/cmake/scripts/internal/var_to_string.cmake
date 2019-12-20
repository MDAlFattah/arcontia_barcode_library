# =================================================================================================
# var_to_string.cmake
# v 0.1
#
# Defines function for getting the string value out of a variable.
#
# var_to_string(<variable> <outvar>)
#   If the <variable> is DEFINED returnt the string stored in it. Otherwise assume it is not a
#   variable and just return the <variable> name as a string.
# =================================================================================================

function(var_to_string _string_or_variable _outvar)
  if(DEFINED ${_string_or_variable})
    set(${_outvar} ${${_string_or_variable}} PARENT_SCOPE)
  else()
    set(${_outvar} ${_string_or_variable} PARENT_SCOPE)
  endif()
endfunction()
