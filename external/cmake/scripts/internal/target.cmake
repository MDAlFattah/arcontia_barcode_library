# =================================================================================================
# target.cmake
# v 0.1
#
# append_target_sources(<outlist> <target>)
#   Add the source files from <target> to the <list>.
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/filetype.cmake)

function(append_target_sources file_list target)
  set(DEBUG_CMAKE OFF)

  get_target_property(all_files ${target} SOURCES)
  get_target_property(_append_target_sources_source_dir ${target} SOURCE_DIR)
  get_target_property(_append_target_sources_binary_dir ${target} BINARY_DIR)

  # We only want to apply formatting to C++ files.
  foreach(item ${all_files})
    is_source_file(${item} _is_source)
    is_header_file(${item} _is_header)
    is_source_config_file(${item} _is_source_config)
    is_header_config_file(${item} _is_header_config)
    is_generated_file(${item} _is_generated_file
                      ROOT_DIR ${_append_target_sources_source_dir}
                      GENERATED_DIR ${_append_target_sources_binary_dir})
    if(NOT _is_generated_file)
      if(_is_source OR _is_header OR _is_source_config OR _is_header_config)
        if (NOT IS_ABSOLUTE ${item})
          set(item "${_append_target_sources_source_dir}/${item}")
        endif()

        if (NOT EXISTS ${item})
          message(FATAL_ERROR "append_target_sources could not find file: ${item}")
        endif()

        # We convert to relative directoy to try and prevent really long file lists that exceed the
        # limit of 8192 characters on Windows.
        file(RELATIVE_PATH stripped_item ${CMAKE_CURRENT_SOURCE_DIR} ${item})
        list(APPEND ${file_list} ${stripped_item})
      else()
        if(item MATCHES "\\$<" OR item MATCHES ">$")
          print_message("Ignoring generator expression: ${item}")
        else()
          print_message("Will not format ${item}")
        endif()
      endif()
    else()
      print_message("Ignoring generated file: ${item}")
    endif()
  endforeach()

  set(${file_list} ${${file_list}} PARENT_SCOPE)
endfunction()
