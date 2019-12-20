#pragma once

#include <iostream>

#include "IBarcodeLogger.h"


class LoggerCout : public IBarcodeLogger {
    void logMessage(const std::string& message) override {
        std::cout << message << std::endl;
    }
};