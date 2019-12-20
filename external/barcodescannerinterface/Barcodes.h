#pragma once
#include "Barcodes-defs.h"

/** 
 *  @brief Exported functions for the Barcodes module.
 *
 *  This header contains the functions that are accessible by the user outside of the DLL.
 */

class IBarcodeScanner;

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Instantiate and return a particular barcode scanner.
 *
 * @param[out]  scanner             A reference to a pointer that will contain the instance's address.
 * @param[in]   deviceName          The device name to open, if applicable.
 * @param[in]   deviceType          The desired device type.
 *
 * @retval  BARCODE_OK              Instantiation OK. The given reference now contains a pointer to the created instance.
 * @retval  BARCODE_NO_DEVICE       The requested device does not exist.
 * @retval  BARCODE_ALREADY_OPEN    The requested device is already in use.
 *
 * @remark Only one instance of any given device number per DLL instance is allowed at all times.
 */
long BARCODE_DLL_EXPORT createBarcodeScanner(IBarcodeScanner*& scanner, const char* deviceName, long deviceNumber);
typedef long (*pfCreateBarcodeScanner_t)(IBarcodeScanner*&, const char*, long);

/**
 * @brief Dispose of the given barcode scanner instance.
 *
 * @retval  BARCODE_OK              Disposal okay. The given reference now contains a NULL pointer.
 * @retval  BARCODE_NO_DEVICE       The given reference contains a pointer to an unknown or not-opened device.
 */
long BARCODE_DLL_EXPORT releaseBarcodeScanner(IBarcodeScanner*& scanner);
typedef long (*pfReleaseBarcodeScanner_t)(IBarcodeScanner*&);

#ifdef __cplusplus
}
#endif
