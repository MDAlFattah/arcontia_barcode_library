# =================================================================================================
# qt_helpers.cmake
# v 0.1
#
# Defines helper functions for qt.cmake
# =================================================================================================

macro(find_qt4_components components)
  set_qt_variables()
  unset(_components)
  foreach(arg ${ARGN})
    list(APPEND _components "Qt${arg}")
  endforeach()
  find_package(Qt4 COMPONENTS ${_components} REQUIRED)
  include(${QT_USE_FILE})

  unset(${components})
  foreach(arg ${ARGN})
    list(APPEND ${components} "${QT_LIBRARIES}")
  endforeach()
endmacro()

macro(find_qt5_components components)
  set_qt_variables()
  find_package(Qt5 COMPONENTS ${ARGN} REQUIRED)

  unset(${components})
  foreach(arg ${ARGN})
    list(APPEND ${components} "Qt5::${arg}")
  endforeach()
endmacro()

macro(set_qt_variables)
  set(CMAKE_AUTOMOC ON)
  set(CMAKE_AUTOUIC ON)
  set(CMAKE_AUTORCC ON)
  set(CMAKE_INCLUDE_CURRENT_DIR ON)
endmacro()
