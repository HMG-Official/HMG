/*----------------------------------------------------------------------------

 * INI Files support procedures

 * (c) 2003 Grigory Filatov
 * (c) 2003 Janusz Pora

 This program is free software; you can redistribute it and/or modify it under 
 the terms of the GNU General Public License as published by the Free Software 
 Foundation; either version 2 of the License, or (at your option) any later 
 version. 

 This program is distributed in the hope that it will be useful, but WITHOUT 
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with 
 this software; see the file COPYING. If not, write to the Free Software 
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or 
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text 
 contained in this file.

 The exception is that, if you link this code with other 
 files to produce an executable, this does not by itself cause the resulting 
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking  
 this code into it.

*/

/* 
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made 
  by Dr. Claudio Soto, November 2012 and June 2014 respectively. 
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "SET_COMPILE_HMG_UNICODE.ch" 
#include "HMG_UNICODE.h"


#include <windows.h>
#include "hbapi.h"

#include "hg_unicode.h"

HB_FUNC (GETPRIVATEPROFILESTRING )
{
   TCHAR bBuffer[ 1024 ] = { 0 };
   DWORD dwLen ;
   void *hSection, *hEntry, *hDefault, *hFileName;
   LPCTSTR lpSection  = HB_PARSTR( 1, &hSection, NULL  );
   LPCTSTR lpEntry    = HB_PARSTR( 2, &hEntry, NULL  );
   LPCTSTR lpDefault  = HB_PARSTR( 3, &hDefault, NULL );
   LPCTSTR lpFileName = HB_PARSTR( 4, &hFileName, NULL  );
   dwLen = GetPrivateProfileString( lpSection , lpEntry ,lpDefault , bBuffer, sizeof(bBuffer)/sizeof(TCHAR) , lpFileName);
   if( dwLen ) {
      HB_RETSTRLEN( bBuffer, dwLen ); }
   else
      HB_RETSTR( lpDefault );

   hb_strfree( hSection );
   hb_strfree( hEntry );
   hb_strfree( hDefault );
   hb_strfree( hFileName );
}


HB_FUNC( WRITEPRIVATEPROFILESTRING )
{
   void *hSection, *hEntry, *hData, *hFileName;
   LPCTSTR lpSection = HB_PARSTR( 1, &hSection, NULL  );
   LPCTSTR lpEntry   = HB_PARSTR( 2, &hEntry, NULL  );
   LPCTSTR lpData    = HB_PARSTR( 3, &hData, NULL );
   LPCTSTR lpFName   = HB_PARSTR( 4, &hFileName, NULL  );

   if ( WritePrivateProfileString( lpSection , lpEntry , lpData , lpFName ) )
      hb_retl( TRUE ) ;
   else
      hb_retl(FALSE);

   hb_strfree( hSection );
   hb_strfree( hEntry );
   hb_strfree( hData );
   hb_strfree( hFileName );
}


HB_FUNC( DELINIENTRY )
{
   void *hSection, *hEntry, *hFileName;
   LPCTSTR lpSection = HB_PARSTR( 1, &hSection, NULL  );
   LPCTSTR lpEntry   = HB_PARSTR( 2, &hEntry, NULL  );
   LPCTSTR lpFName   = HB_PARSTR( 3, &hFileName, NULL  );

   hb_retl( WritePrivateProfileString( lpSection,       // Section
                                       lpEntry,         // Entry
                                     NULL,                 // String
                                     lpFName ) );     // INI File

   hb_strfree( hSection );
   hb_strfree( hEntry );
   hb_strfree( hFileName );
}


HB_FUNC( DELINISECTION )
{
   void *hSection, *hFileName;
   LPCTSTR lpSection = HB_PARSTR( 1, &hSection, NULL  );
   LPCTSTR lpFName   = HB_PARSTR( 2, &hFileName, NULL  );

   hb_retl( WritePrivateProfileString( lpSection,       // Section
                                       NULL,               // Entry
                                       _TEXT(""),          // String
                                       lpFName ) );   // INI File
   hb_strfree( hSection );
   hb_strfree( hFileName );
}



//**************************************
//  by Dr. Claudio Soto, December 2014
//**************************************


HB_FUNC ( HMG_CREATEFILE_UTF16LE_BOM )
{
   void *hFileName ;
   HANDLE  hFile;
   DWORD   nBytes_Written;
   BYTE    UTF16LE_BOM [] = { 0xFF, 0xFE };

   hFile = CreateFile( HB_PARSTR( 1, &hFileName, NULL ), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);
   WriteFile(hFile, (LPBYTE) UTF16LE_BOM, sizeof (UTF16LE_BOM), &nBytes_Written, NULL); 
   CloseHandle (hFile);
   hb_strfree( hFileName );
}


TCHAR * FindFirstSubString ( TCHAR * Strings )
{
   TCHAR *p = Strings;
   if (*p == 0)
       p = NULL;
   return p;
}


TCHAR * FindNextSubString ( TCHAR * Strings )
{
   TCHAR *p = Strings;
   p = p + lstrlen (Strings) + 1;
   if (*p == 0)
       p = NULL;
   return p;
}


INT FindLenSubString ( TCHAR * Strings )
{
   INT i = 0;
   TCHAR * p = Strings;
   if ( (p = FindFirstSubString (p)) != NULL ) 
      for (i=1; (p = FindNextSubString (p)) != NULL; i++);
   return i;
}


//        HMG_GetPrivateProfileSectionNames ( cFileName ) ---> return array { "SectionName1", "SectionName2", ... }
HB_FUNC ( HMG_GETPRIVATEPROFILESECTIONNAMES )
{
   TCHAR  cBuffer [ 32767 ];
   TCHAR *cFileName = (TCHAR *) HMG_parc (1);

   ZeroMemory (cBuffer, sizeof (cBuffer));
   GetPrivateProfileSectionNames ( cBuffer, sizeof(cBuffer) / sizeof(TCHAR), cFileName );
   
   TCHAR *p = cBuffer;
   INT i, nLen = FindLenSubString ( p );
   hb_reta (nLen);
   if ( nLen > 0)
   {  
    HG_pustr( pStr ) ;
    p = FindFirstSubString (p) ;
      HG_storvc(p, -1, 1 ,pStr );
      for ( i=2; (p = FindNextSubString (p)) != NULL; i++ ) {
          HG_storvc(p, -1, i ,pStr ); }
   }
}


//        HMG_GetPrivateProfileSection ( cFileName, cSectionName ) ---> return array { "Key1=string1", "Key2=string2", ... }
HB_FUNC ( HMG_GETPRIVATEPROFILESECTION )
{
   TCHAR  cBuffer [ 32767 ];
   TCHAR *cFileName    = (TCHAR *) HMG_parc (1);
   TCHAR *cSectionName = (TCHAR *) HMG_parc (2);

   ZeroMemory (cBuffer, sizeof (cBuffer));
   GetPrivateProfileSection ( cSectionName, cBuffer, sizeof(cBuffer) / sizeof(TCHAR), cFileName );

   TCHAR *p = cBuffer;
   INT i, nLen = FindLenSubString ( p );
   hb_reta (nLen);
   if ( nLen > 0)
   {
      HG_pustr( pStr ) ;
      p = FindFirstSubString (p) ;
      HG_storvc(p, -1, 1 ,pStr );
      for ( i=2; (p = FindNextSubString (p)) != NULL; i++ ) {
          HG_storvc (p, -1, i ,pStr ); }
   }
}
