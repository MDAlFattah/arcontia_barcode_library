#include "catch.hpp"
#include "fakeit.hpp"

#include "IArcbSerialCommunication.h"
#include "Arcontia_BarcodeScanner.h"
#include "LoggerCout.h"

SCENARIO( "opening port failed", "[arcb]" ) 
{
    using namespace fakeit;

    Mock<IArcbSerialCommunication> mock;

    //tell fakeit how to mock open function
    When(Method(mock,open)).Return(false);
    
    Arcontia_BarcodeScanner scanner(mock.get());

    IBarcodeLogger::SharedPtr logger = new LoggerCout();

    scanner.setBarcodeLogger(logger);

    REQUIRE(scanner.open() == BARCODE_ERROR);
}



