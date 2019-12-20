#include "Barcodes.h"
#include "Arcontia_BarcodeScanner.h"

long createBarcodeScanner(IBarcodeScanner*& scanner, const char* deviceName, long deviceNumber) {
    scanner = new Arcontia_BarcodeScanner();
    return 0;
}

long releaseBarcodeScanner(IBarcodeScanner*& scanner) {
    delete scanner;
    return 0;
}
