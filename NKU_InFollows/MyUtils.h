#pragma once
#include <iostream>
#include <string>
#ifdef linux
#include <unistd.h>
#include <pwd.h>
#endif
#ifdef _WIN32
#include <windows.h>
#endif

std::string getUserName();
namespace myutil;