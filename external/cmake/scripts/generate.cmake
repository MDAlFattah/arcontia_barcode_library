# =================================================================================================
# generate.cmake
# v 0.2
#
# Changelog:
#
# v 0.2:
#   `generate_target_files` added.
#
# generate_target_files(<target> file1 [file2 ...] [ROOT_DIR <dir>] [GENERATED_DIR <dir>])
#   Create a copy of the file(s) using the configure_file command. The new file will be placed
#   relative to GENERATED_DIR. The relative location is identical to the relative location of the
#   input file with respect to ROOT_DIR.
#
#   The input files must end with ".in". The file copies will have this suffix removed.
#   The original file(s) and the generated file(s) will be added as sources of the target.
#
#   ROOT_DIR will default to CMAKE_CURRENT_SOURCE_DIR
#   GENERATED_DIR will default to CMAKE_CURRENT_BINARY_DIR
#
# generate(<outlist> file1 [file2 ...] [ROOT_DIR <dir>] [GENERATED_DIR <dir>])
#   Create a copy of the file(s) using the configure_file command. The new file will be placed
#   relative to GENERATED_DIR. The relative location is identical to the relative location of the
#   input file with respect to ROOT_DIR.
#
#   The input files must end with ".in". The file copies will have this suffix removed.
#   <outlist> will contain a list of both the input and generated files.
#
#   ROOT_DIR will default to CMAKE_CURRENT_SOURCE_DIR
#   GENERATED_DIR will default to CMAKE_CURRENT_BINARY_DIR
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/internal/debug.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/filetype.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/get_optional.cmake)

function(generate outlist)
  set(DEBUG_CMAKE OFF)

  set(_optional_arguments "${ARGN}")
  get_optional(_root_dir "ROOT_DIR"      "${CMAKE_CURRENT_SOURCE_DIR}" _optional_arguments _optional_arguments)
  get_optional(_gen_dir  "GENERATED_DIR" "${CMAKE_CURRENT_BINARY_DIR}" _optional_arguments _optional_arguments)

  list(LENGTH _optional_arguments _optional_arguments_length)

  if ("${_optional_arguments_length}" LESS 1)
    message(FATAL_ERROR "generate requires a list of files")
  endif()

  foreach(_file ${_optional_arguments})
    if(NOT ${_file} MATCHES ".*\\.in$")
      message(FATAL_ERROR "Generate input file '${_file} does not end with '.in'")
    else()
      list(APPEND _outlist ${_file})

      # First ensure the path is absolute
      if(NOT "${_file}" MATCHES "^${_root_dir}")
        set(_file "${CMAKE_CURRENT_SOURCE_DIR}/${_file}")
      endif()

      # Convert to relative path
      print_message("Converting '${_file}' to relative path")
      file(RELATIVE_PATH _relative_file ${_root_dir} ${_file})
      print_message("Relative path is '${_relative_file}'")

      string(REGEX REPLACE "\\.in$" "" _outfile ${_relative_file})
      set(_outfile ${_gen_dir}/${_outfile})
      list(APPEND _outlist ${_outfile})

      print_message("Generated file is '${_outfile}'")

      configure_file(${_file} ${_outfile})
    endif()
  endforeach()

  print_list(_outlist)
  set(${outlist} ${_outlist} PARENT_SCOPE)
endfunction()

function(generate_target_files target)
  set(DEBUG_CMAKE OFF)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "First argument expected to be a TARGET.")
  else()
    print_message("Adding sources to '${target}'")
  endif()

  generate(_my_files ${ARGN})
  foreach(_file ${_my_files})
    print_message("Adding '${_file}'")
  endforeach()

  target_sources(${target} PRIVATE ${_my_files})
endfunction()
