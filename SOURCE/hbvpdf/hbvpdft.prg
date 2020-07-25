/*
 * $Id: hbvpdft.prg 16754 2011-05-11 16:05:43Z vszakats $
 */

//-------------------------\\
//
//    Program Cl_Pdf.prg
//
//    Original   : Victor K.    . http://www.ihaveparts.com
//
//    Class Code : Pritpal Bedi . http://www.vouchcac.com
//
//-------------------------\\

#ifndef __HARBOUR__
   #ifndef __XPP__
      #define __CLP__
   #endif
#endif


#ifdef __HARBOUR__
   #include      "hbclass.ch"
#endif

#ifdef __XPP__             //  Xbase++
   #command CREATE CLASS <x> [ FROM <y> ]  =>  CLASS <x> [ FROM <y> ]
   #command MESSAGE <x> METHOD <y>         =>  METHOD <x> IS <y>
   #command CLASS MESSAGE <x> METHOD <y>   =>  CLASS METHOD <x> IS <y>
#endif

#ifdef __CLP__             //  Clipper
   #include     "class(y).ch"
#endif

#define LEFTEQUAL( l, r ) ( hb_ULeft( l, HMG_Len( r ) ) == r )

//-------------------------\\

#include             "hbvpdf.ch"

//-------------------------\\

CREATE CLASS tPdf

#ifndef __HARBOUR__
EXPORT:
#endif

VAR aReport

#ifndef __HARBOUR__
EXPORT:
#endif

#ifdef __HARBOUR__
METHOD Init( cFile, nLen, lOptimize ) CONSTRUCTOR
#else
METHOD Init
#endif

METHOD AtSay
METHOD Normal
METHOD Bold
METHOD Italic
METHOD UnderLine
METHOD BoldItalic
METHOD BookAdd
METHOD BookClose
METHOD BookOpen
METHOD Box
METHOD Box1
METHOD Center
METHOD Close
METHOD Image
METHOD Length
METHOD NewLine
METHOD NewPage
METHOD PageSize
METHOD PageOrient
METHOD PageNumber
METHOD Reverse
METHOD RJust
METHOD SetFont
METHOD SetLPI
METHOD StringB
METHOD TextCount
METHOD Text
METHOD OpenHeader
METHOD EditOnHeader
METHOD EditOffHeader
METHOD CloseHeader
METHOD DeleteHeader
METHOD EnableHeader
METHOD DisableHeader
METHOD SaveHeader
METHOD Header
METHOD DrawHeader
METHOD Margins
METHOD CreateHeader
METHOD ImageInfo
METHOD TIFFInfo
METHOD JPEGInfo
METHOD FilePrint
METHOD BookCount
METHOD BookFirst
METHOD BookLast
METHOD BookNext
METHOD BookParent
METHOD BookPrev
METHOD CheckLine
METHOD ClosePage
METHOD GetFontInfo
METHOD M2R
METHOD M2X
METHOD M2Y
METHOD R2D
METHOD R2M
METHOD X2M
METHOD TextPrint
METHOD TextNextPara
METHOD Execute

ENDCLASS

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Init( cFile, nLen, lOptimize )
#else
METHOD Init( cFile, nLen, lOptimize )
#endif

local cTemp, nI, nJ, n1, n2 := 896, n12

DEFAULT nLen      TO 200
DEFAULT lOptimize TO .f.

::aReport := array( PARAMLEN )

::aReport[ FONTNAME     ] := 1
::aReport[ FONTSIZE     ] := 10
::aReport[ LPI          ] := 6
::aReport[ PAGESIZE     ] := "LETTER"
::aReport[ PAGEORIENT   ] := "P"
::aReport[ PAGEX        ] := 8.5 * 72
::aReport[ PAGEY        ] := 11.0 * 72
::aReport[ REPORTWIDTH  ] := nLen    // 200 // should be as parameter
::aReport[ REPORTPAGE   ] := 0
::aReport[ REPORTLINE   ] := 0       // 5
::aReport[ FONTNAMEPREV ] := 0
::aReport[ FONTSIZEPREV ] := 0
::aReport[ PAGEBUFFER   ] := ""
::aReport[ REPORTOBJ    ] := 1       //2
::aReport[ DOCLEN       ] := 0
::aReport[ TYPE1        ] := { "Times-Roman", "Times-Bold", "Times-Italic", "Times-BoldItalic", ;
                               "Helvetica", "Helvetica-Bold", "Helvetica-Oblique", "Helvetica-BoldOblique", ;
                               "Courier", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique" }
::aReport[ MARGINS      ] := .t.
::aReport[ HEADEREDIT   ] := .f.
::aReport[ NEXTOBJ      ] := 0
::aReport[ PDFTOP       ] := 1      // top
::aReport[ PDFLEFT      ] := 10     // LEFT & RIGHT
::aReport[ PDFBOTTOM    ] := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6
::aReport[ HANDLE       ] := FCreate( cFile )
::aReport[ PAGES        ] := {}
::aReport[ REFS         ] := { 0, 0 }
::aReport[ BOOKMARK     ] := {}
::aReport[ HEADER       ] := {}
::aReport[ FONTS        ] := {}
::aReport[ IMAGES       ] := {}
::aReport[ PAGEIMAGES   ] := {}
::aReport[ PAGEFONTS    ] := {}

cTemp := vpdf_FontsDat()
n1    := HMG_LEN( cTemp ) / ( 2 * n2 )
::aReport[ FONTWIDTH    ] := array( n1, n2 )

::aReport[ OPTIMIZE     ] := lOptimize
::aReport[ NEXTOBJ      ] := ::aReport[ REPORTOBJ ] + 4

n12 := 2 * n2
for nI := 1 to n1
   for nJ := 1 to n2
      ::aReport[ FONTWIDTH ][ nI ][ nJ ] := bin2i( hb_USubStr( cTemp, ( nI - 1 ) * n12 + ( nJ - 1 ) * 2 + 1, 2 ) )
   next
next

::aReport[ DOCLEN       ] := 0
cTemp                     := "%PDF-1.3" + CRLF
::aReport[ DOCLEN       ] += HMG_LEN( cTemp )

FWrite( ::aReport[ HANDLE ], cTemp )

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:AtSay( cString, nRow, nCol, cUnits, lExact, cId )
#else
METHOD AtSay( cString, nRow, nCol, cUnits, lExact, cId )
#endif

local _nFont, lReverse, nAt

DEFAULT nRow   TO ::aReport[ REPORTLINE ]
DEFAULT cUnits TO "R"
DEFAULT lExact TO .f.
DEFAULT cId    TO ""

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFATSAY", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := hb_UAt( "#pagenumber#", cString ) ) > 0
      cString := hb_ULeft( cString, nAt - 1 ) + LTrim(Str( ::PageNumber())) + hb_USubStr( cString, nAt + 12 )
   ENDIF

   lReverse := .f.
   IF cUnits == "M"
      nRow := ::M2Y( nRow )
      nCol := ::M2X( nCol )
   ELSEIF cUnits == "R"
      IF .not. lExact
         ::CheckLine( nRow )
         nRow := nRow + ::aReport[ PDFTOP]
      ENDIF
      nRow := ::R2D( nRow )
      nCol := ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nCol * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
   ENDIF
   IF !Empty( cString )
      cString := ::StringB( cString )
      IF hb_URight( cString, 1 ) == CHR(255) //reverse
         cString := hb_ULeft( cString, HMG_LEN( cString ) - 1 )
         ::Box( ::aReport[ PAGEY ] - nRow - ::aReport[ FONTSIZE ] + 2.0 , nCol, ::aReport[ PAGEY ] - nRow + 2.0, nCol + ::M2X( ::length( cString )) + 1,,100, "D")
         ::aReport[ PAGEBUFFER ] += " 1 g "
         lReverse := .t.
      ELSEIF hb_URight( cString, 1 ) == CHR(254) //underline
         cString := hb_ULeft( cString, HMG_LEN( cString ) - 1 )
         ::Box( ::aReport[ PAGEY ] - nRow + 0.5,  nCol, ::aReport[ PAGEY ] - nRow + 1, nCol + ::M2X( ::length( cString )) + 1,,100, "D")
      ENDIF

      // version 0.01
      IF ( nAt := hb_UAt( CHR(253), cString )) > 0 // some color text inside
         ::aReport[ PAGEBUFFER ] += CRLF + ;
         Chr_RGB( hb_USubStr( cString, nAt + 1, 1 )) + " " + ;
         Chr_RGB( hb_USubStr( cString, nAt + 2, 1 )) + " " + ;
         Chr_RGB( hb_USubStr( cString, nAt + 3, 1 )) + " rg "
         cString := hb_utf8Stuff( cString, nAt, 4, "")
      ENDIF
      // version 0.01

      _nFont := ascan( ::aReport[ FONTS ], {|arr| arr[1] == ::aReport[ FONTNAME ]} )
      IF !( ::aReport[ FONTNAME ] == ::aReport[ FONTNAMEPREV ] )
         ::aReport[ FONTNAMEPREV ] := ::aReport[ FONTNAME ]
         ::aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + LTrim(Str( _nFont )) + " " + LTrim(Transform( ::aReport[ FONTSIZE ], "999.99")) + " Tf " + LTrim(Transform( nCol, "9999.99" )) + " " + LTrim(Transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ELSEIF ::aReport[ FONTSIZE ] != ::aReport[ FONTSIZEPREV ]
         ::aReport[ FONTSIZEPREV ] := ::aReport[ FONTSIZE ]
         ::aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + LTrim(Str( _nFont )) + " " + LTrim(Transform( ::aReport[ FONTSIZE ], "999.99")) + " Tf " + LTrim(Transform( nCol, "9999.99" )) + " " + LTrim(Transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ELSE
         ::aReport[ PAGEBUFFER ] += CRLF + "BT " + LTrim(Transform( nCol, "9999.99" )) + " " + LTrim(Transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ENDIF
      IF lReverse
         ::aReport[ PAGEBUFFER ] += " 0 g "
      ENDIF
   ENDIF

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Normal()
#else
METHOD Normal()
#endif
local cName := ::GetFontInfo( "NAME" )

   IF cName == "Times"
      ::aReport[ FONTNAME ] := 1
   ELSEIF cName == "Helvetica"
      ::aReport[ FONTNAME ] := 5
   ELSE
      ::aReport[ FONTNAME ] := 9
   ENDIF
   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Italic()
#else
METHOD Italic()
#endif
local cName := ::GetFontInfo( "NAME" )

   IF cName == "Times"
      ::aReport[ FONTNAME ] := 3
   ELSEIF cName == "Helvetica"
      ::aReport[ FONTNAME ] := 7
   ELSE
      ::aReport[ FONTNAME ] := 11
   ENDIF
   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Bold()
#else
METHOD Bold()
#endif
local cName := ::GetFontInfo( "NAME" )

   IF     cName == "Times"
      ::aReport[ FONTNAME ] := 2
   ELSEIF cName == "Helvetica"
      ::aReport[ FONTNAME ] := 6
   ELSEIF cName == "Courier"
      ::aReport[ FONTNAME ] := 10    // Courier // 0.04
   ENDIF

   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BoldItalic()
#else
METHOD BoldItalic()
#endif
local cName := ::GetFontInfo( "NAME" )

IF     cName == "Times"
   ::aReport[ FONTNAME ] := 4
ELSEIF cName == "Helvetica"
   ::aReport[ FONTNAME ] := 8
ELSEIF cName == "Courier"
   ::aReport[ FONTNAME ] := 12 // 0.04
ENDIF

aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
   aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
ENDIF

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookAdd( cTitle, nLevel, nPage, nLine )
#else
METHOD BookAdd( cTitle, nLevel, nPage, nLine )
#endif

aadd( ::aReport[ BOOKMARK ], { nLevel, ALLTRIM( cTitle ), 0, 0, 0, 0, 0, 0, nPage, IIF( nLevel == 1, ::aReport[ PAGEY ], ::aReport[ PAGEY ] - nLine * 72 / ::aReport[ LPI ] ) })

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookClose( )
#else
METHOD BookClose( )
#endif

::aReport[ BOOKMARK ] := nil

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookOpen( )
#else
METHOD BookOpen( )
#endif

::aReport[ BOOKMARK ] := {}

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Box( x1, y1, x2, y2, nBorder, nShade, cUnits, cColor, cId )
#else
METHOD Box( x1, y1, x2, y2, nBorder, nShade, cUnits, cColor, cId )
#endif

local cBoxColor

DEFAULT nBorder TO 0
DEFAULT nShade  TO 0
DEFAULT cUnits  TO "M"
DEFAULT cColor  TO ""

   cBoxColor := ""
   IF !Empty( cColor )
      cBoxColor := " " + Chr_RGB( hb_USubStr( cColor, 2, 1 )) + " " + ;
                         Chr_RGB( hb_USubStr( cColor, 3, 1 )) + " " + ;
                         Chr_RGB( hb_USubStr( cColor, 4, 1 )) + " rg "
      IF Empty( ALLTRIM( cBoxColor ) )
         cBoxColor := ""
      ENDIF
   ENDIF

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFBOX", cId, { x1, y1, x2, y2, nBorder, nShade, cUnits } )
   ENDIF

   IF cUnits == "M"
      y1 += 0.5
      y2 += 0.5

      IF nShade > 0
         ::aReport[ PAGEBUFFER ] += CRLF + Transform( 1.00 - nShade / 100.00, "9.99") + " g " + cBoxColor + LTrim(Str(::M2X( y1 ))) + " " + LTrim(Str(::M2Y( x1 ))) + " " + LTrim(Str(::M2X( y2 - y1 ))) + " -" + LTrim(Str(::M2X( x2 - x1 ))) + " re f 0 g"
      ENDIF

      IF nBorder > 0
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str(::M2X( y1 ))) + " " + LTrim(Str(::M2Y( x1 ))) + " " + LTrim(Str(::M2X( y2 - y1 ))) + " -" + LTrim(Str(::M2X( nBorder ))) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str(::M2X( y2 - nBorder ))) + " " + LTrim(Str(::M2Y( x1 ))) + " " + LTrim(Str(::M2X( nBorder ))) + " -" + LTrim(Str(::M2X( x2 - x1 ))) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str(::M2X( y1 ))) + " " + LTrim(Str(::M2Y( x2 - nBorder ))) + " " + LTrim(Str(::M2X( y2 - y1 ))) + " -" + LTrim(Str(::M2X( nBorder ))) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str(::M2X( y1 ))) + " " + LTrim(Str(::M2Y( x1 ))) + " " + LTrim(Str(::M2X( nBorder ))) + " -" + LTrim(Str(::M2X( x2 - x1 ))) + " re f"
      ENDIF
   ELSEIF cUnits == "D"    // "Dots"
      IF nShade > 0
         ::aReport[ PAGEBUFFER ] += CRLF + Transform( 1.00 - nShade / 100.00, "9.99") + " g " + cBoxColor + LTrim(Str( y1 )) + " " + LTrim(Str( ::aReport[ PAGEY ] - x1 )) + " " + LTrim(Str( y2 - y1 )) + " -" + LTrim(Str( x2 - x1 )) + " re f 0 g"
      ENDIF

      IF nBorder > 0
/*
            1
         Ú-----¿
       4 ³     ³ 2
         À-----Ù
            3
*/
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str( y1 )) + " " + LTrim(Str( ::aReport[ PAGEY ] - x1 )) + " " + LTrim(Str( y2 - y1 )) + " -" + LTrim(Str( nBorder )) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str( y2 - nBorder )) + " " + LTrim(Str( ::aReport[ PAGEY ] - x1 )) + " " + LTrim(Str( nBorder )) + " -" + LTrim(Str( x2 - x1 )) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str( y1 )) + " " + LTrim(Str( ::aReport[ PAGEY ] - x2 + nBorder )) + " " + LTrim(Str( y2 - y1 )) + " -" + LTrim(Str( nBorder )) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim(Str( y1 )) + " " + LTrim(Str( ::aReport[ PAGEY ] - x1 )) + " " + LTrim(Str( nBorder )) + " -" + LTrim(Str( x2 - x1 )) + " re f"
      ENDIF
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Box1( nTop, nLeft, nBottom, nRight, nBorderWidth, cBorderColor, cBoxColor )
#else
METHOD Box1( nTop, nLeft, nBottom, nRight, nBorderWidth, cBorderColor, cBoxColor )
#endif

DEFAULT nBorderWidth to 0.5
DEFAULT cBorderColor to CHR(0) + CHR(0) + CHR(0)
DEFAULT cBoxColor to CHR(255) + CHR(255) + CHR(255)

   ::aReport[ PAGEBUFFER ] +=  CRLF + ;
                         Chr_RGB( hb_USubStr( cBorderColor, 1, 1 )) + " " + ;
                         Chr_RGB( hb_USubStr( cBorderColor, 2, 1 )) + " " + ;
                         Chr_RGB( hb_USubStr( cBorderColor, 3, 1 )) + ;
                         " RG" + ;
                         CRLF + ;
                         Chr_RGB( hb_USubStr( cBoxColor, 1, 1 )) + " " + ;
                         Chr_RGB( hb_USubStr( cBoxColor, 2, 1 )) + " " + ;
                         Chr_RGB( hb_USubStr( cBoxColor, 3, 1 )) + ;
                         " rg" + ;
                         CRLF + LTrim(Str( nBorderWidth )) + " w" + ;
                         CRLF + LTrim( STR ( nLeft + nBorderWidth / 2 )) + " " + ;
                         CRLF + LTrim( STR ( ::aReport[ PAGEY ] - nBottom + nBorderWidth / 2)) + " " + ;
                         CRLF + LTrim( STR ( nRight - nLeft -  nBorderWidth )) + ;
                         CRLF + LTrim( STR ( nBottom - nTop - nBorderWidth )) + " " + ;
                         " re" + ;
                         CRLF + "B"
return nil

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Center( cString, nRow, nCol, cUnits, lExact, cId )
#else
METHOD Center( cString, nRow, nCol, cUnits, lExact, cId )
#endif

local nLen, nAt
DEFAULT nRow TO ::aReport[ REPORTLINE ]
DEFAULT cUnits TO "R"
DEFAULT lExact TO .f.
DEFAULT nCol TO IIF( cUnits == "R", ::aReport[ REPORTWIDTH ] / 2, ::aReport[ PAGEX ] / 72 * 25.4 / 2 )

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFCENTER", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := hb_UAt( "#pagenumber#", cString ) ) > 0
      cString := hb_ULeft( cString, nAt - 1 ) + LTrim(Str( ::PageNumber())) + hb_USubStr( cString, nAt + 12 )
   ENDIF

   nLen := ::length( cString ) / 2
   IF cUnits == "R"
      IF .not. lExact
         ::CheckLine( nRow )
         nRow := nRow + ::aReport[ PDFTOP]
      ENDIF
   ENDIF
   ::AtSay( cString, ::R2M( nRow ), IIF( cUnits == "R", ::aReport[ PDFLEFT ] + ( ::aReport[ PAGEX ] / 72 * 25.4 - 2 * ::aReport[ PDFLEFT ] ) * nCol / ::aReport[ REPORTWIDTH ], nCol ) - nLen, "M", lExact )
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Close()
#else
METHOD Close()
#endif

local nI, cTemp, nCurLevel, nObj1, nLast, nCount, nFirst, nRecno, nBooklen

//   FIELD FIRST, PREV, NEXT, LAST, COUNT, PARENT, PAGE, COORD, TITLE, LEVEL

   ::ClosePage()

   // kids
   ::aReport[ REFS ][ 2 ] := ::aReport[ DOCLEN ]
   cTemp := ;
   "1 0 obj"+CRLF+;
   "<<"+CRLF+;
   "/Type /Pages /Count " + LTrim(Str(::aReport[ REPORTPAGE ])) + CRLF +;
   "/Kids ["

   for nI := 1 to ::aReport[ REPORTPAGE ]
      cTemp += " " + LTrim(Str( ::aReport[ PAGES ][ nI ] )) + " 0 R"
   next

   cTemp += " ]" + CRLF + ;
   ">>" + CRLF + ;
   "endobj" + CRLF

   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   // info
   ++::aReport[ REPORTOBJ ]
   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := LTrim(Str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/Producer ()" + CRLF + ;
            "/Title ()" + CRLF + ;
            "/Author ()" + CRLF + ;
            "/Creator ()" + CRLF + ;
            "/Subject ()" + CRLF + ;
            "/Keywords ()" + CRLF + ;
            "/CreationDate (D:" + Str(Year(Date()), 4) + HMG_PADL( Month(Date()), 2, "0") + HMG_PADL( Day(Date()), 2, "0") + hb_USubStr( Time(), 1, 2 ) + hb_USubStr( Time(), 4, 2 ) + hb_USubStr( Time(), 7, 2 ) + ")" + CRLF + ;
            ">>" + CRLF + ;
            "endobj" + CRLF
   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   // root
   ++::aReport[ REPORTOBJ ]
   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := LTrim(Str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   "<< /Type /Catalog /Pages 1 0 R /Outlines " + LTrim(Str( ::aReport[ REPORTOBJ ] + 1 )) + " 0 R" + IIF( ( nBookLen := HMG_LEN( ::aReport[ BOOKMARK ] )) > 0, " /PageMode /UseOutlines", "") + " >>" + CRLF + "endobj" + CRLF
   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   ++::aReport[ REPORTOBJ ]
   nObj1 := ::aReport[ REPORTOBJ ]

   IF nBookLen > 0

      nRecno := 1
      nFirst := ::aReport[ REPORTOBJ ] + 1
      nLast  := 0
      nCount := 0
      while nRecno <= nBookLen
         nCurLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKPARENT ] := ::BookParent( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ]   := ::BookPrev( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ]   := ::BookNext( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ]  := ::BookFirst( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ]   := ::BookLast( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ]  := ::BookCount( nRecno, nCurLevel )
         IF nCurLevel == 1
            nLast := nRecno
            ++nCount
         ENDIF
         ++nRecno
      enddo

      nLast += ::aReport[ REPORTOBJ ]

      cTemp := LTrim(Str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + "<< /Type /Outlines /Count " + LTrim(Str( nCount )) + " /First " + LTrim(Str( nFirst )) + " 0 R /Last " + LTrim(Str( nLast )) + " 0 R >>" + CRLF + "endobj" //+ CRLF
      aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
      ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
      FWrite( ::aReport[ HANDLE ], cTemp )

      ++::aReport[ REPORTOBJ ]
      nRecno := 1
      FOR nI := 1 to nBookLen
         //cTemp := IIF ( nI > 1, CRLF, "") + LTrim(Str( ::aReport[ REPORTOBJ ] + nI - 1)) + " 0 obj" + CRLF + ;
         cTemp := CRLF + LTrim(Str( ::aReport[ REPORTOBJ ] + nI - 1)) + " 0 obj" + CRLF + ;
                 "<<" + CRLF + ;
                 "/Parent " + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPARENT ])) + " 0 R" + CRLF + ;
                 "/Dest [" + LTrim(Str( ::aReport[ PAGES ][ ::aReport[ BOOKMARK ][ nRecno ][ BOOKPAGE ] ] )) + " 0 R /XYZ 0 " + LTrim( Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;
                 "/Title (" + ALLTRIM( ::aReport[ BOOKMARK ][ nRecno ][ BOOKTITLE ]) + ")" + CRLF + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ] > 0, "/Prev " + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ] > 0, "/Next " + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ] > 0, "/First " + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ] > 0, "/Last " + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ] != 0, "/Count " + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ])) + CRLF, "") + ;
                 ">>" + CRLF + "endobj" + CRLF
//                 "/Dest [" + LTrim(Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPAGE ] * 3 )) + " 0 R /XYZ 0 " + LTrim( Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;
//                 "/Dest [" + LTrim(Str( ::aReport[ PAGES ][ nRecno ] )) + " 0 R /XYZ 0 " + LTrim( Str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;

         aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] + 2 )
         ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
         FWrite( ::aReport[ HANDLE ], cTemp )
         ++nRecno
      NEXT
      ::BookClose()

      ::aReport[ REPORTOBJ ] += nBookLen - 1
   ELSE
      cTemp := LTrim(Str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + "<< /Type /Outlines /Count 0 >>" + CRLF + "endobj" + CRLF
      aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
      ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
      FWrite( ::aReport[ HANDLE ], cTemp )
   ENDIF

   cTemp := CRLF
   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )

   ++::aReport[ REPORTOBJ ]
   cTemp += "xref" + CRLF + ;
   "0 " + LTrim(Str( ::aReport[ REPORTOBJ ] )) + CRLF +;
   HMG_PADL( ::aReport[ REFS ][ 1 ], 10, "0") + " 65535 f" + CRLF

   for nI := 2 to HMG_LEN( ::aReport[ REFS ] )
      cTemp += HMG_PADL( ::aReport[ REFS ][ nI ], 10, "0") + " 00000 n" + CRLF
   next

   cTemp += "trailer << /Size " + LTrim(Str( ::aReport[ REPORTOBJ ] )) + " /Root " + LTrim(Str( nObj1 - 1 )) + " 0 R /Info " + LTrim(Str( nObj1 - 2 )) + " 0 R >>" + CRLF + ;
            "startxref" + CRLF + ;
            LTrim(Str( ::aReport[ DOCLEN ] )) + CRLF + ;
            "%%EOF" + CRLF
   FWrite( ::aReport[ HANDLE ], cTemp )

   FClose( ::aReport[ HANDLE ] )

   ::aReport := nil

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Image( cFile, nRow, nCol, cUnits, nHeight, nWidth, cId )
#else
METHOD Image( cFile, nRow, nCol, cUnits, nHeight, nWidth, cId )
#endif

DEFAULT nRow    TO ::aReport[ REPORTLINE ]
DEFAULT nCol    TO 0
DEFAULT nHeight TO 0
DEFAULT nWidth  TO 0
DEFAULT cUnits  TO "R"
DEFAULT cId TO  ""

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFIMAGE", cId, { cFile, nRow, nCol, cUnits, nHeight, nWidth } )
   ENDIF

   IF cUnits == "M"
      nRow    := ::aReport[ PAGEY ] - ::M2Y( nRow )
      nCol    := ::M2X( nCol )
      nHeight := ::aReport[ PAGEY ] - ::M2Y( nHeight )
      nWidth  := ::M2X( nWidth )
   ELSEIF cUnits == "R"
      //IF .not. lExact
      //   ::CheckLine( nRow )
      //   nRow := nRow + ::aReportStyle[ PDFTOP]
      //ENDIF
      nRow := ::aReport[ PAGEY ] - ::R2D( nRow )
      nCol := ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nCol * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
      nHeight := ::aReport[ PAGEY ] - ::R2D( nHeight )
      nWidth := ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nWidth * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
   ELSEIF cUnits == "D"
   ENDIF

   aadd( ::aReport[ PAGEIMAGES ], { cFile, nRow, nCol, nHeight, nWidth } )

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Length( cString )
#else
METHOD Length( cString )
#endif

local nWidth := 0.00, nI, nLen, nArr, nAdd := ( ::aReport[ FONTNAME ] - 1 ) % 4

   nLen := HMG_LEN( cString )
   IF hb_URight( cString, 1 ) == CHR( 255 ) .or. hb_URight( cString, 1 ) == CHR( 254 )
      --nLen
   ENDIF
   IF ::GetFontInfo("NAME") == "Times"
      nArr := 1
   ELSEIF ::GetFontInfo("NAME") == "Helvetica"
      nArr := 2
   ELSE
      nArr := 3
   ENDIF

   For nI:= 1 To nLen
      nWidth += ::aReport[ FONTWIDTH ][ nArr ][ ( ASC( hb_USubStr( cString, nI, 1 )) - 32 ) * 4 + 1 + nAdd ] * 25.4 * ::aReport[ FONTSIZE ] / 720.00 / 100.00
   Next
RETURN nWidth

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:NewLine( n )
#else
METHOD NewLine( n )
#endif

DEFAULT n TO 1
   IF ::aReport[ REPORTLINE ] + n + ::aReport[ PDFTOP] > ::aReport[ PDFBOTTOM ]
      ::NewPage()
      ::aReport[ REPORTLINE ] += 1
   ELSE
      ::aReport[ REPORTLINE ] += n
   ENDIF

RETURN ::aReport[ REPORTLINE ]

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:NewPage( _cPageSize, _cPageOrient, _nLpi, _cFontName, _nFontType, _nFontSize )
#else
METHOD NewPage( _cPageSize, _cPageOrient, _nLpi, _cFontName, _nFontType, _nFontSize )
#endif



DEFAULT _cPageSize   TO ::aReport[ PAGESIZE ]
DEFAULT _cPageOrient TO ::aReport[ PAGEORIENT ]
DEFAULT _nLpi        TO ::aReport[ LPI ]
DEFAULT _cFontName   TO ::GetFontInfo( "NAME" )
DEFAULT _nFontType   TO ::GetFontInfo( "TYPE" )
DEFAULT _nFontSize   TO ::aReport[ FONTSIZE ]

   IF !Empty( ::aReport[ PAGEBUFFER ] )
      ::ClosePage()
   ENDIF

   ::aReport[ PAGEFONTS  ] := {}
   ::aReport[ PAGEIMAGES ] := {}

   ++::aReport[ REPORTPAGE ]

   ::PageSize( _cPageSize )
   ::PageOrient( _cPageOrient )
   ::SetLPI( _nLpi )

   ::SetFont( _cFontName, _nFontType, _nFontSize )

   ::DrawHeader()

   ::aReport[ REPORTLINE   ] := 0
   ::aReport[ FONTNAMEPREV ] := 0
   ::aReport[ FONTSIZEPREV ] := 0

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:PageSize( _cPageSize )
#else
METHOD PageSize( _cPageSize )
#endif

local nSize, aSize := { { "LETTER",    8.50, 11.00 }, ;
                        { "LEGAL" ,    8.50, 14.00 }, ;
                        { "LEDGER",   11.00, 17.00 }, ;
                        { "EXECUTIVE", 7.25, 10.50 }, ;
                        { "A4",        8.27, 11.69 }, ;
                        { "A3",       11.69, 16.54 }, ;
                        { "JIS B4",   10.12, 14.33 }, ;
                        { "JIS B5",    7.16, 10.12 }, ;
                        { "JPOST",     3.94,  5.83 }, ;
                        { "JPOSTD",    5.83,  7.87 }, ;
                        { "COM10",     4.12,  9.50 }, ;
                        { "MONARCH",   3.87,  7.50 }, ;
                        { "C5",        6.38,  9.01 }, ;
                        { "DL",        4.33,  8.66 }, ;
                        { "B5",        6.93,  9.84 } }

DEFAULT _cPageSize TO "LETTER"

   nSize := ascan( aSize, { |arr| LEFTEQUAL( arr[ 1 ], _cPageSize ) } )

   IF nSize == 0 .or. nSize > 2
      nSize := 1
   ENDIF

   ::aReport[ PAGESIZE ] := aSize[ nSize ][ 1 ]

   IF ::aReport[ PAGEORIENT ] == "P"
      ::aReport[ PAGEX ] := aSize[ nSize ][ 2 ] * 72
      ::aReport[ PAGEY ] := aSize[ nSize ][ 3 ] * 72
   ELSE
      ::aReport[ PAGEX ] := aSize[ nSize ][ 3 ] * 72
      ::aReport[ PAGEY ] := aSize[ nSize ][ 2 ] * 72
   ENDIF

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:PageOrient( _cPageOrient )
#else
METHOD PageOrient( _cPageOrient )
#endif

DEFAULT _cPageOrient TO "P"

   ::aReport[ PAGEORIENT ] := _cPageOrient
   ::PageSize( ::aReport[ PAGESIZE ] )
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:PageNumber( n )
#else
METHOD PageNumber( n )
#endif

DEFAULT n TO 0
   IF n > 0
      ::aReport[ REPORTPAGE ] := n // NEW !!!
   ENDIF
RETURN ::aReport[ REPORTPAGE ]

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Reverse( cString )
#else
METHOD Reverse( cString )
#endif

RETURN cString + CHR(255)

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:RJust( cString, nRow, nCol, cUnits, lExact, cId )
#else
METHOD RJust( cString, nRow, nCol, cUnits, lExact, cId )
#endif

local nLen, nAdj := 1.0, nAt

DEFAULT nRow TO ::aReport[ REPORTLINE ]
DEFAULT cUnits TO "R"
DEFAULT lExact TO .f.

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFRJUST", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := hb_UAt( "#pagenumber#", cString ) ) > 0
      cString := hb_ULeft( cString, nAt - 1 ) + LTrim(Str( ::PageNumber())) + hb_USubStr( cString, nAt + 12 )
   ENDIF

   nLen := ::length( cString )

   IF cUnits == "R"
      IF .not. lExact
         ::CheckLine( nRow )
         nRow := nRow + ::aReport[ PDFTOP]
      ENDIF
   ENDIF
   ::AtSay( cString, ::R2M( nRow ), IIF( cUnits == "R", ::aReport[ PDFLEFT ] + ( ::aReport[ PAGEX ] / 72 * 25.4 - 2 * ::aReport[ PDFLEFT ] ) * nCol / ::aReport[ REPORTWIDTH ] - nAdj, nCol ) - nLen, "M", lExact )
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:SetFont( _cFont, _nType, _nSize, cId )
#else
METHOD SetFont( _cFont, _nType, _nSize, cId )
#endif

DEFAULT _cFont TO "Times"
DEFAULT _nType TO 0
DEFAULT _nSize TO 10

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFSETFONT", cId, { _cFont, _nType, _nSize } )
   ENDIF

   _cFont := HMG_UPPER( _cFont )
   ::aReport[ FONTSIZE ] := _nSize

   IF _cFont == "TIMES"
      ::aReport[ FONTNAME ] := _nType + 1
   ELSEIF _cFont == "HELVETICA"
      ::aReport[ FONTNAME ] := _nType + 5
   ELSE
      ::aReport[ FONTNAME ] := _nType + 9 // 0.04
   ENDIF

   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )

   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:SetLPI(_nLpi)
#else
METHOD SetLPI(_nLpi)
#endif

local cLpi := ALLTRIM(Str(_nLpi))
DEFAULT _nLpi TO 6

   cLpi := iif(cLpi$"1;2;3;4;6;8;12;16;24;48",cLpi,"6")
   ::aReport[ LPI ] := Val( cLpi )

   ::PageSize( ::aReport[ PAGESIZE ] )
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:StringB( cString )
#else
METHOD StringB( cString )
#endif

cString := hb_utf8StrTran( cString, "(", "\(" )
cString := hb_utf8StrTran( cString, ")", "\)" )

RETURN cString

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:TextCount( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits )
#else
METHOD TextCount( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits )
#endif

RETURN ::Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, .f. )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, cColor, lPrint )
#else
METHOD Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, cColor, lPrint )
#endif

local cDelim := CHR(0)+CHR(9)+CHR(10)+CHR(13)+CHR(26)+CHR(32)+CHR(138)+CHR(141)
local nI, cTemp, cToken, k, nL, nRow, nLines, nLineLen, nStart
local lParagraph, nSpace, nNew, nTokenLen, nCRLF, nTokens, nLen

DEFAULT nTab     TO -1
DEFAULT cUnits   TO "R"
DEFAULT nJustify TO 4
DEFAULT lPrint   TO .t.
DEFAULT cColor   TO ""

   IF cUnits == "M"
      nTop := ::M2R( nTop )
   ELSEIF cUnits == "R"
      nLeft := ::X2M( ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nLeft * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00 )
   ENDIF

   ::aReport[ REPORTLINE ] := nTop - 1

   nSpace    := ::length( " " )
   nLines    := 0
   nCRLF     := 0
   nNew      := nTab
   cString   := ALLTRIM( cString )
   nTokens   := NumToken( cString, cDelim )

   nStart    := 1

   IF nJustify == 1 .or. nJustify == 4
      nLeft := nLeft
   ELSEIF nJustify == 2
      nLeft := nLeft - nLength / 2
   ELSEIF nJustify == 3
      nLeft := nLeft - nLength
   ENDIF

   nL := nLeft
   nL += nNew * nSpace
   nLineLen := nSpace * nNew - nSpace

   lParagraph := .t.
   nI := 1

   while nI <= nTokens
      cToken := token( cString, cDelim, nI )
      nTokenLen := ::length( cToken )
      nLen := HMG_LEN( cToken )

      IF nLineLen + nSpace + nTokenLen > nLength
         IF nStart == nI // single word > nLength
            k := 1
            while k <= nLen
               cTemp := ""
               nLineLen := 0.00
               nL := nLeft
               IF lParagraph
                  nLineLen += nSpace * nNew
                  IF nJustify != 2
                     nL += nSpace * nNew
                  ENDIF
                  lParagraph := .f.
               ENDIF
               IF nJustify == 2
                  nL := nLeft + ( nLength - ::length( cTemp ) ) / 2
               ELSEIF nJustify == 3
                  nL := nLeft + nLength - ::length( cTemp )
               ENDIF
               while k <= nLen .and. ( ( nLineLen += ::length( hb_USubStr( cToken, k, 1 ))) <= nLength )
                  nLineLen += ::length( hb_USubStr( cToken, k, 1 ))
                  cTemp += hb_USubStr( cToken, k, 1 )
                  ++k
               enddo
               IF Empty( cTemp ) // single character > nlength
                  cTemp := hb_USubStr( cToken, k, 1 )
                  ++k
               ENDIF
               ++nLines
               IF lPrint
                  nRow := ::NewLine( 1 )
                  ::AtSay( cColor + cTemp, ::R2M( nRow + ::aReport[ PDFTOP] ), nL, "M" )
               ENDIF
            enddo
            ++nI
            nStart := nI
         ELSE
            ::TextPrint( nI - 1, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ENDIF

      ELSEIF ( nI == nTokens ) .or. ( nI < nTokens .and. ( nCRLF := ::TextNextPara( cString, cDelim, nI ) ) > 0 )
         IF nI == nTokens
            nLineLen += nSpace + nTokenLen
         ENDIF
         ::TextPrint( nI, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ++nI

         IF nCRLF > 1
            nLines += nCRLF - 1
         ENDIF
         IF lPrint
            /*nRow :=*/ ::NewLine( nCRLF - 1 )
         ENDIF

      ELSE
         nLineLen += nSpace + nTokenLen
         ++nI
      ENDIF
   enddo

RETURN nLines

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:UnderLine( cString )
#else
METHOD UnderLine( cString )
#endif

RETURN cString + CHR(254)

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:OpenHeader( cFile )
#else
METHOD OpenHeader( cFile )
#endif

local nAt, cCmd

DEFAULT cFile TO ""

   IF !Empty( cFile )
      cFile := ALLTRIM( cFile )
      IF HMG_LEN( cFile ) > 12 .or. ;
         hb_UAt( " ", cFile ) > 0 .or. ;
         ( hb_UAt( " ", cFile ) == 0 .and. HMG_LEN( cFile ) > 8 ) .or. ;
         ( ( nAt := hb_UAt( ".", cFile )) > 0 .and. HMG_LEN( hb_USubStr( cFile, nAt + 1 )) > 3 )

         cCmd := "copy " + cFile + " temp.tmp > nul"
         RunExternal( cCmd )

         cFile := "temp.tmp"
      ENDIF
      // ::aReport[ HEADER ] := ft_RestArr( cFile, @nErrorCode )
      ::aReport[ HEADER ] := File2Array( cFile )
   ELSE
      ::aReport[ HEADER ] := {}
   ENDIF
   ::aReport[ MARGINS ] := .t.

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:EditOnHeader()
#else
METHOD EditOnHeader()
#endif

::aReport[ HEADEREDIT ] := .t.
::aReport[ MARGINS ] := .t.

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:EditOffHeader()
#else
METHOD EditOffHeader()
#endif

::aReport[ HEADEREDIT ] := .f.
::aReport[ MARGINS    ] := .t.

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:CloseHeader()
#else
METHOD CloseHeader()
#endif

   ::aReport[ HEADER ] := {}
   ::aReport[ MARGINS ] := .f.
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:DeleteHeader( cId )
#else
METHOD DeleteHeader( cId )
#endif

local nRet := -1, nId
   cId := HMG_UPPER( cId )
   nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      nRet := HMG_LEN( ::aReport[ HEADER ] ) - 1
      aDel( ::aReport[ HEADER ], nId )
      aSize( ::aReport[ HEADER ], nRet )
      ::aReport[ MARGINS ] := .t.
   ENDIF
RETURN nRet

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:EnableHeader( cId )
#else
METHOD EnableHeader( cId )
#endif

local nId
   cId := HMG_UPPER( cId )
   nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      ::aReport[ HEADER ][ nId ][ 1 ] := .t.
      ::aReport[ MARGINS ] := .t.
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:DisableHeader( cId )
#else
METHOD DisableHeader( cId )
#endif

local nId
   cId := HMG_UPPER( cId )
   nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      ::aReport[ HEADER ][ nId ][ 1 ] := .f.
      ::aReport[ MARGINS ] := .t.
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:SaveHeader( cFile )
#else
METHOD SaveHeader( cFile )
#endif

local cCmd

Array2File( "temp.tmp", ::aReport[ HEADER ] )

cCmd := "copy temp.tmp " + cFile + " > nul"
RunExternal( cCmd )

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Header( cFunction, cId, arr )
#else
METHOD Header( cFunction, cId, arr )
#endif

local nId, nI, nLen, nIdLen
   nId := 0
   IF !Empty( cId )
      cId := HMG_UPPER( cId )
      nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   ENDIF
   IF nId == 0
      nLen := HMG_LEN( ::aReport[ HEADER ] )
      IF Empty( cId )
         cId := cFunction
         nIdLen := HMG_LEN( cId )
         for nI := 1 to nLen
            IF ::aReport[ HEADER ][ nI ][ 2 ] == cId
               IF Val( hb_USubStr( ::aReport[ HEADER ][ nI ][ 3 ], nIdLen + 1 ) ) > nId
                  nId := Val( hb_USubStr( ::aReport[ HEADER ][ nI ][ 3 ], nIdLen + 1 ) )
               ENDIF
            ENDIF
         next
         ++nId
         cId += LTrim(Str(nId))
      ENDIF
      aadd( ::aReport[ HEADER ], { .t., cFunction, cId } )
      ++nLen
      for nI := 1 to HMG_LEN( arr )
         aadd( ::aReport[ HEADER ][ nLen ], arr[ nI ] )
      next
   ELSE
      aSize( ::aReport[ HEADER ][ nId ], 3 )
      for nI := 1 to HMG_LEN( arr )
         aadd( ::aReport[ HEADER ][ nId ], arr[ nI ] )
      next
   ENDIF
RETURN cId

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:DrawHeader()
#else
METHOD DrawHeader()
#endif

local nI, _nFont, _nSize, nLen := HMG_LEN( ::aReport[ HEADER ] )

   IF nLen > 0

      // save font
      _nFont := ::aReport[ FONTNAME ]
      _nSize := ::aReport[ FONTSIZE ]

      for nI := 1 to nLen
         IF ::aReport[ HEADER ][ nI ][ 1 ] // enabled
            do case
            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFATSAY"
               ::AtSay( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFCENTER"
               ::Center( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFRJUST"
               ::RJust( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFBOX"
               ::Box( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 9 ], ::aReport[ HEADER ][ nI ][ 10 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFSETFONT"
               ::SetFont( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFIMAGE"
               ::Image( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 9 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            endcase
         ENDIF
      next
      ::aReport[ FONTNAME ] := _nFont
      ::aReport[ FONTSIZE ] := _nSize

      IF ::aReport[ MARGINS ]
         ::Margins()
      ENDIF

   ELSE
      IF ::aReport[ MARGINS ]
         ::aReport[ PDFTOP] := 1 // top
         ::aReport[ PDFLEFT ] := 10 // LEFT & RIGHT
         ::aReport[ PDFBOTTOM ] := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6

         ::aReport[ MARGINS ] := .f.
      ENDIF
   ENDIF
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Margins( nTop, nLeft, nBottom )
#else
METHOD Margins( nTop, nLeft, nBottom )
#endif

local nI, nLen := HMG_LEN( ::aReport[ HEADER ] ), nTemp, aTemp, nHeight

   for nI := 1 to nLen
      IF ::aReport[ HEADER ][ nI ][ 1 ] // enabled

         IF ::aReport[ HEADER ][ nI ][ 2 ] == "PDFSETFONT"

         ELSEIF ::aReport[ HEADER ][ nI ][ 2 ] == "PDFIMAGE"
            IF ::aReport[ HEADER ][ nI ][ 8 ] == 0 // picture in header, first at all, not at any page yet
               aTemp := ::ImageInfo( ::aReport[ HEADER ][ nI ][ 4 ] )
               nHeight := aTemp[ IMAGE_HEIGHT ] / aTemp[ IMAGE_YRES ] * 25.4
               IF ::aReport[ HEADER ][ nI ][ 7 ] == "D"
                  nHeight := ::M2X( nHeight )
               ENDIF
            ELSE
               nHeight := ::aReport[ HEADER ][ nI ][ 8 ]
            ENDIF

            IF ::aReport[ HEADER ][ nI ][ 7 ] == "M"

               nTemp := ::aReport[ PAGEY ] / 72 * 25.4 / 2

               IF ::aReport[ HEADER ][ nI ][ 5 ] < nTemp
                  nTemp := ( ::aReport[ HEADER ][ nI ][ 5 ] + nHeight ) * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSE
                  nTemp := ::aReport[ HEADER ][ nI ][ 5 ] * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ELSEIF ::aReport[ HEADER ][ nI ][ 7 ] == "D"
               nTemp := ::aReport[ PAGEY ] / 2

               IF ::aReport[ HEADER ][ nI ][ 5 ] < nTemp
                  nTemp := ( ::aReport[ HEADER ][ nI ][ 5 ] + nHeight ) * ::aReport[ LPI ] / 72 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSE
                  nTemp := ::aReport[ HEADER ][ nI ][ 5 ] * ::aReport[ LPI ] / 72 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ENDIF

            ENDIF

         ELSEIF ::aReport[ HEADER ][ nI ][ 2 ] == "PDFBOX"

            IF ::aReport[ HEADER ][ nI ][ 10 ] == "M"

               nTemp := ::aReport[ PAGEY ] / 72 * 25.4 / 2

               IF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                  ::aReport[ HEADER ][ nI ][ 6 ] < nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 6 ] * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 4 ] + ::aReport[ HEADER ][ nI ][ 8 ] ) * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 6 ] - ::aReport[ HEADER ][ nI ][ 8 ] ) * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] > nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 4 ] * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ELSEIF ::aReport[ HEADER ][ nI ][ 10 ] == "D"
               nTemp := ::aReport[ PAGEY ] / 2

               IF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                  ::aReport[ HEADER ][ nI ][ 6 ] < nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 6 ] / ::aReport[ LPI ] // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 4 ] + ::aReport[ HEADER ][ nI ][ 8 ] ) / ::aReport[ LPI ] // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 6 ] - ::aReport[ HEADER ][ nI ][ 8 ] ) / ::aReport[ LPI ] // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] > nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 4 ] / ::aReport[ LPI ] // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ENDIF

         ELSE
            IF ::aReport[ HEADER ][ nI ][ 7 ] == "R"
               nTemp := ::aReport[ HEADER ][ nI ][ 5 ] // top
               IF ::aReport[ HEADER ][ nI ][ 5 ] > ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] / 2
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aReport[ HEADER ][ nI ][ 7 ] == "M"
               nTemp := ::aReport[ HEADER ][ nI ][ 5 ] * ::aReport[ LPI ] / 25.4 // top
               IF ::aReport[ HEADER ][ nI ][ 5 ] > ::aReport[ PAGEY ] / 72 * 25.4 / 2
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aReport[ HEADER ][ nI ][ 7 ] == "D"
               nTemp := ::aReport[ HEADER ][ nI ][ 5 ] / ::aReport[ LPI ] // top
               IF ::aReport[ HEADER ][ nI ][ 5 ] > ::aReport[ PAGEY ] / 2
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   next

   IF nTop != NIL
      ::aReport[ PDFTOP] := nTop
   ENDIF
   IF nLeft != NIL
      ::aReport[ PDFLEFT ] := nLeft
   ENDIF
   IF nBottom != NIL
      ::aReport[ PDFBOTTOM ] := nBottom
   ENDIF

   ::aReport[ MARGINS ] := .f.

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:CreateHeader( _file, _size, _orient, _lpi, _width )
#else
METHOD CreateHeader( _file, _size, _orient, _lpi, _width )
#endif

local ;
   aReportStyle := {                                                  ;
                     { 1,     2,   3,   4,    5,     6    }, ; //"Default"
                     { 2.475, 4.0, 4.9, 6.4,  7.5,  64.0  }, ; //"P6"
                     { 3.3  , 5.4, 6.5, 8.6, 10.0,  85.35 }, ; //"P8"
                     { 2.475, 4.0, 4.9, 6.4,  7.5,  48.9  }, ; //"L6"
                     { 3.3  , 5.4, 6.5, 8.6, 10.0,  65.2  }, ; //"L8"
                     { 2.475, 4.0, 4.9, 6.4,  7.5,  82.0  }, ; //"P6"
                     { 3.3  , 5.4, 6.5, 8.6, 10.0, 109.35 }  ; //"P8"
                   }
local nStyle := 1, nAdd := 0.00

DEFAULT _size TO ::aReport[ PAGESIZE ]
DEFAULT _orient TO ::aReport[ PAGEORIENT ]
DEFAULT _lpi TO ::aReport[ LPI ]
DEFAULT _width TO 200

   IF _size == "LETTER"
      IF _orient == "P"
         IF _lpi == 6
            nStyle := 2
         ELSEIF _lpi == 8
            nStyle := 3
         ENDIF
      ELSEIF _orient == "L"
         IF _lpi == 6
            nStyle := 4
         ELSEIF _lpi == 8
            nStyle := 5
         ENDIF
      ENDIF
   ELSEIF _size == "LEGAL"
      IF _orient == "P"
         IF _lpi == 6
            nStyle := 6
         ELSEIF _lpi == 8
            nStyle := 7
         ENDIF
      ELSEIF _orient == "L"
         IF _lpi == 6
            nStyle := 4
         ELSEIF _lpi == 8
            nStyle := 5
         ENDIF
      ENDIF
   ENDIF

   ::EditOnHeader()

   IF _size == "LEGAL"
      nAdd := 76.2
   ENDIF

   IF _orient == "P"
      ::Box(   5.0, 5.0, 274.0 + nAdd, 210.0,  1.0 )
      ::Box(   6.5, 6.5, 272.5 + nAdd, 208.5,  0.5 )

      ::Box(  11.5, 9.5,  22.0       , 205.5,  0.5, 5 )
      ::Box(  23.0, 9.5,  33.5       , 205.5,  0.5, 5 )
      ::Box(  34.5, 9.5, 267.5 + nAdd, 205.5,  0.5 )

   ELSE
      ::Box(  5.0, 5.0, 210.0, 274.0 + nAdd, 1.0 )
      ::Box(  6.5, 6.5, 208.5, 272.5 + nAdd, 0.5 )

      ::Box( 11.5, 9.5,  22.0, 269.5 + nAdd, 0.5, 5 )
      ::Box( 23.0, 9.5,  33.5, 269.5 + nAdd, 0.5, 5 )
      ::Box( 34.5, 9.5, 203.5, 269.5 + nAdd, 0.5 )
   ENDIF

   ::SetFont("Arial", BOLD, 10)
   ::AtSay( "Test Line 1", aReportStyle[ nStyle ][ 1 ], 1, "R", .t. )

   ::SetFont("Times", BOLD, 18)
   ::Center( "Test Line 2", aReportStyle[ nStyle ][ 2 ],,"R", .t. )

   ::SetFont("Times", BOLD, 12)
   ::Center( "Test Line 3", aReportStyle[ nStyle ][ 3 ],,"R", .t. )

   ::SetFont("Arial", BOLD, 10)
   ::AtSay( "Test Line 4", aReportStyle[ nStyle ][ 4 ], 1, "R", .t. )

   ::SetFont("Arial", BOLD, 10)
   ::AtSay( "Test Line 5", aReportStyle[ nStyle ][ 5 ], 1, "R", .t. )

   ::AtSay( DToC( Date()) + " " + TimeAsAMPM( Time() ), aReportStyle[ nStyle ][ 6 ], 1, "R", .t. )
   ::RJust( "Page: #pagenumber#", aReportStyle[ nStyle ][ 6 ], ::aReport[ REPORTWIDTH ], "R", .t. )

   ::EditOffHeader()
   ::SaveHeader( _file )
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:ImageInfo( cFile )
#else
METHOD ImageInfo( cFile )
#endif

local cTemp := HMG_UPPER(hb_USubStr( cFile, hb_utf8RAt(".", cFile) + 1 )), aTemp := {}
   do case
   case cTemp == "TIF"
      aTemp := ::TIFFInfo( cFile )
   case cTemp == "JPG"
      aTemp := ::JPEGInfo( cFile )
   endcase
RETURN aTemp

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:TIFFInfo( cFile )
#else
METHOD TIFFInfo( cFile )
#endif

local c40    := CHR(0)+CHR(0)+CHR(0)+CHR(0)
//local aType  := {"BYTE","ASCII","SHORT","LONG","RATIONAL","SBYTE","UNDEFINED","SSHORT","SLONG","SRATIONAL","FLOAT","DOUBLE"}
local aCount := { 1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8 }
local nTemp, nHandle, cValues, c2, nFieldType, nCount, nPos, nTag, nValues
local nOffset, cTemp, cIFDNext, nIFD, nFields, cTag, nn

local nWidth := 0, nHeight := 0, nBits := 0, nFrom := 0, nLength := 0, xRes := 0, yRes := 0, aTemp := {}

   nHandle := FOpen( cFile )

   c2 := "  "
   FRead( nHandle, @c2, 2 )
   FRead( nHandle, @c2, 2 )

   cIFDNext := "    "
   FRead( nHandle, @cIFDNext, 4 )

   cTemp  := Space(12)


   while !( cIFDNext == c40 ) //read IFD's

      nIFD := bin2l( cIFDNext )

      FSeek( nHandle, nIFD )

      FRead( nHandle, @c2, 2 )
      nFields := bin2i( c2 )

      for nn := 1 to nFields
         FRead( nHandle, @cTemp, 12 )

         nTag       := bin2w( hb_USubStr( cTemp, 1, 2 ) )
         nFieldType := bin2w( hb_USubStr( cTemp, 3, 2 ) )
         nCount     := bin2l( hb_USubStr( cTemp, 5, 4 ) )
         nOffset    := bin2l( hb_USubStr( cTemp, 9, 4 ) )

         IF nCount > 1 .or. nFieldType == RATIONAL .or. nFieldType == SRATIONAL
            nPos := filepos( nHandle )
            FSeek( nHandle, nOffset)

            nValues := nCount * aCount[ nFieldType ]
            cValues := Space( nValues )
            FRead( nHandle, @cValues, nValues )
            FSeek( nHandle, nPos )
         ELSE
            cValues := hb_USubStr( cTemp, 9, 4 )
         ENDIF

         IF nFieldType ==  ASCII
            --nCount
         ENDIF
         //cTag := ""
         do case
         case nTag == 256
            cTag := "ImageWidth"

            IF nFieldType ==  SHORT
               nWidth := bin2w( hb_USubStr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nWidth := bin2l( hb_USubStr( cValues, 1, 4 ))
            ENDIF

         case nTag == 257
            cTag := "ImageLength"
            IF nFieldType ==  SHORT
               nHeight := bin2w(hb_USubStr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nHeight := bin2l(hb_USubStr( cValues, 1, 4 ))
            ENDIF

         case nTag == 258
            cTag := "BitsPerSample"
            nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF
            nBits := nTemp
         case nTag == 259
            cTag := "Compression"
            /*nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF*/
         case nTag == 262
            cTag := "PhotometricInterpretation"
            /*nTemp := -1
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF*/
         case nTag == 264
            cTag := "CellWidth"
         case nTag == 265
            cTag := "CellLength"
         case nTag == 266
            cTag := "FillOrder"
         case nTag == 273
            cTag := "StripOffsets"
            IF nFieldType ==  SHORT
               nFrom := bin2w(hb_USubStr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nFrom := bin2l(hb_USubStr( cValues, 1, 4 ))
            ENDIF

         case nTag == 277
            cTag := "SamplesPerPixel"
         case nTag == 278
            cTag := "RowsPerStrip"
         case nTag == 279
            cTag := "StripByteCounts"
            IF nFieldType ==  SHORT
               nLength := bin2w(hb_USubStr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nLength := bin2l(hb_USubStr( cValues, 1, 4 ))
            ENDIF

            nLength *= nCount // Count all strips !!!

         case nTag == 282
            cTag := "XResolution"
            xRes := bin2l(hb_USubStr( cValues, 1, 4 ))
         case nTag == 283
            cTag := "YResolution"
            yRes := bin2l(hb_USubStr( cValues, 1, 4 ))
         case nTag == 284
            cTag := "PlanarConfiguration"
         case nTag == 288
            cTag := "FreeOffsets"
         case nTag == 289
            cTag := "FreeByteCounts"
         case nTag == 296
            cTag := "ResolutionUnit"
            /*nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF*/
         case nTag == 305
            cTag := "Software"
         case nTag == 306
            cTag := "DateTime"
         case nTag == 315
            cTag := "Artist"
         case nTag == 320
            cTag := "ColorMap"
         case nTag == 338
            cTag := "ExtraSamples"
         case nTag == 33432
            cTag := "Copyright"
         otherwise
            cTag := "Unknown"
         endcase
      next
      FRead( nHandle, @cIFDNext, 4 )
   enddo
   HB_SYMBOL_UNUSED( cTag )  // TOFIX
   FClose( nHandle )

   aadd( aTemp, nWidth )
   aadd( aTemp, nHeight )
   aadd( aTemp, xRes )
   aadd( aTemp, yRes )
   aadd( aTemp, nBits )
   aadd( aTemp, nFrom )
   aadd( aTemp, nLength )

return aTemp

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:JPEGInfo( cFile )
#else
METHOD JPEGInfo( cFile )
#endif

local c255, nAt, nHandle
local nWidth, nHeight, nBits := 8, nFrom := 0
local nLength, xRes, yRes, aTemp := {}

   nHandle := FOpen( cFile )

   c255 := Space(1024)
   FRead( nHandle, @c255, 1024 )

   xRes := ASC(hb_USubStr( c255, 15, 1 )) * 256 + ASC(hb_USubStr( c255, 16, 1 ))
   yRes := ASC( hb_USubStr( c255, 17, 1 )) * 256 + ASC(hb_USubStr( c255, 18, 1 ))

   nAt := hb_UAt( CHR(255) + CHR(192), c255 ) + 5
   nHeight := ASC(hb_USubStr( c255, nAt, 1 )) * 256 + ASC(hb_USubStr( c255, nAt + 1, 1 ))
   nWidth := ASC( hb_USubStr( c255, nAt + 2, 1 )) * 256 + ASC(hb_USubStr( c255, nAt + 3, 1 ))

   FClose( nHandle )

   nLength := FileSize( cFile )

   aadd( aTemp, nWidth )
   aadd( aTemp, nHeight )
   aadd( aTemp, xRes )
   aadd( aTemp, yRes )
   aadd( aTemp, nBits )
   aadd( aTemp, nFrom )
   aadd( aTemp, nLength )

return aTemp

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookCount( nRecno, nCurLevel )
#else
METHOD BookCount( nRecno, nCurLevel )
#endif

local nTempLevel, nCount := 0, nLen := HMG_LEN( ::aReport[ BOOKMARK ] )
   ++nRecno
   while nRecno <= nLen
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nTempLevel <= nCurLevel
         exit
      ELSE
         IF nCurLevel + 1 == nTempLevel
            ++nCount
         ENDIF
      ENDIF
      ++nRecno
   enddo
return -1 * nCount

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookFirst( nRecno, nCurLevel, nObj )
#else
METHOD BookFirst( nRecno, nCurLevel, nObj )
#endif

local nFirst := 0, nLen := HMG_LEN( ::aReport[ BOOKMARK ] )
   ++nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         nFirst := nRecno
      ENDIF
   ENDIF
return IIF( nFirst == 0, nFirst, nObj + nFirst )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookLast( nRecno, nCurLevel, nObj )
#else
METHOD BookLast( nRecno, nCurLevel, nObj )
#endif

local nLast := 0, nLen := HMG_LEN( ::aReport[ BOOKMARK ] )
   ++nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         while nRecno <= nLen .and. nCurLevel + 1 <= ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
            IF nCurLevel + 1 == ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
               nLast := nRecno
            ENDIF
            ++nRecno
         enddo
      ENDIF
   ENDIF
return IIF( nLast == 0, nLast, nObj + nLast )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookNext( nRecno, nCurLevel, nObj )
#else
METHOD BookNext( nRecno, nCurLevel, nObj )
#endif

local nTempLevel, nNext := 0, nLen := HMG_LEN( ::aReport[ BOOKMARK ] )
   ++nRecno
   while nRecno <= nLen
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nCurLevel > nTempLevel
         exit
      ELSEIF nCurLevel == nTempLevel
         nNext := nRecno
         exit
      ELSE
         // keep going
      ENDIF
      ++nRecno
   enddo
return IIF( nNext == 0, nNext, nObj + nNext )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookParent( nRecno, nCurLevel, nObj )
#else
METHOD BookParent( nRecno, nCurLevel, nObj )
#endif

local nTempLevel
local nParent := 0
   --nRecno
   while nRecno > 0
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nTempLevel < nCurLevel
         nParent := nRecno
         exit
      ENDIF
      --nRecno
   enddo
return IIF( nParent == 0, nObj - 1, nObj + nParent )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:BookPrev( nRecno, nCurLevel, nObj )
#else
METHOD BookPrev( nRecno, nCurLevel, nObj )
#endif

local nTempLevel
local nPrev := 0
   --nRecno
   while nRecno > 0
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nCurLevel > nTempLevel
         exit
      ELSEIF nCurLevel == nTempLevel
         nPrev := nRecno
         exit
      ELSE
         // keep going
      ENDIF
      --nRecno
   enddo
return IIF( nPrev == 0, nPrev, nObj + nPrev )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:CheckLine( nRow )
#else
METHOD CheckLine( nRow )
#endif

   IF nRow + ::aReport[ PDFTOP] > ::aReport[ PDFBOTTOM ]
      ::NewPage()
      nRow := ::aReport[ REPORTLINE ]
   ENDIF
   ::aReport[ REPORTLINE ] := nRow
RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:GetFontInfo( cParam )
#else
METHOD GetFontInfo( cParam )
#endif

local cRet
   IF cParam == "NAME"
      IF hb_ULeft( ::aReport[ TYPE1 ][ ::aReport[ FONTNAME ] ], 5 ) == "Times"
         cRet := "Times"
      ELSEIF hb_ULeft( ::aReport[ TYPE1 ][ ::aReport[ FONTNAME ] ], 9 ) == "Helvetica"
         cRet := "Helvetica"
      ELSE
         cRet := "Courier" // 0.04
      ENDIF
   ELSE // size
      cRet := int(( ::aReport[ FONTNAME ] - 1 ) % 4)
   ENDIF

return cRet

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:M2R( mm )
#else
METHOD M2R( mm )
#endif

return int( ::aReport[ LPI ] * mm / 25.4 )

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:M2X( n )
#else
METHOD M2X( n )
#endif

return n * 72 / 25.4

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:M2Y( n )
#else
METHOD M2Y( n )
#endif

return ::aReport[ PAGEY ] -  n * 72 / 25.4

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:R2D( nRow )
#else
METHOD R2D( nRow )
#endif

return ::aReport[ PAGEY ] - nRow * 72 / ::aReport[ LPI ]

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:R2M( nRow )
#else
METHOD R2M( nRow )
#endif

return 25.4 * nRow / ::aReport[ LPI ]

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:X2M( n )
#else
METHOD X2M( n )
#endif

return n * 25.4 / 72

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:TextPrint( nI, nLeft, lParagraph, nJustify, nSpace, nNew, nLength, nLineLen, nLines, nStart, cString, cDelim, cColor, lPrint )
#else
METHOD TextPrint( nI, nLeft, lParagraph, nJustify, nSpace, nNew, nLength, nLineLen, nLines, nStart, cString, cDelim, cColor, lPrint )
#endif

local nFinish, nL, nB, nJ, cToken, nRow

   nFinish := nI

   nL := nLeft
   IF lParagraph
      IF nJustify != 2
         nL += nSpace * nNew
      ENDIF
   ENDIF

   IF nJustify == 3 // RIGHT
      nL += nLength - nLineLen
   ELSEIF nJustify == 2 // center
      nL += ( nLength - nLineLen ) / 2
   ENDIF

   ++nLines
   IF lPrint
      nRow := ::NewLine( 1 )
   ENDIF
   nB := nSpace
   IF nJustify == 4
      nB := ( nLength - nLineLen + ( nFinish - nStart ) * nSpace ) / ( nFinish - nStart )
   ENDIF
   for nJ := nStart to nFinish
      cToken := token( cString, cDelim, nJ )
      IF lPrint
         // version 0.02
         ::AtSay( cColor + cToken, ::R2M( nRow + ::aReport[ PDFTOP ] ), nL, "M" )
      ENDIF
      nL += ::Length( cToken ) + nB
   next

   nStart := nFinish + 1

   lParagraph := .f.

   nLineLen := 0.00
   nLineLen += nSpace * nNew

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:TextNextPara( cString, cDelim, nI )
#else
METHOD TextNextPara( cString, cDelim, nI )
#endif

local nAt, cAt, nCRLF, nNew, nRat, nRet := 0
   // check if next spaces paragraph(s)
   nAt := attoken( cString, cDelim, nI ) + HMG_LEN( token( cString, cDelim, nI ) )
   cAt := hb_USubStr( cString, nAt, attoken( cString, cDelim, nI + 1 ) - nAt )
   nCRLF := NumAt( CHR(13) + CHR(10), cAt )
   nRat := hb_utf8RAt( CHR(13) + CHR(10), cAt )
   nNew := HMG_LEN( cAt ) - nRat - IIF( nRat > 0, 1, 0 )
   IF nCRLF > 1 .or. ( nCRLF == 1 .and. nNew > 0 )
      nRet := nCRLF
   ENDIF
return nRet

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:ClosePage()
#else
METHOD ClosePage()
#endif

local cTemp, cBuffer, nBuffer, nRead, nI, k, nImage, nFont, nImageHandle

   aadd( ::aReport[ REFS  ], ::aReport[ DOCLEN    ] )

   aadd( ::aReport[ PAGES ], ::aReport[ REPORTOBJ ] + 1 )

   cTemp := ;
     LTrim(Str( ++::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
     "<<" + CRLF + ;
     "/Type /Page /Parent 1 0 R" + CRLF + ;
     "/Resources " + LTrim(Str( ++::aReport[ REPORTOBJ ] )) + " 0 R" + CRLF + ;
     "/MediaBox [ 0 0 " + LTrim(Transform( ::aReport[ PAGEX ], "9999.99")) + " " + ;
     LTrim(Transform(::aReport[ PAGEY ], "9999.99")) + " ]" + CRLF + ;
     "/Contents " + LTrim(Str( ++::aReport[ REPORTOBJ ] )) + " 0 R" + CRLF + ;
     ">>" + CRLF + ;
    "endobj" + CRLF


   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := ;
   LTrim(Str(::aReport[ REPORTOBJ ] - 1)) + " 0 obj" + CRLF + ;
   "<<"+CRLF+;
   "/ColorSpace << /DeviceRGB /DeviceGray >>" + CRLF + ; //version 0.01
   "/ProcSet [ /PDF /Text /ImageB /ImageC ]"

   IF HMG_LEN( ::aReport[ PAGEFONTS ] ) > 0
      cTemp += CRLF + ;
      "/Font" + CRLF + ;
      "<<"

      for nI := 1 to HMG_LEN( ::aReport[ PAGEFONTS ] )
         nFont := ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ PAGEFONTS ][ nI ] } )
         cTemp += CRLF + "/Fo" + LTrim(Str( nFont )) + " " + LTrim(Str( ::aReport[ FONTS ][ nFont ][ 2 ])) + " 0 R"
      next

      cTemp += CRLF + ">>"
   ENDIF

   IF HMG_LEN( ::aReport[ PAGEIMAGES ] ) > 0
      cTemp += CRLF + "/XObject" + CRLF + "<<"
      for nI := 1 to HMG_LEN( ::aReport[ PAGEIMAGES ] )
         nImage := ascan( ::aReport[ IMAGES ], { |arr| arr[1] == ::aReport[ PAGEIMAGES ][ nI ][ 1 ] } )
         IF nImage == 0
            aadd( ::aReport[ IMAGES ], { ::aReport[ PAGEIMAGES ][ nI ][ 1 ], ++::aReport[ NEXTOBJ ], ::ImageInfo( ::aReport[ PAGEIMAGES ][ nI ][ 1 ] ) } )
            nImage := HMG_LEN( ::aReport[ IMAGES ] )
         ENDIF
         cTemp += CRLF + "/Image" + LTrim(Str( nImage )) + " " + LTrim(Str( ::aReport[ IMAGES ][ nImage ][ 2 ])) + " 0 R"
      next
      cTemp += CRLF + ">>"
   ENDIF

   cTemp += CRLF + ">>" + CRLF + "endobj" + CRLF

   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := LTrim(Str( ::aReport[ REPORTOBJ ] )) + " 0 obj << /Length " + ;
   LTrim(Str( ::aReport[ REPORTOBJ ] + 1 )) + " 0 R >>" + CRLF +;
   "stream"

   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   IF HMG_LEN( ::aReport[ PAGEIMAGES ] ) > 0
      cTemp := ""
      for nI := 1 to HMG_LEN( ::aReport[ PAGEIMAGES ] )
         cTemp += CRLF + "q"
         nImage := ascan( ::aReport[ IMAGES ], { |arr| arr[1] == ::aReport[ PAGEIMAGES ][ nI ][ 1 ] } )
         cTemp += CRLF + LTrim(Str( IIF( ::aReport[ PAGEIMAGES ][ nI ][ 5 ] == 0, ::M2X( ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_WIDTH ] / ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_XRES ] * 25.4 ), ::aReport[ PAGEIMAGES ][ nI ][ 5 ]))) + ;
         " 0 0 " + ;
         LTrim(Str( IIF( ::aReport[ PAGEIMAGES ][ nI ][ 4 ] == 0, ::M2X( ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_HEIGHT ] / ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_YRES ] * 25.4 ), ::aReport[ PAGEIMAGES ][ nI ][ 4 ]))) + ;
         " " + LTrim(Str( ::aReport[ PAGEIMAGES ][ nI ][ 3 ] )) + ;
         " " + LTrim(Str( ::aReport[ PAGEY ] - ::aReport[ PAGEIMAGES ][ nI ][ 2 ] - ;
         IIF( ::aReport[ PAGEIMAGES ][ nI ][ 4 ] == 0, ::M2X( ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_HEIGHT ] / ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_YRES ] * 25.4 ), ::aReport[ PAGEIMAGES ][ nI ][ 4 ]))) + " cm"
         cTemp += CRLF + "/Image" + LTrim(Str( nImage )) + " Do"
         cTemp += CRLF + "Q"
      next
      ::aReport[ PAGEBUFFER ] := cTemp + ::aReport[ PAGEBUFFER ]
   ENDIF

   cTemp := ::aReport[ PAGEBUFFER ]

   cTemp += CRLF + "endstream" + CRLF + ;
   "endobj" + CRLF

   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := LTrim(Str( ++::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   LTrim(Str(HMG_LEN( ::aReport[ PAGEBUFFER ] ))) + CRLF + ;
   "endobj" + CRLF

   ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
   FWrite( ::aReport[ HANDLE ], cTemp )

   for nI := 1 to HMG_LEN( ::aReport[ FONTS ] )
      IF ::aReport[ FONTS ][ nI ][ 2 ] > ::aReport[ REPORTOBJ ]

         aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )

         cTemp := ;
         LTrim(Str( ::aReport[ FONTS ][ nI ][ 2 ] )) + " 0 obj" + CRLF + ;
         "<<" + CRLF + ;
         "/Type /Font" + CRLF + ;
         "/Subtype /Type1" + CRLF + ;
         "/Name /Fo" + LTrim(Str( nI )) + CRLF + ;
         "/BaseFont /" + ::aReport[ TYPE1 ][ ::aReport[ FONTS ][ nI ][ 1 ] ] + CRLF + ;
         "/Encoding /WinAnsiEncoding" + CRLF + ;
         ">>" + CRLF + ;
         "endobj" + CRLF

         ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
         FWrite( ::aReport[ HANDLE ], cTemp )

      ENDIF
   next

   for nI := 1 to HMG_LEN( ::aReport[ IMAGES ] )
      IF ::aReport[ IMAGES ][ nI ][ 2 ] > ::aReport[ REPORTOBJ ]

         aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )

         cTemp :=  ;
          LTrim(Str( ::aReport[ IMAGES ][ nI ][ 2 ] )) + " 0 obj" + CRLF + ;
          "<<" + CRLF + ;
          "/Type /XObject" + CRLF + ;
          "/Subtype /Image" + CRLF + ;
          "/Name /Image" + LTrim(Str(nI)) + CRLF + ;
          "/Filter [" + IIF( hb_UAt( ".jpg", HMG_LOWER( ::aReport[ IMAGES ][ nI ][ 1 ]) ) > 0, " /DCTDecode", "" ) + " ]" + CRLF + ;
          "/Width " + LTrim(Str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_WIDTH ] )) + CRLF + ;
          "/Height " + LTrim(Str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_HEIGHT ] )) + CRLF + ;
          "/BitsPerComponent " + LTrim(Str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_BITS ] )) + CRLF + ;
          "/ColorSpace /" + IIF( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_BITS ] == 1, "DeviceGray", "DeviceRGB") + CRLF + ;
          "/Length " + LTrim(Str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ])) + CRLF + ;
          ">>" + CRLF + ;
          "stream" + CRLF

         ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
         FWrite( ::aReport[ HANDLE ], cTemp )

         nImageHandle := FOpen( ::aReport[ IMAGES ][ nI ][ 1 ] )
         FSeek( nImageHandle, ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_FROM ] )

         nBuffer := 8192
         cBuffer := Space( nBuffer )
         k := 0
         while k < ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ]
            IF k + nBuffer <= ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ]
               nRead := nBuffer
            ELSE
               nRead := ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ] - k
            ENDIF
            FRead( nImageHandle, @cBuffer, nRead )

            ::aReport[ DOCLEN ] += nRead
            FWrite( ::aReport[ HANDLE ], cBuffer, nRead )
            k += nRead
         enddo

         cTemp := CRLF + "endstream" + CRLF + "endobj" + CRLF

         ::aReport[ DOCLEN ] += HMG_LEN( cTemp )
         FWrite( ::aReport[ HANDLE ], cTemp )

         FClose( nImageHandle )
      ENDIF
   next

   ::aReport[ REPORTOBJ  ] := ::aReport[ NEXTOBJ ]

   ::aReport[ NEXTOBJ    ] := ::aReport[ REPORTOBJ ] + 4

   ::aReport[ PAGEBUFFER ] := ""

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:FilePrint( cFile )
#else
METHOD FilePrint( cFile )
#endif
local cPathAcro := "C:\progra~1\Adobe\Acroba~1.0\Reader"
local cRun := cPathAcro + "\AcroRd32.exe /t " + cFile + " " + ;
            CHR(34) + "HP LaserJet 5/5M PostScript" + CHR(34) + " " + ;
            CHR(34) + "LPT1" + CHR(34)

IF ( ! RunExternal( cRun, "print" ) )
   alert( "Error printing to PDF reader." )
   break
ENDIF

RETURN self

//-------------------------\\

#ifdef __XPP__
METHOD tPdf:Execute( cFile )
#else
METHOD Execute( cFile )
#endif
//  Replace cPathAcro with the path at your system
local cPathAcro := "C:\progra~1\Adobe\Acroba~1.0\Reader"
local cRun := cPathAcro + "\AcroRd32.exe /t " + cFile + " " + CHR(34) + "HP LaserJet 5/5M PostScript" + CHR(34) + " " + CHR(34) + "LPT1" + CHR(34)

IF (! RunExternal( cRun, "open", cFile ) )
   alert("Error printing to PDF reader.")
   break
ENDIF

RETURN self

//-------------------------\\
//-------------------------\\
//-------------------------\\

STATIC function FilePos( nHandle )
return FSeek( nHandle, 0, FS_RELATIVE )

//-------------------------\\
/*
STATIC function Stuff( cStr, nBeg, nDel, cIns )
return PosIns( PosDel( cStr, nBeg, nDel ), cIns, nBeg )
*/
//-------------------------\\

STATIC function Chr_RGB( cChar )
return Str(ASC( cChar ) / 255, 4, 2)

//-------------------------\\

STATIC function TimeAsAMPM( cTime )
   IF Val(cTime) < 12
      cTime += " am"
   ELSEIF Val(cTime) == 12
      cTime += " pm"
   ELSE
      cTime := Str(Val(cTime) - 12, 2) + hb_USubStr(cTime, 3) + " pm"
   ENDIF
   cTime := hb_ULeft( cTime, 5 ) + hb_USubStr( cTime, 10 )
return cTime

//-------------------------\\

STATIC function FileSize( cFile )

   LOCAL nLength
   LOCAL nHandle

   nHandle := FOpen( cFile )
   nLength := FSeek( nHandle, 0, FS_END )
   FClose( nHandle )

return nLength

//-------------------------\\

STATIC FUNCTION NumToken( cString, cDelimiter )
RETURN AllToken( cString, cDelimiter )

//-------------------------\\

STATIC FUNCTION Token( cString, cDelimiter, nPointer )
RETURN AllToken( cString, cDelimiter, nPointer, 1 )

//-------------------------\\

STATIC function AtToken( cString, cDelimiter, nPointer )
return AllToken( cString, cDelimiter, nPointer, 2 )

//-------------------------\\

STATIC function AllToken( cString, cDelimiter, nPointer, nAction )
local nTokens := 0
local nPos    := 1
local nLen    := HMG_LEN( cString )
local nStart
local cRet    := 0

DEFAULT cDelimiter TO CHR(0)+CHR(9)+CHR(10)+CHR(13)+CHR(26)+CHR(32)+CHR(138)+CHR(141)
DEFAULT nAction to 0

// nAction == 0 - numtoken
// nAction == 1 - token
// nAction == 2 - attoken

while nPos <= nLen
   if .not. hb_USubStr( cString, nPos, 1 ) $ cDelimiter
      nStart := nPos
      while nPos <= nLen .and. .not. hb_USubStr( cString, nPos, 1 ) $ cDelimiter
          ++nPos
      enddo
      ++nTokens
      IF nAction > 0
         IF nPointer == nTokens
            IF nAction == 1
               cRet := hb_USubStr( cString, nStart, nPos - nStart )
            ELSE
               cRet := nStart
            ENDIF
            exit
          ENDIF
       ENDIF
    endif
    if hb_USubStr( cString, nPos, 1 ) $ cDelimiter
       while nPos <= nLen .and. hb_USubStr( cString, nPos, 1 ) $ cDelimiter
          ++nPos
       enddo
    endif
    cRet := nTokens
ENDDO

RETURN cRet

//-------------------------\\
//
// next 3 function written by Peter Kulek
// modified for compatibility with common.ch by V.K.
// modified DATE processing by V.K.
//
STATIC function Array2File( cFile, aRay, nDepth, hFile )
local nBytes := 0
local i
local lOpen  := ( hFile != nil )

nDepth := iif( ISNUMBER( nDepth ), nDepth, 0 )
//if hFile == NIL
if !lOpen
   if ( hFile := FCreate( cFile,FC_NORMAL ) ) == -1
      return nBytes
   endif
endif
nDepth++
nBytes += WriteData( hFile,aRay )
if ISARRAY( aRay )
   for i := 1 to HMG_LEN( aRay )
      nBytes += Array2File( cFile,aRay[i],nDepth,hFile )
   next
endif
nDepth--
// if nDepth == 0
if !lOpen
   FClose(hFile)
endif

return nBytes

//-------------------------\\

STATIC function WriteData(hFile,xData)
local cData  := ValType(xData)

   if ISCHARACTER(xData)
       cData += I2Bin( HMG_LEN( xData ) ) + xData
   elseif ISNUMBER(xData)
       cData += I2Bin( HMG_LEN( ALLTRIM( Str( xData ) ) ) ) + ALLTRIM( Str( xData ) )
   elseif ISDATE( xData )
       cData += I2Bin( 8 )+DToS(xData)
   elseif ISLOGICAL(xData)
       cData += I2Bin( 1 )+iif( xData,"T","F" )
   elseif ISARRAY( xData )
       cData += I2Bin( HMG_LEN( xData ) )
   else
       cData += I2Bin( 0 )   // NIL
   endif

return FWrite( hFile, cData, HMG_LEN( cData ) )

//-------------------------\\

STATIC function File2Array( cFile, nLen, hFile )
LOCAL cData,cType,nDataLen,nBytes
local nDepth := 0
local aRay   := {}
local lOpen  := ( hFile != nil )

if hFile == NIL        // First Timer
   if ( hFile := FOpen( cFile,FO_READ ) ) == -1
      return aRay
   endif
   cData := Space( 3 )
   FRead( hFile, @cData, 3 )
   if !( hb_ULeft( cData,1 ) == "A" )     //  If format of file != array
      FClose( hFile )            //////////
      return aRay
   endif
   nLen := bin2i( hb_URight( cData,2 ) )
endif

do while nDepth < nLen
    cData  := Space( 3 )
    nBytes := FRead( hFile, @cData, 3 )
    if nBytes < 3
       exit
    endif
    cType    := HMG_PADL( cData,1 )
    nDataLen := bin2i( hb_URight( cData,2 ) )
    if !( cType == "A" )
       cData := Space( nDataLen )
       nBytes:= FRead( hFile, @cData, nDataLen )
       if nBytes < nDataLen
           exit
       endif
    endif
    nDepth++
    aadd( aRay,NIL )
    if cType=="C"
        aRay[ nDepth ] := cData
    elseif cType=="N"
        aRay[ nDepth ] := Val(cData)
    elseif cType=="D"
        aRay[ nDepth ] := ctod( hb_ULeft( cData, 4 ) + "/" + hb_USubStr( cData, 5, 2 ) + "/" + hb_USubStr( cData, 7, 2 )) //SToD(cData)
    elseif cType=="L"
        aRay[ nDepth ] := ( cData=="T" )
    elseif cType=="A"
        aRay[ nDepth ] := File2Array( , nDataLen, hFile )
    endif
enddo

if !lOpen
    FClose( hFile )
endif

return aRay

//-------------------------\\

STATIC FUNCTION NumAt( cSearch, cString )

   LOCAL n := 0, nAt, nPos := 0
   WHILE ( nAt := hb_UAt( cSearch, hb_USubStr( cString, nPos + 1 ) )) > 0
           nPos += nAt
           ++n
   ENDDO

RETURN n

//-------------------------\\

STATIC function RunExternal( cCmd, cVerb, cFile )
local lRet := .t.

#ifdef __CLP__
   lRet := SwpRunCmd( cCmd, 0, "", "" )
#endif

#ifdef __HARBOUR__
    if cVerb != nil
// TOFIX: This requires hbwhat, which in turns requires xhb.
//        This has to be solved differently.
//      ShellExecute( GetDeskTopWindow(), cVerb, cFile, , , 1 )
        HB_SYMBOL_UNUSED( cFile )
    else
      hb_run( cCmd )
    endif
#endif

#ifdef __XPP__
   RunShell( cCmd, , .t., .t. )
#endif

return lRet

//-------------------------\\
