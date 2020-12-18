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
#include "common.ch"
*-----------------------------------------------------------------------------*
Function _DefineListbox ( ControlName, ParentForm, x, y, w, h, rows, value, ;
			fontname, fontsize, tooltip, changeprocedure, ;
			dblclick, gotfocus, lostfocus, break, HelpId, ;
			invisible, notabstop, sort , bold, italic, ;
			underline, strikeout , backcolor , fontcolor , ;
			multiselect , dragitems )
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar , ControlHandle
Local FontHandle , k


   DEFAULT w               TO 120
   DEFAULT h               TO 120
   DEFAULT gotfocus        TO ""
   DEFAULT lostfocus       TO ""
   DEFAULT rows            TO {}
   DEFAULT value           TO 0
   DEFAULT changeprocedure TO ""
   DEFAULT dblclick        TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE
   DEFAULT sort            TO FALSE


	if _HMG_SYSDATA [ 264 ] = TRUE
		ParentForm := _HMG_SYSDATA [ 223 ]
		if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(FontName) == "U"
			FontName := _HMG_SYSDATA [ 224 ]
		EndIf
		if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(FontSize) == "U"
			FontSize := _HMG_SYSDATA [ 182 ]
		EndIf
	endif

	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		x 	:= x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		y 	:= y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
	endif

	mVar := "_" + ParentForm + "_" + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	if ValType(x) == "U" .or. ValType(y) == "U"

		If _HMG_SYSDATA [ 216 ] == "TOOLBAR"
			Break := TRUE
		EndIf

		i := GetFormIndex ( cParentForm )

		if i > 0

			if multiselect == .t.
				ControlHandle := InitMultiListBox ( _HMG_SYSDATA [ 87 ] [i], 0, x, y, w, h, fontname, fontsize, invisible, notabstop, sort , dragitems )
			else
				ControlHandle := InitListBox ( _HMG_SYSDATA [ 87 ] [i] , 0 , 0 , 0 , w , h , '' , 0 , invisible , notabstop, sort , dragitems )
			endif

			if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
				FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
			Else
				FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
			endif

			AddSplitBoxItem ( Controlhandle , _HMG_SYSDATA [ 87 ] [i] , w , break , , , , _HMG_SYSDATA [ 258 ] )

			_HMG_SYSDATA [ 216 ]	:= "LISTBOX"

		EndIf

	Else

		if multiselect == .t.
			ControlHandle := InitMultiListBox ( ParentForm, 0, x, y, w, h, fontname, fontsize, invisible, notabstop, sort , dragitems )
		else
			ControlHandle := InitListBox ( ParentForm , 0 , x , y , w , h , '' , 0 , invisible , notabstop, sort , dragitems )
		endif

		if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
			FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
		Else
			FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
		endif

	endif

	If _HMG_SYSDATA [ 265 ] = TRUE
		aAdd ( _HMG_SYSDATA [ 142 ] , ControlHandle )
	EndIf

	if ValType(tooltip) != "U"
		SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := if ( multiselect , "MULTILIST" , "LIST" )
	_HMG_SYSDATA [2]  [k] :=  ControlName
	_HMG_SYSDATA [3]  [k] :=  ControlHandle
	_HMG_SYSDATA [4]  [k] :=  ParentForm
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [ 10 ]  [k] :=  lostfocus
	_HMG_SYSDATA [ 11 ]  [k] :=  gotfocus
	_HMG_SYSDATA [ 12 ]  [k] :=  ChangeProcedure
	_HMG_SYSDATA [ 13 ]  [k] :=  FALSE
	_HMG_SYSDATA [ 14 ]  [k] :=  backcolor
	_HMG_SYSDATA [ 15 ]  [k] :=  fontcolor
	_HMG_SYSDATA [ 16 ]  [k] :=  dblclick
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ]   [k] := x
	_HMG_SYSDATA [ 20 ]   [k] := w
	_HMG_SYSDATA [ 21 ]   [k] := h
	_HMG_SYSDATA [ 22 ]   [k] := 0
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]   [k] := ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]  [k] :=  fontname
	_HMG_SYSDATA [ 28 ]  [k] :=  fontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]   [k] :=  tooltip
	_HMG_SYSDATA [ 31 ]   [k] :=  0
	_HMG_SYSDATA [ 32 ]  [k] :=   0
	_HMG_SYSDATA [ 33 ]   [k] :=  ""
	_HMG_SYSDATA [ 34 ]  [k] :=   if(invisible,FALSE,TRUE)
	_HMG_SYSDATA [ 35 ]   [k] :=  HelpId
	_HMG_SYSDATA [ 36 ]  [k] :=   FontHandle
	_HMG_SYSDATA [ 37 ]  [k] :=   0
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	for i = 1 to HMG_LEN (rows)
  		ListboxAddString (ControlHandle,rows[i])
	next x

	if multiselect == .t.
		if value <> Nil
			LISTBOXSETMULTISEL (ControlHandle,Value)
		endif
	else
		if value <> 0
			ListboxSetCurSel (ControlHandle,Value)
		endif
	endif

Return Nil
