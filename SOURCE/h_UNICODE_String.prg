/*----------------------------------------------------------------------------
 HMG Source File --> h_UNICODE_STRING.prg  

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

#include "hmg.ch"
 
/*

UNICODE/ANSI                 ANSI Only
------------                 ---------
HMG_LEN()               <=>   LEN()
HMG_LOWER()             <=>   LOWER()
HMG_UPPER()             <=>   UPPER()
HMG_PADC()              <=>   PADC()
HMG_PADL()              <=>   PADL()
HMG_PADR()              <=>   PADR()
HMG_ISALPHA()           <=>   ISALPHA()
HMG_ISDIGIT()           <=>   ISDIGIT()
HMG_ISLOWER()           <=>   ISLOWER()
HMG_ISUPPER()           <=>   ISUPPER()
HMG_ISALPHANUMERIC()    <=>   RETURN (ISALPHA(c) .OR. ISDIGIT(c)) 

HB_USUBSTR()            <=>   SUBSTR()
HB_ULEFT()              <=>   LEFT()
HB_URIGHT()             <=>   RIGHT()
HB_UAT()                <=>   AT()
HB_UTF8RAT()            <=>   RAT()
HB_UTF8STUFF()          <=>   STUFF()

*/

 
#include "SET_COMPILE_HMG_UNICODE.ch"


#ifdef COMPILE_HMG_UNICODE


   FUNCTION HMG_LEN (x)
      IF ValType(x) == "C"   // HB_ISSTRING(x) .OR. HB_ISCHAR(x) .OR. HB_ISMEMO(x)
         RETURN HB_ULEN (x)
      ELSE
         RETURN LEN (x)
      ENDIF
   RETURN NIL


   FUNCTION HMG_PADC (xValue, nLen, cFillChar)
   LOCAL cText, nSize, cPadText := ""
      IF nLen > 0
         IF HB_ISNIL(cFillChar)
            cFillChar := " "
         ENDIF
         IF .NOT. HB_WILDMATCHI ("",cFillChar)
             cFillChar := HB_USUBSTR (cFillChar,1,1)
             cText := HB_VALTOSTR (xValue)
             IF HB_ULEN (cText) >= nLen
                cPadText := HB_USUBSTR (cText,1,nLen)
             ELSE
                nSize := nLen - HB_ULEN (cText)
                cPadText := REPLICATE (cFillChar, (nSize/2)) + cText + REPLICATE (cFillChar, ((nSize+1)/2))             
                cPadText := HB_USUBSTR (cPadText,1,nLen)
             ENDIF
         ENDIF
      ENDIF
   RETURN cPadText


   FUNCTION HMG_PADL (xValue, nLen, cFillChar)
   LOCAL cText, nSize, cPadText := ""
      IF nLen > 0
         IF HB_ISNIL(cFillChar)
            cFillChar := " "
         ENDIF
         IF .NOT. HB_WILDMATCHI ("",cFillChar)
             cFillChar := HB_USUBSTR (cFillChar,1,1)
             cText := HB_VALTOSTR (xValue)
             IF HB_ULEN (cText) >= nLen
                cPadText := HB_USUBSTR (cText,1,nLen)
             ELSE
                nSize := nLen - HB_ULEN (cText)
                cPadText := REPLICATE (cFillChar, nSize) + cText
             ENDIF
         ENDIF
      ENDIF
   RETURN cPadText


   FUNCTION HMG_PADR (xValue, nLen, cFillChar)
   LOCAL cText, nSize, cPadText := ""
      IF nLen > 0
         IF HB_ISNIL(cFillChar)
            cFillChar := " "
         ENDIF
         IF .NOT. HB_WILDMATCHI ("",cFillChar)
             cFillChar := HB_USUBSTR (cFillChar,1,1)
             cText := HB_VALTOSTR (xValue)
             IF HB_ULEN (cText) >= nLen
                cPadText := HB_USUBSTR (cText,1,nLen)
             ELSE
                nSize := nLen - HB_ULEN (cText)
                cPadText := cText + REPLICATE (cFillChar, nSize)
             ENDIF
         ENDIF
      ENDIF
   RETURN cPadText

/*
   HB_FUNC (HMG_LOWER)
   HB_FUNC (HMG_UPPER)
   HB_FUNC (HMG_ISALPHA)
   HB_FUNC (HMG_ISDIGIT)
   HB_FUNC (HMG_ISLOWER)
   HB_FUNC (HMG_ISUPPER)
   HB_FUNC (HMG_ISALPHANUMERIC)
*/

#else

   FUNCTION HMG_LEN(x); RETURN LEN (x)
   FUNCTION HMG_LOWER(c); RETURN LOWER (c)
   FUNCTION HMG_UPPER(c); RETURN UPPER (c)

   FUNCTION HMG_PADC(x,n,c); RETURN PADC(x,n,c)
   FUNCTION HMG_PADL(x,n,c); RETURN PADL(x,n,c)
   FUNCTION HMG_PADR(x,n,c); RETURN PADR(x,n,c)

   FUNCTION HMG_ISALPHA(c); RETURN ISALPHA(c)
   FUNCTION HMG_ISDIGIT(c); RETURN ISDIGIT(c)
   FUNCTION HMG_ISLOWER(c); RETURN ISLOWER(c)
   FUNCTION HMG_ISUPPER(c); RETURN ISUPPER(c)
   FUNCTION HMG_ISALPHANUMERIC(c); RETURN (ISALPHA(c) .OR. ISDIGIT(c))

#endif



// #define UTF8_BOM  ( HB_BCHAR (0xEF) + HB_BCHAR (0xBB) + HB_BCHAR (0xBF) )


FUNCTION HMG_IsUTF8WithBOM ( cString )
RETURN (HB_BLEFT (cString, HB_BLEN (UTF8_BOM)) == UTF8_BOM)


FUNCTION HMG_UTF8RemoveBOM ( cString )
   IF HMG_IsUTF8WithBOM (cString) == .T.
      cString := HB_BSUBSTR (cString, HB_BLEN ( UTF8_BOM ) + 1)
   ENDIF
RETURN cString


FUNCTION HMG_UTF8InsertBOM ( cString )
   IF HMG_IsUTF8WithBOM (cString) == .F.
      cString := UTF8_BOM + cString
   ENDIF
RETURN cString



FUNCTION HMG_IsUTF8 ( cString )
RETURN HB_StrIsUTF8 ( cString )


/*
FUNCTION HMG_IsUTF8 ( cString )   // code from Harbour Project, now is implemented as HB_StrIsUTF8()
LOCAL lASCII := .T.
LOCAL nOctets := 0
LOCAL nChar
LOCAL tmp

   FOR EACH tmp IN cString

      nChar := HB_BCODE( tmp )

      IF HB_bitAND ( nChar, 0x80 ) != 0
         lASCII := .F.
      ENDIF

      IF nOctets != 0

         IF HB_bitAND ( nChar, 0xC0 ) != 0x80
            RETURN .F.
         ENDIF

         --nOctets

      ELSEIF HB_bitAND ( nChar, 0x80 ) != 0

         DO WHILE HB_bitAND ( nChar, 0x80 ) != 0
            nChar := HB_bitAND ( HB_bitSHIFT ( nChar, 1 ), 0xFF )
            ++nOctets
         ENDDO

         --nOctets

         IF nOctets == 0
            RETURN .F.
         ENDIF
      ENDIF

   NEXT

RETURN !( nOctets > 0 .OR. lASCII )
*/