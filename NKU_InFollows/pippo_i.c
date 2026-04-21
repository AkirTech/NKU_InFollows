

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 8.01.0628 */
/* at Tue Jan 19 11:14:07 2038
 */
/* Compiler settings for backend\python-3.13.12-embed-amd64\Lib\site-packages\win32com\test\pippo.idl:
    Oicf, W1, Zp8, env=Win64 (32b run), target_arch=AMD64 8.01.0628 
    protocol : all , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */



#ifdef __cplusplus
extern "C"{
#endif 


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        EXTERN_C __declspec(selectany) const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif // !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, IID_ITestServerApp,0x50086EE8,0xF535,0x464B,0x80,0x6E,0x36,0x5A,0xDB,0xB7,0x27,0xCF);


MIDL_DEFINE_GUID(IID, IID_IPippo,0x618DB2A3,0xD5BD,0x4850,0xB6,0x6A,0x82,0x87,0x27,0xEB,0x37,0xE5);


MIDL_DEFINE_GUID(IID, LIBID_TESTSERVERLib,0x7783054E,0x9A20,0x4584,0x8C,0x62,0x6E,0xD2,0xA0,0x8F,0x6A,0xC6);


MIDL_DEFINE_GUID(CLSID, CLSID_TestServerApp,0x49E44E89,0x5A72,0x4456,0xB1,0xD5,0x68,0x26,0x8A,0x19,0xE7,0x98);


MIDL_DEFINE_GUID(CLSID, CLSID_Pippo,0x1F0F75D6,0xBD63,0x41B9,0x9F,0x88,0x2D,0x9D,0x2E,0x1A,0xA5,0xC3);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



