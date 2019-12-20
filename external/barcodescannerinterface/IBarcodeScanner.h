#pragma once

#include "IBarcodeLogger.h"
#include "Barcodes-defs.h"
#include <vector>

// Generic interface for barcode scanners.
class /* BARCODE_DLL_EXPORT */ IBarcodeScanner {
    public:
        virtual ~IBarcodeScanner() { };

        /**
         * @brief Contact and configure the scanner
         *
         * Turns on, establishes contact with and configures the barcode scanner.
         *
         * The configuration parameters used (e.g. port, baudrate and so on) must be
         * set in an implementation-specific manner.
         *
         * @retval  BARCODE_OK              No error
         * @retval  BARCODE_ALREADY_OPEN    Device already open.
         * @retval  BARCODE_NO_DEVICE       No device found or available.
         * @retval  BARCODE_ERROR           Problem encountered during the configuration.
         */
        virtual long open()=0;

        /**
         * @brief Deactivate and break contact with the scanner.
         *
         * Turns the scanner off and breaks contact. If scanning is active,
         * it must be deactivated. Previously-read barcodes are kept in the input queue.
         *
         * @retval  BARCODE_OK              No error
         * @retval  BARCODE_NOT_OPEN        Device not open.
         * @retval  BARCODE_ERROR           Problem encountered during closing.
         */
        virtual long close()=0;

        /**
         * @brief Activate scanner
         *
         * Turns on the barcode scanner.
         * After calling this method, the device must be ready and spontaneously
         * starts scanning barcodes presented to it.
         * Ticketbox: Function is called at Schichtbeginn.
         * IT9000: Function is called when key is pressed.
         * @retval  BARCODE_OK                  No error
         * @retval  BARCODE_NOT_OPEN            Device not open.
         * @retval  BARCODE_ALREADY_SCANNING    Scanning already active.
         * @retval  BARCODE_ERROR               Problem encountered during the configuration.
         */
        virtual long enableScanning()=0;

        /**
         * @brief Deactivate scanner
         *
         * Turns off the barcode scanner. After calling this method, the device must
         * no longer spontaneously scan barcodes presented to it.
         * Ticketbox: Function is called at Schichtende.
         * IT9000: Function is called when key is released.
         * Any visible signs of operation (LED lighting and so on) must be turned off.
         *
         * @retval  BARCODE_OK              No error
         * @retval  BARCODE_NOT_SCANNING    Scanning not enabled, nothing to disable.
         * @retval  BARCODE_ERROR           Problem encountered during the closing.
         */
        virtual long disableScanning()=0;

        /**
         * @brief Check whether scanning is active.
         *
         * @returns \a true if scanning is active, \a false otherwise.
         */
        virtual bool isScanning()=0;

        /**
         * @brief Check whether there is any data to read in the input queue.
         *
         * @returns \a true if barcode data is available, \a false otherwise.
         */
        virtual bool isBarcodeToRead()=0;

        /**
         * @brief Read barcode data.
         *
         * If barcode data is available in the input queue, a pointer to
         * the first entry of the queue is returned in \a barcode. The buffer
         * remains valid until the next call to the function.
         *
         * @param[out]  barCode         Pointer to the read barcode data.
         * @param[out]  readLength      Length of the read barcode.
         *
         * @retval  BARCODE_OK          No error
         * @retval  BARCODE_NO_DATA     No data available
         */
/*        virtual long readBarcode(unsigned char*& barcode, size_t& readLength)=0; */

		/**
         * @brief Read barcode data.
         *
         * If barcode data is available in the input queue, the read Data is returned in barcode.
         *
         * @param[out]  barcode         Vector containing the read barcode data.
         *
         * @retval  BARCODE_OK          No error
         * @retval  BARCODE_NO_DATA     No data available
         */
		virtual long readBarcode(std::vector<unsigned char>& barcode)=0;



        /**
         * @brief Flush the barcode queue.
         *
         * Any barcode data currently in the input queue is discarded.
         */
        virtual void flushInputQueue()=0;

        /**
         * @brief Get the used device name.
         *
         * Used internally by the Barcode DLL. Can be called by the user for logging purposes.
         *
         * Contains the device name as given to the factory.
         */
       // virtual const char* getDeviceName()=0;

		virtual void setBarcodeLogger(IBarcodeLogger::SharedPtr logger)=0;

        virtual void OperationMode(int choice)=0;

};

