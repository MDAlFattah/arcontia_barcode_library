# =================================================================================================
# qt.cmake
# v 0.2
#
# Changelog:
#
# v 0.2:
#   Added `find_qt_components` to help with supporting both Qt4 and Qt5.
#
# Defines helper functions for working with Qt and CMake.
#
# find_qt_components(<outlist> [component ..] [QT4 | QT5])
#   Find the Qt components specified and return them as a list.
#   If the build system detects that Qt4 has already been added, then it will find Qt4 components.
#   Otherwise it will find Qt5 components.
#   This behaviour can be overriden by passing an explicit QT4 or QT5 parameter.
#
# build_qt5_targets_list(<target> <outlist>)
#   Inspect the <target> to determine which Qt5 libraries it depends on.
#   <outlist> will contain a list of the dependant Qt5 targets.
#
# build_qt5_runtime_libraries_list(<target> <outlist>)
#   Inspect the <target> to determine which Qt5 libraries it depends on.
#   <outlist> will contain a list of the dependant Qt5 runtime libraries.
#
# build_qt5_runtime_directories_list(<target> <outlist>)
#   Inspect the <target> to determine which Qt5 libraries it depends on.
#   <outlist> will contain a list of the directories containing the Qt5 runtime libraries.
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/internal/debug.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/get_optional.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/internal/qt_helpers.cmake)

macro(find_qt_components components)
  set(_arguments "${ARGN}")
  get_optional_flag(is_qt4 "QT4" _arguments _arguments)
  get_optional_flag(is_qt5 "QT5" _arguments _arguments)

  unset(_components)
  if (is_qt4)
    find_qt4_components(_components ${_arguments})
  elseif(is_qt5)
    find_qt5_components(_components ${_arguments})
  elseif(Qt4_FOUND)
    message(STATUS "Qt4 dependency found. Defaulting to Qt4.")
    find_qt4_components(_components ${_arguments})
  else()
    message(STATUS "No Qt dependency found. Defaulting to Qt5.")
    find_qt5_components(_components ${_arguments})
  endif()

  set(${components} ${_components})
endmacro()

function(build_qt5_targets_list target outlist)
  unset(_qt_libs)

  get_target_property(_linked_libraries ${target} LINK_LIBRARIES)
  list(LENGTH _linked_libraries _length)
  while("${_length}" GREATER 0)
    foreach(_current_lib ${_linked_libraries})
      if("${_current_lib}" MATCHES "^Qt5.*")
        # This is a Qt5 library. Add it to our list.
        list(APPEND _qt_libs "${_current_lib}")

        # Check this library's dependencies.
        get_target_property(_dependant_libraries ${_current_lib} INTERFACE_LINK_LIBRARIES)
        foreach(_dependant_lib ${_dependant_libraries})
          # Check that we have not already had this dependency.
          if(NOT _dependant_lib IN_LIST _qt_libs AND NOT _dependant_lib IN_LIST _linked_libraries)
            # Add this to the main list for the next iteration.
            list(APPEND _linked_libraries ${_dependant_lib})
          endif()
        endforeach()
      endif()

      # Remove this library from the main list.
      list(REMOVE_ITEM _linked_libraries "${_current_lib}")
    endforeach()

    # Regenerate _length for the while loop.
    list(LENGTH _linked_libraries _length)
  endwhile()

  set(${outlist} ${_qt_libs} PARENT_SCOPE)
endfunction()

function(build_qt5_runtime_libraries_list target outlist)
  unset(_runtime_libraries)

  build_qt5_targets_list(${target} qt_libs)
  foreach(library ${qt_libs})
    string(TOUPPER "LOCATION_${CMAKE_BUILD_TYPE}" _property)
    get_target_property(_runtime ${library} "${_property}")
    list(APPEND _runtime_libraries ${_runtime})
  endforeach()
  set(${outlist} ${_runtime_libraries} PARENT_SCOPE)
endfunction()

function(build_qt5_runtime_directories_list target outlist)
  unset(_runtime_dirs)

  build_qt5_runtime_libraries_list(${target} qt_libs)
  foreach(lib ${qt_libs})
    string(REGEX REPLACE "/[^/]*$" "" _dir ${lib})
    list(APPEND _runtime_dirs ${_dir})
  endforeach()
  list(REMOVE_DUPLICATES _runtime_dirs)
  set(${outlist} ${_runtime_dirs} PARENT_SCOPE)
endfunction()
