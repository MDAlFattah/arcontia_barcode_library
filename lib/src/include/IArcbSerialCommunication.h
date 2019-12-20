#pragma once


class IArcbSerialCommunication {
    
    public:
    virtual ~IArcbSerialCommunication() = default;

    virtual bool open(const std::string &pPortName, unsigned pBitRate) = 0;

    virtual int write(std::string const & msg) = 0;

    virtual std::vector<uint8_t> read() = 0;

    virtual void clearIoBuffers() = 0;

    virtual void close() = 0;

};






