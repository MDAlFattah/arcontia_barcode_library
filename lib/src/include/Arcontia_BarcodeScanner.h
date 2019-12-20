#pragma once
#include <string>
#include <deque>
#include <vector>
#include "IBarcodeScanner.h"
#include "IArcbSerialCommunication.h"

class Arcontia_BarcodeScanner : public IBarcodeScanner {
    public:
        Arcontia_BarcodeScanner(IArcbSerialCommunication & scanneraccess); 
        // Implementation of IBarcodeScanner
        ~Arcontia_BarcodeScanner();
        long open() final;
        long close() final;
        long enableScanning() final;
        long disableScanning() final;
        bool isScanning() final;
        bool isBarcodeToRead() final;
        long readBarcode(std::vector<unsigned char>& data) final;
        void flushInputQueue() final;
		void setBarcodeLogger(IBarcodeLogger::SharedPtr logger) final;
        void OperationMode(int choice);

    private:
        IArcbSerialCommunication & scanneraccess;
        //serial port nameIScannerAccess
        std::string pName;  
        unsigned int bRate;  
        /// Whether the device is currently open (and configured) or not.
        bool openPort;
        /// Whether the scanner is currently active (scanIScannerAccessning) or not.
        bool scanning;
        //if there is any barcode data to read
        bool found;     
        //to store badcode data
        std::vector<uint8_t> lastscannedbarcode;
        //to store the barcode value
        std::vector<uint8_t> answer;
		//log message
        IBarcodeLogger::SharedPtr logger;
};






