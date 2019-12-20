cmake_minimum_required(VERSION 3.6)

project(barcodearcontiademo LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../external/cmake/scripts")

include(multi_option)
add_multi_option(PLATFORM
                 WIN LV700)

if(NOT DEFINED PLATFORM)
  set(PLATFORM "LV700")
  message(STATUS "PLATFORM not set. Using LV700 as default.")
endif()

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

if(PLATFORM STREQUAL "LV700")
        add_library(Arcb IMPORTED SHARED)
        set_target_properties(Arcb PROPERTIES IMPORTED_LOCATION "/opt/lecip/lv-700/Arcb/libArcb-4.5.0-GNU-6.2.0-Linux-x86_64.so")
        include_directories(
          "/opt/lecip/lv-700/Arcb/include/Export"
          "${CMAKE_CURRENT_SOURCE_DIR}/src/include"
          "${CMAKE_CURRENT_SOURCE_DIR}/../arcontia_barcodelib/lib/src"
          "${CMAKE_CURRENT_SOURCE_DIR}/../external"
          "${CMAKE_CURRENT_SOURCE_DIR}/../external/barcodescannerinterface"
          "${CMAKE_CURRENT_SOURCE_DIR}/../lib/src/include"

          )
else()
        find_package(Arcb 4.5.2 REQUIRED)
endif()

add_executable(${PROJECT_NAME}
../lib/src/Arcontia_BarcodeScanner.cpp
#../lib/src/Barcodes.cpp
src/main.cpp
)

target_compile_definitions(
  ${PROJECT_NAME}
  PUBLIC
  $<$<STREQUAL:${PLATFORM},WIN>:PLATFORM_WIN>
  $<$<STREQUAL:${PLATFORM},LV700>:PLATFORM_LV700>
)

target_link_libraries(${PROJECT_NAME} Arcb)

set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED YES
)
