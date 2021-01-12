/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

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
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2008, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net>

	"HWGUI"
  	Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/
MEMVAR _HMG_SYSDATA
#include "hmg.ch"
#include "error.ch"
#INCLUDE "COMMON.CH"



*------------------------------------------------------------------------------*
PROCEDURE ErrorSys
*------------------------------------------------------------------------------*

   ErrorBlock( { | oError | DefError( oError ) } )

   *OutPutSelect()

   Init()

RETURN


STATIC FUNCTION DefError( oError )
   LOCAL cMessage
   LOCAL cDOSError

   _HMG_SYSDATA [ 347 ] := .F.

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   cMessage := ErrorMessage( oError )
   IF ValType( cMessage ) != "C"
      cMessage := ""
   ENDIF
   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   // "Quit" selected

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
   ENDIF
   Errorsys_WriteErrorLog( cMessage + hb_Eol() )

   RETURN .F.

// [vszakats]

STATIC FUNCTION ErrorMessage( oError )
   LOCAL cMessage

   // start error message
   cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   // add subsystem name if available
   IF ISCHARACTER( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF ISNUMBER( oError:subCode )
      cMessage += "/" + LTrim( Str( oError:subCode ) )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF ISCHARACTER( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE !Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE !Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

   RETURN cMessage

*------------------------------------------------------------------------------
*-01-01-2003
*-AUTHOR: Antonio Novo
*-Create/Open the ErrorLog.Htm file
*-Note: Is used in: errorsys.prg and h_error.prg
*------------------------------------------------------------------------------
FUNCTION Errorsys_WriteErrorLog( cText, lAbort )

   Local cFileName := hb_cwd() + "\hb_out.log", nHandle, n

   hb_Default( @lAbort, .T. )

   _HMG_SYSDATA [ 347 ] := .F.

    If .Not. File( cFileName )
        fClose( fCreate( cFileName ) )
    ENDIF
    nHandle := FOpen( cFileName, 2 )
    FSeek( nHandle, 0, 2 )
    fWrite( nHandle, hb_Eol() )
    fWrite( nHandle, "Date:" + Transform( Dtos( Date() ), "@R 9999-99-99" ) + "  Time: " + Time() + hb_Eol() )
    n := 1
    fWrite( nHandle, HMGVersion() + hb_Eol() )
    fWrite( nHandle, cText + hb_Eol() )
    DO WHILE ! Empty( ProcName( n ) )
       fWrite( nHandle, "Called from " + ProcName( n ) + "(" + ALLTRIM( Str( ProcLine( n++ ) ) ) + ")" + hb_Eol() )
    ENDDO
    fWrite( nHandle, hb_Eol() )
    fClose( nHandle )
    wapi_ShellExecute( , "open", "notepad.exe", cFileName, hb_cwd(), 1 ) // SW_SHOWNORMAL )

	UnloadAllDll()

	dbCloseAll()

	ExitProcess(0)

RETURN Nil
