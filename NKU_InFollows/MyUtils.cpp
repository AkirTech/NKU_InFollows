#include <iostream>
#include <string>
#ifdef linux
#include <unistd.h>
#include <pwd.h>
#endif
#ifdef _WIN32
#include <windows.h>
#endif


namespace myutils
{
    std::string getUserName() {
#if defined linux
   uid_t userid = getuid();
   struct passwd* pwd = getpwuid(userid);
   return pwd ? pwd->pw_name : "";
#elif defined _WIN32
   const int MAX_LEN = 256;
   char buffer[MAX_LEN] = {0};
   DWORD len = MAX_LEN;
   if (GetUserNameA(buffer, &len)) {
          return std::string(buffer);
   }
   
#else
   return "";
#endif
}

}
