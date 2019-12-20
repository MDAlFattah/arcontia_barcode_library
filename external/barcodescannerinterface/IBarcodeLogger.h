#pragma once

#include <string>

#include <yasper.h>

class IBarcodeLogger {
public:
	typedef yasper::ptr<IBarcodeLogger> SharedPtr;

	IBarcodeLogger() {};
	virtual ~IBarcodeLogger() {};

	virtual void logMessage(const std::string& message) = 0;
};