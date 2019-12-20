cmake_minimum_required(VERSION 3.0)

project(barcodelib_tests LANGUAGES CXX)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

project(helloworld_cmake)

include_directories(
		"${PROJECT_SOURCE_DIR}/../../external"
		"${PROJECT_SOURCE_DIR}/../../external/catch2"
		"${PROJECT_SOURCE_DIR}/../../external/fakeit"
		"${PROJECT_SOURCE_DIR}/../../external/barcodescannerinterface"
		"${PROJECT_SOURCE_DIR}/../../lib/src/include"
		"${PROJECT_SOURCE_DIR}/../../bin/src/"
		)

add_executable(${PROJECT_NAME}
	src/main.cpp
	src/test_IBarcodeScanner.cpp

	"${PROJECT_SOURCE_DIR}/../src/Arcontia_BarcodeScanner.cpp"
	)
