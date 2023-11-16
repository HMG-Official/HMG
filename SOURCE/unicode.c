/* */ 

#include "SET_COMPILE_HMG_UNICODE.ch"

#if defined( UNICODE ) && !defined( _UNICODE )
  #define _UNICODE
#endif

#include <windows.h>

#include "hbvmint.h" /* TOFIX: clean the code to not access any internal HVM structures */
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbapifs.h"
#include "hbstack.h"
#include "hbapierr.h"
#include "hbvm.h"



LPSTR  U16ToAnsi( LPWSTR );
LPWSTR AnsiToU16( LPCSTR );

/* ----------------------------------------------------------------------- */
/* HB_FUNC ( HMG_CREATEFILE_UTF16LE_BOM )
{
   LPCWSTR FileName = AnsiToWide( ( char * ) hb_parc( 1 ) );
   HANDLE  hFile;
   DWORD   nBytes_Written;
   BYTE    UTF16LE_BOM [] = { 0xFF, 0xFE };

   hFile = CreateFile (FileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);
   WriteFile(hFile, (LPBYTE) UTF16LE_BOM, sizeof (UTF16LE_BOM), &nBytes_Written, NULL);
   hb_xfree( ( TCHAR * ) FileName ); 
   CloseHandle (hFile);
} */
//----------------
LPWSTR AnsiToU16( LPCSTR szString )
{
  if ( szString )
    return ( LPWSTR ) hb_osStrU16Encode( szString ) ;
  return  ( LPWSTR ) hb_osStrU16Encode( "\0" ) ;
}

/*------------------------------------*/
LPSTR U16ToAnsi( LPWSTR szString )
{
  if ( szString )
    return ( LPSTR ) hb_osStrU16Decode( szString ) ;
  return ( LPSTR ) hb_osStrU16Decode( TEXT( "" ) ) ;
}

/*------------------------------------*/
/* https://docs.microsoft.com/en-us/windows/win32/learnwin32/working-with-strings
// https://stackoverflow.com/questions/33834981/struggle-adding-lpstr-and-string-into-lpctstr
typedef wchar_t WCHAR;
wchar_t a = L'a';
wchar_t *str = L"hello";

Typedef	Definition
CHAR ----------   char
PSTR   or LPSTR	  char*
PWSTR  or LPWSTR	wchar_t*

PCSTR  or LPCSTR	const char*
PCWSTR or LPCWSTR	const wchar_t*

Macro	    Unicode	ANSI
TCHAR	    wchar_t	char
WCHAR 	  wchar_t
TEXT("x")	L"x"	  "x"
SetWindowText(TEXT("My Application"));
SetWindowTextW(L"My Application"); // Unicode function with wide-character string.
SetWindowTextA("My Application");  // ANSI function.

LPTSTR is a (long) pointer to a string of TCHARs.
LPWSTR is a (long) pointer to a string of WCHARs.
LPSTR is a (long) pointer to a string of chars.

_tcslen resolves to strlen 
if _UNICODE is undefined; otherwise it resolves to wcslen, 
which is the wide-character version of strlen.

#ifdef _UNICODE
#define _tcslen     wcslen
#else
#define _tcslen     strlen
#endif
D:\hb\hb3221\hb3219\HarBour\src\vm\set.c hb_osStrU16Encode( const char * pszName )
D:\hb\hb3221\hb3219\HarBour\src\nortl\nortl.c hb_osStrU16Encode( const char * pszName )
D:\hb\hb3221\hb3219\HarBour\src\common\hbwin.c hb_mbtowc/hb_wctomb

D:\hb\miniGUI\hwGUI-18\source\winapi\window.c  HWG_ANSITOUNICODE /printdos.prg HWG_WIN_ANSITOOEM 
D:\hb\hb3221\hb3219\HarBour\contrib\sddodbc\core.c
*/
