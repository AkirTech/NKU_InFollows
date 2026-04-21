

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


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



/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 500
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __pippo_h_h__
#define __pippo_h_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#ifndef DECLSPEC_XFGVIRT
#if defined(_CONTROL_FLOW_GUARD_XFG)
#define DECLSPEC_XFGVIRT(base, func) __declspec(xfg_virtual(base, func))
#else
#define DECLSPEC_XFGVIRT(base, func)
#endif
#endif

/* Forward Declarations */ 

#ifndef __ITestServerApp_FWD_DEFINED__
#define __ITestServerApp_FWD_DEFINED__
typedef interface ITestServerApp ITestServerApp;

#endif 	/* __ITestServerApp_FWD_DEFINED__ */


#ifndef __IPippo_FWD_DEFINED__
#define __IPippo_FWD_DEFINED__
typedef interface IPippo IPippo;

#endif 	/* __IPippo_FWD_DEFINED__ */


#ifndef __TestServerApp_FWD_DEFINED__
#define __TestServerApp_FWD_DEFINED__

#ifdef __cplusplus
typedef class TestServerApp TestServerApp;
#else
typedef struct TestServerApp TestServerApp;
#endif /* __cplusplus */

#endif 	/* __TestServerApp_FWD_DEFINED__ */


#ifndef __Pippo_FWD_DEFINED__
#define __Pippo_FWD_DEFINED__

#ifdef __cplusplus
typedef class Pippo Pippo;
#else
typedef struct Pippo Pippo;
#endif /* __cplusplus */

#endif 	/* __Pippo_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __ITestServerApp_INTERFACE_DEFINED__
#define __ITestServerApp_INTERFACE_DEFINED__

/* interface ITestServerApp */
/* [unique][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_ITestServerApp;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("50086EE8-F535-464B-806E-365ADBB727CF")
    ITestServerApp : public IDispatch
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Test1( 
            /* [retval][out] */ ITestServerApp **pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Test2( 
            /* [retval][out] */ VARIANT *pVar) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_MyProp1( 
            /* [retval][out] */ long *pVal) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct ITestServerAppVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ITestServerApp * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ITestServerApp * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ITestServerApp * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            ITestServerApp * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            ITestServerApp * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            ITestServerApp * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            ITestServerApp * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(ITestServerApp, Test1)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Test1 )( 
            ITestServerApp * This,
            /* [retval][out] */ ITestServerApp **pVal);
        
        DECLSPEC_XFGVIRT(ITestServerApp, Test2)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Test2 )( 
            ITestServerApp * This,
            /* [retval][out] */ VARIANT *pVar);
        
        DECLSPEC_XFGVIRT(ITestServerApp, get_MyProp1)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_MyProp1 )( 
            ITestServerApp * This,
            /* [retval][out] */ long *pVal);
        
        END_INTERFACE
    } ITestServerAppVtbl;

    interface ITestServerApp
    {
        CONST_VTBL struct ITestServerAppVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ITestServerApp_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ITestServerApp_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ITestServerApp_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ITestServerApp_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define ITestServerApp_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define ITestServerApp_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define ITestServerApp_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define ITestServerApp_Test1(This,pVal)	\
    ( (This)->lpVtbl -> Test1(This,pVal) ) 

#define ITestServerApp_Test2(This,pVar)	\
    ( (This)->lpVtbl -> Test2(This,pVar) ) 

#define ITestServerApp_get_MyProp1(This,pVal)	\
    ( (This)->lpVtbl -> get_MyProp1(This,pVal) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __ITestServerApp_INTERFACE_DEFINED__ */


#ifndef __IPippo_INTERFACE_DEFINED__
#define __IPippo_INTERFACE_DEFINED__

/* interface IPippo */
/* [unique][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IPippo;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("618DB2A3-D5BD-4850-B66A-828727EB37E5")
    IPippo : public IDispatch
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Method1( 
            /* [retval][out] */ IPippo **val) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_MyProp1( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Method2( 
            /* [in] */ long in1,
            /* [out][in] */ long *inout1,
            /* [retval][out] */ long *val) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Method3( 
            /* [in] */ VARIANT in1,
            /* [retval][out] */ VARIANT *val) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IPippoVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IPippo * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IPippo * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IPippo * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IPippo * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IPippo * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IPippo * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IPippo * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IPippo, Method1)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Method1 )( 
            IPippo * This,
            /* [retval][out] */ IPippo **val);
        
        DECLSPEC_XFGVIRT(IPippo, get_MyProp1)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_MyProp1 )( 
            IPippo * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IPippo, Method2)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Method2 )( 
            IPippo * This,
            /* [in] */ long in1,
            /* [out][in] */ long *inout1,
            /* [retval][out] */ long *val);
        
        DECLSPEC_XFGVIRT(IPippo, Method3)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Method3 )( 
            IPippo * This,
            /* [in] */ VARIANT in1,
            /* [retval][out] */ VARIANT *val);
        
        END_INTERFACE
    } IPippoVtbl;

    interface IPippo
    {
        CONST_VTBL struct IPippoVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IPippo_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPippo_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IPippo_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IPippo_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IPippo_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IPippo_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IPippo_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IPippo_Method1(This,val)	\
    ( (This)->lpVtbl -> Method1(This,val) ) 

#define IPippo_get_MyProp1(This,pVal)	\
    ( (This)->lpVtbl -> get_MyProp1(This,pVal) ) 

#define IPippo_Method2(This,in1,inout1,val)	\
    ( (This)->lpVtbl -> Method2(This,in1,inout1,val) ) 

#define IPippo_Method3(This,in1,val)	\
    ( (This)->lpVtbl -> Method3(This,in1,val) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IPippo_INTERFACE_DEFINED__ */



#ifndef __TESTSERVERLib_LIBRARY_DEFINED__
#define __TESTSERVERLib_LIBRARY_DEFINED__

/* library TESTSERVERLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_TESTSERVERLib;

EXTERN_C const CLSID CLSID_TestServerApp;

#ifdef __cplusplus

class DECLSPEC_UUID("49E44E89-5A72-4456-B1D5-68268A19E798")
TestServerApp;
#endif

EXTERN_C const CLSID CLSID_Pippo;

#ifdef __cplusplus

class DECLSPEC_UUID("1F0F75D6-BD63-41B9-9F88-2D9D2E1AA5C3")
Pippo;
#endif
#endif /* __TESTSERVERLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  VARIANT_UserSize(     unsigned long *, unsigned long            , VARIANT * ); 
unsigned char * __RPC_USER  VARIANT_UserMarshal(  unsigned long *, unsigned char *, VARIANT * ); 
unsigned char * __RPC_USER  VARIANT_UserUnmarshal(unsigned long *, unsigned char *, VARIANT * ); 
void                      __RPC_USER  VARIANT_UserFree(     unsigned long *, VARIANT * ); 

unsigned long             __RPC_USER  VARIANT_UserSize64(     unsigned long *, unsigned long            , VARIANT * ); 
unsigned char * __RPC_USER  VARIANT_UserMarshal64(  unsigned long *, unsigned char *, VARIANT * ); 
unsigned char * __RPC_USER  VARIANT_UserUnmarshal64(unsigned long *, unsigned char *, VARIANT * ); 
void                      __RPC_USER  VARIANT_UserFree64(     unsigned long *, VARIANT * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


