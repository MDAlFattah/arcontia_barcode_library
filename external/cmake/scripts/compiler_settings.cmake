# =================================================================================================
# compiler_settings.cmake
# v 0.1
#
# Defines helper functions for setting the compiler flags for LECIP Arcontia C++ projects.
# =================================================================================================

include(${CMAKE_CURRENT_LIST_DIR}/internal/debug.cmake)

function(set_warnings target)
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  target_compile_options(${target} PRIVATE "/W3" "/WX")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  target_compile_options(${target} PRIVATE "-Wall" "-Werror" "-Wextra")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  target_compile_options(${target} PRIVATE "-Wall" "-Werror" "-Wextra")
else()
  message(FATAL_ERROR "problem activating \"Warnings\" as \"Errors\" for project \"${target}\". \"${CMAKE_CXX_COMPILER_ID}\" compiler not supported.")
endif()
endfunction()