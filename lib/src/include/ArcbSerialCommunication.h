#pragma once

#include "IArcbSerialCommunication.h"
#include <Arcb/Core/SerialPort.h>
#include <Arcb/Core/IoDevice.h>

class ArcbSerialCommunication : public IArcbSerialCommunication {
    public:
    ArcbSerialCommunication() : port(Arcb::Core::SerialPort::Create())
    {
    }

    bool open(const std::string &pPortName, unsigned pBitRate) override
    {
        return port->Open(pPortName, pBitRate);
    }

    int write(std::string const & msg) override
    {
        return port->Write(msg);
    }
    
    std::vector<uint8_t> read() override
    {
        std::vector<uint8_t> answer(1024);
        size_t readbytes = port->Read(&answer[0], answer.size());
        answer.resize(readbytes);
        return answer;
    }

    void clearIoBuffers() override
    {
       port->ClearIoBuffers();
    }

    void close() override
    {
        port->Close(); 
    }

    private:
    std::unique_ptr<Arcb::Core::SerialPort> port;
};