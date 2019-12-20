#include "Arcontia_BarcodeScanner.h"
#include <iostream>
#include <stdexcept>
#include <vector>
#include <thread>
#include <chrono>
#include <string>
#include <iomanip>
#include "IArcbSerialCommunication.h"

#define BARCODE_OK 0;
#define BARCODE_ERROR 1;

Arcontia_BarcodeScanner::Arcontia_BarcodeScanner(IArcbSerialCommunication & scanneraccess) 
: scanneraccess(scanneraccess), openPort(false), scanning(false), pName("/dev/ttymxc3"), found(false), bRate(9600), answer(1024)
{
}

//Destructor implimentation
Arcontia_BarcodeScanner::~Arcontia_BarcodeScanner()
{
}
    
long Arcontia_BarcodeScanner::open()
{  
    if(!openPort)
    {   
        
        scanneraccess.open(pName, bRate);
        
        openPort = true;
        std::string const data = "0001010";	//disable all reading barcode first
        scanneraccess.write(data);

        if (logger)
        logger->logMessage("Open port created. \n");
        return BARCODE_OK;
    }
    else
    {
        if (logger)
            logger->logMessage("Open port failed!");
    }
    
    return 0;
}

long Arcontia_BarcodeScanner::close()
{
    scanneraccess.close();
    return 0;
}

long  Arcontia_BarcodeScanner::enableScanning()
{
        if(!openPort)
        {
            
            scanneraccess.open(pName, bRate);
           
            openPort = true;

            std::string const data = "0001040;0001060;0000160";	//enable 1d, 2d all and save the batch command
            scanneraccess.write(data);

            scanning = true;

            if (logger)
            logger->logMessage("Scanning is enabled."); 
        }
        else{
            std::string const data = "0001040;0001060;0000160";	//enable 1d, 2d all and save the batch command
            scanneraccess.write(data);
            scanning = true;

            if (logger)
            logger->logMessage("Scanning is enabled.");    
        
            return 0;

            }
    
}

long Arcontia_BarcodeScanner::disableScanning() 
{
     if (openPort)
     {
        std::string const data = "0001010";	//send disable all reading cmd
        scanneraccess.write(data);
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        logger->logMessage("Barcode Scanner is disabled.");
        openPort = false;
        found = false;
        scanning = false;

     }else
         logger->logMessage("Barcode Scanner is already disabled.");
        return 0;
    
}


bool Arcontia_BarcodeScanner::isScanning() 
{
    if(scanning)
    {
        logger->logMessage("Barcode scanner is scanning.");
        
    }
    else{
        logger->logMessage("Barcode scanner is not active. try enablescanning() first!");
        
        }
       return 0; 
}



bool Arcontia_BarcodeScanner::isBarcodeToRead() 
{
    
    if(scanning)
    {

        answer = scanneraccess.read();

        if(!answer.empty())
        {
            logger->logMessage("The scanner is on scanning mode!");
            found = true;   //scanner found something
        }
        else
        {   
            
            logger->logMessage("The Barcode Scanner is disabled. Please try enablescnanning() frist!");
            
        }
        
        return 0;
    }

}

long Arcontia_BarcodeScanner::readBarcode(std::vector<unsigned char>& data) 
{
    if (found)
    {
        logger->logMessage("new Barcode");
        data = answer;
        return BARCODE_OK;
    }
    else
    {
        logger->logMessage("No new Barcode");
        return BARCODE_ERROR;
    
    }

}

void  Arcontia_BarcodeScanner::setBarcodeLogger(IBarcodeLogger::SharedPtr logger) 
{
    this->logger = logger;
}

void Arcontia_BarcodeScanner::flushInputQueue() 
{

    scanneraccess.clearIoBuffers();
}


void Arcontia_BarcodeScanner::OperationMode(int choice) 
{
    switch(choice){
        case 1: {
    
            logger->logMessage("\nThis when the bus is stopping during DAY : \n") ;
           
    
            std::string const data = { "NLS0302010; NLS0200000; NLS0201000; NLS0312010;
             NLS0203010; NLS0203030; NLS0321010; NLS0000160"};  
            
            scanneraccess.write(data);
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        
            logger->logMessage("\tAuto reading mode");
            logger->logMessage("\tRed LED winking while reading");   
            logger->logMessage("\tGreen LED winking while reading");
            logger->logMessage("\tCamera sensitivity to Normal");
            logger->logMessage("\tDecoding sound ON");      
            logger->logMessage("\tHigh volume");
            logger->logMessage("\tReflection Eliminating Mode Activated");
            logger->logMessage("\tSaving configuration\n");
            

            break;
        }
    
        case 2: {
    
            logger->logMessage("\nThis when the bus is running during DAY : ");
    
    
            std::string const  Data = { "NLS0302010; NLS0200030; NLS0201000; NLS0312010
             ;NLS0203010 ;NLS0203030; NLS0321010; NLS0000160"};
    
            scanneraccess.write(Data);
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
                
            logger->logMessage("\tAuto reading mode");
            logger->logMessage("\tRed LED always OFF");    
            logger->logMessage("\tGreen LED winking while reading");
            logger->logMessage("\tCamera sensitivity to Normal");
            logger->logMessage("\tDecoding sound ON");      
            logger->logMessage("\tHigh volume");
            logger->logMessage("\tReflection Eliminating Mode Activated");
            logger->logMessage("\tSaving configuration\n");
    
            break;
        }
    
        case 3: {
            
            logger->logMessage("\nThis when the bus is stopping during NIGHT : ");
            std::string const Data = {"NLS0302010; NLS0200010; NLS0201010; NLS0312030;
             NLS0203010; NLS0203030 ;NLS0000160"};
    
            scanneraccess.write(Data);
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            logger->logMessage("\tAuto reading mode");
            logger->logMessage("\tRed LED always ON");    
            logger->logMessage("\tGreen LED always ON");
            logger->logMessage("\tCamera sensitivity to High");
            logger->logMessage("\tDecoding sound ON");      
            logger->logMessage("\tMedium volume");
            logger->logMessage("\tSaving configuration\n");
    
            break;
        }
    
        case 4: {
            logger->logMessage("\nSituation: When the bus is running during NIGHT : ");
        
    
            std::string const Data = { "NLS0302010; NLS0200030; NLS0201010; NLS0312020;
             NLS0203010; NLS0203032; NLS0000160"};
    
            scanneraccess.write(Data);
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            logger->logMessage("\tAuto reading mode");
            logger->logMessage("\tRed LED ON while reading");   
            logger->logMessage("\tGreen LED on all the time");
            logger->logMessage("\tCamera sensitivity to High");
            logger->logMessage("\tDecoding sound ON");      
            logger->logMessage("\tLow volume");
            logger->logMessage("\tSaving configuration \n");
    
            break;
        }
        default: 
        {
    
            logger->logMessage("You have entered the wrong choice. Program terminated.");
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            
        }
    
        }

}


