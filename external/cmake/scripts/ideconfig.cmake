# =================================================================================================
# ideconfig.cmake
# v 0.4
#
# Changelog:
#
# v 0.4:
#   setup_source_groups learnt about QRC files.
#
# v 0.3:
#   Added the `add_target_vs_runtime_paths` function.
#
# v 0.2:
#   `setup_source_groups` learned to detect Qt UI files and place them in the top level IDE
#   directory 'Qt UI Files'. If the file is in SOURCE_DIR this will be stripped from the path.
#   Otherwise only ROOT_DIR will be stripped.
#
# Defines helper functions for configuring the IDE settings for LECIP Arcontia C++ projects.
#
# This file can be included in a CMakeLists.txt file using the command:
#   include(${PATH_TO_FILE}/ideconfig.cmake)
#
# setup_source_groups(
#          <target_name>
#          [ROOT_DIR <dir>]
#          [GENERATED_DIR <dir>]
#          [SOURCE_DIR <dir>]
#          [HEADER_DIR <dir>]
#          [RESOURCE_DIR <dir>])
#   Setup the IDE folder structure to reflect the filesystem layout.
#
#   Target files are assumed to exist relative to the ROOT_DIR.
#   If ROOT_DIR is not provided it is assumend to be ${CMAKE_CURRENT_SOURCE_DIR}
#
#   CMake generated files are assumed to exist below GENERATED_DIR.
#   If GENERATED_DIR is not provided it is assumend to be ${CMAKE_CURRENT_BINARY_DIR}
#
#   Source files are organised relative to the directory ROOT_DIR/SOURCE_DIR.
#   If SOURCE_DIR is not provided it is assumend to be "source". In this case, files will be
#   organized into the 'Source Files' folder.
#
#   Header files are organised relative to the directory ROOT_DIR/HEADER_DIR.
#   If HEADER_DIR is not provided it is assumend to be "include". In this case, files will be
#   organized into the 'Header Files' folder.
#
#   Qt Resource files are organised relative to the directory ROOT_DIR/RESOURCE_DIR.
#   If RESOURCE_DIR is not provided it is assumend to be "resources". In this case, files will be
#   organized into the 'Qt Resource Files' folder.
#
# add_target_vs_runtime_paths(<target> <list>)
#   Add the <list> of paths to the runtime path for <target> in the VS project.
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/generate.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/debug.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/filetype.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/get_optional.cmake)

# ================
# Helper functions
# ================

function(place_file filename filesystem_prefix no_extra_folder extra_folder_name)
  set(DEBUG_CMAKE OFF)

  if(filesystem_prefix)
    string(REGEX REPLACE "^${filesystem_prefix}/*" "" _file "${filename}")
  else()
    set(_file ${filename})
  endif()

  # Create a list of the folders.
  string(REGEX MATCHALL "([^/])+" folders "${_file}")
  list(REMOVE_AT folders -1)

  list(LENGTH folders folder_depth)
  if(NOT ${no_extra_folder} OR folder_depth EQUAL 0)
    list(INSERT folders 0 ${extra_folder_name})
  endif()

  # Convert from a list to an IDE folder string.
  string(REPLACE ";" "\\\\" _ide_folder "${folders}")

  print_message("Placing file '${filename}' into IDE folder '${_ide_folder}'")

  source_group(${_ide_folder} FILES "${filename}")
endfunction()

# ================
# User functions
# ================

function(setup_source_groups target_name)
  set(_optional "${ARGN}")
  get_optional(_root_dir "ROOT_DIR"      "${CMAKE_CURRENT_SOURCE_DIR}" _optional _optional)
  get_optional(_gen_dir  "GENERATED_DIR" "${CMAKE_CURRENT_BINARY_DIR}" _optional _optional)
  get_optional(_src_dir  "SOURCE_DIR"    "source"                      _optional _optional)
  get_optional(_inc_dir  "HEADER_DIR"    "include"                     _optional _optional)
  get_optional(_res_dir  "RESOURCE_DIR"  "resources"                   _optional _optional)

  set(DEBUG_CMAKE OFF)
  print(_root_dir)
  print(_gen_dir)
  print(_src_dir)
  print(_inc_dir)
  print(_res_dir)

  if("${_src_dir}" STREQUAL "source")
    set(_no_src_folder OFF)
  else()
    set(_no_src_folder ON)
  endif()

  if("${_inc_dir}" STREQUAL "include")
    set(_no_inc_folder OFF)
  else()
    set(_no_inc_folder ON)
  endif()

  if("${_res_dir}" STREQUAL "resources")
    set(_no_res_folder OFF)
  else()
    set(_no_res_folder ON)
  endif()

  set(_gen_src_dir "${_gen_dir}/${_src_dir}")
  set(_gen_inc_dir "${_gen_dir}/${_inc_dir}")
  set(_src_dir "${_root_dir}/${_src_dir}")
  set(_inc_dir "${_root_dir}/${_inc_dir}")
  set(_res_dir "${_root_dir}/${_res_dir}")

  print(_gen_src_dir)
  print(_gen_inc_dir)
  print(_src_dir)
  print(_inc_dir)
  print(_res_dir)

  get_target_property(all_files ${target_name} SOURCES)

  foreach(file IN LISTS all_files)
    if (NOT IS_ABSOLUTE ${file})
      set(file "${CMAKE_CURRENT_SOURCE_DIR}/${file}")
    endif()

    is_generated_file("${file}" is_generated ROOT_DIR "${_root_dir}" GENERATED_DIR "${_gen_dir}")
    if(is_generated)
      is_in_dir(file ${_gen_src_dir} is_in_gen_src)
      is_in_dir(file ${_gen_inc_dir} is_in_gen_inc)
      if(is_in_gen_src)
        place_file("${file}" "${_gen_src_dir}" OFF "Generated Files")
      elseif(is_in_gen_inc)
        place_file("${file}" "${_gen_inc_dir}" OFF "Generated Files")
      else()
        place_file("${file}" "${_gen_dir}" OFF "Generated Files")
      endif()
    else()
      is_qt_ui_file(file is_qt_ui)
      is_qt_resource_file(file is_qt_resource)
      is_in_dir(file ${_src_dir} is_in_src)
      is_in_dir(file ${_inc_dir} is_in_inc)
      if(is_qt_ui)
        if(is_in_src)
          place_file(${file} ${_src_dir} OFF "Qt UI Files")
        else()
          place_file(${file} ${_root_dir} OFF "Qt UI Files")
        endif()
      elseif(is_qt_resource)
        place_file(${file} ${_res_dir} _no_res_folder "Qt Resource Files")
      elseif(is_in_src)
        place_file(${file} ${_src_dir} _no_src_folder "Source Files")
      elseif(is_in_inc)
        place_file(${file} ${_inc_dir} _no_inc_folder "Header Files")
      else()
        place_file(${file} ${_root_dir} OFF "Unknown")
      endif()
    endif()
  endforeach()
endfunction()

function(add_target_vs_runtime_paths target_name listvar)
  get_target_property(current_list ${target_name} VS_GLOBAL_LocalDebuggerEnvironment)
  set(list_prefix "PATH=%PATH%")
  if(current_list)
    if(NOT "${current_list}" MATCHES "^${list_prefix}.*")
      message(FATAL_ERROR "Unexpected target property. The VS_GLOBAL_LocalDebuggerEnvironment property of ${target_name} did not begin with ${list_prefix}.")
    endif()
  else()
    set(current_list "${list_prefix}")
  endif()

  list(APPEND current_list ${listvar})

  set_target_properties(
    ${target_name}
    PROPERTIES
    VS_GLOBAL_LocalDebuggerEnvironment "${current_list}"
  )
endfunction()
