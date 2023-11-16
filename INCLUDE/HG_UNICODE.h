
#ifdef UNICODE
#include "hbwinuni.h"
  LPWSTR            AnsiToU16( LPCSTR );
  LPSTR             U16ToAnsi( LPWSTR );

  #define HG_CHAR_TO_WCHAR(c)     ((c != NULL) ? AnsiToU16(c) : NULL)  // return WCHAR
    #define HG_parc(n)            AnsiToU16( ( char * ) hb_parc( n ) )
    #define HG_parvc(n,i)         AnsiToU16( ( char * ) hb_parvc( n ,i ) )
    #define HG_arrayGetCPtr(a,n)  AnsiToU16( ( char * ) hb_arrayGetCPtr( a ,n ) )

    #define HG_retc(c,_p)         _p=U16ToAnsi(c) ; hb_retc(_p) ; hb_xfree( _p )
    #define HG_retcx(c,_p)        _p=U16ToAnsi(c) ; hb_retc(_p)
    #define HG_retclen(c,l,_p)    _p=U16ToAnsi(c) ; hb_retclen(_p,l) ; hb_xfree( _p )
    #define HG_retc_buffer(c,_p)  _p=U16ToAnsi(c) ; hb_retc_buffer(_p) ; hb_xfree( _p )

    #define HG_storc(c,i,_p)     _p=U16ToAnsi(c) ; hb_storc(_p,i) ; hb_xfree( _p )
    #define HG_storvc(c,l,n,_p)  _p=U16ToAnsi(c) ; hb_storvc(_p,l,n) ; hb_xfree( _p )
    #define HG_storcx(c,i,_p)    _p=U16ToAnsi(c) ; hb_storc(_p,i)
    #define HG_storvcx(c,l,n,_p) _p=U16ToAnsi(c) ; hb_storvc(_p,l,n)

    #define HG_xfree( c ) hb_xfree( ( TCHAR * ) c )

  #define HG_pustr( c ) LPSTR c
  #define HG_pstr( c )  LPWSTR c
  #define HG_pcstr( c ) LPCWSTR c
  //--------------------------------------------------
#else
    #define HG_parc(n)            ( char * ) hb_parc( n )
    #define HG_parvc(n,i)         hb_parvc( n ,i )
    #define HG_arrayGetCPtr(a,n)  hb_arrayGetCPtr( a ,n )

    #define HG_retc(c,p)         hb_retc(c)
    #define HG_retcx(c,p)        hb_retc(c)
    #define HG_retclen(c,l,p)    hb_retclen(c,l)
    #define HG_retc_buffer(c,p)  hb_retc_buffer(c) 

    #define HG_storc(c,i,p)         hb_storc (c,i)
    #define HG_storvc(c,l,n,p)      hb_storvc (c,l,n)
    #define HG_storcx(c,i,p)        hb_storc (c,i)
    #define HG_storvcx(c,l,n,p)     hb_storvc (c,l,n)

    #define HG_xfree( c ) // ;

  #define HG_pustr( c )  // ;
  #define HG_pstr( c ) LPSTR c
  #define HG_pcstr( c ) LPCSTR c 
#endif

//