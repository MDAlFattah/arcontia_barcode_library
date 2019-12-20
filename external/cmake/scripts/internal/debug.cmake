# =================================================================================================
# debug.cmake
# v 0.2
#
# Changelog:
#
# v 0.2:
#   Added `print_target_properties`.
#
# Defines debug functions for working with cmake scripts.
#
# print(<variable>)
#   Print the variable name and contents. If the variable contains semicolons it will be treated as
#   a list. Each list element will be printed on a new line.
#
# print_string(<variable>)
#   Print the variable name and contents as a string.
#
# print_list(<variable>)
#   Print the variable name and contents as a list.
#
# print_message(<variable>)
#   Print the variable contents as a string.
#
# print_target_properties(<target>)
#   Print the properties of the target.
# =================================================================================================

function(print_string _string_variable_to_print)
  if(DEBUG_CMAKE)
    message(STATUS "${_string_variable_to_print}:")
    message("       ${${_string_variable_to_print}}")
  endif()
endfunction()

function(print_list _list_variable_to_print)
  if(DEBUG_CMAKE)
    message(STATUS "${_list_variable_to_print}:")
    foreach(_entry ${${_list_variable_to_print}})
      message("       ${_entry}")
    endforeach()
  endif()
endfunction()

function(print _variable_to_print)
  if(${_variable_to_print} MATCHES ".*;.*")
    print_list(${_variable_to_print})
  else()
    print_string(${_variable_to_print})
  endif()
endfunction()

function(print_message _variable_to_print)
  if(DEBUG_CMAKE)
    if(DEFINED ${_variable_to_print})
      message(${${_variable_to_print}})
    else()
      message(${_variable_to_print})
    endif()
  endif()
endfunction()

function(print_target_properties target)
  foreach(property_name
      ALIASED_TARGET
      ANDROID_ANT_ADDITIONAL_OPTIONS
      ANDROID_API
      ANDROID_API_MIN
      ANDROID_ARCH
      ANDROID_ASSETS_DIRECTORIES
      ANDROID_GUI
      ANDROID_JAR_DEPENDENCIES
      ANDROID_JAR_DIRECTORIES
      ANDROID_JAVA_SOURCE_DIR
      ANDROID_NATIVE_LIB_DEPENDENCIES
      ANDROID_NATIVE_LIB_DIRECTORIES
      ANDROID_PROCESS_MAX
      ANDROID_PROGUARD
      ANDROID_PROGUARD_CONFIG_PATH
      ANDROID_SECURE_PROPS_PATH
      ANDROID_SKIP_ANT_STEP
      ANDROID_STL_TYPE
      ARCHIVE_OUTPUT_DIRECTORY
      ARCHIVE_OUTPUT_NAME
      AUTOGEN_TARGET_DEPENDS
      AUTOMOC_MOC_OPTIONS
      AUTOMOC
      AUTOUIC
      AUTOUIC_OPTIONS
      AUTORCC
      AUTORCC_OPTIONS
      BINARY_DIR
      BUILD_WITH_INSTALL_RPATH
      BUNDLE_EXTENSION
      BUNDLE
      C_EXTENSIONS
      C_STANDARD
      C_STANDARD_REQUIRED
      COMPATIBLE_INTERFACE_BOOL
      COMPATIBLE_INTERFACE_NUMBER_MAX
      COMPATIBLE_INTERFACE_NUMBER_MIN
      COMPATIBLE_INTERFACE_STRING
      COMPILE_DEFINITIONS
      COMPILE_FEATURES
      COMPILE_FLAGS
      COMPILE_OPTIONS
      COMPILE_PDB_NAME
      COMPILE_PDB_OUTPUT_DIRECTORY
      CROSSCOMPILING_EMULATOR
      CXX_EXTENSIONS
      CXX_STANDARD
      CXX_STANDARD_REQUIRED
      DEBUG_POSTFIX
      DEFINE_SYMBOL
      DEPLOYMENT_REMOTE_DIRECTORY
      EchoString
      ENABLE_EXPORTS
      EXCLUDE_FROM_ALL
      EXCLUDE_FROM_DEFAULT_BUILD
      EXPORT_NAME
      FOLDER
      Fortran_FORMAT
      Fortran_MODULE_DIRECTORY
      FRAMEWORK
      FRAMEWORK_VERSION
      GENERATOR_FILE_NAME
      GNUtoMS
      HAS_CXX
      IMPLICIT_DEPENDS_INCLUDE_TRANSFORM
      IMPORTED_CONFIGURATIONS
      IMPORTED_IMPLIB
      IMPORTED_LINK_DEPENDENT_LIBRARIES
      IMPORTED_LINK_INTERFACE_LANGUAGES
      IMPORTED_LINK_INTERFACE_LIBRARIES
      IMPORTED_LINK_INTERFACE_MULTIPLICITY
      IMPORTED_LOCATION
      IMPORTED_NO_SONAME
      IMPORTED
      IMPORTED_SONAME
      IMPORT_PREFIX
      IMPORT_SUFFIX
      INCLUDE_DIRECTORIES
      INSTALL_NAME_DIR
      INSTALL_RPATH
      INSTALL_RPATH_USE_LINK_PATH
      INTERFACE_AUTOUIC_OPTIONS
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_COMPILE_FEATURES
      INTERFACE_COMPILE_OPTIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
      INTERFACE_POSITION_INDEPENDENT_CODE
      INTERFACE_SOURCES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES
      INTERPROCEDURAL_OPTIMIZATION
      IOS_INSTALL_COMBINED
      JOB_POOL_COMPILE
      JOB_POOL_LINK
      LABELS
      <LANG>_CLANG_TIDY
      <LANG>_COMPILER_LAUNCHER
      <LANG>_INCLUDE_WHAT_YOU_USE
      <LANG>_VISIBILITY_PRESET
      LIBRARY_OUTPUT_DIRECTORY
      LIBRARY_OUTPUT_NAME
      LINK_DEPENDS_NO_SHARED
      LINK_DEPENDS
      LINKER_LANGUAGE
      LINK_FLAGS
      LINK_INTERFACE_LIBRARIES
      LINK_INTERFACE_MULTIPLICITY
      LINK_LIBRARIES
      LINK_SEARCH_END_STATIC
      LINK_SEARCH_START_STATIC
      LINK_WHAT_YOU_USE
      LOCATION
      MACOSX_BUNDLE_INFO_PLIST
      MACOSX_BUNDLE
      MACOSX_FRAMEWORK_INFO_PLIST
      MACOSX_RPATH
      NAME
      NO_SONAME
      NO_SYSTEM_FROM_IMPORTED
      OSX_ARCHITECTURES
      OUTPUT_NAME
      PDB_NAME
      PDB_OUTPUT_DIRECTORY
      POSITION_INDEPENDENT_CODE
      PREFIX
      PRIVATE_HEADER
      PROJECT_LABEL
      PUBLIC_HEADER
      RESOURCE
      RULE_LAUNCH_COMPILE
      RULE_LAUNCH_CUSTOM
      RULE_LAUNCH_LINK
      RUNTIME_OUTPUT_DIRECTORY
      RUNTIME_OUTPUT_NAME
      SKIP_BUILD_RPATH
      SOURCE_DIR
      SOURCES
      SOVERSION
      STATIC_LIBRARY_FLAGS
      SUFFIX
      TYPE
      VERSION
      VISIBILITY_INLINES_HIDDEN
      VS_CONFIGURATION_TYPE
      VS_DESKTOP_EXTENSIONS_VERSION
      VS_DOTNET_REFERENCES
      VS_DOTNET_TARGET_FRAMEWORK_VERSION
      VS_GLOBAL_KEYWORD
      VS_GLOBAL_PROJECT_TYPES
      VS_GLOBAL_ROOTNAMESPACE
      VS_GLOBAL_<variable>
      VS_IOT_EXTENSIONS_VERSION
      VS_IOT_STARTUP_TASK
      VS_KEYWORD
      VS_MOBILE_EXTENSIONS_VERSION
      VS_SCC_AUXPATH
      VS_SCC_LOCALPATH
      VS_SCC_PROJECTNAME
      VS_SCC_PROVIDER
      VS_SDK_REFERENCES
      VS_WINDOWS_TARGET_PLATFORM_MIN_VERSION
      VS_WINRT_COMPONENT
      VS_WINRT_EXTENSIONS
      VS_WINRT_REFERENCES
      WIN32_EXECUTABLE
      WINDOWS_EXPORT_ALL_SYMBOLS
      XCODE_ATTRIBUTE_<an-attribute>
      XCTEST
      )
    get_target_property(prop ${target} ${property_name})
    if(NOT "${prop}" MATCHES "prop-NOTFOUND")
      message(STATUS "${property_name}: ${prop}")
    endif()
  endforeach()
endfunction()
