# =================================================================================================
# filetype.cmake
# v 0.4
#
# Changelog:
#
# v 0.4:
#   Added the `is_source_config_file` and `is_header_config_file` functions.
#
# v 0.3:
#   Added the `is_qt_resource_file` function.
#
# v 0.2:
#   Added the `is_qt_ui_file` and `is_in_dir` functions.
#
#
# Defines functions for identifying and handling different file types.
#
# is_source_file(<file> <outvar>)
#   If the filename stored in the <file> variable is a source file according to C++ file naming
#   conventions, <outvar> will be set to YES. Otherwise <outvar> will be set to NO.
#
# is_header_file(<file> <outvar>)
#   If the filename stored in the <file> variable is a header file according to C++ file naming
#   conventions, <outvar> will be set to YES. Otherwise <outvar> will be set to NO.
#
# is_source_config_file(<file> <outvar>)
#   If the filename stored in the <file> variable is a configurable source file according to C++
#   file naming conventions, <outvar> will be set to YES. Otherwise <outvar> will be set to NO.
#
# is_header_config_file(<file> <outvar>)
#   If the filename stored in the <file> variable is a configurable header file according to C++
#   file naming conventions, <outvar> will be set to YES. Otherwise <outvar> will be set to NO.
#
# is_qt_ui_file(<file> <outvar>)
#   If the filename stored in the <file> variable is a Qt ui file, <outvar> will be set to YES.
#   Otherwise <outvar> will be set to NO.
#
# is_qt_resource_file(<file> <outvar>)
#   If the file specified by <file> is a Qt resource file, <outvar> will be set to YES.
#   Otherwise <outvar> will be set to NO. Qt resource files have the qrc extension.
#
# is_in_dir(<file> <dir> <outvar>)
#   If <file> is in the directory <dir>, <outvar> will be set to YES. Otherwise <outvar> will be
#   set to NO.
#
# is_generated_file(<file> <outvar> [ROOT_DIR <dir>] [GENERATED_DIR <dir>])
#   Determine if <file> is a generated file.
#
#   If ROOT_DIR == GENERATED_DIR then this will always return false as we cannot detect generated
#   files based on location on the filesystem.
#
#   Generated files are those that exist inside of the GENERATED_DIR
#
#   ROOT_DIR will default to CMAKE_CURRENT_SOURCE_DIR
#
#   GENERATED_DIR will default to CMAKE_CURRENT_BINARY_DIR
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/var_to_string.cmake)

function(is_source_file _filename_variable _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES ".*\\.(C|cc|cpp|CPP|c\\+\\+|cp|cxx|c)$")
    set(${_outvar} YES PARENT_SCOPE)
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_header_file _filename_variable _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES ".*\\.(h|hpp|hh|hxx)$")
    set(${_outvar} YES PARENT_SCOPE)
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_source_config_file _filename_variable _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES ".*\\.in$")
    string(REPLACE ".in" "" _filename ${_variable})
    is_source_file(_filename _is_config_source_file)
    if(_is_config_source_file)
      set(${_outvar} YES PARENT_SCOPE)
    else()
      set(${_outvar} NO PARENT_SCOPE)
    endif()
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_header_config_file _filename_variable _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES ".*\\.in$")
    string(REPLACE ".in" "" _filename ${_variable})
    is_header_file(_filename _is_config_header_file)
    if(_is_config_header_file)
      set(${_outvar} YES PARENT_SCOPE)
    else()
      set(${_outvar} NO PARENT_SCOPE)
    endif()
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_qt_ui_file _filename_variable _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES ".*\\.ui$")
    set(${_outvar} YES PARENT_SCOPE)
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_qt_resource_file _filename_variable _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES ".*\\.qrc$")
    set(${_outvar} YES PARENT_SCOPE)
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_in_dir _filename_variable _directory _outvar)
  var_to_string(${_filename_variable} _variable)

  if(${_variable} MATCHES "^${_directory}")
    set(${_outvar} YES PARENT_SCOPE)
  else()
    set(${_outvar} NO PARENT_SCOPE)
  endif()
endfunction()

function(is_generated_file file outvar)
  set(DEBUG_CMAKE OFF)

  set(_optional_arguments "${ARGN}")
  get_optional(_root_dir "ROOT_DIR"      "${CMAKE_CURRENT_SOURCE_DIR}" _optional_arguments _optional_arguments)
  get_optional(_gen_dir  "GENERATED_DIR" "${CMAKE_CURRENT_BINARY_DIR}" _optional_arguments _optional_arguments)

  if(${_root_dir} STREQUAL ${_gen_dir})
    set(${outvar} OFF PARENT_SCOPE)
  else()
    file(RELATIVE_PATH _relative_dir ${_root_dir} ${_gen_dir})

    if(${file} MATCHES "^${_gen_dir}" OR ${file} MATCHES "^${_relative_dir}")
      print_message("GENERATED: '${file}'")
      set(${outvar} ON PARENT_SCOPE)
    else()
      set(${outvar} OFF PARENT_SCOPE)
    endif()
  endif()
endfunction()
