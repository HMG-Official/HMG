/*----------------------------------------------------------------------------
 HMG Source File --> HMG_TString.prg  

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay). 

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/

#include "SET_COMPILE_HMG_UNICODE.ch"

#include "hmg.ch"

#include "hbclass.ch"



CREATE CLASS HMG_TGeneral
   // AS <type> ( ARRAY, BLOCK, CHARACTER, DATE, HASH, LOGICAL, NIL, NUMERIC, SYMBOL, TIMESTAMP, POINTER, USUAL )
   VAR cargo   AS USUAL   INIT Nil   EXPORTED // User-definable variable
ENDCLASS



CREATE CLASS HMG_TString   INHERIT HMG_TGeneral

   EXPORTED:

      METHOD New()   INLINE ( Self )   // Constructor

      METHOD Chr( nCode )                                 INLINE   hb_UChar( nCode )   // return string with U+nCode character in HVM CP encoding
      METHOD Char( nCode )                                INLINE   hb_UChar( nCode )   // return string with U+nCode character in HVM CP encoding
      METHOD Asc( cString )                               INLINE   hb_UCode( cString )   // return unicode value of 1-st character (not byte) in given string
      METHOD Code( cString )                              INLINE   hb_UCode( cString )   // return unicode value of 1-st character (not byte) in given string
      METHOD Len( cString )                               INLINE   hb_ULen( cString )    // return string length in characters
      METHOD ByteLen( cString )                           INLINE   hb_BLen( cString )    // return string length in bytes
      METHOD Peek( cString, n )                           INLINE   hb_UPeek( cString, n ) // return unicode value of <n>-th character in given string
      METHOD Poke( cString, n, nVal )                     INLINE   hb_UPoke( cString, n, nVal ) // change <n>-th character in given string to unicode <nVal> one and return modified text
      METHOD SubStr( cString, nStart, nCount )            INLINE   hb_USubStr( cString, nStart, nCount )
      METHOD Left( cString, nCount )                      INLINE   hb_ULeft( cString, nCount )
      METHOD Right( cString, nCount )                     INLINE   hb_URight( cString, nCount )
      METHOD At( cSubString, cString, nFrom, nTo )        INLINE   hb_UAt( cSubString, cString, nFrom, nTo )
      METHOD Rat( cSearch, cTarget )                      INLINE   hb_utf8RAt( cSearch, cTarget )
      METHOD Stuff( cString, nStart, nDelete, cInsert )   INLINE   hb_utf8Stuff( cString, nStart, nDelete, cInsert )

      METHOD BLen( cString )                              INLINE   hb_BLen( cString )    // return string length in bytes
      METHOD BLeft( cString, nCount  )                    INLINE   hb_BLeft( cString, nCount )
      METHOD BRight( cString, nCount )                    INLINE   hb_BRight( cString, nCount )
      METHOD BSubStr( cString, nStart, nCount )           INLINE   hb_BSubStr( cString, nStart, nCount )

      METHOD LTrim( cString )                                        INLINE   LTrim( cString )
      METHOD RTrim( cString )                                        INLINE   RTrim( cString )
      METHOD AllTrim( cString )                                      INLINE   ALLTRIM( cString )
      METHOD StrTran( cString, cSearch, cReplace, nStart, nCount )   INLINE   hb_utf8StrTran( cString, cSearch, cReplace, nStart, nCount )
      METHOD Replicate( cString, nCount )                            INLINE   Replicate( cString, nCount )
      METHOD Space( nCount )                                         INLINE   Space( nCount )

      METHOD StrToUTF8( cStr, cCPID )                                INLINE   hb_StrToUTF8( cStr, cCPID )
      METHOD UTF8ToStr( cUTF8Str, cCPID )                            INLINE   hb_UTF8ToStr( cUTF8Str, cCPID )
      METHOD IsUTF8( cString )                                       INLINE   HMG_ISUTF8( cString )

      METHOD EOL()                                                   INLINE   hb_eol()       // CR+LF
      METHOD OsNewLine()                                             INLINE   hb_osNewLine() // CR+LF
      
      METHOD Lower( cString )                      INLINE   HMG_LOWER( cString )
      METHOD Upper( cString )                      INLINE   HMG_UPPER( cString )
      METHOD PadC( cString, nLength, cFillChar )   INLINE   HMG_PADC( cString, nLength, cFillChar )
      METHOD PadL( cString, nLength, cFillChar )   INLINE   HMG_PADL( cString, nLength, cFillChar )
      METHOD PadR( cString, nLength, cFillChar )   INLINE   HMG_PADR( cString, nLength, cFillChar )
      METHOD IsAlpha( cString )                    INLINE   HMG_ISALPHA( cString )
      METHOD IsDigit( cString )                    INLINE   HMG_ISDIGIT( cString )
      METHOD IsLower( cString )                    INLINE   HMG_ISLOWER( cString )
      METHOD IsUpper( cString )                    INLINE   HMG_ISUPPER( cString )
      METHOD IsAlphaNumeric( cString )             INLINE   HMG_ISALPHANUMERIC( cString )   // return (IsAlpha(c) .OR. IsDigit(c))

      METHOD StrCmp( cString1, cString2, lCaseSensitive )   INLINE   HMG_StrCmp( cString1, cString2, lCaseSensitive )   // return -1, 0 , +1

ENDCLASS

