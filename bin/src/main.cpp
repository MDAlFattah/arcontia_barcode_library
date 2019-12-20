#include <iostream>
#include "Arcontia_BarcodeScanner.h"
#include "ArcbSerialCommunication.h"
#include "LoggerCout.h"
#include <thread>
#include <chrono>

int main(int argc, char** argv) 
{
    IBarcodeLogger::SharedPtr logger = new LoggerCout();      //creating logger obj

    std::vector<unsigned char> data;

    ArcbSerialCommunication arcbscom;

    Arcontia_BarcodeScanner scanner(arcbscom);        // You need to define the function with the exact same argument types as in the base class.
    
    scanner.setBarcodeLogger(logger);

    int choice;
    
    std::cout << "\n\tPlease choose your condition: " << '\n';
    std::cout << "\t\t1) Stopping bus (DAY)" << '\n' << "\t\t2) Running bus (DAY)" << '\n';
    std::cout << "\t\t3) Stopping bus (NIGHT)" << '\n' << "\t\t4) Running bus (NIGHT)" << '\n';
    std::cout << "\n\tCondition (Press 1 or 2 or 3 or 4): ";
    std::cin >> choice;

    scanner.open();
    scanner.enableScanning();
    scanner.isScanning();
    
    scanner.OperationMode(choice);

    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    scanner.isBarcodeToRead();
    scanner.readBarcode(data);
    std::cout<< data;
    

    return 0;
    
}