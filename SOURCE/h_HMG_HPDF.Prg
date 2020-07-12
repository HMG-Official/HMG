/*
  - by S. Rathinagiri on October 22nd, 2012
  
  - The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made 
    by Dr. Claudio Soto, November 2012 and June 2014 respectively. 

  - Revised by Pablo César Arrascaeta on April 12th, 2014
    Implement of _HMG_HPDF_SetFont() with improvements extra functions
   
*/
MEMVAR _HMG_SYSDATA, nFhandle, lDoLog

#include <hmg.ch>
#include "harupdf.ch"

Function _HMG_HPDF_INIT ( cPDFFile, nOrientation, nPaperSize, nPaperLength, nPaperWidth, lLog )
Local lReturn := .f.

default nOrientation := 1
default nPaperSize   := 1
default lLog         := .f.

Public nFhandle := 0, lDoLog := lLog

If valtype( _HMG_SYSDATA[ 150 ] ) == 'U'
   _HMG_SYSDATA[ 150 ] := { ;
                        Nil, ;                  //  1.PDF Object
                        cPDFFile,;              //  2.PDF File to Save
                        0,;                     //  3.PDF PaperSize
                        0,;                     //  4.PDF PaperWidth
                        0,;                     //  5.PDF PaperHeight
                        nOrientation,;          //  6.PDF Orientation
                        Nil, ;                  //  7.PDF Current Page
                        'Helvetica',;           //  8.PDF default font
                        12,;                    //  9.PDF default fontsize
                        "StandardEncoding",;    // 10.PDF default encoding
                        {},;                    // 11.PDF Outlines Array                           
                        {},;                    // 12.PDF Pages Array
                        0;                      // 13.PDF Current Page Number 
                        }
   _HMG_SYSDATA[ 150 ][ 1 ] := HPDF_New()
   If _HMG_SYSDATA[ 150 ][ 1 ] == Nil
      _HMG_HPDF_Error( 2 )
      Return lReturn
   endif
   
   If lLog
      nFhandle := FCreate( 'UsedFonts.htm', 0 )
	  Html_Table_Ini(nFHandle,"TruType Fonts used",1024,3)
	  HTML_TABLE_LINE( nFHandle,{{HTML_BOLD(nFHandle,"Line (pixels)"),"#ABABAB",.t.},;
	                             {HTML_BOLD(nFHandle,"Column (pixels)"),"#ABABAB",.t.},;
						 	     {HTML_BOLD(nFHandle,"Page"),"#ABABAB",.t.},;
						 	     {HTML_BOLD(nFHandle,"Given Font Name"),"#ABABAB",.f.},;
                                 {HTML_BOLD(nFHandle,"Size"),"#ABABAB",.t.},;
						 	     {HTML_BOLD(nFHandle,"Properties"),"#ABABAB",.f.},;
						 	     {HTML_BOLD(nFHandle,"Reassigned Font Name"),"#ABABAB",.f.}} )
   Endif
   
   _HMG_SYSDATA[ 150 ][ 3 ] := nPaperSize
   If nPaperSize == 256 // user size
      If _HMG_SYSDATA[ 150 ][ 6 ] == 1 // orientation portrait
         _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( nPaperWidth )
         _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( nPaperLength )
      else // orientation landscape
         _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( nPaperLength )
         _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( nPaperWidth )
      endIf         
   else
      _HMG_HPDF_INIT_PAPERSIZE( nPaperSize )
   endIf   
   lReturn := .t.
else
   _HMG_HPDF_Error( 1 )
   Return lReturn
endIf   
Return lReturn

Function _hmg_hpdf_setencoding( cEncoding )
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
HPDF_SetCurrentEncoder( _HMG_SYSDATA[ 150 ][ 1 ], cEncoding ) 
_HMG_SYSDATA[ 150 ] [ 10 ] := cEncoding
Return Nil

Function _hmg_hpdf_startdoc() // START HPDFDOC
Return Nil

Function _hmg_hpdf_startpage()
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endIf   
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // Page is free
   _HMG_SYSDATA[ 150 ][ 7 ] := HPDF_AddPage( _HMG_SYSDATA[ 150 ][ 1 ] )
   If EMPTY( _HMG_SYSDATA[ 150, 7 ] )
      _HMG_HPDF_Error( 9 , hb_HPDF_GetErrorString( _HMG_SYSDATA[ 150 ][ 7 ] )+" | StartPage" )
      Return Nil
   ELSE
   // add current page to the pages array
      aadd( _HMG_SYSDATA[ 150 ][ 12 ], _HMG_SYSDATA[ 150 ][ 7 ] )
      _HMG_SYSDATA[ 150 ][ 13 ] := HMG_LEN( _HMG_SYSDATA[ 150 ][ 12 ] )
   // set page size
      HPDF_Page_SetWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_SYSDATA[ 150 ][ 4 ] )
      HPDF_Page_SetHeight( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_SYSDATA[ 150 ][ 5 ] )
   endif
else
   _HMG_HPDF_Error( 4 )
endIf   
Return Nil

Function _HMG_HPDF_InsertPage( nPage )
Local oOldPage := Nil
Local aPages := aclone( _HMG_SYSDATA[ 150 ][ 12 ] )

If nPage > HMG_LEN( aPages ) .or. nPage < 1
   _HMG_HPDF_Error( 16 )
   Return Nil
endIf   
oOldPage := aPages[ nPage ]
If empty( oOldPage )
   _HMG_HPDF_Error( 16 )
   Return Nil
endIf   
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // Page is free
   _HMG_SYSDATA[ 150 ][ 7 ] := HPDF_InsertPage( _HMG_SYSDATA[ 150 ][ 1 ], oOldPage )
   If EMPTY( _HMG_SYSDATA[ 150, 7 ] )
      _HMG_HPDF_Error( 9 , hb_HPDF_GetErrorString( _HMG_SYSDATA[ 150 ][ 7 ] )+" | InsertPage" )
      Return Nil
   ELSE
   // insert current page to the pages array
      asize( aPages, HMG_LEN( aPages ) + 1 )
      ains( aPages, nPage )
      aPages[ nPage ] := _HMG_SYSDATA[ 150, 7 ]
      _HMG_SYSDATA[ 150 ][ 12 ] := aclone( aPages )
      _HMG_SYSDATA[ 150 ][ 13 ] := nPage     
      HPDF_Page_SetWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_SYSDATA[ 150 ][ 4 ] )
      HPDF_Page_SetHeight( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_SYSDATA[ 150 ][ 5 ] )
   endif
else
   _HMG_HPDF_Error( 4 )
endIf   
Return Nil

Function _HMG_HPDF_GoToPage( nPage )
Local oPage := Nil
Local aPages := aclone( _HMG_SYSDATA[ 150 ][ 12 ] )

If nPage > HMG_LEN( aPages ) .or. nPage < 1
   _HMG_HPDF_Error( 18 )
   Return Nil
endIf   
oPage := aPages[ nPage ]
If empty( oPage )
   _HMG_HPDF_Error( 18 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // Page is free
   _HMG_SYSDATA[ 150 ][ 7 ] := aPages[ nPage ]
   If EMPTY( _HMG_SYSDATA[ 150, 7 ] )
      _HMG_HPDF_Error( 19 )
      Return Nil
   ENDIF
   _HMG_SYSDATA[ 150 ][ 13 ] := nPage
endIf   
Return Nil

Function _hmg_hpdf_endpage()
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endIf   
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // Page is free
   _HMG_HPDF_Error( 5 )
   Return Nil
else
   _HMG_SYSDATA[ 150 ][ 7 ] := Nil         
endif
Return Nil

Function HMG_HPDF_PageCount()
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endIf   
Return HMG_LEN( _HMG_SYSDATA[ 150 ][ 12 ] )

Function HMG_HPDF_PageNo()
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endIf   
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // Page is free
   _HMG_HPDF_Error( 5 )
   Return Nil
endif
Return _HMG_SYSDATA[ 150 ][ 13 ]

Function _hmg_hpdf_enddoc()
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
HPDF_SaveToFile( _HMG_SYSDATA[ 150 ][ 1 ], _HMG_SYSDATA[ 150 ][ 2 ] )
HPDF_Free( _HMG_SYSDATA[ 150 ][ 1 ] )
_HMG_SYSDATA[ 150 ] := Nil

//HTML_END(nFHandle)
//FClose( nFhandle )
If lDoLog
   FWrite( nFHandle, "</table></body></html>"+CRLF )
   FClose( nFHandle )
Endif

Release nFhandle, lDoLog
Return Nil

Function _hmg_hpdf_abortdoc()
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
HPDF_Free( _HMG_SYSDATA[ 150 ][ 1 ] )
_HMG_SYSDATA[ 150 ][ 1 ] := Nil
Return Nil

Function _HMG_HPDF_PRINT ( nRow, nCol, cFontName, nFontSize, nRColor, nGColor, nBColor, cText, lBold, lItalic, lUnderline, lStrikeout, lColor, lFont, lSize, cAlign )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local oFont := Nil
Local cFont := ''
Local cTtfFnt
default cFontName := ''
default nFontSize := 12
default nRColor := 0
default nGColor := 0
default nBColor := 0
default lBold := .f.
default lItalic := .f.
default lUnderline := .f.
default lStrikeout := .f.
default lColor := .f.
default lFont := .f.
default lSize := .f.
default cAlign := ''

cTtfFnt := cFontName

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

// set font
If HMG_LEN( AllTrim( cFontName ) ) == 0
   cFontName := _HMG_HPDF_SetFont( cFontName, lBold, lItalic )
   oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
else
   cFontName := AllTrim(_HMG_HPDF_SetFont( cFontName, lBold, lItalic ))
   
   if HMG_UPPER (cFileExt (cFontName)) == '.TTF' // load ttf font
   
      cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, .t. )
      If HMG_LEN( alltrim( cFont ) ) == 0
         _HMG_HPDF_Error( 6 , cFontName )
         Return Nil
      endif
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFont, _HMG_SYSDATA[ 150 ][ 10 ] )
   else
      If HMG_UPPER( alltrim( cFontName ) ) == "SYMBOL" .or. HMG_UPPER( alltrim( cFontName ) ) == "ZAPFDINGBATS"
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, Nil )
      else   
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
      endIf   
   endif
endIf   
If oFont == Nil
   _HMG_HPDF_Error( 6 , cFontName )
   Return Nil
Else
   HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ][ 7 ], oFont, nFontSize )
   nTextWidth := HPDF_Page_TextWidth( _HMG_SYSDATA[ 150 ][ 7 ], cText )
   do case
      case HMG_UPPER( alltrim( cAlign ) ) == 'CENTER'
         nxPos := nxPos - ( nTextWidth / 2 )
      case HMG_UPPER( alltrim( cAlign ) ) == 'RIGHT'
         nxPos := nxPos - ( nTextWidth )
   endcase
   nyPos -= nFontSize
   HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ][ 7 ] )
   HPDF_PAGE_TEXTOUT( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, cText )
   HPDF_Page_EndText( _HMG_SYSDATA[ 150 ][ 7 ] )
   
   If lDoLog
	  HTML_TABLE_LINE(nFHandle,{{StrZero(nRow,4,0)+" ("+StrZero(nyPos,7,2)+")","#FFFFFF",.t.},;
	                            {StrZero(nCol,4,0)+" ("+StrZero(nxPos,7,2)+")","#FFFFFF",.t.},;
							    {StrZero(_HMG_SYSDATA[ 150 ][ 13 ],3,0),"#FFFFFF",.t.},;
							    {PadR(If(Empty(cTtfFnt),"<Default>",cTtfFnt),If(HMG_Len(cTtfFnt)>30,HMG_Len(cTtfFnt),30)),"#FFFFFF",.f.},;
							    {StrZero(nFontSize,2,0),"#FFFFFF",.t.},;
							    {If(lBold,"BOLD" ,Space(4))+If(lItalic," ITALIC",Space(7)),"#FFFFFF",.f.},;
							    {cFontName,If(If(Empty(cTtfFnt),HMG_Len(cFontName),HMG_Len(cTtfFnt))==HMG_Len(cFontName),"#FFFFFF","#FFFF66"),.f.}})
   Endif
Endif
Return Nil


Function _HMG_HPDF_MULTILINE_PRINT ( nRow, nCol, nToRow, nToCol, cFontName, nFontSize, nRColor, nGColor, nBColor, cText, lBold, lItalic, lUnderline, lStrikeout, lColor, lFont, lSize, cAlign )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
Local nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
Local oFont := Nil
Local cFont := ''
Local cTtfFnt // Pablo June, 2014

default cFontName := ''
default nFontSize := 12
default nRColor := 0
default nGColor := 0
default nBColor := 0
default lBold := .f.
default lItalic := .f.
default lUnderline := .f.
default lStrikeout := .f.
default lColor := .f.
default lFont := .f.
default lSize := .f.
default cAlign := ''

cTtfFnt := cFontName // Pablo June, 2014

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

// set font
If HMG_LEN( alltrim( cFontName ) ) == 0
   cFontName := _HMG_HPDF_SetFont( cFontName, lBold, lItalic )
   oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
else
   // cFontName := alltrim( cFontName )
   cFontName := AllTrim(_HMG_HPDF_SetFont( cFontName, lBold, lItalic ))
   
   if HMG_UPPER (cFileExt (cFontName)) == '.TTF' // load ttf font
   
      cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, .t. )
      If HMG_LEN( alltrim( cFont ) ) == 0
         _HMG_HPDF_Error( 6 , cFontName )
         Return Nil
      endif
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFont, _HMG_SYSDATA[ 150 ][ 10 ] )
   else
      If HMG_UPPER( alltrim( cFontName ) ) == "SYMBOL" .or. HMG_UPPER( alltrim( cFontName ) ) == "ZAPFDINGBATS"
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, Nil )
      else   
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
      endIf   
   endif
endIf   
If oFont == Nil
   _HMG_HPDF_Error( 6 , cFontName )
   Return Nil
else
   HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ][ 7 ], oFont, nFontSize )
   HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ][ 7 ] )
   do case
      case HMG_UPPER( cAlign ) == 'CENTER'
         HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_CENTER, Nil )
      case HMG_UPPER( cAlign ) == 'RIGHT'
         HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_RIGHT, Nil )
      case HMG_UPPER( cAlign ) == 'JUSTIFY'
         HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_JUSTIFY, Nil )
      otherwise         
         HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_LEFT, Nil )
   endcase         
   HPDF_Page_EndText( _HMG_SYSDATA[ 150 ][ 7 ] )
   
   If lDoLog // Pablo June, 2014
     HTML_TABLE_LINE(nFHandle,{{StrZero(nRow,4,0)+" ("+StrZero(nyPos,7,2)+")","#FFFFFF",.t.},;
                               {StrZero(nCol,4,0)+" ("+StrZero(nxPos,7,2)+")","#FFFFFF",.t.},;
                         {StrZero(_HMG_SYSDATA[ 150 ][ 13 ],3,0),"#FFFFFF",.t.},;
                         {PadR(If(Empty(cTtfFnt),"<Default>",cTtfFnt),If(HMG_Len(cTtfFnt)>30,HMG_Len(cTtfFnt),30)),"#FFFFFF",.f.},;
                         {StrZero(nFontSize,2,0),"#FFFFFF",.t.},;
                         {If(lBold,"BOLD" ,Space(4))+If(lItalic," ITALIC",Space(7)),"#FFFFFF",.f.},;
                         {cFontName,If(If(Empty(cTtfFnt),HMG_Len(cFontName),HMG_Len(cTtfFnt))==HMG_Len(cFontName),"#FFFFFF","#FFFF66"),.f.}})
   Endif
endif
Return Nil


Function _HMG_HPDF_LINE ( nRow , nCol , nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor ) 
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
Local nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
default nRColor := 0
default nGColor := 0
default nBColor := 0
default nWidth := 1
default lWidth := .f.
default lColor := .f.

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
HPDF_Page_MoveTo( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos )
HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ][ 7 ], nToxPos, nToyPos )
HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
Return Nil

Function _HMG_HPDF_RECTANGLE ( nRow, nCol, nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled ) 
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
Local nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
default nRColor := 0
default nGColor := 0
default nBColor := 0
default nWidth := 1
default lWidth := .f.
default lColor := .f.
default lFilled := .f.

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   If lFilled
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   endif
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
HPDF_Page_Rectangle( _HMG_SYSDATA[ 150 ][ 7 ], nxPos , nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow ), _HMG_HPDF_MM2Pixel( nToCol - nCol ), _HMG_HPDF_MM2Pixel( nToRow - nRow ) )
If lFilled
   HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ][ 7 ] )
else
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
endIf   
Return Nil

Function _HMG_HPDF_ROUNDRECTANGLE ( nRow , nCol , nToRow , nToCol , nLineWidth, nRColor , nGColor , nBColor , lWidth , lColor, lFilled, nRoundness ) 
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
Local nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
Local nRectWidth := nToCol - nCol
Local nRectHeight := nToRow - nRow
default nRColor := 0
default nGColor := 0
default nBColor := 0
default nWidth := 1
default lWidth := .f.
default lColor := .f.
default lFilled := .f.
default nRoundness := 0
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif
// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   If lFilled
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   endif
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   
// set line Width
If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
If nRoundness == 0
   nRoundness := int( min( nRectWidth, nRectHeight ) * 10 / 100 )
else
   If nRoundness > int( min( nRectWidth, nRectHeight ) / 2 )
      _HMG_HPDF_Error( 8 )
      Return Nil
   endif
endif

nRoundness := _HMG_HPDF_MM2Pixel( nRoundness )

// start rounded rectangle path
HPDF_Page_MoveTo( _HMG_SYSDATA[ 150 ][ 7 ], nxPos + nRoundness, nyPos )  // top line left position
HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ][ 7 ], nToxPos - nRoundness, nyPos ) // draw top line
HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ][ 7 ], nToxPos, nyPos, nToxPos, nyPos - nRoundness ) // draw top right curve
HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ][ 7 ], nToxPos , nToyPos + nRoundness ) // draw right line
HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ][ 7 ], nToxPos, nToyPos, nToxPos - nRoundness, nToyPos ) // draw bottom right curve
HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ][ 7 ], nxPos + nRoundness , nToyPos ) // draw bottom line
HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nToyPos, nxPos, nToyPos + nRoundness ) // draw bottom left curve
HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos - nRoundness ) // draw left line
HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, nxPos + nRoundness, nyPos ) // draw top left curve

// now start and finish drawing along the path   
If lFilled
   HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ][ 7 ] )
else
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
endIf   
Return Nil

Function _HMG_HPDF_CIRCLE( nRow, nCol, nR, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
default nWidth := 1
default lWidth := .f.
default lColor := .f.
default lFilled := .f.
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   If lFilled
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   endif
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   
// set line Width
If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
HPDF_Page_Circle( _HMG_SYSDATA[ 150 ][ 7 ], nxPos , nyPos, _HMG_HPDF_MM2Pixel( nR ) )
If lFilled
   HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ][ 7 ] )
else
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
endIf   
Return Nil   

Function _HMG_HPDF_ELLIPSE( nRow, nCol, nHR, nVR, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
default nWidth := 1
default lWidth := .f.
default lColor := .f.
default lFilled := .f.
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   If lFilled
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
   endif
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   
// set line Width
If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
HPDF_Page_Ellipse( _HMG_SYSDATA[ 150 ][ 7 ], nxPos , nyPos, _HMG_HPDF_MM2Pixel( nHR ), _HMG_HPDF_MM2Pixel( nVR ) )
If lFilled
   HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ][ 7 ] )
else
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
endIf   
Return Nil   


Function _HMG_HPDF_ARC( nRow, nCol, nR, nFromAngle, nToAngle, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
default nWidth := 1
default lWidth := .f.
default lColor := .f.
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   
// set line Width
If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
HPDF_Page_Arc( _HMG_SYSDATA[ 150 ][ 7 ], nxPos , nyPos, _HMG_HPDF_MM2Pixel( nR ), nFromAngle, nToAngle )
HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
Return Nil   
   
Function _HMG_HPDF_CURVE ( nRow , nCol , nFromRow, nFromCol, nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor ) 
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
Local nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
Local nFromxPos := _HMG_HPDF_MM2Pixel( nFromCol )
Local nFromyPos := nHeight - _HMG_HPDF_MM2Pixel( nFromRow )
default nRColor := 0
default nGColor := 0
default nBColor := 0
default nWidth := 1
default lWidth := .f.
default lColor := .f.

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

If lWidth
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
else
   HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ][ 7 ], 1 )
endif
HPDF_Page_MoveTo( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos )
HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ][ 7 ], nFromxPos, nFromyPos, nToxPos, nToyPos )
HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ][ 7 ] )
Return Nil

Function _HMG_HPDF_IMAGE ( cImage, nRow, nCol, nImageheight, nImageWidth, lStretch , cImageType)
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local oImage := Nil
default lStretch := .f.
default cImageType := "PNG"

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

do case
   case HMG_UPPER( alltrim( cImageType ) ) = "PNG"
      oImage := _HPDF_LOAD_PNG (_HMG_SYSDATA[ 150 ][ 1 ], cImage)
   case HMG_UPPER( alltrim( cImageType ) ) = "JPG"
      oImage := _HPDF_LOAD_JPG (_HMG_SYSDATA[ 150 ][ 1 ], cImage)
   otherwise
       _HMG_HPDF_Error( 20 )
endcase    

If oImage = Nil  
   _HMG_HPDF_Error( 7 )
   Return Nil
endIf   

If empty( oImage ) 
   _HMG_HPDF_Error( 7 )
   Return Nil
endIf   
HPDF_Page_DrawImage( _HMG_SYSDATA[ 150 ][ 7 ], oImage, nxPos, nyPos - _HMG_HPDF_MM2Pixel( nImageHeight ), _HMG_HPDF_MM2Pixel( nImageWidth ), _HMG_HPDF_MM2Pixel( nImageHeight ) )
Return Nil
   
Function _HMG_HPDF_SetPassword( cOwnerPass, cUserPass )
default cUserPass := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
HPDF_SetPassword( _HMG_SYSDATA[ 150 ][ 1 ], cOwnerPass, cUserPass )
Return Nil

Function _HMG_HPDF_SetCompression( cMode )
default cMode := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
cMode := HMG_UPPER( cMode )
do case
   case cMode == 'NONE'
      HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_COMP_NONE )
   case cMode == 'TEXT'
      HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_COMP_TEXT )
   case cMode == 'IMAGE'
      HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_COMP_IMAGE )
   case cMode == 'METADATA'
      HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_COMP_METADATA )
   case cMode == 'ALL'
      HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_COMP_ALL )
   otherwise      
      HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_COMP_NONE )
endcase      
Return Nil

Function _HMG_HPDF_SetPermission( cMode )
default cMode := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
cMode := HMG_UPPER( cMode )
do case
   case cMode == 'READ'
      HPDF_SetPermission( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_ENABLE_READ )  
   case cMode == 'PRINT'
      HPDF_SetPermission( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_ENABLE_PRINT )  
   case cMode == 'COPY'
      HPDF_SetPermission( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_ENABLE_COPY )  
   case cMode == 'EDIT'
      HPDF_SetPermission( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_ENABLE_EDIT )  
   case cMode == 'EDIT_ALL'
      HPDF_SetPermission( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_ENABLE_EDIT_ALL )  
endcase      
Return Nil

Function _HMG_HPDF_SetPageMode( cMode )
default cMode := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
cMode := HMG_UPPER( cMode )
do case
   case cMode == 'OUTLINE'
      HPDF_SetPageMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_PAGE_MODE_USE_OUTLINE )
   case cMode == 'NONE'
      HPDF_SetPageMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_PAGE_MODE_USE_NONE )
   case cMode == 'THUMBS'
      HPDF_SetPageMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_PAGE_MODE_USE_THUMBS )
   case cMode == 'FULL_SCREEN'
      HPDF_SetPageMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_PAGE_MODE_FULL_SCREEN )
   case cMode == 'EOF'
      HPDF_SetPageMode( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_PAGE_MODE_EOF )
endcase      
Return Nil

Function _HMG_HPDF_RootOutline( cTitle, cName, cParent )
Local aOutlines := {}
Local oOutline := Nil
Local i
default cParent := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If HMG_LEN( alltrim( cTitle ) ) == 0
   _HMG_HPDF_Error( 11 )
   Return Nil
endif
If HMG_LEN( alltrim( cName ) ) == 0
   _HMG_HPDF_Error( 12 )
   Return Nil
endif
If HMG_LEN( alltrim( cParent ) ) == 0 // make this a root outline
   oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ][ 1 ], Nil, cTitle, HPDF_GetCurrentEncoder() )
   If Empty( oOutLine )
      _HMG_HPDF_Error( 10 )
      Return Nil
   else
      aadd( _HMG_SYSDATA[ 150 ][ 11 ], { oOutline, cName } )
   endif
else
   aOutLines := aclone( _HMG_SYSDATA[ 150 ][ 11 ] )
   for i := 1 to HMG_LEN( aOutLines )
      If HMG_UPPER( alltrim( aOutLines[ i, 2 ] ) ) == HMG_UPPER( alltrim( cParent ) )
         oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ][ 1 ], aOutLines[ i, 1 ], cTitle, HPDF_GetCurrentEncoder() )
         If Empty( oOutLine )
            _HMG_HPDF_Error( 10 )
            Return Nil
         else
            aadd( _HMG_SYSDATA[ 150 ][ 11 ], { oOutline, cName } )
         endif
         exit
      endif
   next i
endif
Return Nil

Function _HMG_HPDF_PageOutline( cTitle, cParent, cName )
Local aOutlines := {}
Local oOutline := Nil
Local oDestination := Nil
Local i
default cParent := ''
default cName := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif
oDestination := HPDF_Page_CreateDestination( _HMG_SYSDATA[ 150 ][ 7 ] )
If empty( oDestination )
   _HMG_HPDF_Error( 13 )
   Return Nil
endif
If HMG_LEN( alltrim( cParent ) ) == 0 // No parent make this page root element
   oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ][ 1 ], Nil, cTitle, HPDF_GetCurrentEncoder() )
   If empty( oOutline )
      _HMG_HPDF_Error( 13 )
      Return Nil
   endif
else
   aOutlines := aclone( _HMG_SYSDATA[ 150 ][ 11 ] )
   for i := 1 to HMG_LEN( aOutlines )
      If HMG_UPPER( alltrim( aOutlines[ i, 2 ] ) ) == HMG_UPPER( alltrim( cParent ) )
         oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ][ 1 ], aOutlines[ i, 1 ], cTitle, HPDF_GetCurrentEncoder() )
         exit
      endif
   next i
   If empty( oOutline )
      _HMG_HPDF_Error( 14 )
      Return Nil
   endif
endif
If HMG_LEN( alltrim( cName ) ) > 0
   aadd( _HMG_SYSDATA[ 150 ][ 11 ], { oOutline, cName } )
endIf      
HPDF_Outline_SetDestination( oOutline, oDestination )
Return Nil      

Function _HMG_HPDF_SetTextAnnot( nRow, nCol, cToolTip, cIcon )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nToRow := nRow + 5
Local nToCol := nCol + 5
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
Local nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
Local aRect := { nxPos, nyPos, nToxPos, nToyPos }
Local oAnnot := Nil
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif
oAnnot := HPDF_Page_CreateTextAnnot ( _HMG_SYSDATA[ 150 ][ 7 ], aRect, cTooltip, HPDF_GetCurrentEncoder() )
If empty( oAnnot )
   _HMG_HPDF_Error( 15 )
   Return Nil
endif
do case
   case HMG_UPPER( alltrim( cIcon ) ) == "COMMENT"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_COMMENT )
   case HMG_UPPER( alltrim( cIcon ) ) == "KEY"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_KEY )
   case HMG_UPPER( alltrim( cIcon ) ) == "NOTE"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_NOTE )
   case HMG_UPPER( alltrim( cIcon ) ) == "HELP"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_HELP )
   case HMG_UPPER( alltrim( cIcon ) ) == "NEW_PARAGRAPH"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_NEW_PARAGRAPH )
   case HMG_UPPER( alltrim( cIcon ) ) == "PARAGRAPH"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_PARAGRAPH )
   case HMG_UPPER( alltrim( cIcon ) ) == "INSERT"
      HPDF_TextAnnot_SetIcon ( oAnnot, HPDF_ANNOT_ICON_INSERT )
endcase   
Return Nil

Function _HMG_HPDF_SetPageLink( nRow, nCol, cText, nPage, cFontName, nFontSize, nRColor, nGColor, nBColor, cAlign, lColor, lFont, lSize, lBorder, lWidth, nBorderWidth )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local oFont := Nil
Local cFont := ''
Local aRect := { }
Local aCurXY := {}
Local oAnnot := Nil
Local oDest := Nil
Local aPages := {}
Local oLinkPage := Nil
default cFontName := ''
default nFontSize := 12
default nRColor := 0
default nGColor := 0
default nBColor := 0
default lColor := .f.
default lFont := .f.
default lSize := .f.
default cAlign := ''
default lBorder := .f.
default lWidth := .f.
default nBorderWidth := 0

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif

aPages := aClone( _HMG_SYSDATA[ 150 ][ 12 ] )
If nPage > HMG_LEN( aPages ) .or. nPage < 1
   _HMG_HPDF_Error( 17 )
   Return Nil
endif
   
oLinkPage := aPages[ nPage ]
If empty( oLinkPage )
   _HMG_HPDF_Error( 17 )
   Return Nil
endif
oDest := HPDF_Page_CreateDestination( oLinkPage )
If empty( oDest )
   _HMG_HPDF_Error( 17 )
   Return Nil
endif

// set color
If lColor
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

// set font
If HMG_LEN( alltrim( cFontName ) ) == 0
   cFontName := _HMG_HPDF_SetFont( cFontName )
   oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
else
   // cFontName := alltrim( cFontName )
   cFontName := AllTrim(_HMG_HPDF_SetFont( cFontName ))
   
   if HMG_UPPER (cFileExt (cFontName)) == '.TTF' // load ttf font
   
      cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, .t. )
      If HMG_LEN( alltrim( cFont ) ) == 0
         _HMG_HPDF_Error( 6 , cFontName )
         Return Nil
      endif
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFont, _HMG_SYSDATA[ 150 ][ 10 ] )
   else
      If HMG_UPPER( alltrim( cFontName ) ) == "SYMBOL" .or. HMG_UPPER( alltrim( cFontName ) ) == "ZAPFDINGBATS"
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, Nil )
      else   
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
      endIf   
   endif
endIf   
If oFont == Nil
   _HMG_HPDF_Error( 6 , cFontName )
   Return Nil
else
   HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ][ 7 ], oFont, nFontSize )
   nTextWidth := HPDF_Page_TextWidth( _HMG_SYSDATA[ 150 ][ 7 ], cText )
   do case
      case HMG_UPPER( alltrim( cAlign ) ) == 'CENTER'
         nxPos := nxPos - ( nTextWidth / 2 )
      case HMG_UPPER( alltrim( cAlign ) ) == 'RIGHT'
         nxPos := nxPos - ( nTextWidth )
   endcase
   HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ][ 7 ] )
   HPDF_PAGE_TEXTOUT( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, cText )
   aRect := { nxPos - 4, nyPos + nFontsize + 4, nxPos + nTextWidth + 4, nyPos - 4 }
   oAnnot := HPDF_Page_CreateLinkAnnot( _HMG_SYSDATA[ 150 ][ 7 ], aRect, oDest )
   If lBorder
      If nBorderWidth == 0
         nBorderWidth := 1
      else
         nBorderWidth := _HMG_HPDF_MM2Pixel( nBorderWidth )
      endif
      HPDF_LinkAnnot_SetBorderStyle ( oAnnot, nBorderWidth, 0, 0)
   else
      HPDF_LinkAnnot_SetBorderStyle ( oAnnot, 0, 0, 0)
   endIf      
   HPDF_Page_EndText( _HMG_SYSDATA[ 150 ][ 7 ] )
endif
Return Nil   


Function _HMG_HPDF_SetURLLink( nRow, nCol, cText, cLink, cFontName, nFontSize, nRColor, nGColor, nBColor, cAlign, lColor, lFont, lSize, lBold, lItalic  )
Local nWidth := _HMG_SYSDATA[ 150 ][ 4 ]
Local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
Local nTextWidth := 0
Local nxPos := _HMG_HPDF_MM2Pixel( nCol )
Local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
Local oFont := Nil
Local cFont := ''
Local aRect := { }
Local aCurXY := {}
Local oAnnot := Nil
default cFontName := ''
default nFontSize := 12
default nRColor := 0
default nGColor := 0
default nBColor := 0
default lColor := .f.
default lFont := .f.
default lSize := .f.
default lBold := .f.
default lItalic := .f.
default cAlign := ''

If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif


// set color
If lColor
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], nRColor/255, nGColor/255, nBColor/255 )
else
   HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ][ 7 ], 0.0, 0.0, 0.0 )
endIf   

// set font
If HMG_LEN( alltrim( cFontName ) ) == 0
   cFontName := _HMG_HPDF_SetFont( cFontName )
   oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
else
   // cFontName := alltrim( cFontName )
   cFontName := AllTrim(_HMG_HPDF_SetFont( cFontName, lBold, lItalic ))
   
   if HMG_UPPER (cFileExt (cFontName)) == '.TTF' // load ttf font
   
      cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, .t. )
      If HMG_LEN( alltrim( cFont ) ) == 0
         _HMG_HPDF_Error( 6 , cFontName )
         Return Nil
      endif
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFont, _HMG_SYSDATA[ 150 ][ 10 ] )
   else
      If HMG_UPPER( alltrim( cFontName ) ) == "SYMBOL" .or. HMG_UPPER( alltrim( cFontName ) ) == "ZAPFDINGBATS"
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, Nil )
      else   
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], cFontName, _HMG_SYSDATA[ 150 ][ 10 ] )
      endIf   
   endif
endIf   
If oFont == Nil
   _HMG_HPDF_Error( 6 , cFontName )
   Return Nil
else
   HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ][ 7 ], oFont, nFontSize )
   nTextWidth := HPDF_Page_TextWidth( _HMG_SYSDATA[ 150 ][ 7 ], cText )
   do case
      case HMG_UPPER( alltrim( cAlign ) ) == 'CENTER'
         nxPos := nxPos - ( nTextWidth / 2 )
      case HMG_UPPER( alltrim( cAlign ) ) == 'RIGHT'
         nxPos := nxPos - ( nTextWidth )
   endcase
   HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ][ 7 ] )
   HPDF_PAGE_TEXTOUT( _HMG_SYSDATA[ 150 ][ 7 ], nxPos, nyPos, cText )
   aRect := { nxPos - 4, nyPos + nFontsize + 4, nxPos + nTextWidth + 4, nyPos - 4 }
   HPDF_Page_CreateURILinkAnnot( _HMG_SYSDATA[ 150 ][ 7 ], aRect, cLink )
   HPDF_Page_EndText( _HMG_SYSDATA[ 150 ][ 7 ] )
endif
Return Nil   

Function _HMG_HPDF_SetLineSpacing( nSpacing )
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
   _HMG_HPDF_Error( 5 )
   Return Nil
endif
HPDF_Page_SetTextLeading( _HMG_SYSDATA[ 150 ][ 7 ], _HMG_HPDF_MM2Pixel( nSpacing ) )
Return Nil

Function _HMG_HPDF_SetInfo( cAttrib, xValue, cTime )
Local cValue := ''
Local dValue := ''
Local nHours := 0
Local nMinutes := 0
Local nSeconds := 0
default cTime := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
do case
   case valtype( xValue ) == 'D'
      dValue := xValue
   otherwise
      cValue := xValue
endcase      
do case
   case HMG_UPPER( alltrim( cAttrib ) ) == "AUTHOR"
      HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_AUTHOR, cValue )
   case HMG_UPPER( alltrim( cAttrib ) ) == "CREATOR"
      HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_CREATOR, cValue )
   case HMG_UPPER( alltrim( cAttrib ) ) == "TITLE"
      HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_TITLE, cValue )
   case HMG_UPPER( alltrim( cAttrib ) ) == "SUBJECT"
      HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_SUBJECT, cValue )
   case HMG_UPPER( alltrim( cAttrib ) ) == "KEYWORDS"
      HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_KEYWORDS, cValue )
   case HMG_UPPER( alltrim( cAttrib ) ) == "DATECREATED"
      If HMG_LEN( alltrim( cTime ) ) > 0
         nHours := val( HB_USUBSTR( cTime, 1, 2) )
         nMinutes := val( HB_USUBSTR( cTime, 4, 2) )
         nSeconds := val( HB_USUBSTR( cTime, 7, 2) )
      endif
      HPDF_SetInfoDateAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_CREATION_DATE, { year( dValue ), month( dVAlue ), day( dValue ), nHours, nMinutes, nSeconds } )
   case HMG_UPPER( alltrim( cAttrib ) ) == "DATEMODIFIED"
      If HMG_LEN( alltrim( cTime ) ) > 0
         nHours := val( HB_USUBSTR( cTime, 1, 2) )
         nMinutes := val( HB_USUBSTR( cTime, 4, 2) )
         nSeconds := val( HB_USUBSTR( cTime, 7, 2) )
      endif
      HPDF_SetInfoDateAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_MOD_DATE, { year( dValue ), month( dVAlue ), day( dValue ), nHours, nMinutes, nSeconds } )
endcase
Return Nil


Function _HMG_HPDF_GetInfo( cAttrib )
Local cRetValue := ''
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
do case
   case HMG_UPPER( alltrim( cAttrib ) ) == "AUTHOR"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_AUTHOR )
   case HMG_UPPER( alltrim( cAttrib ) ) == "CREATOR"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_CREATOR )
   case HMG_UPPER( alltrim( cAttrib ) ) == "TITLE"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_TITLE )
   case HMG_UPPER( alltrim( cAttrib ) ) == "SUBJECT"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_SUBJECT )
   case HMG_UPPER( alltrim( cAttrib ) ) == "KEYWORDS"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_KEYWORDS )
   case HMG_UPPER( alltrim( cAttrib ) ) == "DATECREATED"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_CREATION_DATE )
   case HMG_UPPER( alltrim( cAttrib ) ) == "DATEMODIFIED"
      cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ][ 1 ], HPDF_INFO_MOD_DATE )
endcase
Return cRetValue

Function _HMG_HPDF_SetPageLabel( nPage, cStyle, cCase, cPrefix )
default cCase := ""
default cStyle := "DECIMAL"
default nPage := 1
default cPrefix := ""
If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
   _HMG_HPDF_Error( 3 )
   Return Nil
endif
do case
   case HMG_UPPER( alltrim( cStyle ) ) == "DECIMAL"
      HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ][ 1 ], nPage, HPDF_PAGE_NUM_STYLE_DECIMAL, nPage, cPrefix )
   case HMG_UPPER( alltrim( cStyle ) ) == "ROMAN" 
      If HMG_UPPER( alltrim( cCase ) ) == "LOWER"
         HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ][ 1 ], nPage, HPDF_PAGE_NUM_STYLE_LOWER_ROMAN, nPage, cPrefix )
      else
         HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ][ 1 ], nPage, HPDF_PAGE_NUM_STYLE_UPPER_ROMAN, nPage, cPrefix )
      endIf   
   case HMG_UPPER( alltrim( cStyle ) ) == "LETTERS" 
      If HMG_UPPER( alltrim( cCase ) ) == "LOWER"
         HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ][ 1 ], nPage, HPDF_PAGE_NUM_STYLE_LOWER_LETTERS, nPage, cPrefix )
      else
         HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ][ 1 ], nPage, HPDF_PAGE_NUM_STYLE_UPPER_LETTERS, nPage, cPrefix )
      endIf   
endcase      
Return Nil
   
Function _HMG_HPDF_Error( nErr, ctxt )
Local cErr := ''

Default ctxt := ""
do case
   case nErr == 1
      cErr := 'A PDF document is already initiated.'
   case nErr == 2
      cErr := 'PDF document cannot be initialized.'
   case nErr == 3
      cErr := 'PDF PAGE cannot be added. PDF document cannot be found.'
   case nErr == 4
      cErr := 'A PDF PAGE is already inititated.'
   case nErr == 5
      cErr := 'PDF PAGE cannot be found.'
   case nErr == 6
      cErr := 'Font cannot be loaded.'+" | "+ctxt
   case nErr == 7
      cErr := 'Image cannot be loaded.'
   case nErr == 8
      cErr := 'Round curve can not be longer than half of the width/height.'
   case nErr == 9
      cErr := 'Can not start new page.'+" | "+ctxt
   case nErr == 10
      cErr := 'Can not create new parent outline.'
   case nErr == 11
      cErr := 'Outline Title is not valid.'
   case nErr == 12
      cErr := 'Outline Name is not valid.'
   case nErr == 13
      cErr := 'Can not create Page Outline.'
   case nErr == 14
      cErr := 'Can not find Parent Node.'
   case nErr == 15
      cErr := 'Tooltip creation error!'
   case nErr == 16
      cErr := 'Page not found. New page can not be inserted.'
   case nErr == 17
      cErr := 'Link Page not found.'
   case nErr == 18
      cErr := 'Selected Page can not be found.'
   case nErr == 19
      cErr := 'Page Selection error!'
   case nErr == 20
      cErr := 'Invalid Image Type!'
endcase
MsgStop( cErr )
Return Nil

Function _HMG_HPDF_Inch2Pixel( nInches )
Return ( nInches * 72 )
   
Function _HMG_HPDF_Pixel2Inch( nPixels )
Return ( nPixels / 72 )

Function _HMG_HPDF_MM2Pixel( nMM )
Return ( ( nMM / 25.4 ) * 72 )

Function _HMG_HPDF_Pixel2MM( nPixel )
Return ( ( nPixel / 72 ) * 25.4 )
   
Function _HMG_HPDF_INIT_PAPERSIZE( nPaperSize )
Local nTemp := 0
do case
   case nPaperSize == 1 .or. nPaperSize == -999 // HPDF_PAPER_LETTER or default
      _HMG_SYSDATA[ 150 ][ 4 ] := 612
      _HMG_SYSDATA[ 150 ][ 5 ] := 792
   case nPaperSize == 2 // HPDF_PAPER_LETTERSMALL
      _HMG_SYSDATA[ 150 ][ 4 ] := 612
      _HMG_SYSDATA[ 150 ][ 5 ] := 792
   case nPaperSize == 3 // HPDF_PAPER_TABLOID
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 11 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 17 )
   case nPaperSize == 4 // HPDF_PAPER_LEDGER
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 17 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 5 // HPDF_PAPER_LEGAL
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 14 )
   case nPaperSize == 6 // HPDF_PAPER_STATEMENT
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 5.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
   case nPaperSize == 7 // HPDF_PAPER_EXECUTIVE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 5.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
   case nPaperSize == 8 // HPDF_PAPER_A3
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 297 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 420 )
   case nPaperSize == 9 // HPDF_PAPER_A4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
   case nPaperSize == 10 // HPDF_PAPER_A4SMALL
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
   case nPaperSize == 11 // HPDF_PAPER_A5
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 210 )
   case nPaperSize == 12 // HPDF_PAPER_B4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 250 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 354 )
   case nPaperSize == 13 // HPDF_PAPER_B5
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 185 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 257 )
   case nPaperSize == 14 // HPDF_PAPER_FOLIO
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 13 )
   case nPaperSize == 15 // HPDF_PAPER_QUARTO
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 215 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 275 )
   case nPaperSize == 16 // HPDF_PAPER_10X14
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 10 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 140 )
   case nPaperSize == 17 // HPDF_PAPER_11X17
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 11 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 17 )
   case nPaperSize == 18 // HPDF_PAPER_NOTE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 19 // HPDF_PAPER_ENV_9
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 3 + (7 / 8) )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 8 + (7 / 8) )
   case nPaperSize == 20 // HPDF_PAPER_ENV_10
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 4 + (1 / 8) )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
   case nPaperSize == 21 // HPDF_PAPER_ENV_11
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 4.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 10 + (3 / 8) )
   case nPaperSize == 22 // HPDF_PAPER_ENV_12
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 4.75 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 23 // HPDF_PAPER_ENV_14
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11.5 )
   case nPaperSize == 24 // HPDF_PAPER_CSHEET
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 17 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 22 )
   case nPaperSize == 25 // HPDF_PAPER_DSHEET
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 22 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 34 )
   case nPaperSize == 26 // HPDF_PAPER_ESHEET
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 34 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 44 )
   case nPaperSize == 27 // HPDF_PAPER_ENV_DL
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 220 )
   case nPaperSize == 28 // HPDF_PAPER_ENV_C5
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 162 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 229 )
   case nPaperSize == 29 // HPDF_PAPER_ENV_C3
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 324 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 458 )
   case nPaperSize == 30 // HPDF_PAPER_ENV_C4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 229 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 324 )
   case nPaperSize == 31 // HPDF_PAPER_ENV_C6
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 114 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 162 )
   case nPaperSize == 32 // HPDF_PAPER_ENV_C65
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 114 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 229 )
   case nPaperSize == 33 // HPDF_PAPER_ENV_B4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 250 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 353 )
   case nPaperSize == 34 // HPDF_PAPER_ENV_B5
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 250 )
   case nPaperSize == 35 // HPDF_PAPER_ENV_B6
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 125 )
   case nPaperSize == 36 // HPDF_PAPER_ENV_ITALY
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 230 )
   case nPaperSize == 37 // HPDF_PAPER_ENV_MONARCH
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 3.875 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 7.5 )
   case nPaperSize == 38 // HPDF_PAPER_ENV_PERSONAL
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 3 + ( 5 / 8 ) )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 6.5 )
   case nPaperSize == 39 // HPDF_PAPER_FANFOLD_US
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 14 + ( 7 / 8 ) )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 40 // HPDF_PAPER_FANFOLD_STD_GERMAN
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 12 )
   case nPaperSize == 41 // HPDF_PAPER_FANFOLD_LGL_GERMAN
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 13 )
   case nPaperSize == 42 // HPDF_PAPER_ISO_B4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 250 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 353 )
   case nPaperSize == 43 // HPDF_PAPER_JAPANESE_POSTCARD
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 100 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
   case nPaperSize == 44 // HPDF_PAPER_9X11
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 9 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 45 // HPDF_PAPER_10X11
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 10 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 46 // HPDF_PAPER_15X11
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 15 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 47 // HPDF_PAPER_ENV_INVITE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 220 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 220 )
   case nPaperSize == 48 // HPDF_PAPER_RESERVED_48
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
   case nPaperSize == 49 // HPDF_PAPER_RESERVED_49
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
   case nPaperSize == 50 // HPDF_PAPER_LETTER_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 12 )
   case nPaperSize == 51 // HPDF_PAPER_LEGAL_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 15 )
   case nPaperSize == 52 // HPDF_PAPER_TABLOID_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 11.69 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 18 )
   case nPaperSize == 53 // HPDF_PAPER_A4_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 9.27 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 12.69 )
   case nPaperSize == 54 // HPDF_PAPER_LETTER_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 55 // HPDF_PAPER_A4_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
   case nPaperSize == 56 // HPDF_PAPER_LETTER_EXTRA_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 12 )
   case nPaperSize == 57 // HPDF_PAPER_A_PLUS
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 227 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 356 )
   case nPaperSize == 58 // HPDF_PAPER_B_PLUS
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 305 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 487 )
   case nPaperSize == 59 // HPDF_PAPER_LETTER_PLUS
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 12.69 )
   case nPaperSize == 60 // HPDF_PAPER_A4_PLUS
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 330 )
   case nPaperSize == 61 // HPDF_PAPER_A5_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 210 )
   case nPaperSize == 62 // HPDF_PAPER_B5_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 182 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 257 )
   case nPaperSize == 63 // HPDF_PAPER_A3_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 322 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 445 )
   case nPaperSize == 64 // HPDF_PAPER_A5_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 174 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 235 )
   case nPaperSize == 65 // HPDF_PAPER_B5_EXTRA
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 201 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 276 )
   case nPaperSize == 66 // HPDF_PAPER_A2
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 420 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 594 )
   case nPaperSize == 67 // HPDF_PAPER_A3_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 297 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 420 )
   case nPaperSize == 68 // HPDF_PAPER_A3_EXTRA_TRANSVERSE
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 322 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 445 )
   case nPaperSize == 69 // HPDF_PAPER_DBL_JAPANESE_POSTCARD
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 200 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
   case nPaperSize == 70 // HPDF_PAPER_A6
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 105 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
   case nPaperSize == 71 // HPDF_PAPER_JENV_KAKU2
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 240 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 332 )
   case nPaperSize == 72 // HPDF_PAPER_JENV_KAKU2
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 216 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 277 )
   case nPaperSize == 73 // HPDF_PAPER_JENV_CHOU3
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 120 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 235 )
   case nPaperSize == 74 // HPDF_PAPER_JENV_CHOU4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 90 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 205 )
   case nPaperSize == 75 // HPDF_PAPER_LETTER_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 11 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
   case nPaperSize == 76 // HPDF_PAPER_A3_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 420 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
   case nPaperSize == 77 // HPDF_PAPER_A4_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 297 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 210 )
   case nPaperSize == 78 // HPDF_PAPER_A5_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
   case nPaperSize == 79 // HPDF_PAPER_B4_JIS_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 364 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 257 )
   case nPaperSize == 80 // HPDF_PAPER_B5_JIS_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 257 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 182 )
   case nPaperSize == 81 // HPDF_PAPER_B5_JAPANESE_POSTCARD_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 100 )
   case nPaperSize == 82 // HPDF_PAPER_B5_DBL_JAPANESE_POSTCARD_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 200 )
   case nPaperSize == 83 // HPDF_PAPER_A6_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 105 )
   case nPaperSize == 84 // HPDF_PAPER_JENV_KAKU2_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 332 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 240 )
   case nPaperSize == 85 // HPDF_PAPER_JENV_KAKU3_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 277 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 216 )
   case nPaperSize == 86 // HPDF_PAPER_JENV_CHOU3_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 235 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 120 )
   case nPaperSize == 87 // HPDF_PAPER_JENV_CHOU4_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 205 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 90 )
   case nPaperSize == 88 // HPDF_PAPER_B6_JIS
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 128 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 182 )
   case nPaperSize == 89 // HPDF_PAPER_B6_JIS_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 182 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 128 )
   case nPaperSize == 90 // HPDF_PAPER_12X11
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_Inch2Pixel( 12 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
   case nPaperSize == 91 // HPDF_PAPER_JENV_YOU4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 235 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 105 )
   case nPaperSize == 92 // HPDF_PAPER_JENV_YOU4_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 105 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 235 )
   case nPaperSize == 93 // HPDF_PAPER_P16K
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 146 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 215 )
   case nPaperSize == 94 // HPDF_PAPER_P32K
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 97 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 151 )
   case nPaperSize == 95 // HPDF_PAPER_P32KBIG
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 97 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 151 )
   case nPaperSize == 96 // HPDF_PAPER_PENV_1
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 102 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 165 )
   case nPaperSize == 97 // HPDF_PAPER_PENV_2
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 102 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 176 )
   case nPaperSize == 98 // HPDF_PAPER_PENV_3
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 125 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 176 )
   case nPaperSize == 99 // HPDF_PAPER_PENV_4
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 208 )
   case nPaperSize == 100 // HPDF_PAPER_PENV_5
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 220 )
   case nPaperSize == 101 // HPDF_PAPER_PENV_6
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 120 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 230 )
   case nPaperSize == 102 // HPDF_PAPER_PENV_7
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 160 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 230 )
   case nPaperSize == 103 // HPDF_PAPER_PENV_8
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 120 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 208 )
   case nPaperSize == 104 // HPDF_PAPER_PENV_9
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 229 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 324 )
   case nPaperSize == 105 // HPDF_PAPER_PENV_10
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 324 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 458 )
   case nPaperSize == 106 // HPDF_PAPER_P16K_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 215 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 146 )
   case nPaperSize == 107 // HPDF_PAPER_P32K_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 151 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 97 )
   case nPaperSize == 108 // HPDF_PAPER_P32KBIG_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 151 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 97 )
   case nPaperSize == 109 // HPDF_PAPER_PENV_1_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 165 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 102 )
   case nPaperSize == 110 // HPDF_PAPER_PENV_2_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 102 )
   case nPaperSize == 111 // HPDF_PAPER_PENV_3_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 125 )
   case nPaperSize == 112 // HPDF_PAPER_PENV_4_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 208 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 110 )
   case nPaperSize == 113 // HPDF_PAPER_PENV_5_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 220 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 110 )
   case nPaperSize == 114 // HPDF_PAPER_PENV_6_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 230 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 120 )
   case nPaperSize == 115 // HPDF_PAPER_PENV_7_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 230 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 160 )
   case nPaperSize == 116 // HPDF_PAPER_PENV_8_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 309 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 120 )
   case nPaperSize == 117 // HPDF_PAPER_PENV_9_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 324 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 229 )
   case nPaperSize == 118 // HPDF_PAPER_PENV_10_ROTATED
      _HMG_SYSDATA[ 150 ][ 4 ] := _HMG_HPDF_MM2Pixel( 458 )
      _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_HPDF_MM2Pixel( 324 )
endcase
If _HMG_SYSDATA[ 150 ][ 6 ] == 2 // landscape
   nTemp := _HMG_SYSDATA[ 150 ][ 5 ]
   _HMG_SYSDATA[ 150 ][ 5 ] := _HMG_SYSDATA[ 150 ][ 4 ]
   _HMG_SYSDATA[ 150 ][ 4 ] := nTemp
endif
Return Nil

*------------------------------------------------------------------------------
*-12th April, 2014
*-Author: Pablo César Arrascaeta
*-_HMG_HPDF validation/selection fonts
*------------------------------------------------------------------------------

Function _HMG_HPDF_SetFont( cFntName, lBold, lItalic )
Local cFntTmp := "", cFnt := "", cFntNoExt

Default lBold := .f., lItalic := .f.

If HMG_Len( AllTrim( cFntName ) ) == 0
   cFnt := _HMG_SYSDATA[ 150 ][ 8 ]
   If lBold .and. lItalic
      cFnt += '-BoldOblique'
   ElseIf lBold
      cFnt += '-Bold'
   ElseIf lItalic
      cFnt += '-Oblique'
   Endif
   Return cFnt
EndIf   

if HMG_UPPER (cFileExt (cFntName)) == '.TTF' // load ttf font
   cFnt := _HMG_HPDF_ExistInLocal(cFntName)
   If !Empty(cFnt)
      Return cFnt
   Endif
Endif

cFntTmp := cFileNoExt( cFntName )
cFntNoExt := cFntTmp
cFnt := _HMG_HPDF_SeekHaruFonts(cFntTmp,lBold,lItalic)
If !Empty(cFnt)
   Return cFnt
Endif

cFnt := _HMG_HPDF_SeekEquivalences(cFntNoExt,lBold,lItalic)
If !Empty(cFnt)
   Return cFnt
Endif

cFnt := _HMG_HPDF_SeekInLocalOptions(cFntNoExt,lBold,lItalic)
If !Empty(cFnt)
   cFntTmp := _HMG_HPDF_ExistInLocal(cFnt)
   If !Empty(cFntTmp)
      Return cFntTmp
   Endif
Endif
Return "Helvetica"


Function _HMG_HPDF_SeekHaruFonts(cFontName,lBold,lItalic)
Local aHpdf_Font := {"Courier",;
                    "Courier-Bold",;
                    "Courier-Oblique",;
                    "Courier-BoldOblique",;
                    "Helvetica",;
                    "Helvetica-Bold",;
                    "Helvetica-Oblique",;
                    "Helvetica-BoldOblique",;
                    "Times-Roman",;
                    "Times-Bold",;
                    "Times-Italic",;
                    "Times-BoldItalic",;
                    "Symbol",;
                    "ZapfDingbats"}
Local nPos, cFnt, cFont, cFntHaru

If (nPos := AScan(aHpdf_Font, {|cFnt| HMG_Upper(cFnt) == HMG_Upper(cFontName)})) > 0
   cFont := aHpdf_Font[nPos]
   Do Case
      Case "SYMBOL" $ HMG_Upper( cFont )
          cFntHaru := "Symbol"
      Case "ZAPFDINGBATS" $ HMG_Upper( cFont )
           cFntHaru := "ZapfDingbats"
      Case HMG_Upper(HB_USubStr(cFont,1,5)) == 'TIMES' 
           cFnt := "Times"
           If lBold .and. lItalic
              cFntHaru := cFnt + '-BoldItalic'
           ElseIf lBold
              cFntHaru := cFnt + '-Bold'
           ElseIf lItalic
              cFntHaru := cFnt + '-Italic'
           Else
              cFntHaru := cFnt + '-Roman'
           Endif
      OtherWise
           If (nPos := HB_UAt('-',cFont)) > 0
              cFnt := HB_USubStr(cFont, 1, nPos-1)
           Endif
           If lBold .and. lItalic
              cFntHaru := cFnt + '-BoldOblique'
           ElseIf lBold
              cFntHaru := cFnt + '-Bold'
           ElseIf lItalic
              cFntHaru := cFnt + '-Oblique'
           Endif
   EndCase
   If lBold .or. lItalic
      Return cFntHaru
   Else
      Return cFont
   Endif
Endif
Return ""

Function _HMG_HPDF_SeekEquivalences(FontName,lBold,lItalic)
Local cFldWindows := GetSpecialFolder(CSIDL_FONTS)
Local cRet:=""

Default lBold := .f., lItalic := .f.

Do Case
   Case "COUR" $ HMG_Upper(FontName)
        cRet:="cour"
   Case "TIMES" $ HMG_Upper(FontName)
        cRet:="times"
   Case "ARIAL" $ HMG_Upper(FontName)
        cRet:="arial"
   Case "VERDANA" $ HMG_Upper(FontName)
        cRet:="verdana"
EndCase
If !Empty(cRet)
   cRet := cFldWindows + "\" + cRet
   If lBold .and. lItalic
      cRet := cRet + 'bi.ttf'
   ElseIf lBold
      cRet := cRet + 'bd.ttf'
   ElseIf lItalic
      cRet := cRet + 'i.ttf'
   Else
      cRet := cRet + '.ttf'
   Endif
   cRet := _HMG_HPDF_ExistInLocal(cRet)
Endif
Return cRet

Function _HMG_HPDF_ExistInLocal(FontName)
Local cFldWindows := GetSpecialFolder(CSIDL_FONTS)
Local cFileTTF := cFileNoExt( FontName )+".ttf"
Local cFldLocal := GetCurrentFolder()
Local cFntTmp := ""

If File(FontName)
   Return FontName
Endif
If File(cFldWindows+"\"+cFileTTF)
      cFntTmp := cFldWindows+"\"+cFileTTF
Endif
If File(cFldLocal+"\"+cFileTTF)
      cFntTmp := cFldLocal+"\"+cFileTTF
Endif
Return cFntTmp

Function _HMG_HPDF_SeekInLocalOptions(FontName,lBold,lItalic)
Local aDirFnts := {}, cRet:=""
Local cFldWindows, cFileTTF

Default lBold := .f., lItalic := .f.

cFldWindows := GetSpecialFolder(CSIDL_FONTS)
cFileTTF := cFileNoExt( FontName )
aDirFnts := ASort(Directory(cFldWindows+"\"+HB_USubStr(cFileTTF,1,4)+"*.ttf"),,,{|x,y| HMG_Len(x[1]) < HMG_Len(y[1] )})
If Len(aDirFnts)>0
   cRet := cFldWindows + "\" + cFileNoExt( aDirFnts[1,1] )
   If lBold .and. lItalic
      cRet := cRet + 'bi.ttf'
   ElseIf lBold
      cRet := cRet + 'bd.ttf'
   ElseIf lItalic
      cRet := cRet + 'i.ttf'
   Else
      cRet := cRet + '.ttf'
   Endif
Endif
Return cRet

Function FWriteLine( nFHandle, cString )
If nFHandle>3
   Fwrite( nFHandle, cString )
   Fwrite( nFHandle, chr(13) )
   Fwrite( nFHandle, chr(10) )
Endif
Return Nil

*------------------------------------------------------------------------------
*-12th April, 2014
*-Author: Pablo César Arrascaeta
*-HTML Table
*------------------------------------------------------------------------------

Function HTML_TABLE_INI(nFHandle,cTit,nWidth,nPading)
Local cStyle

Default nPading := 3
Default nWidth := 1024

cStyle := '<html><head>'+CRLF+;
          '<style>'+CRLF+;
          'table,th,td'+CRLF+;
          '{'+CRLF+;
          'border:1px solid black;'+CRLF+;
          'border-collapse:collapse;'+CRLF+;
          '}'+CRLF+;
          '</style>'+CRLF+;
          '</head>'+CRLF+;
          '<body>'+CRLF+;
		  '<table style='+Chr(34)+'width:'+StrZero(nWidth,4,0)+'px'+Chr(34)+' cellpadding='+Chr(34)+Str(nPading,1,0)+Chr(34)+'>'
cTit := alltrim( cTit )        
FWriteLine( nFHandle,cStyle)
Return Nil

Function HTML_TABLE_LINE(nFHandle,aLin)
Local i, nLen:=Len(aLin), cLin := "<tr>"

For i=1 To nLen
    cLin := cLin+CRLF+'<td '+If(aLin[i,3],' align="center" valign="middle" ',"")+'bgcolor='+Chr(34)+aLin[i,2]+Chr(34)+'>'+aLin[i,1]+'</td>'
Next
FWriteLine( nFHandle, cLin + CRLF +"</tr>" )
Return Nil


Function HTML_BOLD(nFHandle,cText)
nFHandle := nFHandle
Return ("<b>"+cText+"</b>")


#pragma BEGINDUMP


#include "SET_COMPILE_HMG_UNICODE.ch"

#ifdef COMPILE_HMG_UNICODE
   #undef COMPILE_HMG_UNICODE   // Force to compile only for ANSI character set
#endif

#include "HMG_UNICODE.h"

#include <windows.h>
#include <tchar.h>
#include "hbapi.h"
#include "hpdf.h"


/*-------------------------------------------------------------------------
   The following Functions are taken from the graphics library Bos Taurus.
   Bos Taurus, (c) 2012 by Dr. Claudio Soto <srvet@adinet.com.uy>
---------------------------------------------------------------------------*/

//*********************************************************************************************************************
// _bt_LoadFileFromResources (FileName, TypeResource) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL _bt_HPDF_LoadFileFromResources (TCHAR * FileName, TCHAR * TypeResource)
{
   HRSRC     hResourceData;
   HGLOBAL   hGlobalAlloc,  hGlobalResource;
   LPVOID    lpGlobalAlloc, lpGlobalResource;
   DWORD     nFileSize;

   hResourceData = FindResource (NULL, FileName, TypeResource);
   if (hResourceData == NULL)
       return NULL;

   hGlobalResource = LoadResource (NULL, hResourceData);
   if (hGlobalResource == NULL)
       return NULL;

   lpGlobalResource  = LockResource (hGlobalResource);
   if (lpGlobalResource == NULL)
       return NULL;

   nFileSize = SizeofResource (NULL, hResourceData);

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   FreeResource (hGlobalResource);
       return NULL;
   }

   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   memcpy (lpGlobalAlloc, lpGlobalResource, nFileSize);
   GlobalUnlock (hGlobalAlloc);

   FreeResource (hGlobalResource);

   return hGlobalAlloc;
}


//*********************************************************************************************************************
// _bt_LoadFileFromDisk (FileName) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL _bt_HPDF_LoadFileFromDisk (TCHAR * FileName)
{
   HGLOBAL   hGlobalAlloc;
   LPVOID    lpGlobalAlloc;
   HANDLE    hFile;
   DWORD     nFileSize;
   DWORD     nReadByte;

   hFile = CreateFile (FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
   if (hFile == INVALID_HANDLE_VALUE)
       return NULL;

   nFileSize = GetFileSize (hFile, NULL);
   if (nFileSize == INVALID_FILE_SIZE)
   {   CloseHandle (hFile);
       return NULL;
   }

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   CloseHandle (hFile);
       return NULL;
   }
   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   ReadFile (hFile, lpGlobalAlloc, nFileSize, &nReadByte, NULL);
   GlobalUnlock (hGlobalAlloc);

   CloseHandle (hFile);

   return hGlobalAlloc;
}


//*******************************************************************************************************
//* _HPDF_LOAD_PNG (hPDF_Doc, cFileName) ---> return Pointer   // load PNG image from Resourse or Disk
//*******************************************************************************************************

/*
typedef void*         HPDF_HANDLE;
typedef HPDF_HANDLE   HPDF_Image;   // void* ptr
typedef HPDF_HANDLE   HPDF_Doc;     // void* ptr
HPDF_LoadPngImageFromFile () ---> return image = void* ptr 
HPDF_LoadPngImageFromMem  () ---> return image = void* ptr
*/

extern HPDF_Doc hb_HPDF_Doc_par (int);

HB_FUNC (_HPDF_LOAD_PNG)
{
    TCHAR       *FileName;
    HGLOBAL     hGlobalAlloc;
    LPVOID      lpGlobalAlloc;
    UINT        nSizeGlobalAlloc;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;

    hpdf_Doc  = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName  = (TCHAR *)  HMG_parc (2);

    hGlobalAlloc = _bt_HPDF_LoadFileFromResources (FileName, _TEXT("PNG"));

 // if fail: find in disk
    if (hGlobalAlloc == NULL)
        hGlobalAlloc = _bt_HPDF_LoadFileFromDisk (FileName);

    if (hGlobalAlloc == NULL)
    {    hb_ret();  // return Nil
         return;
    }
 
    nSizeGlobalAlloc = (UINT) GlobalSize(hGlobalAlloc); 
    lpGlobalAlloc = GlobalLock (hGlobalAlloc);
        image = HPDF_LoadPngImageFromMem  (hpdf_Doc, (BYTE*)lpGlobalAlloc, nSizeGlobalAlloc);
    GlobalUnlock (hGlobalAlloc);
    GlobalFree (hGlobalAlloc);

    if (image == NULL)
    {   hb_ret();  // return Nil
        return;
    }

    hb_retptr ((void *) image); // return image (void* ptr)
}


//*******************************************************************************************************
//* _HPDF_LOAD_JPG (hPDF_Doc, cFileName) ---> return Pointer   // load PNG image from Resourse or Disk
//*******************************************************************************************************

HB_FUNC (_HPDF_LOAD_JPG)
{
    TCHAR       *FileName;
    HGLOBAL     hGlobalAlloc;
    LPVOID      lpGlobalAlloc;
    UINT        nSizeGlobalAlloc;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;

    hpdf_Doc  = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName  = (TCHAR *)  HMG_parc (2);

    hGlobalAlloc = _bt_HPDF_LoadFileFromResources (FileName, _TEXT("JPG"));

 // if fail: find in disk
    if (hGlobalAlloc == NULL)
        hGlobalAlloc = _bt_HPDF_LoadFileFromDisk (FileName);

    if (hGlobalAlloc == NULL)
    {    hb_ret();  // return Nil
         return;
    }
 
    nSizeGlobalAlloc = (UINT) GlobalSize(hGlobalAlloc); 
    lpGlobalAlloc = GlobalLock (hGlobalAlloc);
        image = HPDF_LoadJpegImageFromMem (hpdf_Doc, (BYTE*)lpGlobalAlloc, nSizeGlobalAlloc);
    GlobalUnlock (hGlobalAlloc);
    GlobalFree (hGlobalAlloc);

    if (image == NULL)
    {   hb_ret();  // return Nil
        return;
    }

    hb_retptr ((void *) image); // return image (void* ptr)
}

#pragma ENDDUMP