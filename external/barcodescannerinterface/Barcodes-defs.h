#ifndef BARCODES_DEFS_H
#define BARCODES_DEFS_H

#include <b4dll.h>
#ifdef BUILDING_BARCODE_DLL
#define BARCODE_DLL_EXPORT DLLEXPORT
#else
#define BARCODE_DLL_EXPORT DLLIMPORT
#endif

// Return codes
const long BARCODE_OK               = 0;
const long BARCODE_ERROR            = 1;
const long BARCODE_NO_DEVICE        = 2;
const long BARCODE_NOT_OPEN         = 3;
const long BARCODE_ALREADY_OPEN     = 4;
const long BARCODE_NOT_SCANNING     = 5;
const long BARCODE_ALREADY_SCANNING = 6;
const long BARCODE_NO_DATA          = 7;
const long BARCODE_NOT_IMPLEMENTED  = 8;
const long BARCODE_NO_PRPOFILE      = 9;

// Device types

// 5x80 imager as used on G3 devices with a ticket scanner configuration
const long BARCODE_DEVTYPE_5x80_TICKET_SCANNER = 0; 
// 5x80 imager as used on G3 devices with a paper tracker configuration
const long BARCODE_DEVTYPE_5x80_PAPER_TRACKER = 1; 
// 5x80 imager as used on Validator devices with a ticket scanner configuration
const long BARCODE_DEVTYPE_VALIDATOR_5x80_TICKET_SCANNER = 2; 
// 5x80 imager as used on Printer 2 devices with a ticket scanner configuration
const long BARCODE_DEVTYPE_PRINTER_5x80_TICKET_SCANNER = 3; 
// Casio imager - used for now only in IT9000 as ticket scanner
const long BARCODE_DEVTYPE_CASIO_TICKET_SCANNER = 4;
// Android JNI-based scanner. Specific class is given via device name
const long BARCODE_DEVTYPE_JNI_SCANNER = 5;


#endif
