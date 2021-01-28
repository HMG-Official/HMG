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


#include "SET_COMPILE_HMG_UNICODE.ch"   // UNICODE


MEMVAR _HMG_SYSDATA

#include "hmg.ch"


#define ABM_CRLF                hb_osNewLine()



FUNCTION HMG_SupportUnicode()   // This function is more intuitive that HMG_IsUnicode()
RETURN HMG_IsUnicode()


FUNCTION HMG_IsCurrentCodePageUnicode()   // New Function HMG-UNICODE
RETURN (Set(_SET_CODEPAGE) == "UTF8")


FUNCTION HMG_IsNotDefParam ( xDefineParam , xDefault )
LOCAL xRet
   IF PCount() == 1
      xRet := xDefault
   ELSE
      xRet := xDefineParam
   ENDIF
RETURN xRet


Function Init
Local aWinver, i, nIndex
LOCAL COLOR_HIGHLIGHT      := 13
LOCAL COLOR_HIGHLIGHTTEXT  := 14

MEMVAR _HMG_MsgDebugTitle
MEMVAR _HMG_MsgDebugType
MEMVAR _HMG_MsgDebugTimeOut

MEMVAR _HMG_InitCodepage
MEMVAR _HMG_MainWindowFirst
MEMVAR _HMG_MainFormIndex
MEMVAR _HMG_LastActiveFormIndex 
MEMVAR _HMG_LastActiveControlIndex
MEMVAR _HMG_LastFormIndexWithCursor
MEMVAR _HMG_StopWindowEventProcedure
MEMVAR _HMG_StopControlEventProcedure
MEMVAR _HMG_GRID_SELECTEDROW_DISPLAYCOLOR
MEMVAR _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR
MEMVAR _HMG_SetControlContextMenu

MEMVAR _HMG_MsgIDFindDlg
MEMVAR _HMG_FindReplaceOnAction

MEMVAR _HMG_EventData
MEMVAR _HMG_EventIsInProgress
MEMVAR _HMG_EventIsKeyboardMessage
MEMVAR _HMG_EventIsMouseMessage
MEMVAR _HMG_EventIsHMGWindowsMessage
MEMVAR _HMG_EventHookID
MEMVAR _HMG_EventHookCode
MEMVAR _HMG_EventINDEX
MEMVAR _HMG_EventHWND
MEMVAR _HMG_EventMSG
MEMVAR _HMG_EventWPARAM
MEMVAR _HMG_EventLPARAM
MEMVAR _HMG_EventPROCNAME

MEMVAR _HMG_CharRange_Min
MEMVAR _HMG_CharRange_Max

MEMVAR _HMG_GridInplaceEdit_StageEvent
MEMVAR _HMG_GridInplaceEdit_ControlHandle
MEMVAR _HMG_GridInplaceEdit_GridIndex
MEMVAR _HMG_GridEx_InplaceEditOption
MEMVAR _HMG_GridEx_InplaceEdit_nMsg

MEMVAR _HMG_DefaultIconName

MEMVAR _HMG_This_TreeItem_Value

PUBLIC _HMG_MsgDebugTitle   := NIL
PUBLIC _HMG_MsgDebugType    := NIL
PUBLIC _HMG_MsgDebugTimeOut := NIL

PUBLIC _HMG_MainWindowFirst                  := .T.   //ADD
PUBLIC _HMG_MainFormIndex                    := 0     //ADD
PUBLIC _HMG_LastActiveFormIndex              := 0     //ADD
PUBLIC _HMG_LastActiveControlIndex           := 0     //ADD
PUBLIC _HMG_LastFormIndexWithCursor          := 0     //ADD
PUBLIC _HMG_StopWindowEventProcedure         := {}    //ADD
PUBLIC _HMG_StopControlEventProcedure        := {}    //ADD
PUBLIC _HMG_GRID_SELECTEDROW_DISPLAYCOLOR    := .T.   //ADD
PUBLIC _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR   := .T.   //ADD
PUBLIC _HMG_SetControlContextMenu            := .T.   //ADD

PUBLIC _HMG_MsgIDFindDlg                     := 0           //ADD
PUBLIC _HMG_FindReplaceOnAction              := {|| NIL }   //ADD

PUBLIC _HMG_EventData                := {}    //ADD
PUBLIC _HMG_EventIsInProgress        := .F.   //ADD
PUBLIC _HMG_EventIsKeyboardMessage   := .F.   //ADD
PUBLIC _HMG_EventIsMouseMessage      := .F.   //ADD
PUBLIC _HMG_EventIsHMGWindowsMessage := .F.   //ADD
PUBLIC _HMG_EventHookID              := -1    //ADD
PUBLIC _HMG_EventHookCode            := -1    //ADD
PUBLIC _HMG_EventINDEX               := 0     //ADD
PUBLIC _HMG_EventHWND                := 0     //ADD
PUBLIC _HMG_EventMSG                 := 0     //ADD
PUBLIC _HMG_EventWPARAM              := 0     //ADD
PUBLIC _HMG_EventLPARAM              := 0     //ADD
PUBLIC _HMG_EventPROCNAME            := ""    //ADD

PUBLIC _HMG_CharRange_Min            := 0   //ADD
PUBLIC _HMG_CharRange_Max            := 0   //ADD

PUBLIC _HMG_GridInplaceEdit_StageEvent        := 0   //ADD
PUBLIC _HMG_GridInplaceEdit_ControlHandle     := 0   //ADD
PUBLIC _HMG_GridInplaceEdit_GridIndex         := 0   //ADD
PUBLIC _HMG_GridEx_InplaceEditOption          := 0   //ADD
PUBLIC _HMG_GridEx_InplaceEdit_nMsg           := 0   //ADD

PUBLIC _HMG_This_TreeItem_Value   := NIL   //ADD

PUBLIC _HMG_DefaultIconName       := 0     //ADD

PUBLIC _HMG_InitCodepage := SET (_SET_CODEPAGE)

#ifdef COMPILE_HMG_UNICODE
       SET CODEPAGE TO UNICODE
#endif       


//------------------------------------------------------------------------
// Set Default: Title, TypeIconButton and TimeOut in MsgDebug() function
//------------------------------------------------------------------------
   MsgDebugTitle()
   MsgDebugType()
   MsgDebugTimeOut()
//------------------------------------------------------------------------


    aWinver := WindowsVersion()

	* _HMG_SYSDATA Reference ;)

	* _HMG_SYSDATA [   1 ] -> Control Data
	* _HMG_SYSDATA [   2 ] -> Control Data
	* _HMG_SYSDATA [   3 ] -> Control Data
	* _HMG_SYSDATA [   4 ] -> Control Data
	* _HMG_SYSDATA [   5 ] -> Control Data
	* _HMG_SYSDATA [   6 ] -> Control Data
	* _HMG_SYSDATA [   7 ] -> Control Data
	* _HMG_SYSDATA [   8 ] -> Control Data
	* _HMG_SYSDATA [   9 ] -> Control Data
	* _HMG_SYSDATA [  10 ] -> Control Data
	* _HMG_SYSDATA [  11 ] -> Control Data
	* _HMG_SYSDATA [  12 ] -> Control Data
	* _HMG_SYSDATA [  13 ] -> Control Data
	* _HMG_SYSDATA [  14 ] -> Control Data
	* _HMG_SYSDATA [  15 ] -> Control Data
	* _HMG_SYSDATA [  16 ] -> Control Data
	* _HMG_SYSDATA [  17 ] -> Control Data
	* _HMG_SYSDATA [  18 ] -> Control Data
	* _HMG_SYSDATA [  19 ] -> Control Data
	* _HMG_SYSDATA [  20 ] -> Control Data
	* _HMG_SYSDATA [  21 ] -> Control Data
	* _HMG_SYSDATA [  22 ] -> Control Data
	* _HMG_SYSDATA [  23 ] -> Control Data
	* _HMG_SYSDATA [  24 ] -> Control Data
	* _HMG_SYSDATA [  25 ] -> Control Data
	* _HMG_SYSDATA [  26 ] -> Control Data
	* _HMG_SYSDATA [  27 ] -> Control Data
	* _HMG_SYSDATA [  28 ] -> Control Data
	* _HMG_SYSDATA [  29 ] -> Control Data
	* _HMG_SYSDATA [  30 ] -> Control Data
	* _HMG_SYSDATA [  31 ] -> Control Data
	* _HMG_SYSDATA [  32 ] -> Control Data
	* _HMG_SYSDATA [  33 ] -> Control Data
	* _HMG_SYSDATA [  34 ] -> Control Data
	* _HMG_SYSDATA [  35 ] -> Control Data
	* _HMG_SYSDATA [  36 ] -> Control Data
	* _HMG_SYSDATA [  37 ] -> Control Data
	* _HMG_SYSDATA [  38 ] -> Control Data
	* _HMG_SYSDATA [  39 ] -> Control Data
	* _HMG_SYSDATA [  40 ] -> Control Data

	* _HMG_SYSDATA [  41 ] -> _RESERVED_   // array --> { OnKeyControlEventProc, OnMouseControlEventProc, ToolTip_CustomDrawData }
	* _HMG_SYSDATA [  42 ] -> _RESERVED_
	* _HMG_SYSDATA [  43 ] -> _RESERVED_
	* _HMG_SYSDATA [  44 ] -> _RESERVED_
	* _HMG_SYSDATA [  45 ] -> _RESERVED_
	* _HMG_SYSDATA [  46 ] -> _RESERVED_
	* _HMG_SYSDATA [  47 ] -> _RESERVED_
	* _HMG_SYSDATA [  48 ] -> _RESERVED_
	* _HMG_SYSDATA [  49 ] -> _RESERVED_
	* _HMG_SYSDATA [  50 ] -> _RESERVED_
	* _HMG_SYSDATA [  51 ] -> _RESERVED_
	* _HMG_SYSDATA [  52 ] -> Drag ListBox 'ListId'
	* _HMG_SYSDATA [  53 ] -> Drag ListBox 'DragItem'
	* _HMG_SYSDATA [  54 ] -> Drag ListBox Notfycation message number
	* _HMG_SYSDATA [  55 ] -> ToolTip Style
	* _HMG_SYSDATA [  56 ] -> ToolTip BackColor
	* _HMG_SYSDATA [  57 ] -> Tooltip ForeColor
	* _HMG_SYSDATA [  58 ] -> _RESERVED_
	* _HMG_SYSDATA [  59 ] -> _RESERVED_
	* _HMG_SYSDATA [  60 ] -> Custom Event Procedures Array
	* _HMG_SYSDATA [  61 ] -> Custom Properties Procedures Array
	* _HMG_SYSDATA [  62 ] -> Custom Methods Procedures Array
	* _HMG_SYSDATA [  63 ] -> User Component Process Flag
	* _HMG_SYSDATA [  64 ] -> _RESERVED_
	* _HMG_SYSDATA [  65 ] -> _HMG_aFormDeleted
	* _HMG_SYSDATA [  66 ] -> _HMG_aFormNames
	* _HMG_SYSDATA [  67 ] -> _HMG_aFormHandles
	* _HMG_SYSDATA [  68 ] -> _HMG_aFormActive
	* _HMG_SYSDATA [  69 ] -> _HMG_aFormType
	* _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
	* _HMG_SYSDATA [  71 ] -> _HMG_aFormReleaseProcedure
	* _HMG_SYSDATA [  72 ] -> _HMG_aFormInitProcedure
	* _HMG_SYSDATA [  73 ] -> _HMG_aFormToolTipHandle
	* _HMG_SYSDATA [  74 ] -> _HMG_aFormContextMenuHandle
	* _HMG_SYSDATA [  75 ] -> _HMG_aFormMouseDragProcedure
	* _HMG_SYSDATA [  76 ] -> _HMG_aFormSizeProcedure
	* _HMG_SYSDATA [  77 ] -> _HMG_aFormClickProcedure
	* _HMG_SYSDATA [  78 ] -> _HMG_aFormMouseMoveProcedure
	* _HMG_SYSDATA [  79 ] -> _HMG_aFormBkColor
	* _HMG_SYSDATA [  80 ] -> _HMG_aFormPaintProcedure
	* _HMG_SYSDATA [  81 ] -> _HMG_aFormNoShow
	* _HMG_SYSDATA [  82 ] -> _HMG_aFormNotifyIconName
	* _HMG_SYSDATA [  83 ] -> _HMG_aFormNotifyIconToolTip
	* _HMG_SYSDATA [  84 ] -> _HMG_aFormNotifyIconLeftClick
	* _HMG_SYSDATA [  85 ] -> _HMG_aFormGotFocusProcedure
	* _HMG_SYSDATA [  86 ] -> _HMG_aFormLostFocusProcedure
	* _HMG_SYSDATA [  87 ] -> _HMG_aFormReBarHandle
	* _HMG_SYSDATA [  88 ] -> _HMG_aFormNotifyMenuHandle
	* _HMG_SYSDATA [  89 ] -> _HMG_aFormBrowseList
	* _HMG_SYSDATA [  90 ] -> _HMG_aFormSplitChildList
	* _HMG_SYSDATA [  91 ] -> _HMG_aFormVirtualHeight
	* _HMG_SYSDATA [  92 ] -> _HMG_aFormVirtualWidth
	* _HMG_SYSDATA [  93 ] -> _HMG_aFormFocused
	* _HMG_SYSDATA [  94 ] -> _HMG_aFormScrollUp
	* _HMG_SYSDATA [  95 ] -> _HMG_aFormScrollDown
	* _HMG_SYSDATA [  96 ] -> _HMG_aFormScrollLeft
	* _HMG_SYSDATA [  97 ] -> _HMG_aFormScrollRight
	* _HMG_SYSDATA [  98 ] -> _HMG_aFormHScrollBox
	* _HMG_SYSDATA [  99 ] -> _HMG_aFormVScrollBox
	* _HMG_SYSDATA [ 100 ] -> _HMG_aFormBrushHandle
	* _HMG_SYSDATA [ 101 ] -> _HMG_aFormFocusedControl
	* _HMG_SYSDATA [ 102 ] -> _HMG_aFormGraphTasks
	* _HMG_SYSDATA [ 103 ] -> _HMG_aFormMaximizeProcedure
	* _HMG_SYSDATA [ 104 ] -> _HMG_aFormMinimizeProcedure
	* _HMG_SYSDATA [ 105 ] -> _HMG_aFormAutoRelease
	* _HMG_SYSDATA [ 106 ] -> _HMG_aFormInteractiveCloseProcedure
	* _HMG_SYSDATA [ 107 ] -> _HMG_aFormActivateId
	* _HMG_SYSDATA [ 108 ] -> Coordinates For Window Graph
	* _HMG_SYSDATA [ 109 ] -> Current Alternate Modal Parent
	* _HMG_SYSDATA [ 110 ] -> Current Report Image FromRow
	* _HMG_SYSDATA [ 111 ] -> Current Report Image FromCol
	* _HMG_SYSDATA [ 112 ] -> Current Report Image ToRow
	* _HMG_SYSDATA [ 113 ] -> Current Report Image ToCol
	* _HMG_SYSDATA [ 114 ] -> Current Report Image PenWidth
	* _HMG_SYSDATA [ 115 ] -> Current Report Image PenColor
	* _HMG_SYSDATA [ 116 ] -> Current Report Text Expression
	* _HMG_SYSDATA [ 117 ] -> Current Report Page Number
	* _HMG_SYSDATA [ 118 ] -> Current Report Paper Width (User PaperSize)
	* _HMG_SYSDATA [ 119 ] -> Current Report Paper Length (User paperSize)
	* _HMG_SYSDATA [ 120 ] -> Current Report Group Count
	* _HMG_SYSDATA [ 121 ] -> Current Report Group Header Array
	* _HMG_SYSDATA [ 122 ] -> Current Report Group Footer Array
	* _HMG_SYSDATA [ 123 ] -> Current Report Group Footer Band Height
	* _HMG_SYSDATA [ 124 ] -> Current Report Group Header Band Height
	* _HMG_SYSDATA [ 125 ] -> Current Report Group Expression
	* _HMG_SYSDATA [ 126 ] -> Current Report Summary Array
	* _HMG_SYSDATA [ 127 ] -> Current Report Summary Band Height
	* _HMG_SYSDATA [ 128 ] -> _HMG_aLangButton
	* _HMG_SYSDATA [ 129 ] -> _HMG_aLangLabel
	* _HMG_SYSDATA [ 130 ] -> _HMG_aLangUser
	* _HMG_SYSDATA [ 131 ] -> _HMG_aABMLangUser
	* _HMG_SYSDATA [ 132 ] -> _HMG_aABMLangLabel
	* _HMG_SYSDATA [ 133 ] -> _HMG_aABMLangButton
	* _HMG_SYSDATA [ 134 ] -> _HMG_aABMLangError
	* _HMG_SYSDATA [ 135 ] -> _HMG_BRWLangButton
	* _HMG_SYSDATA [ 136 ] -> _HMG_BRWLangError
	* _HMG_SYSDATA [ 137 ] -> _HMG_BRWLangMessage
	* _HMG_SYSDATA [ 138 ] -> _HMG_aTreeMap
	* _HMG_SYSDATA [ 139 ] -> _HMG_aTreeIdMap
	* _HMG_SYSDATA [ 140 ] -> _HMG_ActiveTabFullPageMap
	* _HMG_SYSDATA [ 141 ] -> _HMG_ActiveTabCaptions
	* _HMG_SYSDATA [ 142 ] -> _HMG_ActiveTabCurrentPageMap
	* _HMG_SYSDATA [ 143 ] -> _hmg_CurrentStatusBarCaptions
	* _HMG_SYSDATA [ 144 ] -> _hmg_CurrentStatusBarWidths
	* _HMG_SYSDATA [ 145 ] -> _hmg_CurrentStatusBarImages
	* _HMG_SYSDATA [ 146 ] -> _hmg_CurrentStatusBarStyles
	* _HMG_SYSDATA [ 147 ] -> _hmg_CurrentStatusBarToolTips
	* _HMG_SYSDATA [ 148 ] -> _hmg_CurrentStatusBarActions
	* _HMG_SYSDATA [ 149 ] -> Current Report HTML Code
	* _HMG_SYSDATA [ 150 ] -> Current Report PDF File Generator Flag
	* _HMG_SYSDATA [ 151 ] -> Current Report PDF Object Variable
	* _HMG_SYSDATA [ 152 ] -> Current Report Header Band Height
	* _HMG_SYSDATA [ 153 ] -> Current Report Detail Band Height
	* _HMG_SYSDATA [ 154 ] -> Current Report Footer Band Height
	* _HMG_SYSDATA [ 155 ] -> Current Report Orientation
	* _HMG_SYSDATA [ 156 ] -> Current Report Paper Size
	* _HMG_SYSDATA [ 157 ] -> Current Report Footer Array
	* _HMG_SYSDATA [ 158 ] -> Current Report Detail Array
	* _HMG_SYSDATA [ 159 ] -> Current Report Layout Array
	* _HMG_SYSDATA [ 160 ] -> Current Report Header Array
	* _HMG_SYSDATA [ 161 ] -> Current Report Section
	* _HMG_SYSDATA [ 162 ] -> Current Report Name
	* _HMG_SYSDATA [ 163 ] -> Current Report HTML File Generator Flag
	* _HMG_SYSDATA [ 164 ] -> _HMG_MainIndex
	* _HMG_SYSDATA [ 165 ] -> _hmg_CurrentStatusBarFontSize
	* _HMG_SYSDATA [ 166 ] -> _hmg_UserWindowHandle
	* _HMG_SYSDATA [ 167 ] -> _hmg_activemodalhandle
	* _HMG_SYSDATA [ 168 ] -> _HMG_nTopic
	* _HMG_SYSDATA [ 169 ] -> _HMG_xContextMenuButtonIndex
	* _HMG_SYSDATA [ 170 ] -> _HMG_nMet
	* _HMG_SYSDATA [ 171 ] -> _HMG_ActiveSplitChildIndex
	* _HMG_SYSDATA [ 172 ] -> _HMG_xMainMenuHandle
	* _HMG_SYSDATA [ 173 ] -> _HMG_xMainMenuParentHandle
	* _HMG_SYSDATA [ 174 ] -> _HMG_xMenuPopupLevel
	* _HMG_SYSDATA [ 175 ] -> _HMG_xContextMenuHandle
	* _HMG_SYSDATA [ 176 ] -> _HMG_xContextMenuParentHandle
	* _HMG_SYSDATA [ 177 ] -> _HMG_xContextPopupLevel
	* _HMG_SYSDATA [ 178 ] -> _HMG_ActiveTreeValue
	* _HMG_SYSDATA [ 179 ] -> _HMG_ActiveTreeIndex
	* _HMG_SYSDATA [ 180 ] -> _HMG_ActiveTreeHandle
	* _HMG_SYSDATA [ 181 ] -> _HMG_MainHandle
	* _HMG_SYSDATA [ 182 ] -> _HMG_ActiveFontSize
	* _HMG_SYSDATA [ 183 ] -> _HMG_FrameLevel
	* _HMG_SYSDATA [ 184 ] -> _HMG_ActiveTabPage
	* _HMG_SYSDATA [ 185 ] -> _HMG_ActiveTabRow
	* _HMG_SYSDATA [ 186 ] -> _HMG_ActiveTabCol
	* _HMG_SYSDATA [ 187 ] -> _HMG_ActiveTabWidth
	* _HMG_SYSDATA [ 188 ] -> _HMG_ActiveTabHeight
	* _HMG_SYSDATA [ 189 ] -> _HMG_ActiveTabValue
	* _HMG_SYSDATA [ 190 ] -> _HMG_ActiveTabFontSize
	* _HMG_SYSDATA [ 191 ] -> _HMG_MouseRow
	* _HMG_SYSDATA [ 192 ] -> _HMG_MouseCol
	* _HMG_SYSDATA [ 193 ] -> _HMG_MouseState
	* _HMG_SYSDATA [ 194 ] -> _HMG_ThisFormIndex
	* _HMG_SYSDATA [ 195 ] -> _HMG_ThisItemRowIndex
	* _HMG_SYSDATA [ 196 ] -> _HMG_ThisItemColIndex
	* _HMG_SYSDATA [ 197 ] -> _HMG_ThisItemCellRow
	* _HMG_SYSDATA [ 198 ] -> _HMG_ThisItemCellCol
	* _HMG_SYSDATA [ 199 ] -> _HMG_ThisItemCellWidth
	* _HMG_SYSDATA [ 200 ] -> _HMG_ThisItemCellHeight
	* _HMG_SYSDATA [ 201 ] -> _HMG_ThisQueryRowIndex
	* _HMG_SYSDATA [ 202 ] -> _HMG_ThisQueryColIndex
	* _HMG_SYSDATA [ 203 ] -> _HMG_ThisIndex
	* _HMG_SYSDATA [ 204 ] -> Current TAB multiline
	* _HMG_SYSDATA [ 205 ] -> _RESERVED_
	* _HMG_SYSDATA [ 206 ] -> Current Report Iterator Expression
	* _HMG_SYSDATA [ 207 ] -> Current Report EOF Expression
	* _HMG_SYSDATA [ 208 ] -> _RESERVED_
	* _HMG_SYSDATA [ 209 ] -> Current Cell Parent Control Index (Grid Inplace Edit)
	* _HMG_SYSDATA [ 210 ] -> _HMG_ActiveToolBarFormName
	* _HMG_SYSDATA [ 211 ] -> _HMG_LANG_ID
	* _HMG_SYSDATA [ 212 ] -> _hmg_CurrentStatusBarParent
	* _HMG_SYSDATA [ 213 ] -> _hmg_CurrentStatusBarFontName
	* _HMG_SYSDATA [ 214 ] -> _HMG_TempWindowName
	* _HMG_SYSDATA [ 215 ] -> _HMG_ActiveFormNameBak
	* _HMG_SYSDATA [ 216 ] -> _HMG_SplitLastControl
	* _HMG_SYSDATA [ 217 ] -> _HMG_ActiveHelpFile
	* _HMG_SYSDATA [ 218 ] -> _HMG_xMenuType
	* _HMG_SYSDATA [ 219 ] -> _HMG_ActiveIniFile
	* _HMG_SYSDATA [ 220 ] -> _HMG_xMainMenuParentName
	* _HMG_SYSDATA [ 221 ] -> _HMG_xContextMenuParentName
	* _HMG_SYSDATA [ 222 ] -> _HMG_ActiveSplitBoxParentFormName
	* _HMG_SYSDATA [ 223 ] -> _HMG_ActiveFormName
	* _HMG_SYSDATA [ 224 ] -> _HMG_ActiveFontName
	* _HMG_SYSDATA [ 225 ] -> _HMG_ActiveTabName
	* _HMG_SYSDATA [ 226 ] -> _HMG_ActiveTabParentFormName
	* _HMG_SYSDATA [ 227 ] -> _HMG_ActiveTabFontName
	* _HMG_SYSDATA [ 228 ] -> _HMG_ActiveTabToolTip
	* _HMG_SYSDATA [ 229 ] -> _HMG_ActiveTabMnemonic
	* _HMG_SYSDATA [ 230 ] -> _HMG_ThisQueryData
	* _HMG_SYSDATA [ 231 ] -> _HMG_ThisType
	* _HMG_SYSDATA [ 232 ] -> _HMG_ThisEventType
	* _HMG_SYSDATA [ 233 ] -> Alternate Syntax: OnEditEnd Event Temporary Storage
	* _HMG_SYSDATA [ 234 ] -> _RESERVED_
	* _HMG_SYSDATA [ 235 ] -> LOAD WINDOW optional row
	* _HMG_SYSDATA [ 236 ] -> LOAD WINDOW optional col
	* _HMG_SYSDATA [ 237 ] -> LOAD WINDOW optional width
	* _HMG_SYSDATA [ 238 ] -> LOAD WINDOW optional height
	* _HMG_SYSDATA [ 239 ] -> _RESERVED_
	* _HMG_SYSDATA [ 240 ] -> Parent Window Active
	* _HMG_SYSDATA [ 241 ] -> _RESERVED_
	* _HMG_SYSDATA [ 242 ] -> TextBox GotFocus Execution Flag
	* _HMG_SYSDATA [ 243 ] -> TextBox LostFocus Execution Flag
	* _HMG_SYSDATA [ 244 ] -> Current DynamicDisplay
	* _HMG_SYSDATA [ 245 ] -> CellNavigation UpDown Flag
	* _HMG_SYSDATA [ 246 ] -> HeaderImages Property
	* _HMG_SYSDATA [ 247 ] -> OnCloseUp Event
	* _HMG_SYSDATA [ 248 ] -> OnDropDown Event
	* _HMG_SYSDATA [ 249 ] -> DroppedWidth Property
	* _HMG_SYSDATA [ 250 ] -> _HMG_IsXP
	* _HMG_SYSDATA [ 251 ] -> _HMG_SetFocusExecuted
	* _HMG_SYSDATA [ 252 ] -> _HMG_InteractiveCloseStarted
	* _HMG_SYSDATA [ 253 ] -> _HMG_DateTextBoxActive
	* _HMG_SYSDATA [ 254 ] -> _HMG_BrowseSyncStatus
	* _HMG_SYSDATA [ 255 ] -> _HMG_ExtendedNavigation
	* _HMG_SYSDATA [ 256 ] -> _HMG_IPE_CANCELLED
	* _HMG_SYSDATA [ 257 ] -> _HMG_DialogCancelled
	* _HMG_SYSDATA [ 258 ] -> _HMG_ActiveSplitBoxInverted
	* _HMG_SYSDATA [ 259 ] -> _HMG_ActiveTreeItemIds
	* _HMG_SYSDATA [ 260 ] -> _HMG_SplitChildActive
	* _HMG_SYSDATA [ 261 ] -> _HMG_ActiveToolBarBreak
	* _HMG_SYSDATA [ 262 ] -> _HMG_ActiveSplitBox
	* _HMG_SYSDATA [ 263 ] -> _HMG_MainActive
	* _HMG_SYSDATA [ 264 ] -> _HMG_BeginWindowActive
	* _HMG_SYSDATA [ 265 ] -> _HMG_BeginTabActive
	* _HMG_SYSDATA [ 266 ] -> _HMG_ActiveTabButtons
	* _HMG_SYSDATA [ 267 ] -> _HMG_ActiveTabFlat
	* _HMG_SYSDATA [ 268 ] -> _HMG_ActiveTabHotTrack
	* _HMG_SYSDATA [ 269 ] -> _HMG_ActiveTabVertical
	* _HMG_SYSDATA [ 270 ] -> _HMG_ActiveTabNoTabStop
	* _HMG_SYSDATA [ 271 ] -> _HMG_IsModalActive
	* _HMG_SYSDATA [ 272 ] -> _hmg_CurrentStatusBarFontBold
	* _HMG_SYSDATA [ 273 ] -> _hmg_CurrentStatusBarFontItalic
	* _HMG_SYSDATA [ 274 ] -> _hmg_CurrentStatusBarFontUnderLine
	* _HMG_SYSDATA [ 275 ] -> _hmg_CurrentStatusBarFontStrikeout
	* _HMG_SYSDATA [ 276 ] -> _hmg_CurrentStatusBarTop
	* _HMG_SYSDATA [ 277 ] -> Current OnSave
	* _HMG_SYSDATA [ 278 ] -> This.EditBuffer
	* _HMG_SYSDATA [ 279 ] -> This.DeleteBuffer
	* _HMG_SYSDATA [ 280 ] -> This.AppendBuffer
	* _HMG_SYSDATA [ 281 ] -> Current LockColumns
	* _HMG_SYSDATA [ 282 ] -> _RESERVED_
	* _HMG_SYSDATA [ 283 ] -> _RESERVED_
	* _HMG_SYSDATA [ 284 ] -> _RESERVED_
	* _HMG_SYSDATA [ 285 ] -> _RESERVED_
	* _HMG_SYSDATA [ 286 ] -> User Current Print Copies
	* _HMG_SYSDATA [ 287 ] -> User Current Print Collation
	* _HMG_SYSDATA [ 288 ] -> _RESERVED_
	* _HMG_SYSDATA [ 289 ] -> _RESERVED_
	* _HMG_SYSDATA [ 290 ] -> _HMG_SENDDATACOUNT
	* _HMG_SYSDATA [ 291 ] -> _HMG_COMMPATH
	* _HMG_SYSDATA [ 292 ] -> _HMG_STATIONNAME
	* _HMG_SYSDATA [ 293 ] -> _DoControlEventProcedure Eval Result
	* _HMG_SYSDATA [ 294 ] -> _RESERVED_
	* _HMG_SYSDATA [ 295 ] -> _RESERVED_
	* _HMG_SYSDATA [ 296 ] -> HFCL data
	* _HMG_SYSDATA [ 297 ] -> _RESERVED_
	* _HMG_SYSDATA [ 298 ] -> Current Disabled BackColor
	* _HMG_SYSDATA [ 299 ] -> Current Disabled ForeColor
	* _HMG_SYSDATA [ 300 ] -> _hmg_ActiveToolBarImageHeight	
	* _HMG_SYSDATA [ 301 ] -> _HMG_ActiveTabBold
	* _HMG_SYSDATA [ 302 ] -> _HMG_ActiveTabItalic
	* _HMG_SYSDATA [ 303 ] -> _HMG_ActiveTabUnderline
	* _HMG_SYSDATA [ 304 ] -> _HMG_ActiveTabStrikeout
	* _HMG_SYSDATA [ 305 ] -> _HMG_ActiveTabImages
	* _HMG_SYSDATA [ 306 ] -> _HMG_IsMultiple
	* _HMG_SYSDATA [ 307 ] -> _HMG_NodeIndex
	* _HMG_SYSDATA [ 308 ] -> _HMG_ActiveTabChangeProcedure
	* _HMG_SYSDATA [ 309 ] -> _hmg_ActiveToolBarButtonCount
	* _HMG_SYSDATA [ 310 ] -> _hmg_ActiveToolBarHandle
	* _HMG_SYSDATA [ 311 ] -> _hmg_ActiveToolBarParentWindowName
	* _HMG_SYSDATA [ 312 ] -> _hmg_ActiveToolBarParentWindowHandle
	* _HMG_SYSDATA [ 313 ] -> _hmg_ActiveToolBarGripperText
	* _HMG_SYSDATA [ 314 ] -> _hmg_ActiveToolBarBreak
	* _HMG_SYSDATA [ 315 ] -> _hmg_ActiveToolBarImageWidth	
	* _HMG_SYSDATA [ 316 ] -> _HMG_ThisFormName
	* _HMG_SYSDATA [ 317 ] -> _HMG_ThisControlName
	* _HMG_SYSDATA [ 318 ] -> _HMG_THISItemCellValue
	* _HMG_SYSDATA [ 319 ] -> _RESERVED_
	* _HMG_SYSDATA [ 320 ] -> EXPERIMENTAL/NOT FULLY IMPLEMENTED: VIRTUAL GRID EDIT FLAG
	* _HMG_SYSDATA [ 321 ] -> EXPERIMENTAL/NOT FULLY IMPLEMENTED: VIRTUAL GRID EDIT ALLOW TAB FLAG
	* _HMG_SYSDATA [ 322 ] -> _RESERVED_
	* _HMG_SYSDATA [ 323 ] -> OOP Object Counter
	* _HMG_SYSDATA [ 324 ] -> OOP Last Window Object
	* _HMG_SYSDATA [ 325 ] -> Current Control Definition: 'Buffered'
	* _HMG_SYSDATA [ 326 ] -> Current Control Definition: 'ColumnFields'
	* _HMG_SYSDATA [ 327 ] -> Current Control Definition: 'RecordSource'
	* _HMG_SYSDATA [ 328 ] -> Last 'By Cell' Grid Event
	* _HMG_SYSDATA [ 329 ] -> Active CellNavigation
	* _HMG_SYSDATA [ 330 ] -> _HMG_aEventInfo
	* _HMG_SYSDATA [ 331 ] -> _HMG_MESSAGE
	* _HMG_SYSDATA [ 332 ] -> _HMG_ActiveFrameParentFormName
	* _HMG_SYSDATA [ 333 ] -> _HMG_ActiveFrameRow
	* _HMG_SYSDATA [ 334 ] -> _HMG_ActiveFrameCol
	* _HMG_SYSDATA [ 335 ] -> _HMG_xMenuPopuphandle
	* _HMG_SYSDATA [ 336 ] -> _HMG_xMenuPopupCaption
	* _HMG_SYSDATA [ 337 ] -> _HMG_NodeHandle
	* _HMG_SYSDATA [ 338 ] -> _HMG_ShowContextMenus
	* _HMG_SYSDATA [ 339 ] -> _HMG_InteractiveClose
	* _HMG_SYSDATA [ 340 ] -> _HMG_IPE_COL
	* _HMG_SYSDATA [ 341 ] -> _HMG_IPE_ROW
	* _HMG_SYSDATA [ 342 ] -> _HMG_DefaultFontName
	* _HMG_SYSDATA [ 343 ] -> _HMG_DefaultFontSize
	* _HMG_SYSDATA [ 344 ] -> _HMG_LastWIndowDefinition
	* _HMG_SYSDATA [ 345 ] -> ScrollStep
	* _HMG_SYSDATA [ 346 ] -> Set AutoScroll
	* _HMG_SYSDATA [ 347 ] -> Grid Automatic Update
	* _HMG_SYSDATA [ 348 ] -> Grid Selected Row ForeColor (by cell navigation)
	* _HMG_SYSDATA [ 349 ] -> Grid Selected Row BackColor (by cell navigation)
	* _HMG_SYSDATA [ 350 ] -> Grid Selected Cell ForeColor (by cell navigation)
	* _HMG_SYSDATA [ 351 ] -> Grid Selected Cell BackColor (by cell navigation)
	* _HMG_SYSDATA [ 352 ] -> Active Control DRAGITEMS
	* _HMG_SYSDATA [ 353 ] -> Active Control MULTILINE
	* _HMG_SYSDATA [ 354 ] -> Active Control DISPLAYITEMS
	* _HMG_SYSDATA [ 355 ] -> Active Control INPUTITEMS
	* _HMG_SYSDATA [ 356 ] -> Active Control PROGID
	* _HMG_SYSDATA [ 357 ] -> Active Control Horizontal
	* _HMG_SYSDATA [ 358 ] -> Print Job Name
	* _HMG_SYSDATA [ 359 ] -> PRINTER_DELTA_ZOOM
	* _HMG_SYSDATA [ 360 ] -> _hmg_printer_BasePageName
	* _HMG_SYSDATA [ 361 ] -> _hmg_printer_CurrentPageNumber
	* _HMG_SYSDATA [ 362 ] -> _hmg_printer_SizeFactor
	* _HMG_SYSDATA [ 363 ] -> _hmg_printer_Dx
	* _HMG_SYSDATA [ 364 ] -> _hmg_printer_Dy
	* _HMG_SYSDATA [ 365 ] -> _hmg_printer_Dz
	* _HMG_SYSDATA [ 366 ] -> _hmg_printer_scrollstep
	* _HMG_SYSDATA [ 367 ] -> _hmg_printer_zoomclick_xoffset
	* _HMG_SYSDATA [ 368 ] -> _HMG_PRINTER_THUMBUPDATE
	* _HMG_SYSDATA [ 369 ] -> _hmg_printer_thumbscroll 
	* _HMG_SYSDATA [ 370 ] -> _hmg_printer_PrevPageNumber
	* _HMG_SYSDATA [ 371 ] -> _hmg_printer_usermessages
	* _HMG_SYSDATA [ 372 ] -> _hmg_printer_hdc_bak
	* _HMG_SYSDATA [ 373 ] -> _hmg_printer_aPrinterProperties	
	* _HMG_SYSDATA [ 374 ] -> _hmg_printer_hdc 
	* _HMG_SYSDATA [ 375 ] -> _hmg_printer_name 
	* _HMG_SYSDATA [ 376 ] -> _hmg_printer_copies 
	* _HMG_SYSDATA [ 377 ] -> _hmg_printer_collate 
	* _HMG_SYSDATA [ 378 ] -> _hmg_printer_preview 
	* _HMG_SYSDATA [ 379 ] -> _hmg_printer_timestamp 
	* _HMG_SYSDATA [ 380 ] -> _hmg_printer_PageCount
	* _HMG_SYSDATA [ 381 ] -> Active Picture Alignment
	* _HMG_SYSDATA [ 382 ] -> Grid Column Header
	* _HMG_SYSDATA [ 383 ] -> Control Definition Active
	* _HMG_SYSDATA [ 384 ] -> _HMG_ActiveControlNoAutoSizeMovie
	* _HMG_SYSDATA [ 385 ] -> _HMG_ActiveControlField
	* _HMG_SYSDATA [ 386 ] -> _HMG_ActiveControlColumnWhen
	* _HMG_SYSDATA [ 387 ] -> _HMG_ActiveControlColumnValid
	* _HMG_SYSDATA [ 388 ] -> _HMG_ActiveControlEditControls
	* _HMG_SYSDATA [ 389 ] -> _HMG_ActiveControlWhen
	* _HMG_SYSDATA [ 390 ] -> _HMG_ActiveControlDynamicForeColor
	* _HMG_SYSDATA [ 391 ] -> _HMG_ActiveControlDynamicBackColor
	* _HMG_SYSDATA [ 392 ] -> _HMG_ActiveControlHandCursor
	* _HMG_SYSDATA [ 393 ] -> _HMG_ActiveControlCenterAlign
	* _HMG_SYSDATA [ 394 ] -> _HMG_ActiveControlNoHScroll
	* _HMG_SYSDATA [ 395 ] -> _HMG_ActiveControlGripperText
	* _HMG_SYSDATA [ 396 ] -> _HMG_ActiveControlDisplayEdit
	* _HMG_SYSDATA [ 397 ] -> _HMG_ActiveControlDisplayChange
	* _HMG_SYSDATA [ 398 ] -> _HMG_ActiveControlNoVScroll
	* _HMG_SYSDATA [ 399 ] -> _HMG_ActiveControlForeColor
	* _HMG_SYSDATA [ 400 ] -> _HMG_ActiveControlDateType
	* _HMG_SYSDATA [ 401 ] -> _HMG_ActiveControlInPlaceEdit
	* _HMG_SYSDATA [ 402 ] -> _HMG_ActiveControlItemSource
	* _HMG_SYSDATA [ 403 ] -> _HMG_ActiveControlValueSource
	* _HMG_SYSDATA [ 404 ] -> _HMG_ActiveControlWrap
	* _HMG_SYSDATA [ 405 ] -> _HMG_ActiveControlIncrement	
	* _HMG_SYSDATA [ 406 ] -> _HMG_ActiveControlAddress
	* _HMG_SYSDATA [ 407 ] -> _HMG_ActiveControlItemCount 
	* _HMG_SYSDATA [ 408 ] -> _HMG_ActiveControlOnQueryData
	* _HMG_SYSDATA [ 409 ] -> _HMG_ActiveControlAutoSize
	* _HMG_SYSDATA [ 410 ] -> _HMG_ActiveControlVirtual
	* _HMG_SYSDATA [ 411 ] -> _HMG_ActiveControlStretch
	* _HMG_SYSDATA [ 412 ] -> _HMG_ActiveControlFontBold
	* _HMG_SYSDATA [ 413 ] -> _HMG_ActiveControlFontItalic
	* _HMG_SYSDATA [ 414 ] -> _HMG_ActiveControlFontStrikeOut
	* _HMG_SYSDATA [ 415 ] -> _HMG_ActiveControlFontUnderLine
	* _HMG_SYSDATA [ 416 ] -> _HMG_ActiveControlName
	* _HMG_SYSDATA [ 417 ] -> _HMG_ActiveControlOf                 
	* _HMG_SYSDATA [ 418 ] -> _HMG_ActiveControlCaption            
	* _HMG_SYSDATA [ 419 ] -> _HMG_ActiveControlAction             
	* _HMG_SYSDATA [ 420 ] -> _HMG_ActiveControlWidth              
	* _HMG_SYSDATA [ 421 ] -> _HMG_ActiveControlHeight             
	* _HMG_SYSDATA [ 422 ] -> _HMG_ActiveControlFont               
	* _HMG_SYSDATA [ 423 ] -> _HMG_ActiveControlSize               
	* _HMG_SYSDATA [ 424 ] -> _HMG_ActiveControlTooltip
	* _HMG_SYSDATA [ 425 ] -> _HMG_ActiveControlFlat               
	* _HMG_SYSDATA [ 426 ] -> _HMG_ActiveControlOnGotFocus         
	* _HMG_SYSDATA [ 427 ] -> _HMG_ActiveControlOnLostFocus        
	* _HMG_SYSDATA [ 428 ] -> _HMG_ActiveControlNoTabStop  
	* _HMG_SYSDATA [ 429 ] -> _HMG_ActiveControlHelpId          
	* _HMG_SYSDATA [ 430 ] -> _HMG_ActiveControlInvisible  
	* _HMG_SYSDATA [ 431 ] -> _HMG_ActiveControlRow
	* _HMG_SYSDATA [ 432 ] -> _HMG_ActiveControlCol                
	* _HMG_SYSDATA [ 433 ] -> _HMG_ActiveControlPicture
	* _HMG_SYSDATA [ 434 ] -> _HMG_ActiveControlValue
	* _HMG_SYSDATA [ 435 ] -> _HMG_ActiveControlOnChange
	* _HMG_SYSDATA [ 436 ] -> _HMG_ActiveControlItems
	* _HMG_SYSDATA [ 437 ] -> _HMG_ActiveControlOnEnter
	* _HMG_SYSDATA [ 438 ] -> _HMG_ActiveControlShowNone
	* _HMG_SYSDATA [ 439 ] -> _HMG_ActiveControlUpDown
	* _HMG_SYSDATA [ 440 ] -> _HMG_ActiveControlRightAlign
	* _HMG_SYSDATA [ 441 ] -> _HMG_ActiveControlReadOnly
	* _HMG_SYSDATA [ 442 ] -> _HMG_ActiveControlMaxLength
	* _HMG_SYSDATA [ 443 ] -> _HMG_ActiveControlBreak
	* _HMG_SYSDATA [ 444 ] -> _HMG_ActiveControlOpaque
	* _HMG_SYSDATA [ 445 ] -> _HMG_ActiveControlHeaders
	* _HMG_SYSDATA [ 446 ] -> _HMG_ActiveControlWidths
	* _HMG_SYSDATA [ 447 ] -> _HMG_ActiveControlOnDblClick
	* _HMG_SYSDATA [ 448 ] -> _HMG_ActiveControlOnHeadClick
	* _HMG_SYSDATA [ 449 ] -> _HMG_ActiveControlNoLines
	* _HMG_SYSDATA [ 450 ] -> _HMG_ActiveControlImage
	* _HMG_SYSDATA [ 451 ] -> _HMG_ActiveControlJustify
	* _HMG_SYSDATA [ 452 ] -> _HMG_ActiveControlNoToday
	* _HMG_SYSDATA [ 453 ] -> _HMG_ActiveControlNoTodayCircle
	* _HMG_SYSDATA [ 454 ] -> _HMG_ActiveControlWeekNumbers
	* _HMG_SYSDATA [ 455 ] -> _HMG_ActiveControlMultiSelect
	* _HMG_SYSDATA [ 456 ] -> _HMG_ActiveControlEdit		
	* _HMG_SYSDATA [ 457 ] -> _HMG_ActiveControlBackColor
	* _HMG_SYSDATA [ 458 ] -> _HMG_ActiveControlFontColor
	* _HMG_SYSDATA [ 459 ] -> _HMG_ActiveControlBorder
	* _HMG_SYSDATA [ 460 ] -> _HMG_ActiveControlClientEdge
	* _HMG_SYSDATA [ 461 ] -> _HMG_ActiveControlHScroll
	* _HMG_SYSDATA [ 462 ] -> _HMG_ActiveControlVscroll
	* _HMG_SYSDATA [ 463 ] -> _HMG_ActiveControlTransparent
	* _HMG_SYSDATA [ 464 ] -> _HMG_ActiveControlSort
	* _HMG_SYSDATA [ 465 ] -> _HMG_ActiveControlRangeLow
	* _HMG_SYSDATA [ 466 ] -> _HMG_ActiveControlRangeHigh
	* _HMG_SYSDATA [ 467 ] -> _HMG_ActiveControlVertical
	* _HMG_SYSDATA [ 468 ] -> _HMG_ActiveControlSmooth
	* _HMG_SYSDATA [ 469 ] -> _HMG_ActiveControlOptions
	* _HMG_SYSDATA [ 470 ] -> _HMG_ActiveControlSpacing
	* _HMG_SYSDATA [ 471 ] -> _HMG_ActiveControlNoTicks
	* _HMG_SYSDATA [ 472 ] -> _HMG_ActiveControlBoth
	* _HMG_SYSDATA [ 473 ] -> _HMG_ActiveControlTop
	* _HMG_SYSDATA [ 474 ] -> _HMG_ActiveControlLeft
	* _HMG_SYSDATA [ 475 ] -> _HMG_ActiveControlUpperCase
	* _HMG_SYSDATA [ 476 ] -> _HMG_ActiveControlLowerCase
	* _HMG_SYSDATA [ 477 ] -> _HMG_ActiveControlNumeric
	* _HMG_SYSDATA [ 478 ] -> _HMG_ActiveControlPassword
	* _HMG_SYSDATA [ 479 ] -> _HMG_ActiveControlInputMask
	* _HMG_SYSDATA [ 480 ] -> _HMG_ActiveControlWorkArea
	* _HMG_SYSDATA [ 481 ] -> _HMG_ActiveControlFields
	* _HMG_SYSDATA [ 482 ] -> _HMG_ActiveControlDelete
	* _HMG_SYSDATA [ 483 ] -> _HMG_ActiveControlValid		
	* _HMG_SYSDATA [ 484 ] -> _HMG_ActiveControlValidMessages
	* _HMG_SYSDATA [ 485 ] -> _HMG_ActiveControlLock
	* _HMG_SYSDATA [ 486 ] -> _HMG_ActiveControlAppendable
	* _HMG_SYSDATA [ 487 ] -> _HMG_ActiveControlFile
	* _HMG_SYSDATA [ 488 ] -> _HMG_ActiveControlAutoPlay
	* _HMG_SYSDATA [ 489 ] -> _HMG_ActiveControlCenter
	* _HMG_SYSDATA [ 490 ] -> _HMG_ActiveControlNoAutoSizeWindow
	* _HMG_SYSDATA [ 491 ] -> _HMG_ActiveControlNoAuotSizeMovie
	* _HMG_SYSDATA [ 492 ] -> _HMG_ActiveControlNoErrorDlg
	* _HMG_SYSDATA [ 493 ] -> _HMG_ActiveControlNoMenu
	* _HMG_SYSDATA [ 494 ] -> _HMG_ActiveControlNoOpen
	* _HMG_SYSDATA [ 495 ] -> _HMG_ActiveControlNoPlayBar
	* _HMG_SYSDATA [ 496 ] -> _HMG_ActiveControlShowAll
	* _HMG_SYSDATA [ 497 ] -> _HMG_ActiveControlShowMode
	* _HMG_SYSDATA [ 498 ] -> _HMG_ActiveControlShowName
	* _HMG_SYSDATA [ 499 ] -> _HMG_ActiveControlShowPosition
	* _HMG_SYSDATA [ 500 ] -> _HMG_ActiveControlFormat

   * _HMG_SYSDATA [ 501 ] -> ScrollPage
   * _HMG_SYSDATA [ 502 ] -> #xtranslate --> _HMG_PrinterMetaFileDC
   * _HMG_SYSDATA [ 503 ] -> #xtranslate --> _HMG_FindReplaceOptions
   * _HMG_SYSDATA [ 504 ] -> {x,y,w,h}   --> Position of Panel Window
 
   * _HMG_SYSDATA [ 505 ] -> PrintPreview NotSaveButton --> .T. or .F.
   * _HMG_SYSDATA [ 506 ] -> PrintPreview Dialog cFileName
   * _HMG_SYSDATA [ 507 ] -> Print SaveAs cFullFileName
   * _HMG_SYSDATA [ 508 ] -> Open PrintPreview Dialog  --> .T. or .F.
   * _HMG_SYSDATA [ 509 ] -> ToolTip CustomDraw  --> .T. or .F.
   * _HMG_SYSDATA [ 510 ] -> ToolTip Menu --> .T. or .F.
   * _HMG_SYSDATA [ 511 ] -> ToolTip Menu Handle  --> { hWndToolTipMenu, ... }
   * _HMG_SYSDATA [ 512 ] -> ToolTip Form Data
   * _HMG_SYSDATA [ 513 ] -> Default Print PDF Mode --> .T. or .F.
   * _HMG_SYSDATA [ 514 ] -> SetGridCustomDrawNewBehavior() --> .T. or .F.
   * _HMG_SYSDATA [ 515 ] -> #xtranslate --> OpenPrinterGetJobID()
   * _HMG_SYSDATA [ 516 ] -> cVarName of STOREJOBDATA <aJobData>
   * _HMG_SYSDATA [ 517 ] -> #xtranslate --> oString
   * _HMG_SYSDATA [ 518 ] -> #xtranslate --> This.Cargo 

	* Create Public Array and Give it Initial Values

	Public _HMG_SYSDATA [ 518 ]

   
	For i := 1 to 108
		_HMG_SYSDATA [ i ] := {}
	Next i

	For i := 128 to 148
		_HMG_SYSDATA [ i ] := {}
	Next i

	For i := 164 to 203
		_HMG_SYSDATA [ i ] := 0
	Next i

	For i := 210 to 232
		_HMG_SYSDATA [ i ] := ''
	Next i

	For i := 250 to 276
		_HMG_SYSDATA [ i ] := .F.
	Next i

	For i := 300 to 318
		_HMG_SYSDATA [ i ] := NIL
	Next i

	For i := 360 to 380
		_HMG_SYSDATA [ i ] := NIL
	Next i

	_HMG_SYSDATA [ 330 ] := {}
	_HMG_SYSDATA [ 331 ] := ARRAY (8)
	_HMG_SYSDATA [ 332 ] := ARRAY (128)
	_HMG_SYSDATA [ 333 ] := ARRAY (128)
	_HMG_SYSDATA [ 334 ] := ARRAY (128)
	_HMG_SYSDATA [ 335 ] := ARRAY (255)
	_HMG_SYSDATA [ 336 ] := ARRAY (255)
	_HMG_SYSDATA [ 337 ] := ARRAY (255)
	_HMG_SYSDATA [ 338 ] := .T.
	_HMG_SYSDATA [ 339 ] := 1
	_HMG_SYSDATA [ 340 ] := 1
	_HMG_SYSDATA [ 341 ] := 1
	_HMG_SYSDATA [ 342 ] := 'Arial'
	_HMG_SYSDATA [ 343 ] := 9
	_HMG_SYSDATA [ 344 ] := 'None'
	_HMG_SYSDATA [ 371 ] := ARRAY (29)
   _HMG_SYSDATA [ 373 ] := {0,"",0,0}  // _hmg_printer_aPrinterProperties
	_HMG_SYSDATA [  55 ] := .F. 
	_HMG_SYSDATA [  56 ] := NIL
	_HMG_SYSDATA [  57 ] := NIL 
	_HMG_SYSDATA [ 383 ] := .F.
	_HMG_SYSDATA [ 345 ] := 1   // ScrollStep
   _HMG_SYSDATA [ 501 ] := 20  // ScrollPage
	_HMG_SYSDATA [ 346 ] := .T.
	_HMG_SYSDATA [ 357 ] := .F.
	_HMG_SYSDATA [ 109 ] := 0

	_HMG_SYSDATA [ 348 ] := { 0 , 0 , 0 }
	_HMG_SYSDATA [ 349 ] := { 235 , 235 , 235 }

	_HMG_SYSDATA [ 350 ] := { GetRed ( GetSysColor (COLOR_HIGHLIGHTTEXT) )	, GetGreen ( GetSysColor ( COLOR_HIGHLIGHTTEXT) )	, GetBlue ( GetSysColor (COLOR_HIGHLIGHTTEXT) ) }
	_HMG_SYSDATA [ 351 ] := { GetRed ( GetSysColor (COLOR_HIGHLIGHT) )	, GetGreen ( GetSysColor (COLOR_HIGHLIGHT ) )		, GetBlue ( GetSysColor (COLOR_HIGHLIGHT) )	}

   
// for default the selected language is English
   HB_LANGSELECT ("EN")
   InitMessages ("EN")

   _HMG_SYSDATA [ 306 ] := IsExeRunning (HB_UTF8STRTRAN (GetProgramFileName(), '\', '_'))

	If 'XP' $ aWINver[1] 
		_HMG_SYSDATA [ 250 ] := .T.
	EndIf

	_HMG_SYSDATA [ 320 ] := .F.
	_HMG_SYSDATA [ 321 ] := .F.
	_HMG_SYSDATA [ 299 ] := .F.
	_HMG_SYSDATA [ 243 ] := .F.
	_HMG_SYSDATA [ 242 ] := .F.

	_HMG_SYSDATA [ 347 ] := .T.

	_HMG_SYSDATA [ 286 ] := .F.
	_HMG_SYSDATA [ 287 ] := .F.

	_HMG_SYSDATA [ 240 ] := .F.

	_HMG_SYSDATA [ 235 ] := -1
	_HMG_SYSDATA [ 236 ] := -1
	_HMG_SYSDATA [ 237 ] := -1
	_HMG_SYSDATA [ 238 ] := -1
   _HMG_SYSDATA [ 284 ] := .F.
   _HMG_SYSDATA [ 285 ] := .F.

   _HMG_SYSDATA [ 375 ] := ""  // OpenPrinterGetName()
   _HMG_SYSDATA [ 504 ] := {}
   _HMG_SYSDATA [ 505 ] := NIL
   _HMG_SYSDATA [ 506 ] := NIL
   _HMG_SYSDATA [ 507 ] := NIL
   _HMG_SYSDATA [ 508 ] := NIL
   _HMG_SYSDATA [ 509 ] := .F. // ToolTip CustomDraw
   _HMG_SYSDATA [ 510 ] := .T. // ToolTip Menu
   _HMG_SYSDATA [ 511 ] := {}  // ToolTip Menu Handle  --> { hWndToolTipMenu, ... }
   _HMG_SYSDATA [ 512 ] := {}  // ToolTip Form Data
   _HMG_SYSDATA [ 513 ] := .F. // Default Print PDF Mode off
   _HMG_SYSDATA [ 514 ] := .T. // SetGridCustomDrawNewBehavior(), for default is .T.
   _HMG_SYSDATA [ 515 ] := 0   // OpenPrinterGetJobID()
   _HMG_SYSDATA [ 516 ] := ""  // cVarName of STOREJOBDATA <aJobData>
   _HMG_SYSDATA [ 517 ] := HMG_TStringNew()


   _HMG_PrinterMetaFileDC  := 0           // ADD
   _HMG_FindReplaceOptions := ARRAY (9)   // ADD

   _HMG_SYSDATA [54] := _GETDDLMESSAGE()           // ADD
   _HMG_MsgIDFindDlg := REGISTERFINDMSGSTRING ()   // ADD

   HMG_InitAllCommonControls()   // ADD
   OleInitialize()               // ADD

   SET WINDOW MAIN FIRST OFF     // ADD march 2017


   _HMG_DialogBoxProperty ( NIL, NIL, .F., 0, .F. )            // ADD
   _HMG_DialogBoxProcedure()                                   // ADD
   CREATE EVENT PROCNAME _HMG_DialogBoxProcedure(EventMsg())   // ADD

   CREATE EVENT PROCNAME _HMG_OnKey_OnMouse_Controls() STOREINDEX nIndex  // ADD
   EventProcessHMGWindowsMessage (nIndex, .F.)

   CREATE EVENT PROCNAME _HMG_GridOnClickAndOnKeyEvent()  STOREINDEX nIndex   // ADD
   EventProcessHMGWindowsMessage (nIndex, .F.)   // December 2014

   CREATE EVENT PROCNAME _HMG_GridInplaceEditEvent()      STOREINDEX nIndex   // ADD
   EventProcessHMGWindowsMessage (nIndex, .F.)   // December 2014

// MsgDebug("Init Proc")

Return Nil



// Dr. Claudio Soto (May 2013)
*--------------------------------------------------*
Procedure SetMultiple (lSetMultiple, lWarning)
*--------------------------------------------------*
LOCAL lExeRunning := _HMG_SYSDATA [ 306 ]

  IF ( lExeRunning == .T.) .AND. (lSetMultiple == .F.)  
      IF lWarning == .T.
         InitMessages() 
         MsgStop (_HMG_SYSDATA [ 331 ] [ 4 ])
      ENDIF
      ExitProcess(0)
  ENDIF
Return



// Dr. Claudio Soto (May 2013)
*-----------------------------------------------*
Function HMG_GetLanguage ()
*-----------------------------------------------*
LOCAL cLang := _HMG_SYSDATA [ 211 ]
Return cLang



*------------------------------------------------------------------------------*
Procedure InitMessages (cSetLang)
*------------------------------------------------------------------------------*
__THREAD STATIC cLang := "EN"

   IF cSetLang <> NIL
      cLang := cSetLang 
   ENDIF
   
   _HMG_SYSDATA [ 211 ] := cLang
   
// cLang := Set ( _SET_LANGUAGE )

// FINNISH and DUTCH: LANGUAGES NOT SUPPORTED BY hb_langSelect() FUNCTION.

/*
	IF _HMG_SYSDATA [ 211 ] == 'FI'		// FINNISH
		cLang := 'FI'
	ELSEIF _HMG_SYSDATA [ 211 ] == 'NL'	// DUTCH
		cLang := 'NL'
	ENDIF
*/

   _hmg_printer_InitUserMessages (cLang)

********************************************************************************************************************************************************
IF HMG_IsCurrentCodePageUnicode()
********************************************************************************************************************************************************

	do case

        // case cLang == "TRWIN" .OR. cLang == "TR"
        case cLang == "TR"

    /////////////////////////////////////////////////////////////
    // TÜRKÇE
    ////////////////////////////////////////////////////////////

        // ÇEÞÝTLÝ MESAJLAR

        _HMG_SYSDATA [ 331 ] [1] := 'Emin misiniz ?'
        _HMG_SYSDATA [ 331 ] [2] := 'Pencereyi Kapat'
        _HMG_SYSDATA [ 331 ] [3] := 'Kapatýlamýyor'
        _HMG_SYSDATA [ 331 ] [4] := 'Program hâlen çalýþýyor'
        _HMG_SYSDATA [ 331 ] [5] := 'Edit'
        _HMG_SYSDATA [ 331 ] [6] := 'Tamam'
        _HMG_SYSDATA [ 331 ] [7] := 'Ýptal'
        _HMG_SYSDATA [ 331 ] [8] := 'Syf.'

        // BROWSE MESAJLARI ( TÜRKÇE )

            _HMG_SYSDATA [ 136 ]  := { ;
                     "Pencere: ",;
                     " tanýmsýz. Program sonlandýrýldý.",;
                     "HMG Hatasý",;
                     "Kontrol: ",;
                     " / ",;
                     " Önceden tanýmlý. Program sonlandýrýldý.",;
                     "Browse: Geçersiz Tip. Program sonlandýrýldý.",;
                     "Browse: Browse çalýþma alanýnda olmayan sahalar için " +;
                              "Append ibaresi kullanýlamaz. Program sonlandýrýldý.",;
                     "Bu kaydý þu anda baþka biri editliyor.",;
                     "Uyarý",;
                     "Geçersiz giriþ"}

           _HMG_SYSDATA [ 137 ] := { 'Emin misiniz ?' , 'Kayýt silme' }

        // EDIT MESAJLARI ( TÜRKÇE )

        _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Kayýt silme"+CHR(13)+"Emin misiniz ?"+CHR(13),;
                     CHR(13)+"Indeks dosyasý yok"+CHR(13)+"Arama yapýlamýyor"+CHR(13),;
                     CHR(13)+"Indeks dosyasý bulunamadý"+CHR(13)+"Arama yapýlamýyor"+CHR(13),;
                     CHR(13)+"Memo ve mantýksal sahalarda"+CHR(13)+"Arama yapýlamaz"+CHR(13),;
                     CHR(13)+"Kayýt bulunamadý"+CHR(13),;
                     CHR(13)+"Çok fazla sütun var"+CHR(13)+"Rapor sayfaya sýðmýyor"+CHR(13) }

        _HMG_SYSDATA [ 132 ]  := { ;
                     "Kayýt",;
                     "Kayýt sayýsý",;
                     "       (Yeni)",;
                     "       (Edit)",;
                     " Kayýt No.su :",;
                     "Ara",;
                     "Metin ara",;
                     "Tarih ara",;
                     "Sayý ara",;
                     "Rapor tanýmý",;
                     "Rapor sütunlarý",;
                     "Müsait sütunlar",;
                     "Ýlk kayýt",;
                     "Son kayýt",;
                     "Rapor adý ",;
                     "Tarih:",;
                     "Ýlk kayýt:",;
                     "Son kayýt:",;
                     "Sýra düzeni:",;
                     "Evet",;
                     "Hayýr",;
                     "Sayfa ",;
                     " / "}

        _HMG_SYSDATA [ 133 ] := { ;
                     "Kapat",;
                     "Yeni",;
                     "Edit",;
                     "Sil",;
                     "Ara",;
                     "Git",;
                     "Rapor",;
                     "Ýlk",;
                     "Önceki",;
                     "Sonraki",;
                     "Son",;
                     "Kaydet",;
                     "Ýptal",;
                     "Ekle",;
                     "Kaldýr",;
                     "Print",;
                     "Kapat"}
                     
        _HMG_SYSDATA [ 134 ]  := { ;
                     "EDIT, çalýþma alaný ismi noksan",;
                     "EDIT, bu çalýþma alanýnda 16'dan fazla saha var",;
                     "EDIT, Tazeleme mod'u sýnýr ötesinde ( lütfen hatayý bildirin )",;
                     "EDIT, Temel olay numarasý sýnýr ötesinde ( lütfen hatayý bildirin )",;
                     "EDIT, Liste olay numarasý sýnýr ötesinde ( lütfen hatayý bildirin )" }

        // EDIT EXTENDED MESAJLARI ( TÜRKÇE )

            _HMG_SYSDATA [ 128 ] := { ;
                     "&Kapat",;                // 1
                     "&Yeni",;                 // 2
                     "&Deðiþtir",;             // 3
                     "&Sil",;                  // 4
                     "&Ara",;                  // 5
                     "&Print",;                // 6
                     "&Ýptal",;                // 7
                     "&Tamam",;                // 8
                     "&Kopyala",;              // 9
                     "&Süzgeçi etkinleþtir",;  // 10
                     "&Süzgeçi kaldýr" }       // 11
                                      
            _HMG_SYSDATA [ 129 ] := { ;
                     "Yok",;                         // 1
                     "Kayýt",;                       // 2
                     "Toplam",;                      // 3
                     "Aktif sýra",;                  // 4
                     "Seçenekler",;                  // 5
                     "Yeni kayýt",;                  // 6
                     "Kaydý deðiþtir",;              // 7
                     "Kayýt seç",;                   // 8
                     "Kayýt ara",;                   // 9
                     "Print seçenekleri",;           // 10
                     "Müsait sahalar",;              // 11
                     "Print edilecek sahalar",;      // 12
                     "Müsait printerler",;           // 13
                     "Print ediecek ilk kayýt",;     // 14
                     "Print ediecek son kayýt",;     // 15
                     "Kayýt sil",;                   // 16
                     "Önizleme",;                    // 17
                     "Sayfa ikonlarýný göster",;     // 18
                     "Süzgeç þartý: ",;              // 19
                     "Süzgeçli: ",;                  // 20
                     "Süzgeç seçenekleri" ,;         // 21
                     "Database Sahalarý",;           // 22
                     "Karþýlaþtýrma operatörleri",;  // 23
                     "Süzgeç deðeri",;               // 24
                     "Süzgeçlenecek sahalarý seç",;  // 25
                     "Karþýlaþtýrma operatörü seç",; // 26
                     "Eþit",;                        // 27
                     "Eþit deðil",;                  // 28
                     "Daha büyük",;                  // 29
                     "Daha küçük",;                  // 30
                     "Daha büyük veya eþit",;        // 31
                     "Daha küçük veya eþit"}         // 32
                                      
            _HMG_SYSDATA [ 130 ] := { ABM_CRLF + ;
                "Aktif bir alan bulunamadý."  + ABM_CRLF + ;       
                "Lütfen EDIT'i çaðýrmadan önce bir alan seçin" + ABM_CRLF,;           //  1
                "Saha deðeri girin ( metin )",;                                       //  2
                "Saha deðeri girin ( sayý )",;                                        //  3
                "Tarih seçimi",;                                                      //  4
                "Doðru deðeri onayla",;                                               //  5
                "Saha deðeri girin",;                                                 //  6
                "Bir kayýt seçip 'Tamam'a basýn",;                                    //  7
                ABM_CRLF + "Aktif kaydý silmek üzeresiniz" + ABM_CRLF + ;                 
                           "Emin misiniz ?    " + ABM_CRLF,;                          //  8
                ABM_CRLF + "Aktif bir sýra düzeni yok   " + ABM_CRLF + ;                  
                           "Lütfen birini seçin " + ABM_CRLF,;                        //  9
                ABM_CRLF + "Memo ve mantýksal sahada arama yapýlamýyor." + ABM_CRLF,; // 10
                ABM_CRLF + "Kayýt bulunmadý   " + ABM_CRLF,;                          // 11
                "Listeye girecek sahayý seçin",;                                      // 12
                "Listeye girmeyecek sahayý seçin",;                                   // 13
                "Printer seçin",;                                                     // 14
                "Sahayý eklemek için düðmeye basýn",;                                 // 15
                "Sahayý çýkarmak için düðmeye basýn",;                                // 16
                "Print edilecek ilk kaydý seçmek için düðmeye basýn",;                // 17
                "Print edilecek son kaydý seçmek için düðmeye basýn",;                // 18
                ABM_CRLF + "Eklenecek baþka saha yok.   " + ABM_CRLF,;                // 19
                ABM_CRLF + "Önce eklenecek sahayý seçin"   + ABM_CRLF,;               // 20
                ABM_CRLF + "Dýþlanacak baþka saha yok   "   + ABM_CRLF,;              // 21
                ABM_CRLF + "Önce çýkarýlacak sahayý seçin   " + ABM_CRLF,;            // 22
                ABM_CRLF + "Bir saha bile seçilmedi   " + ABM_CRLF + ;
                           "Lütfen print edilecek sahalarý seçin" + ABM_CRLF,;        // 23
                ABM_CRLF + "Çok fazla saha" + ABM_CRLF + ;
                           "Saha sayýsýný azaltýn" + ABM_CRLF,;                       // 24
                ABM_CRLF + "Printer hazýr deðil   " + ABM_CRLF,;                      // 25
                "Sýra düzeni",;                                                       // 26
                "Ýlk Kayýt",;                                                         // 27
                "Son kayýt",;                                                         // 28
                "Evet",;                                                              // 29
                "Hayýr",;                                                             // 30
                "Sayfa:",;                                                            // 31
                ABM_CRLF + "Lütfen bir printer seçin" + ABM_CRLF,;                    // 32
                "Süzgeç : ",;                                                         // 33
                ABM_CRLF + "Aktif süzgeç yok" + ABM_CRLF,;                            // 34
                ABM_CRLF + "Memo sahalar süzgeçlenemiyor    " + ABM_CRLF,;            // 35
                ABM_CRLF + "Süzgeçelenecek sahayý seçin    " + ABM_CRLF,;             // 36
                ABM_CRLF + "Süzgeç için bir operatör seçin    " + ABM_CRLF,;          // 37
                ABM_CRLF + "Süzgeç içi bir deðer yazýn    " + ABM_CRLF,;              // 38
                ABM_CRLF + "Aktif bir süzgeç yok    " + ABM_CRLF,;                    // 39
                ABM_CRLF + "Süzgeç kaldýrýlsýn mý   " + ABM_CRLF,;                    // 40
                ABM_CRLF + "Kaydý baþka bir kullanýcý kilitlemiþ    " + ABM_CRLF }    // 41

        // case cLang ==  "CS" .OR. cLang == "CSWIN"
        case cLang ==  "CS"
	/////////////////////////////////////////////////////////////
	// CZECH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES (ENGLISH DEFAULT)

		_hMG_SYSDATA [ 331 ] [1] := 'Jste si jist(a)?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zavøi okno'
		_hMG_SYSDATA [ 331 ] [3] := 'Uzavøení zakázáno'
		_hMG_SYSDATA [ 331 ] [4] := 'Program už bìží'
		_hMG_SYSDATA [ 331 ] [5] := 'Úprava'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Storno'
		_hMG_SYSDATA [ 331 ] [8] := 'Str.'

		// BROWSE MESSAGES (ENGLISH DEFAULT)

        	_HMG_SYSDATA [ 136 ]  := { "Okno: "                                              ,;
                                     " není definováno. Program ukonèen"                   ,;
                                     "HMG Error"                                         ,;
                                     "Prvek: "                                             ,;
                                     " z "                                                  ,;
				     " už definován. Program ukonèen"                  ,;
				     "Browse: Typ nepovolen. Program ukonèen"          ,;
				     "Browse: Append frázi nelze použít s poli nepatøícími do Browse pracovní oblasti. Program ukonèen",;
				     "Záznam edituje jiný uživatel"                ,;
				     "Varování"                                              ,;
				     "Chybný vstup"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Jste si jist(a)?' , 'Smazat záznam' }

		// EDIT MESSAGES (ENGLISH DEFAULT)

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Smazat záznam"+CHR(13)+"Jste si jist(a)?"+CHR(13)                  ,;
                     CHR(13)+"Chybí indexový soubor"+CHR(13)+"Nemohu hledat"+CHR(13)            ,;
                     CHR(13)+"Nemohu najít indexované pole"+CHR(13)+"Nemohu hledat"+CHR(13)        ,;
                     CHR(13)+"Nemohu hledat podle"+CHR(13)+"pole memo nebo logické"+CHR(13)       ,;
                     CHR(13)+"Záznam nenalezen"+CHR(13)                                        ,;
                     CHR(13)+"Pøíliš mnoho sloupcù"+CHR(13)+"Sestava se nevejde na plochu"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Záznam"      ,;
                     "Poèet záznamù"         ,;
                     "      (Nový)"          ,;
                     "     (Úprava)"         ,;
                     "Zadejte èíslo záznamu" ,;
                     "Hledej"                ,;
                     "Hledaný text"          ,;
                     "Hledané datum"         ,;
                     "Hledané èíslo"         ,;
                     "Definice sestavy"      ,;
                     "Sloupce sestavy"       ,;
                     "Dostupné sloupce"      ,;
                     "První záznam"          ,;
                     "Poslední záznam"       ,;
                     "Sestava "              ,;
                     "Datum:"                ,;
                     "První záznam:"         ,;
                     "Poslední záznam:"      ,;
                     "Tøídìno dle:"          ,;
                     "Ano"                   ,;
                     "Ne"                    ,;
                     "Strana "               ,;
                     " z "                   }

		_HMG_SYSDATA [ 133 ] := { "Zavøít"    ,;
                     "Nový"      ,;
                     "Úprava"    ,;
                     "Smaž"      ,;
                     "Najdi"     ,;
                     "Jdi"       ,;
                     "Sestava"   ,;
                     "První"     ,;
                     "Pøedchozí" ,;
                     "Další"     ,;
                     "Poslední"  ,;
                     "Ulož"      ,;
                     "Storno"    ,;
                     "Pøidej"    ,;
                     "Odstraò"   ,;
                     "Tisk"      ,;
                     "Zavøi"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, chybí jméno pracovní oblasti"                              ,;
                     "EDIT, pracovní oblast má víc jak 16 polí"              ,;
                     "EDIT, refresh mode mimo rozsah (prosím, nahlaste chybu)"      ,;
                     "EDIT, hlavní event èíslo mimo rozsah (prosím, nahlaste chybu)" ,;
                     "EDIT, list event èíslomimo rozsah (prosím, nahlaste chybu)"  }

		// EDIT EXTENDED (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Zavøi",            ; // 1
                "&Nový",             ; // 2
                "Ú&prava",           ; // 3
                "S&maž  ",           ; // 4
                "Na&jdi",            ; // 5
                "&Tisk",             ; // 6
                "&Storno",           ; // 7
                "&Ok",               ; // 8
                "&Kopíruj",          ; // 9
                "Aktivuj &filtr",    ; // 10
                "&Vypni filtr" }       // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "Žádný",                        ; // 1
                "Záznam",                       ; // 2
                "Suma",                         ; // 3
                "Aktivní tøídìní",              ; // 4
                "Volby",                        ; // 5
                "Nový záznam",                  ; // 6
                "Uprav záznam",                 ; // 7
                "Vyber záznam",                 ; // 8
                "Najdi záznam",                 ; // 9
                "Tiskni volby",                 ; // 10
                "Dostupná pole",                ; // 11
                "Pole k tisku",                 ; // 12
                "Dostupné tiskárny",            ; // 13
                "První záznam k tisku",         ; // 14
                "Poslední záznam k tisku",      ; // 15
                "Smaž záznam",                  ; // 16
                "Náhled",                       ; // 17
                "Zobraz miniatury stran",       ; // 18
                "Filtr: ",                      ; // 19
                "Filtrován: ",                  ; // 20
                "Volby filtru",                 ; // 21
                "Pole databáze",                ; // 22
                "Operátor porovnání",           ; // 23
                "Hodnota filtru",               ; // 24
                "Vyber pole do filtru",         ; // 25
                "Vyber operátor porovnání",     ; // 26
                "rovno",                        ; // 27
                "nerovno",                      ; // 28
                "vìtší než",                    ; // 29
                "menší než",                    ; // 30
                "vìtší nebo rovno než",         ; // 31
                "menší nebo rovno než",         } // 32

	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Nelze najít aktivní oblast   "  + ABM_CRLF + "Prosím vyberte nìkterou pøed voláním EDIT   " + ABM_CRLF,     ; // 1
                "Zadejte hodnotu pole (libovolný text)",                                                                                ; // 2
                "Zadejte hodnotu pole (libovolné èíslo)",                                                                               ; // 3
                "Vyberte datum",                                                                                                        ; // 4
                "Zatrhnìte pro hodnotu true",                                                                                           ; // 5
                "Zadejte hodnotu pole",                                                                                                 ; // 6
                "Vyberte jakýkoliv záznam s stisknìte OK",                                                                              ; // 7
                ABM_CRLF + "Chcete smazat tento záznam  " + ABM_CRLF + "Jste si jist(a)?    " + ABM_CRLF,                               ; // 8
                ABM_CRLF + "Není vybráno žádné tøídìní   " + ABM_CRLF + "Prosím zvolte jedno   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Nelze hledat podle pole memo nebo logic   " + ABM_CRLF,                                                     ; // 10
                ABM_CRLF + "Záznam nenalezen   " + ABM_CRLF,                                                                            ; // 11
                "Vyberte pole k zaøazení do seznamu",                                                                                   ; // 12
                "Vyberte pole k vyøazení ze seznamu",                                                                                   ; // 13
                "Vyberte tiskárnu",                                                                                                     ; // 14
                "Stisknìte tlaèítko pro zaøazení pole",                                                                                 ; // 15
                "Stisknìtì tlaèítko k vyøazení pole",                                                                                   ; // 16
                "Stisknìte tlaèítko k výbìru prvního záznamu k tisku",                                                                  ; // 17
                "Stisknìtì tlaèítko k výbìru posledního záznamu k tisku",                                                               ; // 18
                ABM_CRLF + "K zaøazení nezbývají pole   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "První výbìr pole k zaøazení   " + ABM_CRLF,                                                                 ; // 20
                ABM_CRLF + "Nelze vyøadit další pole   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "První výbìr pole k vyøazení   " + ABM_CRLF,                                                                 ; // 22
                ABM_CRLF + "Nebylo vybráno žádné pole   " + ABM_CRLF + "Prosím vyberte pole pro zaøazení do tisku   " + ABM_CRLF,       ; // 23
                ABM_CRLF + "Pøíliš mnoho polí   " + ABM_CRLF + "odeberte nìkterá pole   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Tiskárna není pøipravena   " + ABM_CRLF,                                                                    ; // 25
                "Tøídìno dle",                                                                                                          ; // 26
                "Od záznamu",                                                                                                           ; // 27
                "Do záznamu",                                                                                                           ; // 28
                "Ano",                                                                                                                  ; // 29
                "Ne",                                                                                                                   ; // 30
                "Strana:",                                                                                                              ; // 31
                ABM_CRLF + "Prosím vyberte tiskárnu   " + ABM_CRLF,                                                                     ; // 32
                "Filtrováno dle",                                                                                                       ; // 33
                ABM_CRLF + "Filtr není aktivní    " + ABM_CRLF,                                                                         ; // 34
                ABM_CRLF + "Nelze filtrovat podle memo    " + ABM_CRLF,                                                                 ; // 35
                ABM_CRLF + "Vyberte pole do filtru    " + ABM_CRLF,                                                                     ; // 36
                ABM_CRLF + "Vybarte operátor do filtru    " + ABM_CRLF,                                                                 ; // 37
                ABM_CRLF + "Zadejte hodnotu do filtru    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "Není žádný aktivní filtr    " + ABM_CRLF,                                                                   ; // 39
                ABM_CRLF + "Deactivovat filtr?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Záznam uzamèen jiným uživatelem  " + ABM_CRLF                                                                   } // 41

	/////////////////////////////////////////////////////////////
	// CROATIAN
	////////////////////////////////////////////////////////////
        // case cLang == "HR852" // Croatian
        case cLang == "HR"

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zatvori prozor'
		_hMG_SYSDATA [ 331 ] [3] := 'Zatvaranje nije dozvoljeno'
		_hMG_SYSDATA [ 331 ] [4] := 'Program je veæ pokrenut'
		_hMG_SYSDATA [ 331 ] [5] := 'Uredi'
		_hMG_SYSDATA [ 331 ] [6] := 'U redu'
		_hMG_SYSDATA [ 331 ] [7] := 'Prekid'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE MESSAGES 

        	_HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED MESSAGES

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
	        _HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
        	_HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

        case cLang == "EU"        // Basque.
	/////////////////////////////////////////////////////////////
	// BASQUE
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Close Window'
		_hMG_SYSDATA [ 331 ] [3] := 'Close not allowed'
		_hMG_SYSDATA [ 331 ] [4] := 'Program Already Running'
		_hMG_SYSDATA [ 331 ] [5] := 'Edit'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancel'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	


		// BROWSE MESSAGES 

        	_HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {            ;
                                "&Itxi",             ; // 1
                                "&Berria",           ; // 2
                                "&Aldatu",           ; // 3
                                "&Ezabatu",          ; // 4
                                "Bi&latu",           ; // 5
                                "In&primatu",        ; // 6
                                "&Utzi",             ; // 7
                                "&Ok",               ; // 8
                                "&Kopiatu",          ; // 9
                                "I&ragazkia Ezarri", ; // 10
                                "Ira&gazkia Kendu"   } // 11
                        _HMG_SYSDATA [ 129 ] := {                              ;
                                "Bat ere ez",                         ; // 1
                                "Erregistroa",                        ; // 2
                                "Guztira",                            ; // 3
                                "Orden Aktiboa",                      ; // 4
                                "Aukerak",                            ; // 5
                                "Erregistro Berria",                  ; // 6
                                "Erregistroa Aldatu",                 ; // 7
                                "Erregistroa Aukeratu",               ; // 8
                                "Erregistroa Bilatu",                 ; // 9
                                "Inprimatze-aukerak",                 ; // 10
                                "Eremu Libreak",                      ; // 11
                                "Inprimatzeko Eremuak",               ; // 12
                                "Inprimagailu Libreak",               ; // 13
                                "Inprimatzeko Lehenengo Erregistroa", ; // 14
                                "Inprimatzeko Azken Erregistroa",     ; // 15
                                "Erregistroa Ezabatu",                ; // 16
                                "Aurreikusi",                         ; // 17
                                "Orrien Irudi Txikiak Ikusi",         ; // 18
                                "Iragazkiaren Baldintza: ",           ; // 19
                                "Iragazita: ",                        ; // 20
                                "Iragazte-aukerak" ,                  ; // 21
                                "Datubasearen Eremuak" ,              ; // 22
                                "Konparaketa Eragilea",               ; // 23
                                "Iragazkiaren Balioa",                ; // 24
                                "Iragazteko Eremua Aukeratu",         ; // 25
                                "Konparaketa Eragilea Aukeratu",      ; // 26
                                "Berdin",                             ; // 27
                                "Ezberdin",                           ; // 28
                                "Handiago",                           ; // 29
                                "Txikiago",                           ; // 30
                                "Handiago edo Berdin",                ; // 31
                                "Txikiago edo Berdin"                 } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Ezin da area aktiborik aurkitu.   "  + ABM_CRLF + "Mesedez aukeratu area EDIT deitu baino lehen   " + ABM_CRLF,  ; // 1
                                "Eremuaren balioa idatzi (edozein testu)",                                                                                   ; // 2
                                "Eremuaren balioa idatzi (edozein zenbaki)",                                                                                 ; // 3
                                "Data aukeratu",                                                                                                             ; // 4
                                "Markatu egiazko baliorako",                                                                                                 ; // 5
                                "Eremuaren balioa sartu",                                                                                                    ; // 6
                                "Edozein erregistro aukeratu eta OK sakatu",                                                                                 ; // 7
                                ABM_CRLF + "Erregistro aktiboa ezabatuko duzu   " + ABM_CRLF + "Ziur zaude?    " + ABM_CRLF,                                 ; // 8
                                ABM_CRLF + "Ez dago orden aktiborik   " + ABM_CRLF + "Mesedez aukeratu bat   " + ABM_CRLF,                                   ; // 9
                                ABM_CRLF + "Memo edo eremu logikoen arabera ezin bilaketarik egin   " + ABM_CRLF,                                            ; // 10
                                ABM_CRLF + "Erregistroa ez da aurkitu   " + ABM_CRLF,                                                                        ; // 11
                                "Zerrendan sartzeko eremua aukeratu",                                                                                        ; // 12
                                "Zerrendatik kentzeko eremua aukeratu",                                                                                      ; // 13
                                "Inprimagailua aukeratu",                                                                                                    ; // 14
                                "Sakatu botoia eremua sartzeko",                                                                                             ; // 15
                                "Sakatu botoia eremua kentzeko",                                                                                             ; // 16
                                "Sakatu botoia inprimatzeko lehenengo erregistroa aukeratzeko",                                                              ; // 17
                                "Sakatu botoia inprimatzeko azken erregistroa aukeratzeko",                                                                  ; // 18
                                ABM_CRLF + "Sartzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 19
                                ABM_CRLF + "Lehenago aukeratu sartzeko eremua   " + ABM_CRLF,                                                                ; // 20
                                ABM_CRLF + "Kentzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 21
                                ABM_CRLF + "Lehenago aukeratu kentzeko eremua   " + ABM_CRLF,                                                                ; // 22
                                ABM_CRLF + "Ez duzu eremurik aukeratu  " + ABM_CRLF + "Mesedez aukeratu inprimaketan sartzeko eremuak   " + ABM_CRLF,        ; // 23
                                ABM_CRLF + "Eremu gehiegi   " + ABM_CRLF + "Murriztu eremu kopurua   " + ABM_CRLF,                                           ; // 24
                                ABM_CRLF + "Inprimagailua ez dago prest   " + ABM_CRLF,                                                                      ; // 25
                                "Ordenatuta honen arabera:",                                                                                                 ; // 26
                                "Erregistro honetatik:",                                                                                                     ; // 27
                                "Erregistro honetara:",                                                                                                      ; // 28
                                "Bai",                                                                                                                       ; // 29
                                "Ez",                                                                                                                        ; // 30
                                "Orrialdea:",                                                                                                                ; // 31
                                ABM_CRLF + "Mesedez aukeratu inprimagailua   " + ABM_CRLF,                                                                   ; // 32
                                "Iragazita honen arabera:",                                                                                                  ; // 33
                                ABM_CRLF + "Iragazki aktiboa dago    " + ABM_CRLF,                                                                           ; // 34
                                ABM_CRLF + "Ezin iragazi Memo eremuen arabera    " + ABM_CRLF,                                                               ; // 35
                                ABM_CRLF + "Iragazteko eremua aukeratu    " + ABM_CRLF,                                                                      ; // 36
                                ABM_CRLF + "Iragazteko edozein eragile aukeratu    " + ABM_CRLF,                                                             ; // 37
                                ABM_CRLF + "Idatzi edozein balio iragazteko    " + ABM_CRLF,                                                                 ; // 38
                                ABM_CRLF + "Ez dago iragazki aktiborik    " + ABM_CRLF,                                                                      ; // 39
                                ABM_CRLF + "Iragazkia kendu?   " + ABM_CRLF,                                                                                  ; // 40                
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

        case cLang == "EN"        // English
	/////////////////////////////////////////////////////////////
	// ENGLISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES (ENGLISH DEFAULT)

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Close Window'
		_hMG_SYSDATA [ 331 ] [3] := 'Close not allowed'
		_hMG_SYSDATA [ 331 ] [4] := 'Program Already Running'
		_hMG_SYSDATA [ 331 ] [5] := 'Edit'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancel'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE MESSAGES (ENGLISH DEFAULT)

        	_HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES (ENGLISH DEFAULT)

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

        case cLang == "FR"        // French
	/////////////////////////////////////////////////////////////
	// FRENCH
	////////////////////////////////////////////////////////////


		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Etes-vous sûre ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Fermer la fenêtre'
		_hMG_SYSDATA [ 331 ] [3] := 'Fermeture interdite'
		_hMG_SYSDATA [ 331 ] [4] := 'Programme déjà activé'
		_hMG_SYSDATA [ 331 ] [5] := 'Editer'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Abandonner'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Fenêtre: "                                             ,;
                                     " n'est pas définie. Programme terminé"                 ,;
                                     "Erreur HMG"                                        ,;
                                     "Contrôle: "                                            ,;
                                     " De "                                                  ,;
				     " Déjà défini. Programme terminé"                       ,;
				     "Modification: Type non autorisé. Programme terminé"    ,;
				     "Modification: La clause Ajout ne peut être utilisée avec des champs n'appartenant pas à la zone de travail de Modification. Programme terminé",;
				     "L'enregistrement est utilisé par un autre utilisateur"  ,;
				     "Erreur"                                                ,;
				     "Entrée invalide"                                        }
                _HMG_SYSDATA [ 137 ] := { 'Etes-vous sûre ?' , 'Enregistrement détruit' }

		// EDIT 

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Suppression d'enregistrement"+CHR(13)+"Etes-vous sûre ?"+CHR(13)  ,;
                                     CHR(13)+"Index manquant"+CHR(13)+"Recherche impossible"+CHR(13)            ,;
                                     CHR(13)+"Champ Index introuvable"+CHR(13)+"Recherche impossible"+CHR(13)   ,;
                                     CHR(13)+"Recherche impossible"+CHR(13)+"sur champs memo ou logique"+CHR(13),;
                                     CHR(13)+"Enregistrement non trouvé"+CHR(13)                                                     ,;
                                     CHR(13)+"Trop de colonnes"+CHR(13)+"L'état ne peut être imprimé"+CHR(13)      }
                _HMG_SYSDATA [ 132 ]  := { "Enregistrement"                       ,;
                                     "Nb. total enr."                       ,;
                                     "   (Ajouter)"                        ,;
                                     "  (Modifier)"                        ,;
                                     "Entrez le numéro de l'enregistrement" ,;
                                     "Trouver"                              ,;
                                     "Chercher texte"                       ,;
                                     "Chercher date"                        ,;
                                     "Chercher numéro"                      ,;
                                     "Définition de l'état"                 ,;
                                     "Colonnes de l'état"                   ,;
                                     "Colonnes disponibles"                 ,;
                                     "Enregistrement de début"              ,;
                                     "Enregistrement de fin"                ,;
                                     "Etat de "                             ,;
                                     "Date:"                                ,;
                                     "Enregistrement de début:"             ,;
                                     "Enregistrement de fin:"               ,;
                                     "Trié par:"                            ,;
                                     "Oui"                                  ,;
                                     "Non"                                  ,;
                                     " Page"                                ,;
                                     " de "                                 }
                _HMG_SYSDATA [ 133 ] := { "Fermer"      ,;
                                     "Nouveau"     ,;
                                     "Modifier"    ,;
                                     "Supprimer"   ,;
                                     "Trouver"     ,;
                                     "Aller à"     ,;
                                     "Etat"   ,;
                                     "Premier"     ,;
                                     "Précédent"   ,;
                                     "Suivant"     ,;
                                     "Dernier"     ,;
                                     "Enregistrer" ,;
                                     "Annuler"     ,;
                                     "Ajouter"     ,;
                                     "Retirer"     ,;
                                     "Imprimer"    ,;
                                     "Fermer"      }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, nom de la table manquant"                                         ,;
                                     "EDIT, la table a plus de 16 champs"                                     ,;
                                     "EDIT, mode rafraichissement hors limite (Rapport d'erreur merci)"       ,;
                                     "EDIT, événement principal nombre hors limite (Rapport d'erreur merci)"  ,;
                                     "EDIT, liste d'événements nombre hors limite (Rapport d'erreur merci)"   }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {           ;
                                "&Fermer",          ; // 1
                                "&Nouveau",         ; // 2
                                "&Modifier",        ; // 3
                                "&Supprimer",       ; // 4
                                "&Trouver",         ; // 5
                                "&Imprimer",        ; // 6
                                "&Abandon",         ; // 7
                                "&Ok",              ; // 8
                                "&Copier",          ; // 9
                                "&Activer Filtre",  ; // 10
                                "&Déactiver Filtre" } // 11
                        _HMG_SYSDATA [ 129 ] := {                                   ;
                                "Aucun",                                   ; // 1
                                "Enregistrement",                          ; // 2
                                "Total",                                   ; // 3
                                "Ordre actif",                             ; // 4
                                "Options",                                 ; // 5
                                "Nouvel enregistrement",                   ; // 6
                                "Modifier enregistrement",                 ; // 7
                                "Selectionner enregistrement",             ; // 8
                                "Trouver enregistrement",                  ; // 9
                                "Imprimer options",                        ; // 10
                                "Champs disponibles",                      ; // 11
                                "Champs à imprimer",                       ; // 12
                                "Imprimantes connectées",                  ; // 13
                                "Premier enregistrement à imprimer",       ; // 14
                                "Dernier enregistrement à imprimer",       ; // 15
                                "Enregistrement supprimé",                 ; // 16
                                "Prévisualisation",                        ; // 17
                                "Aperçu pages",                            ; // 18
                                "Condition filtre : ",                     ; // 19
                                "Filtré : ",                               ; // 20
                                "Options de filtrage" ,                    ; // 21
                                "Champs de la Bdd" ,                       ; // 22
                                "Opérateurs de comparaison",               ; // 23
                                "Valeur du filtre",                        ; // 24
                                "Selectionner le champ à filtrer",         ; // 25
                                "Selectionner l'opérateur de comparaison", ; // 26
                                "Egal",                                    ; // 27
                                "Différent",                               ; // 28
                                "Plus grand",                              ; // 29
                                "Plus petit",                              ; // 30
                                "Plus grand ou égal",                      ; // 31
                                "Plus petit ou égal"                       } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Ne peut trouver une base active.   "  + ABM_CRLF + "Sélectionner une base avant la fonction EDIT  " + ABM_CRLF,           ; // 1
                                "Entrer la valeur du champ (du texte)",                                                                                               ; // 2
                                "Entrer la valeur du champ (un nombre)",                                                                                              ; // 3
                                "Sélectionner la date",                                                                                                               ; // 4
                                "Vérifier la valeur logique",                                                                                                         ; // 5
                                "Entrer la valeur du champ",                                                                                                          ; // 6
                                "Sélectionner un enregistrement et appuyer sur OK",                                                                                   ; // 7
                                ABM_CRLF + "Vous voulez détruire l'enregistrement actif  " + ABM_CRLF + "Etes-vous sûre?   " + ABM_CRLF,                              ; // 8
                                ABM_CRLF + "Il n'y a pas d'ordre actif   " + ABM_CRLF + "Sélectionner en un   " + ABM_CRLF,                                           ; // 9
                                ABM_CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + ABM_CRLF,                                                      ; // 10
                                ABM_CRLF + "Enregistrement non trouvé  " + ABM_CRLF,                                                                                  ; // 11
                                "Sélectionner le champ à inclure à la liste",                                                                                         ; // 12
                                "Sélectionner le champ à exclure de la liste",                                                                                        ; // 13
                                "Sélectionner l'imprimante",                                                                                                          ; // 14
                                "Appuyer sur le bouton pour inclure un champ",                                                                                        ; // 15
                                "Appuyer sur le bouton pour exclure un champ",                                                                                        ; // 16
                                "Appuyer sur le bouton pour sélectionner le premier enregistrement à imprimer",                                                       ; // 17
                                "Appuyer sur le bouton pour sélectionner le dernier champ à imprimer",                                                                ; // 18
                                ABM_CRLF + "Plus de champs à inclure   " + ABM_CRLF,                                                                                  ; // 19
                                ABM_CRLF + "Sélectionner d'abord les champs à inclure   " + ABM_CRLF,                                                                 ; // 20
                                ABM_CRLF + "Plus de champs à exclure   " + ABM_CRLF,                                                                                  ; // 21
                                ABM_CRLF + "Sélectionner d'abord les champs à exclure   " + ABM_CRLF,                                                                 ; // 22
                                ABM_CRLF + "Vous n'avez sélectionné aucun champ   " + ABM_CRLF + "Sélectionner les champs à inclure dans l'impression   " + ABM_CRLF, ; // 23
                                ABM_CRLF + "Trop de champs   " + ABM_CRLF + "Réduiser le nombre de champs   " + ABM_CRLF,                                             ; // 24
                                ABM_CRLF + "Imprimante pas prête   " + ABM_CRLF,                                                                                      ; // 25
                                "Trié par",                                                                                                                           ; // 26
                                "De l'enregistrement",                                                                                                                ; // 27
                                "A l'enregistrement",                                                                                                                 ; // 28
                                "Oui",                                                                                                                                ; // 29
                                "Non",                                                                                                                                ; // 30
                                "Page:",                                                                                                                              ; // 31
                                ABM_CRLF + "Sélectionner une imprimante   " + ABM_CRLF,                                                                               ; // 32
                                "Filtré par",                                                                                                                         ; // 33
                                ABM_CRLF + "Il y a un filtre actif    " + ABM_CRLF,                                                                                   ; // 34
                                ABM_CRLF + "Filtre impossible sur champ memo    " + ABM_CRLF,                                                                         ; // 35
                                ABM_CRLF + "Sélectionner un champ de filtre    " + ABM_CRLF,                                                                          ; // 36
                                ABM_CRLF + "Sélectionner un opérateur de filtre   " + ABM_CRLF,                                                                       ; // 37
                                ABM_CRLF + "Entrer une valeur au filtre    " + ABM_CRLF,                                                                              ; // 38
                                ABM_CRLF + "Il n'y a aucun filtre actif    " + ABM_CRLF,                                                                              ; // 39
                                ABM_CRLF + "Désactiver le filtre?   " + ABM_CRLF,                                                                                     ; // 40
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

       // case cLang == "DEWIN" .OR. cLang == "DE"       // German
       case cLang == "DE"
	/////////////////////////////////////////////////////////////
	// GERMAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Sind Sie sicher ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Fenster schließen'
		_hMG_SYSDATA [ 331 ] [3] := 'Schließen nicht erlaubt'
		_hMG_SYSDATA [ 331 ] [4] := 'Programm läuft bereits'
		_hMG_SYSDATA [ 331 ] [5] := 'Bearbeiten'
		_hMG_SYSDATA [ 331 ] [6] := 'OK'
		_hMG_SYSDATA [ 331 ] [7] := 'Abbrechen'
		_hMG_SYSDATA [ 331 ] [8] := 'Seite'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
                _HMG_SYSDATA [ 137 ] := { 'Sind Sie sicher ?' , 'Datensatz löschen' }

		// EDIT

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Datensatz loeschen"+CHR(13)+"Sind Sie sicher ?"+CHR(13)                 ,;
                                     CHR(13)+" Falscher Indexdatensatz"+CHR(13)+"Suche unmoeglich"+CHR(13)         ,;
                                     CHR(13)+"Man kann nicht Indexdatenfeld finden"+CHR(13)+"Suche unmoeglich"+CHR(13) ,;
                                     CHR(13)+"Suche unmoeglich nach"+CHR(13)+"Feld memo oder logisch"+CHR(13)         ,;
                                     CHR(13)+"Datensatz nicht gefunden"+CHR(13)                                                     ,;
                                     CHR(13)+" zu viele Spalten"+CHR(13)+"Zu wenig Platz  fuer die Meldung auf dem Blatt" + CHR(13) }
                _HMG_SYSDATA [ 132 ]  := { "Datensatz"              ,;
                                     "Menge der Dat."        ,;
                                     "       (Neu)"        ,;
                                     " (Editieren)"        ,;
                                     "Datensatznummer eintragen" ,;
                                     "Suche"                ,;
                                     "Suche Text"         ,;
                                     "Suche Datum"         ,;
                                     "Suche Zahl"       ,;
                                     "Definition der Meldung"   ,;
                                     "Spalten der Meldung"      ,;
                                     "Zugaengliche Spalten"     ,;
                                     "Anfangsdatensatz"      ,;
                                     "Endedatensatz"        ,;
                                     "Datensatz vom "          ,;
                                     "Datum:"               ,;
                                     "Anfangsdatensatz:"     ,;
                                     "Endedatensatz:"       ,;
                                     "Sortieren nach:"         ,;
                                     "Ja"                 ,;
                                     "Nein"                  ,;
                                     "Seite "               ,;
                                     " von "                 }
                _HMG_SYSDATA [ 133 ] := { "Schliesse"    ,;
                                     "Neu"      ,;
                                     "Editiere"     ,;
                                     "Loesche"   ,;
                                     "Finde"     ,;
                                     "Gehe zu"     ,;
                                     "Meldung"   ,;
                                     "Erster"    ,;
                                     "Zurueck" ,;
                                     "Naechst"     ,;
                                     "Letzter"     ,;
                                     "Speichern"     ,;
                                     "Aufheben"   ,;
                                     "Hinzufuegen"      ,;
                                     "Loeschen"   ,;
                                     "Drucken"    ,;
                                     "Schliessen"     }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, falscher Name von Datenbank"                                  ,;
                                     "EDIT, Datenbank hat mehr als 16 Felder"                   ,;
                                     "EDIT, Auffrische-Modus ausser dem Bereich (siehe Fehlermeldungen)"      ,;
                                     "EDIT, Menge der Basisereignisse ausser dem Bereich (siehe Fehlermeldungen)" ,;
                                     "EDIT, Liste der Ereignisse ausser dem Bereich (siehe Fehlermeldungen)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {              ;
                                "S&chließen",          ; // 1
                                "&Neu",                ; // 2
                                "&Bearbeiten",         ; // 3
                                "&Löschen",            ; // 4
                                "&Suchen",             ; // 5
                                "&Drucken",            ; // 6
                                "&Abbruch",            ; // 7
                                "&Ok",                 ; // 8
                                "&Kopieren",           ; // 9
                                "&Filter aktivieren",  ; // 10
                                "&Filter deaktivieren" } // 11
                        _HMG_SYSDATA [ 129 ] := {                                         ;
                                "Keine",                                         ; // 1
                                "Datensatz",                                     ; // 2
                                "Gesamt",                                        ; // 3
                                "Aktive Sortierung",                             ; // 4
                                "Einstellungen",                                 ; // 5
                                "Neuer Datensatz",                               ; // 6
                                "Datensatz bearbeiten",                          ; // 7
                                "Datensatz auswählen",                           ; // 8
                                "Datensatz finden",                              ; // 9
                                "Druckeinstellungen",                            ; // 10
                                "Verfügbare Felder",                             ; // 11
                                "Zu druckende Felder",                           ; // 12
                                "Verfügbare Drucker",                            ; // 13
                                "Erster zu druckender Datensatz",                ; // 14
                                "Letzter zu druckender Datensatz",               ; // 15
                                "Datensatz löschen",                             ; // 16
                                "Vorschau",                                      ; // 17
                                "Übersicht",                                     ; // 18
                                "Filterbedingung: ",                             ; // 19
                                "Gefiltert: ",                                   ; // 20
                                "Filter-Einstellungen" ,                         ; // 21
                                "Datenbank-Felder" ,                             ; // 22
                                "Vergleichs-Operator",                           ; // 23
                                "Filterwert",                                    ; // 24
                                "Zu filterndes Feld auswählen",                  ; // 25
                                "Vergleichs-Operator auswählen",                 ; // 26
                                "Gleich",                                        ; // 27
                                "Ungleich",                                      ; // 28
                                "Größer als",                                    ; // 29
                                "Kleiner als",                                   ; // 30
                                "Größer oder gleich als",                        ; // 31
                                "Kleiner oder gleich als"                        } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Kein aktiver Arbeitsbereich gefunden.   "  + ABM_CRLF + "Bitte einen Arbeitsbereich auswählen vor dem Aufruf von EDIT   " + ABM_CRLF,       ; // 1
                                "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 2
                                "Eine Zahl eingeben",                                                                                                                                   ; // 3
                                "Datum auswählen",                                                                                                                                      ; // 4
                                "Für positive Auswahl einen Haken setzen",                                                                                                              ; // 5
                                "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 6
                                "Einen Datensatz wählen und mit OK bestätigen",                                                                                                         ; // 7
                                ABM_CRLF + "Sie sind im Begriff, den aktiven Datensatz zu löschen.   " + ABM_CRLF + "Sind Sie sicher?    " + ABM_CRLF,                                  ; // 8
                                ABM_CRLF + "Es ist keine Sortierung aktiv.   " + ABM_CRLF + "Bitte wählen Sie eine Sortierung   " + ABM_CRLF,                                           ; // 9
                                ABM_CRLF + "Suche nach den Feldern memo oder logisch nicht möglich.   " + ABM_CRLF,                                                                     ; // 10
                                ABM_CRLF + "Datensatz nicht gefunden   " + ABM_CRLF,                                                                                                    ; // 11
                                "Bitte ein Feld zum Hinzufügen zur Liste wählen",                                                                                                       ; // 12
                                "Bitte ein Feld zum Entfernen aus der Liste wählen ",                                                                                                   ; // 13
                                "Drucker auswählen",                                                                                                                                    ; // 14
                                "Schaltfläche  Feld hinzufügen",                                                                                                                        ; // 15
                                "Schaltfläche  Feld Entfernen",                                                                                                                         ; // 16
                                "Schaltfläche  Auswahl erster zu druckender Datensatz",                                                                                                 ; // 17
                                "Schaltfläche  Auswahl letzte zu druckender Datensatz",                                                                                                 ; // 18
                                ABM_CRLF + "Keine Felder zum Hinzufügen mehr vorhanden   " + ABM_CRLF,                                                                                  ; // 19
                                ABM_CRLF + "Bitte erst ein Feld zum Hinzufügen wählen   " + ABM_CRLF,                                                                                   ; // 20
                                ABM_CRLF + "Keine Felder zum Entfernen vorhanden   " + ABM_CRLF,                                                                                        ; // 21
                                ABM_CRLF + "Bitte ein Feld zum Entfernen wählen   " + ABM_CRLF,                                                                                         ; // 22
                                ABM_CRLF + "Kein Feld ausgewählt   " + ABM_CRLF + "Bitte die Felder für den Ausdruck auswählen   " + ABM_CRLF,                                          ; // 23
                                ABM_CRLF + "Zu viele Felder   " + ABM_CRLF + "Bitte Anzahl der Felder reduzieren   " + ABM_CRLF,                                                        ; // 24
                                ABM_CRLF + "Drucker nicht bereit   " + ABM_CRLF,                                                                                                        ; // 25
                                "Sortiert nach",                                                                                                                                        ; // 26
                                "Von Datensatz",                                                                                                                                        ; // 27
                                "Bis Datensatz",                                                                                                                                        ; // 28
                                "Ja",                                                                                                                                                   ; // 29
                                "Nein",                                                                                                                                                 ; // 30
                                "Seite:",                                                                                                                                               ; // 31
                                ABM_CRLF + "Bitte einen Drucker wählen   " + ABM_CRLF,                                                                                                  ; // 32
                                "Filtered by",                                                                                                                                          ; // 33
                                ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 34
                                ABM_CRLF + "Kann nicht nach Memo-Feldern filtern    " + ABM_CRLF,                                                                                       ; // 35
                                ABM_CRLF + "Feld zum Filtern auswählen    " + ABM_CRLF,                                                                                                 ; // 36
                                ABM_CRLF + "Einen Operator zum Filtern auswählen    " + ABM_CRLF,                                                                                       ; // 37
                                ABM_CRLF + "Bitte einen Wert für den Filter angeben    " + ABM_CRLF,                                                                                    ; // 38
                                ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 39
                                ABM_CRLF + "Filter deaktivieren?   " + ABM_CRLF,                                                                                                         ; // 40
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

	case cLang == "IT"        // Italian
	/////////////////////////////////////////////////////////////
	// ITALIAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Sei sicuro ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Chiudi la finestra'
		_hMG_SYSDATA [ 331 ] [3] := 'Chiusura non consentita'
		_hMG_SYSDATA [ 331 ] [4] := 'Il programma è già in esecuzione'
		_hMG_SYSDATA [ 331 ] [5] := 'Edita'
		_hMG_SYSDATA [ 331 ] [6] := 'Conferma'
		_hMG_SYSDATA [ 331 ] [7] := 'Annulla'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

		_HMG_SYSDATA [ 136 ]  := { "Window: " ,;
                    " non Š definita. Programma terminato" ,;
                    "Errore HMG"  ,;
                    "Controllo: " ,;
                    " Di " ,;
                    " Gi… definito. Programma Terminato" ,;
               	"Browse: Tipo non valido. Programma Terminato"  ,;
                "Browse: Modifica non possibile: il campo non Š pertinente l'area di lavoro.Programma Terminato",;
                "Record gi… utilizzato da altro utente"                 ,;     
		"Attenzione!"                                           ,;
                "Dato non valido" }
                _HMG_SYSDATA [ 137 ] := { 'Sei sicuro ?' , 'Cancella Record' }

		// EDIT 

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Cancellare il record"+CHR(13)+"Sei sicuro ?"+CHR(13)                  ,;
                 	             CHR(13)+"File indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)            ,;
                     		     CHR(13)+"Campo indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)        ,;
                     		     CHR(13)+"Ricerca impossibile per"+CHR(13)+"campi memo o logici"+CHR(13)       ,;
                     		     CHR(13)+"Record non trovato"+CHR(13)                                        ,;
                                     CHR(13)+"Troppe colonne"+CHR(13)+"Il report non può essere stampato"+CHR(13) }
		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     		     "Record totali"       ,;
                     		     "  (Aggiungi)"        ,;
                     		     "     (Nuovo)"        ,;
                     		     "Inserire il numero del record" ,;
                     		     "Ricerca"                ,;
                     		     "Testo da cercare"         ,;
                     		     "Data da cercare"         ,;
                     		     "Numero da cercare"       ,;
                      		     "Definizione del report"   ,;
                     		     "Colonne del report"      ,;
                     		     "Colonne totali"     ,;
                     		     "Record Iniziale"      ,;
                     		     "Record Finale"        ,;
                     		     "Report di "          ,;
                     		     "Data:"               ,;
                     		     "Primo Record:"     ,;
                     		     "Ultimo Record:"       ,;
                     		     "Ordinare per:"         ,;
                     		     "Sì"                 ,;
                     		     "No"                  ,;
                     		     "Pagina "               ,;
                     		     " di "                 }
		_HMG_SYSDATA [ 133 ] := { "Chiudi"    ,;
                     		     "Nuovo"      ,;
                     		     "Modifica"     ,;
                     		     "Cancella"   ,;
                     		     "Ricerca"     ,;
                     		     "Vai a"     ,;
                     		     "Report"   ,;
                     		     "Primo"    ,;
                     		     "Precedente" ,;
                     		     "Successivo"     ,;
                     		     "Ultimo"     ,;
                     		     "Salva"     ,;
                     		     "Annulla"   ,;
                     		     "Aggiungi"      ,;
                     		     "Rimuovi"   ,;
                     		     "Stampa"    ,;
                     		     "Chiudi"     }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, il nome dell'area è mancante"                              ,;
                       		     "EDIT, quest'area contiene più di 16 campi"              ,;
                     		     "EDIT, modalità aggiornamento fuori dal limite (segnalare l'errore)"      ,;
                     		     "EDIT, evento pricipale fuori dal limite (segnalare l'errore)" ,;
                     		     "EDIT, lista eventi fuori dal limite (segnalare l'errore)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {           ;
                                "&Chiudi",          ; // 1
                                "&Nuovo",           ; // 2
                                "&Modifica",        ; // 3
                                "&Cancella",        ; // 4
                                "&Trova",           ; // 5
                                "&Stampa",          ; // 6
                                "&Annulla",         ; // 7
                                "&Ok",              ; // 8
                                "C&opia",           ; // 9
                                "A&ttiva Filtro",   ; // 10
                                "&Disattiva Filtro" } // 11
                        _HMG_SYSDATA [ 129 ] := {                            ;
                                "Nessuno",                          ; // 1
                                "Record",                           ; // 2
                                "Totale",                           ; // 3
                                "Ordinamento attivo",               ; // 4
                                "Opzioni",                          ; // 5
                                "Nuovo record",                     ; // 6
                                "Modifica record",                  ; // 7
                                "Seleziona record",                 ; // 8
                                "Trova record",                     ; // 9
                                "Stampa opzioni",                   ; // 10
                                "Campi disponibili",                ; // 11
                                "Campi da stampare",                ; // 12
                                "Stampanti disponibili",            ; // 13
                                "Primo  record da stampare",        ; // 14
                                "Ultimo record da stampare",        ; // 15
                                "Cancella record",                  ; // 16
                                "Anteprima",                        ; // 17
                                "Visualizza pagina miniature",      ; // 18
                                "Condizioni Filtro: ",              ; // 19
                                "Filtrato: ",                       ; // 20
                                "Opzioni Filtro" ,                  ; // 21
                                "Campi del Database" ,              ; // 22
                                "Operatori di comparazione",        ; // 23
                                "Valore Filtro",                    ; // 24
                                "Seleziona campo da filtrare",      ; // 25
                                "Seleziona operatore comparazione", ; // 26
                                "Uguale",                           ; // 27
                                "Non Uguale",                       ; // 28
                                "Maggiore di",                      ; // 29
                                "Minore di",                        ; // 30
                                "Maggiore o uguale a",              ; // 31
                                "Minore o uguale a"                 } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Nessuna area attiva.   "  + ABM_CRLF + "Selezionare un'area prima della chiamata a EDIT   " + ABM_CRLF,  ; // 1
                                "Digitare valore campo (testo)",                                                                                     ; // 2
                                "Digitare valore campo (numerico)",                                                                                  ; // 3
                                "Selezionare data",                                                                                                  ; // 4
                                "Attivare per valore TRUE",                                                                                          ; // 5
                                "Inserire valore campo",                                                                                             ; // 6
                                "Seleziona un record and premi OK",                                                                                  ; // 7
                                ABM_CRLF + "Cancellazione record attivo   " + ABM_CRLF + "Sei sicuro?      " + ABM_CRLF,                             ; // 8
                                ABM_CRLF + "Nessun ordinamento attivo     " + ABM_CRLF + "Selezionarne uno " + ABM_CRLF,                             ; // 9
                                ABM_CRLF + "Ricerca non possibile su campi MEMO o LOGICI   " + ABM_CRLF,                                             ; // 10
                                ABM_CRLF + "Record non trovato   " + ABM_CRLF,                                                                       ; // 11
                                "Seleziona campo da includere nel listato",                                                                          ; // 12
                                "Seleziona campo da escludere dal listato",                                                                          ; // 13
                                "Selezionare la stampante",                                                                                          ; // 14
                                "Premi per includere il campo",                                                                                      ; // 15
                                "Premi per escludere il campo",                                                                                      ; // 16
                                "Premi per selezionare il primo record da stampare",                                                                 ; // 17
                                "Premi per selezionare l'ultimo record da stampare",                                                                 ; // 18
                                ABM_CRLF + "Nessun altro campo da inserire   " + ABM_CRLF,                                                           ; // 19
                                ABM_CRLF + "Prima seleziona il campo da includere " + ABM_CRLF,                                                      ; // 20
                                ABM_CRLF + "Nessun altro campo da escludere       " + ABM_CRLF,                                                      ; // 21
                                ABM_CRLF + "Prima seleziona il campo da escludere " + ABM_CRLF,                                                      ; // 22
                                ABM_CRLF + "Nessun campo selezionato     " + ABM_CRLF + "Selezionare campi da includere nel listato   " + ABM_CRLF,  ; // 23
                                ABM_CRLF + "Troppi campi !   " + ABM_CRLF + "Redurre il numero di campi   " + ABM_CRLF,                              ; // 24
                                ABM_CRLF + "Stampante non pronta..!   " + ABM_CRLF,                                                                  ; // 25
                                "Ordinato per",                                                                                                      ; // 26
                                "Dal record",                                                                                                        ; // 27
                                "Al  record",                                                                                                        ; // 28
                                "Si",                                                                                                                ; // 29
                                "No",                                                                                                                ; // 30
                                "Pagina:",                                                                                                           ; // 31
                                ABM_CRLF + "Selezionare una stampante   " + ABM_CRLF,                                                                ; // 32
                                "Filtrato per ",                                                                                                     ; // 33
                                ABM_CRLF + "Esiste un filtro attivo     " + ABM_CRLF,                                                                ; // 34
                                ABM_CRLF + "Filtro non previsto per campi MEMO   " + ABM_CRLF,                                                       ; // 35
                                ABM_CRLF + "Selezionare campo da filtrare        " + ABM_CRLF,                                                       ; // 36
                                ABM_CRLF + "Selezionare un OPERATORE per filtro  " + ABM_CRLF,                                                       ; // 37
                                ABM_CRLF + "Digitare un valore per filtro        " + ABM_CRLF,                                                       ; // 38
                                ABM_CRLF + "Nessun filtro attivo    " + ABM_CRLF,                                                                    ; // 39
                                ABM_CRLF + "Disattivare filtro ?   " + ABM_CRLF,                                                                     ; // 40
                                ABM_CRLF + "Record bloccato da altro utente" + ABM_CRLF                                                              } // 41

        // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish 
        case cLang == "PL"
	/////////////////////////////////////////////////////////////
	// POLISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Czy jesteœ pewny ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zamknij okno'
		_hMG_SYSDATA [ 331 ] [3] := 'Zamkniêcie niedozwolone'
		_hMG_SYSDATA [ 331 ] [4] := 'Program ju¿ uruchomiony'
		_hMG_SYSDATA [ 331 ] [5] := 'Edycja'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Porzuæ'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Okno: "                                              ,;
                                     " nie zdefiniowane.Program zakoñczony"         ,;
                                     "B³¹d HMG"                                         ,;
                                     "Kontrolka: "                                             ,;
                                     " z "                                                  ,;
				     " ju¿ zdefiniowana. Program zakoñczony"                  ,;
				     "Browse: Niedozwolony typ danych. Program zakoñczony"          ,;
				     "Browse: Klauzula Append nie mo¿e byæ stosowana do pól nie nale¿¹cych do aktualnego obszaru roboczego. Program zakoñczony",;
				     "Rekord edytowany przez innego u¿ytkownika"                ,;
				     "Ostrze¿enie"                                               ,;
				     "Nieprawid³owy wpis"                                          }
                _HMG_SYSDATA [ 137 ] := { 'Czy jesteo pewny ?' , 'Skasuj rekord' }  

		// EDIT

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Usuni©cie rekordu"+CHR(13)+"Jeste˜ pewny ?"+CHR(13)                 ,;
                                     CHR(13)+"Bˆ©dny zbi¢r Indeksowy"+CHR(13)+"Nie mo¾na szuka†"+CHR(13)         ,;
                                     CHR(13)+"Nie mo¾na znale˜† pola indeksu"+CHR(13)+"Nie mo¾na szuka†"+CHR(13) ,;
                                     CHR(13)+"Nie mo¾na szukaæ wg"+CHR(13)+"pola memo lub logicznego"+CHR(13)         ,;
                                     CHR(13)+"Rekordu nie znaleziono"+CHR(13)                                                     ,;
                                     CHR(13)+"Zbyt wiele kolumn"+CHR(13)+"Raport nie mo¾e zmie˜ci† si© na arkuszu"+CHR(13)      }
                _HMG_SYSDATA [ 132 ]  := { "Rekord"              ,;
                                     "Liczba rekord¢w"        ,;
                                     "      (Nowy)"        ,;
                                     "    (Edycja)"        ,;
                                     "Wprowad« numer rekordu" ,;
                                     "Szukaj"                ,;
                                     "Szukaj tekstu"         ,;
                                     "Szukaj daty"         ,;
                                     "Szukaj liczby"       ,;
                                     "Definicja Raportu"   ,;
                                     "Kolumny Raportu"      ,;
                                     "Dost©pne kolumny"     ,;
                                     "Pocz¥tkowy rekord"      ,;
                                     "Koäcowy rekord"        ,;
                                     "Raport z "          ,;
                                     "Data:"               ,;
                                     "Pocz¥tkowy rekord:"     ,;
                                     "Koäcowy rekord:"       ,;
                                     "Sortowanie wg:"         ,;
                                     "Tak"                 ,;
                                     "Nie"                  ,;
                                     "Strona "               ,;
                                     " z "                 }
                _HMG_SYSDATA [ 133 ] := { "Zamknij"    ,;
                                     "Nowy"      ,;
                                     "Edytuj"     ,;
                                     "Usuä"   ,;
                                     "Znajd«"     ,;
                                     "IdŸ do"     ,;
                                     "Raport"   ,;
                                     "Pierwszy"    ,;
                                     "Poprzedni" ,;
                                     "Nast©pny"     ,;
                                     "Ostatni"     ,;
                                     "Zapisz"     ,;
                                     "Rezygnuj"   ,;
                                     "Dodaj"      ,;
                                     "Usuä"   ,;
                                     "Drukuj"    ,;
                                     "Zamknij"     }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, bˆ©dna nazwa bazy"                                  ,;
                                     "EDIT, baza ma wi©cej ni¾ 16 p¢l"                   ,;
                                     "EDIT, tryb od˜wierzania poza zakresem (zobacz raport bˆ©d¢w)"      ,;
                                     "EDIT, liczba zdarzä podstawowych poza zakresem (zobacz raport bˆ©d¢w)" ,;
                                     "EDIT, lista zdarzeä poza zakresem (zobacz raport bˆ©d¢w)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {          ;
                                "&Zamknij",        ; // 1
                                "&Nowy",           ; // 2
                                "&Modyfikuj",      ; // 3
                                "&Kasuj",          ; // 4
                                "&ZnajdŸ",         ; // 5
                                "&Drukuj",         ; // 6
                                "&Porzuæ",         ; // 7
                                "&Ok",             ; // 8
                                "&Kopiuj",         ; // 9
                                "&Aktywuj Filtr",  ; // 10
                                "&Deaktywuj Filtr" } // 11
                        _HMG_SYSDATA [ 129 ] := {                       ;
                                "Brak",                        ; // 1
                                "Rekord",                      ; // 2
                                "Suma",                        ; // 3
                                "Aktywny indeks",              ; // 4
                                "Opcje",                       ; // 5
                                "Nowy rekord",                 ; // 6
                                "Modyfikuj rekord",            ; // 7
                                "Wybierz rekord",              ; // 8
                                "ZnajdŸ rekord",               ; // 9
                                "Opcje druku",                 ; // 10
                                "Dostêpne pola",               ; // 11
                                "Pola do druku",               ; // 12
                                "Dostêpne drukarki",           ; // 13
                                "Pierwszy rekord do druku",    ; // 14
                                "Ostatni rekord do druku",     ; // 15
                                "Skasuj rekord",               ; // 16
                                "Podgl¹d",                     ; // 17
                                "Poka¿ miniatury",             ; // 18
                                "Stan filtru: ",               ; // 19
                                "Filtrowane: ",                ; // 20
                                "Opcje filtrowania" ,          ; // 21
                                "Pola bazy danych" ,           ; // 22
                                "Operator porównania",         ; // 23
                                "Wartoœæ filtru",              ; // 24
                                "Wybierz pola do filtru",      ; // 25
                                "Wybierz operator porównania", ; // 26
                                "Równa siê",                   ; // 27
                                "Nie równa siê",               ; // 28
                                "Wiêkszy ",                    ; // 29
                                "Mniejszy ",                   ; // 30
                                "Wiêkszy lub równy ",          ; // 31
                                "Mniejszy lub równy"           } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Aktywny obszar nie odnaleziony   "  + ABM_CRLF + "Wybierz obszar przed wywo³aniem EDIT   " + ABM_CRLF,   ; // 1
                                "Poszukiwany ci¹g znaków (dowolny tekst)",                                                                           ; // 2
                                "Poszukiwana wartoœæ (dowolna liczba)",                                                                              ; // 3
                                "Wybierz datê",                                                                                                      ; // 4
                                "Check for true value",                                                                                              ; // 5
                                "Wprowaæ wartoœæ",                                                                                                   ; // 6
                                "Wybierz dowolny rekord i naciœcij OK",                                                                              ; // 7
                                ABM_CRLF + "Wybra³eœ opcjê kasowania rekordu   " + ABM_CRLF + "Czy jesteœ pewien?    " + ABM_CRLF,                   ; // 8
                                ABM_CRLF + "Brak aktywnych indeksów   " + ABM_CRLF + "Wybierz    " + ABM_CRLF,                                       ; // 9
                                ABM_CRLF + "Nie mo¿na szukaæ w polach typu MEMO lub LOGIC   " + ABM_CRLF,                                            ; // 10
                                ABM_CRLF + "Rekord nie znaleziony   " + ABM_CRLF,                                                                    ; // 11
                                "Wybierz rekord który nale¿y dodaæ do listy",                                                                        ; // 12
                                "Wybierz rekord który nale¿y wy³¹czyæ z listy",                                                                      ; // 13
                                "Wybierz drukarkê",                                                                                                  ; // 14
                                "Kliknij na przycisk by dodaæ pole",                                                                                 ; // 15
                                "Kliknij na przycisk by odj¹æ pole",                                                                                 ; // 16
                                "Kliknij, aby wybraæ pierwszy rekord do druku",                                                                      ; // 17
                                "Kliknij, aby wybraæ ostatni rekord do druku",                                                                       ; // 18
                                ABM_CRLF + "Brak pól do w³¹czenia   " + ABM_CRLF,                                                                    ; // 19
                                ABM_CRLF + "Najpierw wybierz pola do w³¹czenia   " + ABM_CRLF,                                                       ; // 20
                                ABM_CRLF + "Brak pól do wy³¹czenia   " + ABM_CRLF,                                                                   ; // 21
                                ABM_CRLF + "Najpierw wybierz pola do wy³¹czenia   " + ABM_CRLF,                                                      ; // 22
                                ABM_CRLF + "Nie wybra³eœ ¿adnych pól   " + ABM_CRLF + "Najpierw wybierz pola do w³¹czenia do wydruku   " + ABM_CRLF, ; // 23
                                ABM_CRLF + "Za wiele pól   " + ABM_CRLF + "Zredukuj liczbê pól   " + ABM_CRLF,                                       ; // 24
                                ABM_CRLF + "Drukarka nie gotowa   " + ABM_CRLF,                                                                      ; // 25
                                "Porz¹dek wg",                                                                                                       ; // 26
                                "Od rekordu",                                                                                                        ; // 27
                                "Do rekordu",                                                                                                        ; // 28
                                "Tak",                                                                                                               ; // 29
                                "Nie",                                                                                                               ; // 30
                                "Strona:",                                                                                                           ; // 31
                                ABM_CRLF + "Wybierz drukarkê   " + ABM_CRLF,                                                                         ; // 32
                                "Filtrowanie wg",                                                                                                    ; // 33
                                ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 34
                                ABM_CRLF + "Nie mo¿na filtrowaæ wg. pól typu MEMO    " + ABM_CRLF,                                                   ; // 35
                                ABM_CRLF + "Wybierz pola dla filtru    " + ABM_CRLF,                                                                 ; // 36
                                ABM_CRLF + "Wybierz operator porównania dla filtru    " + ABM_CRLF,                                                  ; // 37
                                ABM_CRLF + "Wpisz dowoln¹ wartoœæ dla filtru    " + ABM_CRLF,                                                        ; // 38
                                ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 39
                                ABM_CRLF + "Deaktywowaæ filtr?   " + ABM_CRLF,                                                                        ;
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

        // case cLang == "pt.PT850"        // Portuguese
        case cLang == "PT"
	/////////////////////////////////////////////////////////////
	// PORTUGUESE
	////////////////////////////////////////////////////////////

// MISC MESSAGES

_hMG_SYSDATA [ 331 ] [1] := 'Você tem Certeza ?'
_hMG_SYSDATA [ 331 ] [2] := 'Fechar Janela'
_hMG_SYSDATA [ 331 ] [3] := 'Fechamento não permitido'
_hMG_SYSDATA [ 331 ] [4] := 'O programa já está em execução'
_hMG_SYSDATA [ 331 ] [5] := 'Edita'
_hMG_SYSDATA [ 331 ] [6] := 'Ok'
_hMG_SYSDATA [ 331 ] [7] := 'Cancela'
_hMG_SYSDATA [ 331 ] [8] := 'Pág.'	


// BROWSE

_HMG_SYSDATA [ 136 ]:= {"Window: ",											;
               		" Erro não definido. O programa será fechado",							;
               		"Erro na HMG.lib",										;
               		"Control: ",											;
               		" Of ",												;
               		" Não pronto. O programa será fechado",								;
               		"Browse: Tipo Inválido !!!. O programa será fechado",						;
               		"Browse: A edição não é possível, o campo não pertence a essa área. O programa será fechado",	;
              		"O arquivo está em uso e não pode ser editado !!!",						;
      		 	"Aguarde...",											;
            		"Dado Inválido"											}
_HMG_SYSDATA [ 137 ] := { 'Você tem Certeza ?' , 'Apagar Registro' }




// EDIT

_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Excluir o registro atual"+CHR(13)+"Tem certeza?"+CHR(13),					;
	                    CHR(13)+"Não existe nenhum índice ativo"+CHR(13)+"Não é possível realizar a busca"+CHR(13),		;
        	            CHR(13)+"Não foi encontrado o campo índice"+CHR(13)+"Não é possível realizar a busca"+CHR(13),	;
                	    CHR(13)+"Não é possível realizar busca"+CHR(13)+"por campos Memo ou Lógicos"+CHR(13),		;
                            CHR(13)+"Registro não encontrado"+CHR(13),								;
                            CHR(13)+"Incluídas colunas em excesso"+CHR(13)+"A listagem completa não caberá na tela"+CHR(13)     }

_HMG_SYSDATA [ 132 ]  := { "Registro Atual",				;
                           "Total de Registros",			;
                           "      (Novo)",				;
                           "    (Editar)",				;
                           "Introduza o número do registro",		;
                           "Buscar",					;
                           "Texto à buscar",				;
                           "Data à buscar",				;
                           "Número à buscar",				;
                           "Definicão da lista",			;
                           "Colunas da lista",				;
                           "Colunas disponíveis",			;
                           "Registro inicial",				;
                           "Registro final",				;
                           "Lista de ",					;
                           "Data:",					;
                           "Primeiro registro:",			;
                           "Último registro:",				;
                           "Ordenado por:",				;
                           "Sim",					;
                           "Não",					;
                           "Página ",					;
                           " de "					}

_HMG_SYSDATA [ 133 ] := { "Fechar",					;
                           "Novo",					;
                           "Alterar",					;
                           "Excluir",					;
                           "Buscar",					;
                           "Ir ao registro",				;
                           "Listar",					;
                           "Primeiro",					;
                           "Anterior",					;
                           "Seguinte",					;
                           "Último",					;
                           "Salvar",					;
                           "Cancelar",					;
                           "Juntar",					;
                           "Sair",					;
                           "Imprimir",					;
                           "Fechar"					}
     
_HMG_SYSDATA [ 134 ]  := { "EDIT, Nenhuma Área foi especificada",					;
                           "EDIT, A Área selecionada possui mais de 16 campos",				;
                           "EDIT, Atualização está fora do limite (Favor comunicar este erro)",		;
                           "EDIT, Evento principal está fora do limite (Favor comunicar este erro)",	;
                           "EDIT, Evento mostrado está fora do limite (Favor comunicar este erro)"	}



// EDIT EXTENDED

_HMG_SYSDATA [ 128 ] :={"&Sair", 		; // 1
        	      	"&Novo",		; // 2
	              	"&Alterar",		; // 3
        	      	"&Excluir",		; // 4
	              	"&Localizar",		; // 5
        	      	"&Imprimir",		; // 6
	              	"&Cancelar",		; // 7
        	      	"&Aceitar",		; // 8
	              	"&Copiar",		; // 9
        	      	"&Ativar Filtro",	; // 10
	              	"&Desativar Filtro"	} // 11

_HMG_SYSDATA [ 129 ] :={"Nenhum",					; // 1
              		"Registro",					; // 2
              		"Total",					; // 3
              		"Índice ativo",					; // 4
              		"Opção",					; // 5
              		"Novo registro",				; // 6
             		"Modificar registro",				; // 7
              		"Selecionar registro",				; // 8
              		"Localizar registro",				; // 9
              		"Opção de impressão",				; // 10
              		"Campos disponíveis",				; // 11
              		"Campos selecionados",				; // 12
              		"Impressoras disponíveis",			; // 13
              		"Primeiro registro a imprimir",			; // 14
              		"Último registro a imprimir",			; // 15
              		"Apagar registro",				; // 16
              		"Visualizar impressão",				; // 17
              		"Miniaturas das páginas",			; // 18
              		"Condição do filtro: ",				; // 19
              		"Filtrado: ",					; // 20
              		"Opções do filtro" ,				; // 21
              		"Campos do BDD" ,				; // 22
              		"Operador de comparação",			; // 23
              		"Argumento de comparação",			; // 24
              		"Selecione o campo à filtrar",			; // 25
              		"Selecione o operador de comparação",		; // 26
              		"Igual",					; // 27
              		"Diferente",					; // 28
              		"Maior que",					; // 29
              		"Menor que",					; // 30
              		"Maior ou igual que",				; // 31
              		"Menor ou igual que"				} // 32

_HMG_SYSDATA [ 130 ] := { ABM_CRLF + "Não há uma área ativa   "  + ABM_CRLF + 								;
				"Por favor selecione uma área antes de executar o EDIT EXTENDED   " + ABM_CRLF,				; // 1
              		"Introduza o valor do campo (texto)",										; // 2
              		"Introduza o valor do campo (numérico)",									; // 3
              		"Selecione a data",												; // 4
              		"Ative o indicar para valor verdadero",										; // 5
              		"Introduza o valor do campo",											; // 6
              		"Selecione um registro e tecle Ok",										; // 7
              		ABM_CRLF + "Confirma exclusão do registro selecionado ??   " + ABM_CRLF + "Tem certeza?    " + ABM_CRLF,	; // 8
              		ABM_CRLF + "Não ha um índice seleccionado    " + ABM_CRLF + "Por favor selecione um   " + ABM_CRLF,		; // 9
              		ABM_CRLF + "Não é possível excutar buscas em campos tipo Memo ou Lógico   " + ABM_CRLF,				; // 10
              		ABM_CRLF + "Registro não encontrado   " + ABM_CRLF,								; // 11
              		"Selecione o campo a incluir na lista",										; // 12
              		"Selecione o campo a excluir da lista",										; // 13
              		"Selecione a Impressora",											; // 14
              		"Pressione o botão para incluir o campo",									; // 15
              		"Pressione o botão para excluir o campo",									; // 16
              		"Pressione o botão para selecionar o primeiro registro a imprimir",						; // 17
              		"Pressione o botão para selecionar o último registro a imprimir",						; // 18
              		ABM_CRLF + "Foram incluídos todos os campos   " + ABM_CRLF,							; // 19
              		ABM_CRLF + "Primeiro seleccione o campo a incluir   " + ABM_CRLF,						; // 20
              		ABM_CRLF + "Não ha campos para excluir   " + ABM_CRLF,								; // 21
              		ABM_CRLF + "Primeiro selecione o campo a excluir   " + ABM_CRLF,						; // 22
              		ABM_CRLF + "Não há mais campos selecionáveis   " + ABM_CRLF,							; // 23
              		ABM_CRLF + "A lista não cabe na página   " + ABM_CRLF + "Reduza o número de campos   " + ABM_CRLF,		; // 24
              		ABM_CRLF + "A impressora não está disponível   " + ABM_CRLF,							; // 25
              		"Ordenado por",													; // 26
              		"Do registro",													; // 27
              		"Até o registro",												; // 28
              		"Sim",														; // 29
              		"Não",														; // 30
              		"Página:",													; // 31
              		ABM_CRLF + "Por favor selecione uma impressora   " + ABM_CRLF,							; // 32
              		"Filtrado por",													; // 33
              		ABM_CRLF + "Não há nenhum filtro ativo    " + ABM_CRLF,								; // 34
              		ABM_CRLF + "Não é possível filtrar por campos Memo    " + ABM_CRLF,						; // 35
              		ABM_CRLF + "Selecione o campo a filtrar    " + ABM_CRLF,							; // 36
              		ABM_CRLF + "Selecione o operador de comparação    " + ABM_CRLF,							; // 37
              		ABM_CRLF + "Introduza o valor do filtro    " + ABM_CRLF,							; // 38
              		ABM_CRLF + "Não ha nenhum filtro ativo    " + ABM_CRLF,								; // 39
              		ABM_CRLF + "Limpar o filtro ativo?   " + ABM_CRLF,								; // 40
  			ABM_CRLF + "Registro está bloqueado por outro usuário" + ABM_CRLF						} // 41


        // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
        case cLang == "RU"
	/////////////////////////////////////////////////////////////
	// RUSSIAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Âû óâåðåíû ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Çàêðûòü îêíî'
		_hMG_SYSDATA [ 331 ] [3] := 'Çàêðûòèå íå äîñòóïíî'
		_hMG_SYSDATA [ 331 ] [4] := 'Ïðîãðàììà óæå çàïóùåíà'
		_hMG_SYSDATA [ 331 ] [5] := 'Èçìåíèòü'
		_hMG_SYSDATA [ 331 ] [6] := 'Äà'
		_hMG_SYSDATA [ 331 ] [7] := 'Îòìåíà'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Îêíî: "                                              ,;
                                     " íå îïðåäåëåíî. Ïðîãðàììà ïðåðâàíà"                 ,;
                                     "HMG Îøèáêà"                                     ,;
                                     "Ýëåìåíò óïðàâëåíè: "                               ,;
                                     " èç "                                               ,;
				     " Óæå îïðåäåëåí. Ïðîãðàììà ïðåðâàíà"                         ,;
				     "Browse: Òàêîé òèï íå ïîääåðæèâàåòñ. Ïðîãðàììà ïðåðâàíà"    ,;
				     "Browse: Append êëàññ íå ìîæåò áûòü èñïîëüçîâàí ñ ïîëìè èç äðóãîé ðàáî÷åé îáëàñòè. Ïðîãðàììà ïðåðâàíà",;
				     "Çàïèñü ñåé÷àñ ðåäàêòèðóåòñ äðóãèì ïîëüçîâàòåëåì"           ,;
				     "Ïðåäóïðåæäåíèå"                                             ,;
				     "Ââåäåíû íåïðàâèëüíûå äàííûå"                                 }
                _HMG_SYSDATA [ 137 ] := { 'Âû óâåðåíû ?' , 'Óäàëèòü çàïèñü' }

		// EDIT

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Óäàëåíèå çàïèñè."+CHR(13)+"Âû óâåðåíû ?"+CHR(13)                  ,;
                                     CHR(13)+"Îòñóòñòâóåò èíäåêñíûé ôàéë"+CHR(13)+"Ïîèñê íåâîçìîæåí"+CHR(13)   ,;
                                     CHR(13)+"Îòñóòñòâóåò èíäåêñíîå ïîëå"+CHR(13)+"Ïîèñê íåâîçìîæåí"+CHR(13)   ,;
                                     CHR(13)+"Ïîèñê íåâîçìîæåí ïî"+CHR(13)+"ìåìî èëè ëîãè÷åñêèì ïîëÿì"+CHR(13) ,;
                                     CHR(13)+"Çàïèñü íå íàéäåíà"+CHR(13)                                       ,;
                                     CHR(13)+"Ñëèøêîì ìíîãî êîëîíîê"+CHR(13)+"Îò÷åò íå ïîìåñòèòñÿ íà ëèñòå"+CHR(13) }
                _HMG_SYSDATA [ 132 ]  := { "Çàïèñü"              ,;
                                     "Âñåãî çàïèñåé"       ,;
                                     "     (Íîâàÿ)"        ,;
                                     "  (Èçìåíèòü)"        ,;
                                     "Ââåäèòå íîìåð çàïèñè",;
                                     "Ïîèñê"               ,;
                                     "Íàéòè òåêñò"         ,;
                                     "Íàéòè äàòó"          ,;
                                     "Íàéòè ÷èñëî"         ,;
                                     "Íàñòðîéêà îò÷åòà"    ,;
                                     "Êîëîíêè îò÷åòà"      ,;
                                     "Äîñòóïíûå êîëîíêè"   ,;
                                     "Íà÷àëüíàÿ çàïèñü"    ,;
                                     "Êîíå÷íàÿ çàïèñü"     ,;
                                     "Îò÷åò äëÿ "          ,;
                                     "Äàòà:"               ,;
                                     "Ïåðâàÿ çàïèñü:"      ,;
                                     "Êîíå÷íàÿ çàïèñü:"    ,;
                                     "Ãðóïïèðîâêà ïî:"     ,;
                                     "Äà"                  ,;
                                     "Íåò"                 ,;
                                     "Ñòðàíèöà "           ,;
                                     " èç "                 }
                _HMG_SYSDATA [ 133 ] := { "Çàêðûòü"   ,;
                                     "Íîâàÿ"     ,;
                                     "Èçìåíèòü"  ,;
                                     "Óäàëèòü"   ,;
                                     "Ïîèñê"     ,;
                                     "Ïåðåéòè"   ,;
                                     "Îò÷åò"     ,;
                                     "Ïåðâàÿ"    ,;
                                     "Íàçàä"     ,;
                                     "Âïåðåä"    ,;
                                     "Ïîñëåäíÿÿ" ,;
                                     "Ñîõðàíèòü" ,;
                                     "Îòìåíà"    ,;
                                     "Äîáàâèòü"  ,;
                                     "Óäàëèòü"   ,;
                                     "Ïå÷àòü"    ,;
                                     "Çàêðûòü"    }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, íå óêàçàíî èìÿ ðàáî÷åé îáëàñòè"                     ,;
                                     "EDIT, äîïóñêàåòñÿ òîëüêî äî 16 ïîëåé"                     ,;
                                     "EDIT, ðåæèì îáíîâëåíèÿ âíå äèàïàçîíà (ñîîáùèòå îá îøèáêå)",;
                                     "EDIT, íîìåð ñîáûòèÿ âíå äèàïàçîíà (ñîîáùèòå îá îøèáêå)"   ,;
                                     "EDIT, íîìåð ñîáûòèÿ ëèñòèíãà âíå äèàïàçîíà (ñîîáùèòå îá îøèáêå)" }

		// EDIT EXTENDED

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

        // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
        case cLang == "ES"
	/////////////////////////////////////////////////////////////
	// SPANISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Está seguro ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Cerrar Ventana'
		_hMG_SYSDATA [ 331 ] [3] := 'Operación no permitida'
		_hMG_SYSDATA [ 331 ] [4] := 'EL programa ya está ejecutándose'
		_hMG_SYSDATA [ 331 ] [5] := 'Editar'
		_hMG_SYSDATA [ 331 ] [6] := 'Aceptar'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancelar'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE		

                _HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " no está definida. Ejecución terminada"                ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " De "                                                  ,;
				     " ya definido. Ejecución terminada"                     ,;
				     "Browse: Tipo no permitido. Ejecución terminada"        ,;
				     "Browse: La calusula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. Ejecución terminada",;
				     "El registro está siendo editado por otro usuario"      ,;
				     "Peligro"                                               ,;
				     "Entrada no válida"                                      }
                _HMG_SYSDATA [ 137 ] := { 'Está Seguro ?' , 'Eliminar Registro' }

		// EDIT 

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Va a eliminar el registro actual"+CHR(13)+"¿ Está seguro ?"+CHR(13)                 ,;
                                     CHR(13)+"No hay un indice activo"+CHR(13)+"No se puede realizar la busqueda"+CHR(13)         ,;
                                     CHR(13)+"No se encuentra el campo indice"+CHR(13)+"No se puede realizar la busqueda"+CHR(13) ,;
                                     CHR(13)+"No se pueden realizar busquedas"+CHR(13)+"por campos memo o lógico"+CHR(13)         ,;
                                     CHR(13)+"Registro no encontrado"+CHR(13)                                                     ,;
                                     CHR(13)+"Ha inclido demasiadas columnas"+CHR(13)+"El listado no cabe en la hoja"+CHR(13)      }
                _HMG_SYSDATA [ 132 ]  := { "Registro Actual"                  ,;
                                     "Registros Totales"                ,;
                                     "     (Nuevo)"                     ,;
                                     "    (Editar)"                     ,;
                                     "Introducca el número de registro" ,;
                                     "Buscar"                           ,;
                                     "Texto a buscar"                   ,;
                                     "Fecha a buscar"                   ,;
                                     "Número a buscar"                  ,;
                                     "Definición del listado"           ,;
                                     "Columnas del listado"             ,;
                                     "Columnas disponibles"             ,;
                                     "Registro inicial"                 ,;
                                     "Registro final"                   ,;
                                     "Listado de "                      ,;
                                     "Fecha:"                           ,;
                                     "Primer registro:"                 ,;
                                     "Ultimo registro:"                 ,;
                                     "Ordenado por:"                    ,;
                                     "Si"                               ,;
                                     "No"                               ,;
                                     "Pagina "                          ,;
                                     " de "                              }
                _HMG_SYSDATA [ 133 ] := { "Cerrar"           ,;
                                     "Nuevo"            ,;
                                     "Modificar"        ,;
                                     "Eliminar"         ,;
                                     "Buscar"           ,;
                                     "Ir al registro"   ,;
                                     "Listado"          ,;
                                     "Primero"          ,;
                                     "Anterior"         ,;
                                     "Siguiente"        ,;
                                     "Ultimo"           ,;
                                     "Guardar"          ,;
                                     "Cancelar"         ,;
                                     "Añadir"           ,;
                                     "Quitar"           ,;
                                     "Imprimir"         ,;
                                     "Cerrar"            }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, No se ha especificado el area"                                  ,;
                                     "EDIT, El area contiene más de 16 campos"                              ,;
                                     "EDIT, Refesco fuera de rango (por favor comunique el error)"          ,;
                                     "EDIT, Evento principal fuera de rango (por favor comunique el error)" ,;
                                     "EDIT, Evento listado fuera de rango (por favor comunique el error)"    }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {            ;
                                "&Cerrar",           ; // 1
                                "&Nuevo",            ; // 2
                                "&Modificar",        ; // 3
                                "&Eliminar",         ; // 4
                                "&Buscar",           ; // 5
                                "&Imprimir",         ; // 6
                                "&Cancelar",         ; // 7
                                "&Aceptar",          ; // 8
                                "&Copiar",           ; // 9
                                "&Activar Filtro",   ; // 10
                                "&Desactivar Filtro" } // 11
                        _HMG_SYSDATA [ 129 ] := {                                 ;
                                "Ninguno",                               ; // 1
                                "Registro",                              ; // 2
                                "Total",                                 ; // 3
                                "Indice activo",                         ; // 4
                                "Opciones",                              ; // 5
                                "Nuevo registro",                        ; // 6
                                "Modificar registro",                    ; // 7
                                "Seleccionar registro",                  ; // 8
                                "Buscar registro",                       ; // 9
                                "Opciones de impresión",                 ; // 10
                                "Campos disponibles",                    ; // 11
                                "Campos del listado",                    ; // 12
                                "Impresoras disponibles",                ; // 13
                                "Primer registro a imprimir",            ; // 14
                                "Ultimo registro a imprimir",            ; // 15
                                "Borrar registro",                       ; // 16
                                "Vista previa",                          ; // 17
                                "Páginas en miniatura",                  ; // 18
                                "Condición del filtro: ",                ; // 19
                                "Filtrado: ",                            ; // 20
                                "Opciones de filtrado" ,                 ; // 21
                                "Campos de la bdd" ,                     ; // 22
                                "Operador de comparación",               ; // 23
                                "Valor de comparación",                  ; // 24
                                "Seleccione el campo a filtrar",         ; // 25
                                "Seleccione el operador de comparación", ; // 26
                                "Igual",                                 ; // 27
                                "Distinto",                              ; // 28
                                "Mayor que",                             ; // 29
                                "Menor que",                             ; // 30
                                "Mayor o igual que",                     ; // 31
                                "Menor o igual que"                      } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "No hay un area activa   "  + ABM_CRLF + "Por favor seleccione un area antes de llamar a EDIT EXTENDED   " + ABM_CRLF,       ; // 1
                                "Introduzca el valor del campo (texto)",                                                                                      ; // 2
                                "Introduzca el valor del campo (numérico)",                                                                                    ; // 3
                                "Seleccione la fecha",                                                                                                      ; // 4
                                "Active la casilla para indicar un valor verdadero",                                                                                                 ; // 5
                                "Introduzca el valor del campo",                                                                                                ; // 6
                                "Seleccione un registro y pulse aceptar",                                                                                       ; // 7
                                ABM_CRLF + "Se dispone a borrar el registro activo   " + ABM_CRLF + "¿Esta seguro?    " + ABM_CRLF,                  ; // 8
                                ABM_CRLF + "No se ha seleccionado un indice   " + ABM_CRLF + "Por favor seleccione uno   " + ABM_CRLF,                            ; // 9
                                ABM_CRLF + "No se pueden realizar busquedad por campos tipo memo o lógico   " + ABM_CRLF,                                                   ; // 10
                                ABM_CRLF + "Registro no encontrado   " + ABM_CRLF,                                                                            ; // 11
                                "Seleccione el campo a incluir en el listado",                                                                                  ; // 12
                                "Seleccione el campo a excluir del listado",                                                                                ; // 13
                                "Seleccione la impresora",                                                                                                   ; // 14
                                "Pulse el botón para incluir el campo",                                                                                         ; // 15
                                "Pulse el botón para excluir el campo",                                                                                         ; // 16
                                "Pulse el botón para seleccionar el primer registro a imprimir",                                                                      ; // 17
                                "Pulse el botón para seleccionar el último registro a imprimir",                                                                       ; // 18
                                ABM_CRLF + "Ha incluido todos los campos   " + ABM_CRLF,                                                                   ; // 19
                                ABM_CRLF + "Primero seleccione el campo a incluir   " + ABM_CRLF,                                                           ; // 20
                                ABM_CRLF + "No hay campos para excluir   " + ABM_CRLF,                                                                    ; // 21
                                ABM_CRLF + "Primero seleccione el campo a excluir   " + ABM_CRLF,                                                            ; // 22
                                ABM_CRLF + "No ha seleccionado ningún campo   " + ABM_CRLF,                                              ; // 23
                                ABM_CRLF + "El listado no cabe en la página   " + ABM_CRLF + "Reduzca el numero de campos   " + ABM_CRLF,                                   ; // 24
                                ABM_CRLF + "La impresora no está disponible   " + ABM_CRLF,                                                                           ; // 25
                                "Ordenado por",                                                                                                           ; // 26
                                "Del registro",                                                                                                          ; // 27
                                "Al registro",                                                                                                            ; // 28
                                "Si",                                                                                                                  ; // 29
                                "No",                                                                                                                   ; // 30
                                "Página:",                                                                                                                ; // 31
                                ABM_CRLF + "Por favor seleccione una impresora   " + ABM_CRLF,                                                                     ; // 32
                                "Filtrado por",                                                                                                          ; // 33
                                ABM_CRLF + "No hay un filtro activo    " + ABM_CRLF,                                                                  ; // 34
                                ABM_CRLF + "No se puede filtrar por campos memo    " + ABM_CRLF,                                                                ; // 35
                                ABM_CRLF + "Seleccione el campo a filtrar    " + ABM_CRLF,                                                                 ; // 36
                                ABM_CRLF + "Seleccione el operador de comparación    " + ABM_CRLF,                                                              ; // 37
                                ABM_CRLF + "Introduzca el valor del filtro    " + ABM_CRLF,                                                                   ; // 38
                                ABM_CRLF + "No hay ningún filtro activo    " + ABM_CRLF,                                                              ; // 39
                                ABM_CRLF + "¿Eliminar el filtro activo?   " + ABM_CRLF,                                                                           ; // 40
                                ABM_CRLF + "Registro bloqueado por otro usuario    " + ABM_CRLF                                                                   } // 41

        case cLang == "FI"        // Finnish
	///////////////////////////////////////////////////////////////////////
	// FINNISH
	///////////////////////////////////////////////////////////////////////
	// MISC MESSAGES

	_hMG_SYSDATA [ 331 ] [1] := 'Oletko varma ?'
	_hMG_SYSDATA [ 331 ] [2] := 'Sulje ikkuna'
	_hMG_SYSDATA [ 331 ] [3] := 'Sulkeminen ei sallittu'
	_hMG_SYSDATA [ 331 ] [4] := 'Ohjelma on jo käynnissä'
	_hMG_SYSDATA [ 331 ] [5] := 'Korjaa'
	_hMG_SYSDATA [ 331 ] [6] := 'Ok'
	_hMG_SYSDATA [ 331 ] [7] := 'Keskeytä'
	_hMG_SYSDATA [ 331 ] [8] := 'Sivu.'      

	// BROWSE

	_HMG_SYSDATA [ 136 ]  := { "Ikkuna: " ,;
		" määrittelemätön. Ohjelma lopetettu" ,;
		"HMG Virhe",;
		"Kontrolli: ",;
		" / " ,;
		" On jo määritelty. Ohjelma lopetettu" ,;
		"Browse: Virheellinen tyyppi. Ohjelma lopetettu" ,;
		"Browse: Et voi lisätä kenttiä jotka eivät ole BROWSEN määrityksessä. Ohjelma lopetettu",;
		"Toinen käyttäjä korjaa juuri tietuetta" ,;
		"Varoitus" ,;
		"Virheellinen arvo" }

		_HMG_SYSDATA [ 137 ] := { 'Oletko varma ?' , 'Poista tietue' }

		// EDIT 
		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Poista tietue"+CHR(13)+"Oletko varma?"+CHR(13)                  ,;
			CHR(13)+"Indeksi tiedosto puuttuu"+CHR(13)+"En voihakea"+CHR(13)            ,;
			CHR(13)+"Indeksikenttä ei löydy"+CHR(13)+"En voihakea"+CHR(13)        ,;
			CHR(13)+"En voi hakea memo"+CHR(13)+"tai loogisen kentän mukaan"+CHR(13)       ,;
			CHR(13)+"Tietue ei löydy"+CHR(13),;
			CHR(13)+"Liian monta saraketta"+CHR(13)+"raportti ei mahdu sivulle"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Tietue"              ,;
			"Tietue lukumäärä"    ,;
			"       (Uusi)"       ,;
			"      (Korjaa)"      ,;
			"Anna tietue numero"  ,;
			"Hae"                 ,;
			"Hae teksti"          ,;
			"Hae päiväys"         ,;
			"Hae numero"          ,;
			"Raportti määritys"   ,;
			"Raportti sarake"     ,;
			"Sallitut sarakkeet"  ,;
			"Alku tietue"         ,;
			"Loppu tietue"        ,;
			"Raportti "           ,;
			"Pvm:"                ,;
			"Alku tietue:"        ,;
			"Loppu tietue:"       ,;
			"Lajittelu:"         ,;
			"Kyllä"                 ,;
			"Ei"                  ,;
			"Sivu "               ,;
			" / "                 }

		_HMG_SYSDATA [ 133 ] := { "Sulje"    ,;
			"Uusi"     ,;
			"Korjaa"   ,;
			"Poista"   ,;
			"Hae"      ,;
			"Mene"     ,;
			"Raportti" ,;
			"Ensimmäinen" ,;
			"Edellinen"   ,;
			"Seuraava"    ,;
			"Viimeinen"   ,;
			"Tallenna"    ,;
			"Keskeytä"    ,;
			"Lisää"       ,;
			"Poista"      ,;
			"Tulosta"     ,;
			"Sulje"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, työalue puuttuu"   ,;
			"EDIT, työalueella yli 16 kenttää",;
			"EDIT, päivitysalue ylitys (raportoi virhe)"      ,;
			"EDIT, tapahtuma numero ylitys (raportoi virhe)" ,;
			"EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

		// EDIT EXTENDED

		_HMG_SYSDATA [ 128 ] := {            ;
			" Sulje",            ; // 1
			" Uusi",              ; // 2
			" Muuta",           ; // 3
			" Poista",           ; // 4
			" Hae",             ; // 5
			" Tulosta",            ; // 6
			" Keskeytä",           ; // 7
			" Ok",               ; // 8
			" Kopioi",             ; // 9
			" Aktivoi Filtteri",  ; // 10
			" Deaktivoi Filtteri" } // 11

		_HMG_SYSDATA [ 129 ] := {                        ;
			"Ei mitään",                         ; // 1
			"Tietue",                       ; // 2
			"Yhteensä",                        ; // 3
			"Aktiivinen lajittelu",                 ; // 4
			"Optiot",                      ; // 5
			"Uusi tietue",                   ; // 6
			"Muuta tietue",                ; // 7
			"Valitse tietue",                ; // 8
			"Hae tietue",                  ; // 9
			"Tulostus optiot",                ; // 10
			"Valittavat kentät",               ; // 11
			"Tulostettavat kentät",              ; // 12
			"Valittavat tulostimet",           ; // 13
			"Ensim. tulostuttava tietue",        ; // 14
			"Viim. tulostettava tietue",         ; // 15
			"Poista tietue",                ; // 16
			"Esikatselu",                      ; // 17
			"Näytä sivujen miniatyyrit",         ; // 18
			"Suodin ehto: ",           ; // 19
			"Suodatettu: ",                   ; // 20
			"Suodatus Optiot" ,           ; // 21
			"Tietokanta kentät" ,             ; // 22
			"Vertailu operaattori",        ; // 23
			"Suodatus arvo",                 ; // 24
			"Valitse suodatus kenttä",       ; // 25
			"Valitse vertailu operaattori", ; // 26
			"Yhtä kuin",                        ; // 27
			"Erisuuri kuin",                    ; // 28
			"Isompi kuin",                 ; // 29
			"Pienempi kuin",                   ; // 30
			"Isompi tai sama kuin",        ; // 31
			"Pienempi tai sama kuin"           } // 32

		_HMG_SYSDATA [ 130 ] := { ;
			ABM_CRLF + "Työalue ei löydy.   "  + ABM_CRLF + "Valitse työaluetta ennenkun kutsut Edit  " + ABM_CRLF,       ; // 1
			"Anna kenttä arvo (tekstiä)",                                  ; // 2
			"Anna kenttä arvo (numeerinen)",                                  ; // 3
			"Valitse päiväys",                            ; // 4
			"Tarkista tosi arvo",                     ; // 5
			"Anna kenttä arvo",                    ; // 6
			"Valitse joku tietue ja paina OK",                                     ; // 7
			ABM_CRLF + "Olet poistamassa aktiivinen tietue   "+ABM_CRLF + "Oletko varma?    " + ABM_CRLF,                  ; // 8
			ABM_CRLF + "Ei aktiivista lajittelua   " + ABM_CRLF+"Valitse lajittelu   " + ABM_CRLF,                            ; // 9
			ABM_CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + ABM_CRLF,; // 10
			ABM_CRLF + "Tietue ei löydy   " + ABM_CRLF,                                                ; // 11
			"Valitse listaan lisättävät kentät",                                                    ; // 12
			"Valitse EI lisättävät kentät",                                        ; // 13
			"Valitse tulostin",                   ; // 14
			"Paina näppäin lisäätäksesi kenttä",                                                                  ; // 15
			"Paina näppäin poistaaksesi kenttä",                                                       ; //16
			"Paina näppäin valittaaksesi ensimmäinen tulostettava tietue",  ; // 17
			"Paina näppäin valittaaksesi viimeinen tulostettava tietue",   ; // 18
			ABM_CRLF + "Ei lisää kenttiä   " + ABM_CRLF,                                 ; // 19
			ABM_CRLF + "Valitse ensin lisättävä kenttä   "+ABM_CRLF,                                                           ; //20
			ABM_CRLF + "EI Lisää ohitettavia kenttiä   " +ABM_CRLF,; // 21
			ABM_CRLF + "Valitse ensin ohitettava kenttä   " +ABM_CRLF,                                                            ;//22
			ABM_CRLF + "Et valinnut kenttiä   " + ABM_CRLF + "Valitse tulosteen kentät   " + ABM_CRLF,   ; // 23
			ABM_CRLF + "Liikaa kenttiä   " + ABM_CRLF + "Vähennä kenttä lukumäärä   " + ABM_CRLF,; // 24
			ABM_CRLF + "Tulostin ei valmiina   " + ABM_CRLF,                                                  ; // 25
			"Lajittelu",             ; // 26
			"Tietueesta",              ; // 27
			"Tietueeseen",                  ; // 28
			"Kyllä",                ; // 29
			"EI",       ; // 30
			"Sivu:",          ; // 31
			ABM_CRLF + "Valitse tulostin   " + ABM_CRLF,                                       ; // 32
			"Lajittelu",            ; // 33
			ABM_CRLF + "Aktiivinen suodin olemassa    " + ABM_CRLF,                                                          ; // 34
			ABM_CRLF + "En voi suodattaa memo kenttiä    "+ABM_CRLF,;// 35
			ABM_CRLF + "Valitse suodattava kenttä    " + ABM_CRLF,                                                           ; // 36
			ABM_CRLF + "Valitse suodattava operaattori    " +ABM_CRLF,                                                             ; //37
			ABM_CRLF + "Anna suodatusarvo    " + ABM_CRLF,                                         ; // 38
			ABM_CRLF + "Ei aktiivisia suotimia    " + ABM_CRLF,                                              ; // 39
			ABM_CRLF + "Poista suodin?   " + ABM_CRLF,                                        ; // 40
			ABM_CRLF + "Tietue lukittu    " + ABM_CRLF                                 } // 41
	
        case cLang == "NL"        // Dutch
	/////////////////////////////////////////////////////////////
	// DUTCH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Weet u het zeker?'
		_hMG_SYSDATA [ 331 ] [2] := 'Sluit venster'
		_hMG_SYSDATA [ 331 ] [3] := 'Sluiten niet toegestaan'
		_hMG_SYSDATA [ 331 ] [4] := 'Programma is al actief'
		_hMG_SYSDATA [ 331 ] [5] := 'Bewerken'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Annuleren'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE

                  _HMG_SYSDATA [ 136 ]  := { "Scherm: ",;
                                       " is niet gedefinieerd. Programma beëindigd"           ,;
                                       "HMG fout",;
                                       "Control: ",;
                                       " Van ",;
	           " Is al gedefinieerd. Programma beëindigd"                   ,;
        	   "Browse: Type niet toegestaan. Programma beëindigd"          ,;
	           "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma beëindigd",;
        	   "Regel word al veranderd door een andere gebruiker"          ,;
	           "Waarschuwing"                                               ,;
        	   "Onjuiste invoer"                                            }

                  _HMG_SYSDATA [ 137 ] := { 'Weet u het zeker?' , 'Verwijder regel' }

	    // EDIT

	    _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Verwijder regel"+CHR(13)+"Weet u het zeker ?"+CHR(13)    ,;
                       CHR(13)+"Index bestand is er niet"+CHR(13)+"Kan niet zoeken"+CHR(13)          ,;
                       CHR(13)+"Kan index veld niet vinden"+CHR(13)+"Kan niet zoeken"+CHR(13)        ,;
                       CHR(13)+"Kan niet zoeken op"+CHR(13)+"Memo of logische velden"+CHR(13)        ,;
                       CHR(13)+"Regel niet gevonden"+CHR(13) ,;
                       CHR(13)+"Te veel rijen"+CHR(13)+"Het rapport past niet op het papier"+CHR(13) }

	    _HMG_SYSDATA [ 132 ]  := { "Regel"     ,;
                       "Regel aantal"          ,;
                       "       (Nieuw)"        ,;
                       "      (Bewerken)"      ,;
                       "Geef regel nummer"     ,;
                       "Vind"                  ,;
                       "Zoek tekst"            ,;
                       "Zoek datum"            ,;
                       "Zoek nummer"           ,;
                       "Rapport definitie"     ,;
                       "Rapport rijen"         ,;
                       "Beschikbare rijen"     ,;
                       "Eerste regel"          ,;
                       "Laatste regel"         ,;
                       "Rapport van "          ,;
                       "Datum:"                ,;
                       "Eerste regel:"         ,;
                       "Laatste tegel:"        ,;
                       "Gesorteerd op:"        ,;
                       "Ja"                    ,;
                       "Nee"                   ,;
                       "Pagina "               ,;
                       " van "                 }

	    _HMG_SYSDATA [ 133 ] := { "Sluiten"   ,;
                       "Nieuw"                 ,;
                       "Bewerken"              ,;
                       "Verwijderen"           ,;
                       "Vind"                  ,;
                       "Ga naar"               ,;
                       "Rapport"               ,;
                       "Eerste"                ,;
                       "Vorige"                ,;
                       "Volgende"              ,;
                       "Laatste"               ,;
                       "Bewaar"                ,;
                       "Annuleren"             ,;
                       "Voeg toe"              ,;
                       "Verwijder"             ,;
                       "Print"                 ,;
                       "Sluiten"               }
	    _HMG_SYSDATA [ 134 ]  := { "BEWERKEN, werkgebied naam bestaat niet",;
                       "BEWERKEN, dit werkgebied heeft meer dan 16 velden",;
                       "BEWERKEN, ververs manier buiten bereik (a.u.b. fout melden)"           ,;
                       "BEWERKEN, hoofd gebeurtenis nummer buiten bereik (a.u.b. fout melden)" ,;
                       "BEWERKEN, list gebeurtenis nummer buiten bereik (a.u.b. fout melden)"  }

	    // EDIT EXTENDED
                          _HMG_SYSDATA [ 128 ] := {            ;
                                  "&Sluiten",          ; // 1
                                  "&Nieuw",            ; // 2
                                  "&Aanpassen",        ; // 3
                                  "&Verwijderen",      ; // 4
                                  "&Vind",             ; // 5
                                  "&Print",            ; // 6
                                  "&Annuleren",        ; // 7
                                  "&Ok",               ; // 8
                                  "&Kopieer",          ; // 9
                                  "&Activeer filter",  ; // 10
                                  "&Deactiveer filter" } // 11
                          _HMG_SYSDATA [ 129 ] := {                            ;
                                  "Geen",                             ; // 1
                                  "Regel",                            ; // 2
                                  "Totaal",                           ; // 3
                                  "Actieve volgorde",                 ; // 4
                                  "Opties",                           ; // 5
                                  "Nieuw regel",                      ; // 6
                                  "Aanpassen regel",                  ; // 7
                                  "Selecteer regel",                  ; // 8
                                  "Vind regel",                       ; // 9
                                  "Print opties",                     ; //10
                                  "Beschikbare velden",               ; //11
                                  "Velden te printen",                ; //12
                                  "Beschikbare printers",             ; //13
                                  "Eerste regel te printen",          ; //14
                                  "Laatste regel te printen",         ; //15
                                  "Verwijder regel",                  ; //16
                                  "Voorbeeld",                        ; //17
                                  "Laat pagina klein zien",           ; //18
                                  "Filter condities: ",               ; //19
                                  "Gefilterd: ",                      ; //20
                                  "Filter opties" ,                   ; //21
                                  "Database velden" ,                 ; //22
                                  "Vergelijkings operator",           ; //23
                                  "Filter waarde",                    ; //24
                                  "Selecteer velden om te filteren",  ; //25
                                  "Selecteer vergelijkings operator", ; //26
                                  "Gelijk",                           ; //27
                                  "Niet gelijk",                      ; //28
                                  "Groter dan",                       ; //29
                                  "Kleiner dan",                      ; //30
                                  "Groter dan of gelijk aan",         ; //31
                                  "Kleiner dan of gelijk aan"         } //32
                          _HMG_SYSDATA [ 130 ] := { ;
                                  ABM_CRLF + "Kan geen actief werkgebied vinden   "  + ABM_CRLF + "Selecteer A.U.B. een actief werkgebied voor BEWERKEN aan te roepen   " + ABM_CRLF, ; // 1
                                  "Geef de veld waarde (een tekst)",; // 2
                                  "Geef de veld waarde (een nummer)",; // 3
                                  "Selecteer de datum",; // 4
                                  "Controleer voor geldige waarde",; // 5
                                  "Geef de veld waarde",; // 6
                                  "Selecteer een regel en druk op OK",; // 7
                                  ABM_CRLF + "Je gaat het actieve regel verwijderen  " + ABM_CRLF + "Zeker weten?    " + ABM_CRLF,; // 8
                                  ABM_CRLF + "Er is geen actieve volgorde " + ABM_CRLF + "Selecteer er A.U.B. een   " + ABM_CRLF,; // 9
                                  ABM_CRLF + "Kan niet zoeken in memo of logische velden   " + ABM_CRLF,; // 10
                                  ABM_CRLF + "Regel niet gevonden   " +ABM_CRLF,; // 11
                                  "Selecteer het veld om in de lijst in te sluiten",; // 12
                                  "Selecteer het veld om uit de lijst te halen",; // 13
                                  "Selecteer de printer",; // 14
                                  "Druk op de knop om het veld in te sluiten",; // 15
                                  "Druk op de knop om het veld uit te sluiten",; // 16
                                  "Druk op de knop om het eerste veld te selecteren om te printen",; // 17
                                  "Druk op de knop om het laatste veld te selecteren om te printen",; // 18
                                  ABM_CRLF + "Geen velden meer om in te sluiten   " + ABM_CRLF,; // 19
                                  ABM_CRLF + "Selecteer eerst het veld om in te sluiten   " + ABM_CRLF,; // 20
                                  ABM_CRLF + "Geen velden meer om uit te sluiten   " + ABM_CRLF,; // 21
                                  ABM_CRLF + "Selecteer eerst het veld om uit te sluiten   " + ABM_CRLF,; // 22
                                  ABM_CRLF + "Je hebt geen velden geselecteerd   " + ABM_CRLF + "Selecteer A.U.B. de velden om in te sluiten om te printen   " + ABM_CRLF, ; // 23
                                  ABM_CRLF + "Teveel velden   " + ABM_CRLF + "Selecteer minder velden   " + ABM_CRLF,; // 24
                                  ABM_CRLF + "Printer niet klaar   " + ABM_CRLF,; // 25
                                  "Volgorde op",; // 26
                                  "Van regel",; // 27
                                  "Tot regel",; // 28
                                  "Ja",; // 29
                                  "Nee",; // 30
                                  "Pagina:",; // 31
                                  ABM_CRLF + "Selecteer A.U.B. een printer " + ABM_CRLF,; // 32
                                  "Gefilterd op", ; // 33
                                  ABM_CRLF + "Er is een actief filter    " + ABM_CRLF,; // 34
                                  ABM_CRLF + "Kan niet filteren op memo velden    " + ABM_CRLF,; // 35 
                                  ABM_CRLF + "Selecteer het veld om op te filteren    " + ABM_CRLF, ; // 36
                                  ABM_CRLF + "Selecteer een operator om te filteren    " + ABM_CRLF,; // 37
                                  ABM_CRLF + "Type een waarde om te filteren " + ABM_CRLF,; // 38
                                  ABM_CRLF + "Er is geen actief filter    "+ ABM_CRLF,; // 39
                                  ABM_CRLF + "Deactiveer filter?   " + ABM_CRLF,; // 40
                                  ABM_CRLF + "Regel geblokkeerd door een andere gebuiker" + ABM_CRLF } // 41

        // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
        case cLang == "SL"
  	/////////////////////////////////////////////////////////////
	// SLOVENIAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Ste preprièani ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zapri okno'
		_hMG_SYSDATA [ 331 ] [3] := 'Zapiranje ni dovoljeno'
		_hMG_SYSDATA [ 331 ] [4] := 'Program je že zagnan'
		_hMG_SYSDATA [ 331 ] [5] := 'Popravi'
		_hMG_SYSDATA [ 331 ] [6] := 'V redu'
		_hMG_SYSDATA [ 331 ] [7] := 'Prekini'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE MESSAGES

		_HMG_SYSDATA [ 136 ]  := { "Window: "                        ,;     
                           " not defined. Program terminated"     ,;
                           "HMG Error"                        ,;
                           "Control: "                            ,;
                           " Of "                                 ,;
                           " Already defined. Program Terminated" ,;
                           "Type Not Allowed. Program terminated" ,;
                           "False WorkArea. Program Terminated"   ,;
                           "Zapis ureja drug uporabnik"           ,;
                           "Opozorilo"                            ,;
                           "Narobe vnos" }

	       _HMG_SYSDATA [ 137 ] := { 'Ste preprièani ?' , 'Briši vrstico' }

		// EDIT MESSAGES

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Briši vrstico"+CHR(13)+"Ste preprièani ?"+CHR(13)     ,;
                     CHR(13)+"Manjka indeksna datoteka"+CHR(13)+"Ne morem iskati"+CHR(13)       ,;
                     CHR(13)+"Ne najdem indeksnega polja"+CHR(13)+"Ne morem iskati"+CHR(13)     ,;
                     CHR(13)+"Ne morem iskati po"+CHR(13)+"memo ali logiènih poljih"+CHR(13)    ,;
                     CHR(13)+"Ne najdem vrstice"+CHR(13)                                        ,;
                     CHR(13)+"Preveè kolon"+CHR(13)+"Poroèilo ne gre na list"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Vrstica"    ,;
                     "Število vrstic"         ,;
                     "       (Nova)"          ,;
                     "      (Popravi)"        ,;
                     "Vnesi številko vrstice" ,;
                     "Poišèi"                 ,;
                     "Besedilo za iskanje"    ,;
                     "Datum za iskanje"       ,;
                     "Številka za iskanje"    ,;
                     "Parametri poroèila"     ,;
                     "Kolon v poroèilu"       ,;
                     "Kolon na razpolago"     ,;
                     "Zaèetna vrstica"        ,;
                     "Konèna vrstica"         ,;
                     "Pporoèilo za "          ,;
                     "Datum:"                 ,;
                     "Zaèetna vrstica:"       ,;
                     "Konèna vrstica:"        ,;
                     "Urejeno po:"            ,;
                     "Ja"                     ,;
                     "Ne"                     ,;
                     "Stran "                 ,;
                     " od "                 }

		_HMG_SYSDATA [ 133 ] := { "Zapri" ,;
                     "Nova"              ,;
                     "Uredi"             ,;
                     "Briši"             ,;
                     "Poišèi"            ,;
                     "Pojdi na"          ,;
                     "Poroèilo"          ,;
                     "Prva"              ,;
                     "Prejšnja"          ,;
                     "Naslednja"         ,;
                     "Zadnja"            ,;
                     "Shrani"            ,;
                     "Prekini"           ,;
                     "Dodaj"             ,;
                     "Odstrani"          ,;
                     "Natisni"           ,;
                     "Zapri"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                  ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED

	        _HMG_SYSDATA [ 128 ] := {     ;
                "&Zapri",             ; // 1
                "&Nova",              ; // 2
                "&Spremeni",          ; // 3
                "&Briši",             ; // 4
                "&Poišèi",            ; // 5
                "&Natisni",           ; // 6
                "&Prekini",           ; // 7
                "&V redu",            ; // 8
                "&Kopiraj",           ; // 9
                "&Aktiviraj Filter",  ; // 10
                "&Deaktiviraj Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                 ;
                "Prazno",                        ; // 1
                "Vrstica",                       ; // 2
                "Skupaj",                        ; // 3
                "Activni indeks",                ; // 4
                "Možnosti",                      ; // 5
                "Nova vrstica",                  ; // 6
                "Spreminjaj vrstico",            ; // 7
                "Oznaèi vrstico",                ; // 8
                "Najdi vrstico",                 ; // 9
                "Možnosti tiskanja",             ; // 10
                "Polja na razpolago",            ; // 11
                "Polja za tiskanje",             ; // 12
                "Tiskalniki na razpolago",       ; // 13
                "Prva vrstica za tiskanje",      ; // 14
                "Zadnja vrstica za tiskanje",    ; // 15
                "Briši vrstico",                 ; // 16
                "Pregled",                       ; // 17
                "Mini pregled strani",           ; // 18
                "Pogoj za filter: ",             ; // 19
                "Filtrirano: ",                  ; // 20
                "Možnosti filtra" ,              ; // 21
                "Polja v datoteki" ,             ; // 22
                "Operator za primerjavo",        ; // 23
                "Vrednost filtra",               ; // 24
                "Izberi polje za filter",        ; // 25
                "Izberi operator za primerjavo", ; // 26
                "Enako",                         ; // 27
                "Neenako",                       ; // 28
                "Veèje od",                      ; // 29
                "Manjše od",                     ; // 30
                "Veèje ali enako od",            ; // 31
                "Manjše ali enako od"            } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,; // 1
                "Vnesi vrednost (tekst)",                                                                                        ; // 2
                "Vnesi vrednost (številka)",                                                                                     ; // 3
                "Izberi datum",                                                                                                  ; // 4
                "Oznaèi za logièni DA",                                                                                          ; // 5
                "Vnesi vrednost",                                                                                                ; // 6
                "Izberi vrstico in pritisni <V redu>",                                                                           ; // 7
                ABM_CRLF + "Pobrisali boste trenutno vrstico   " + ABM_CRLF + "Ste preprièani?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "Ni aktivnega indeksa   " + ABM_CRLF + "Prosimo, izberite ga   " + ABM_CRLF,                          ; // 9
                ABM_CRLF + "Ne morem iskati po logiènih oz. memo poljih   " + ABM_CRLF,                                          ; // 10
                ABM_CRLF + "Ne najdem vrstice   " + ABM_CRLF,                                                                    ; // 11
                "Izberite polje, ki bo vkljuèeno na listo",                                                                      ; // 12
                "Izberite polje, ki NI vkljuèeno na listo",                                                                      ; // 13
                "Izberite tisklanik",                                                                                            ; // 14
                "Pritisnite gumb za vkljuèitev polja",                                                                           ; // 15
                "Pritisnite gumb za izkljuèitev polja",                                                                          ; // 16
                "Pritisnite gumb za izbor prve vrstice za tiskanje",                                                             ; // 17
                "Pritisnite gumb za izbor zadnje vrstice za tiskanje",                                                           ; // 18
                ABM_CRLF + "Ni veè polj za dodajanje   " + ABM_CRLF,                                                             ; // 19
                ABM_CRLF + "Najprej izberite ppolje za vkljuèitev   " + ABM_CRLF,                                                ; // 20
                ABM_CRLF + "Ni veè polj za izkljuèitev   " + ABM_CRLF,                                                           ; // 21
                ABM_CRLF + "Najprej izberite polje za izkljuèitev   " + ABM_CRLF,                                                ; // 22
                ABM_CRLF + "Niste izbrali nobenega polja   " + ABM_CRLF + "Prosom, izberite polje za tiskalnje   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Preveè polj   " + ABM_CRLF + "Zmanjšajte število polj   " + ABM_CRLF,                                ; // 24
                ABM_CRLF + "Tiskalnik ni pripravljen   " + ABM_CRLF,                                                             ; // 25
                "Urejeno po",                                                                                                    ; // 26
                "Od vrstice",                                                                                                    ; // 27
                "do vrstice",                                                                                                    ; // 28
                "Ja",                                                                                                            ; // 29
                "Ne",                                                                                                            ; // 30
                "Stran:",                                                                                                        ; // 31
                ABM_CRLF + "Izberite tiskalnik   " + ABM_CRLF,                                                                   ; // 32
                "Filtrirano z",                                                                                                  ; // 33
                ABM_CRLF + "Aktiven filter v uporabi    " + ABM_CRLF,                                                            ; // 34
                ABM_CRLF + "Ne morem filtrirati z memo polji    " + ABM_CRLF,                                                    ; // 35
                ABM_CRLF + "Izberi polje za filtriranje    " + ABM_CRLF,                                                         ; // 36
                ABM_CRLF + "Izberi operator za filtriranje    " + ABM_CRLF,                                                      ; // 37
                ABM_CRLF + "Vnesi vrednost za filtriranje    " + ABM_CRLF,                                                       ; // 38
                ABM_CRLF + "Ni aktivnega filtra    " + ABM_CRLF,                                                                 ; // 39
                ABM_CRLF + "Deaktiviram filter?   " + ABM_CRLF,                                                                  ; // 40
                ABM_CRLF + "Vrstica zaklenjena - uporablja jo drug uporabnik    " + ABM_CRLF                                     } // 41

	OtherWise
	/////////////////////////////////////////////////////////////
	// DEFAULT ENGLISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES (ENGLISH DEFAULT)

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Close Window'
		_hMG_SYSDATA [ 331 ] [3] := 'Close not allowed'
		_hMG_SYSDATA [ 331 ] [4] := 'Program Already Running'
		_hMG_SYSDATA [ 331 ] [5] := 'Edit'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancel'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE MESSAGES (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES (ENGLISH DEFAULT)

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

	endcase

********************************************************************************************************************************************************
ELSE   // ANSI 
********************************************************************************************************************************************************

	do case

        // case cLang == "TRWIN" .OR. cLang == "TR"
        case cLang == "TR"

    /////////////////////////////////////////////////////////////
    // T�RK�E
    ////////////////////////////////////////////////////////////

        // �E��TL� MESAJLAR

        _HMG_SYSDATA [ 331 ] [1] := 'Emin misiniz ?'
        _HMG_SYSDATA [ 331 ] [2] := 'Pencereyi Kapat'
        _HMG_SYSDATA [ 331 ] [3] := 'Kapat�lam�yor'
        _HMG_SYSDATA [ 331 ] [4] := 'Program h�len �al���yor'
        _HMG_SYSDATA [ 331 ] [5] := 'Edit'
        _HMG_SYSDATA [ 331 ] [6] := 'Tamam'
        _HMG_SYSDATA [ 331 ] [7] := '�ptal'
        _HMG_SYSDATA [ 331 ] [8] := 'Syf.'

        // BROWSE MESAJLARI ( T�RK�E )

            _HMG_SYSDATA [ 136 ]  := { ;
                     "Pencere: ",;
                     " tan�ms�z. Program sonland�r�ld�.",;
                     "HMG Hatas�",;
                     "Kontrol: ",;
                     " / ",;
                     " �nceden tan�ml�. Program sonland�r�ld�.",;
                     "Browse: Ge�ersiz Tip. Program sonland�r�ld�.",;
                     "Browse: Browse �al��ma alan�nda olmayan sahalar i�in " +;
                              "Append ibaresi kullan�lamaz. Program sonland�r�ld�.",;
                     "Bu kayd� �u anda ba�ka biri editliyor.",;
                     "Uyar�",;
                     "Ge�ersiz giri�"}

           _HMG_SYSDATA [ 137 ] := { 'Emin misiniz ?' , 'Kay�t silme' }

        // EDIT MESAJLARI ( T�RK�E )

        _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Kay�t silme"+CHR(13)+"Emin misiniz ?"+CHR(13),;
                     CHR(13)+"Indeks dosyas� yok"+CHR(13)+"Arama yap�lam�yor"+CHR(13),;
                     CHR(13)+"Indeks dosyas� bulunamad�"+CHR(13)+"Arama yap�lam�yor"+CHR(13),;
                     CHR(13)+"Memo ve mant�ksal sahalarda"+CHR(13)+"Arama yap�lamaz"+CHR(13),;
                     CHR(13)+"Kay�t bulunamad�"+CHR(13),;
                     CHR(13)+"�ok fazla s�tun var"+CHR(13)+"Rapor sayfaya s��m�yor"+CHR(13) }

        _HMG_SYSDATA [ 132 ]  := { ;
                     "Kay�t",;
                     "Kay�t say�s�",;
                     "       (Yeni)",;
                     "       (Edit)",;
                     " Kay�t No.su :",;
                     "Ara",;
                     "Metin ara",;
                     "Tarih ara",;
                     "Say� ara",;
                     "Rapor tan�m�",;
                     "Rapor s�tunlar�",;
                     "M�sait s�tunlar",;
                     "�lk kay�t",;
                     "Son kay�t",;
                     "Rapor ad� ",;
                     "Tarih:",;
                     "�lk kay�t:",;
                     "Son kay�t:",;
                     "S�ra d�zeni:",;
                     "Evet",;
                     "Hay�r",;
                     "Sayfa ",;
                     " / "}

        _HMG_SYSDATA [ 133 ] := { ;
                     "Kapat",;
                     "Yeni",;
                     "Edit",;
                     "Sil",;
                     "Ara",;
                     "Git",;
                     "Rapor",;
                     "�lk",;
                     "�nceki",;
                     "Sonraki",;
                     "Son",;
                     "Kaydet",;
                     "�ptal",;
                     "Ekle",;
                     "Kald�r",;
                     "Print",;
                     "Kapat"}
                     
        _HMG_SYSDATA [ 134 ]  := { ;
                     "EDIT, �al��ma alan� ismi noksan",;
                     "EDIT, bu �al��ma alan�nda 16'dan fazla saha var",;
                     "EDIT, Tazeleme mod'u s�n�r �tesinde ( l�tfen hatay� bildirin )",;
                     "EDIT, Temel olay numaras� s�n�r �tesinde ( l�tfen hatay� bildirin )",;
                     "EDIT, Liste olay numaras� s�n�r �tesinde ( l�tfen hatay� bildirin )" }

        // EDIT EXTENDED MESAJLARI ( T�RK�E )

            _HMG_SYSDATA [ 128 ] := { ;
                     "&Kapat",;                // 1
                     "&Yeni",;                 // 2
                     "&De�i�tir",;             // 3
                     "&Sil",;                  // 4
                     "&Ara",;                  // 5
                     "&Print",;                // 6
                     "&�ptal",;                // 7
                     "&Tamam",;                // 8
                     "&Kopyala",;              // 9
                     "&S�zge�i etkinle�tir",;  // 10
                     "&S�zge�i kald�r" }       // 11
                                      
            _HMG_SYSDATA [ 129 ] := { ;
                     "Yok",;                         // 1
                     "Kay�t",;                       // 2
                     "Toplam",;                      // 3
                     "Aktif s�ra",;                  // 4
                     "Se�enekler",;                  // 5
                     "Yeni kay�t",;                  // 6
                     "Kayd� de�i�tir",;              // 7
                     "Kay�t se�",;                   // 8
                     "Kay�t ara",;                   // 9
                     "Print se�enekleri",;           // 10
                     "M�sait sahalar",;              // 11
                     "Print edilecek sahalar",;      // 12
                     "M�sait printerler",;           // 13
                     "Print ediecek ilk kay�t",;     // 14
                     "Print ediecek son kay�t",;     // 15
                     "Kay�t sil",;                   // 16
                     "�nizleme",;                    // 17
                     "Sayfa ikonlar�n� g�ster",;     // 18
                     "S�zge� �art�: ",;              // 19
                     "S�zge�li: ",;                  // 20
                     "S�zge� se�enekleri" ,;         // 21
                     "Database Sahalar�",;           // 22
                     "Kar��la�t�rma operat�rleri",;  // 23
                     "S�zge� de�eri",;               // 24
                     "S�zge�lenecek sahalar� se�",;  // 25
                     "Kar��la�t�rma operat�r� se�",; // 26
                     "E�it",;                        // 27
                     "E�it de�il",;                  // 28
                     "Daha b�y�k",;                  // 29
                     "Daha k���k",;                  // 30
                     "Daha b�y�k veya e�it",;        // 31
                     "Daha k���k veya e�it"}         // 32
                                      
            _HMG_SYSDATA [ 130 ] := { ABM_CRLF + ;
                "Aktif bir alan bulunamad�."  + ABM_CRLF + ;       
                "L�tfen EDIT'i �a��rmadan �nce bir alan se�in" + ABM_CRLF,;           //  1
                "Saha de�eri girin ( metin )",;                                       //  2
                "Saha de�eri girin ( say� )",;                                        //  3
                "Tarih se�imi",;                                                      //  4
                "Do�ru de�eri onayla",;                                               //  5
                "Saha de�eri girin",;                                                 //  6
                "Bir kay�t se�ip 'Tamam'a bas�n",;                                    //  7
                ABM_CRLF + "Aktif kayd� silmek �zeresiniz" + ABM_CRLF + ;                 
                           "Emin misiniz ?    " + ABM_CRLF,;                          //  8
                ABM_CRLF + "Aktif bir s�ra d�zeni yok   " + ABM_CRLF + ;                  
                           "L�tfen birini se�in " + ABM_CRLF,;                        //  9
                ABM_CRLF + "Memo ve mant�ksal sahada arama yap�lam�yor." + ABM_CRLF,; // 10
                ABM_CRLF + "Kay�t bulunmad�   " + ABM_CRLF,;                          // 11
                "Listeye girecek sahay� se�in",;                                      // 12
                "Listeye girmeyecek sahay� se�in",;                                   // 13
                "Printer se�in",;                                                     // 14
                "Sahay� eklemek i�in d��meye bas�n",;                                 // 15
                "Sahay� ��karmak i�in d��meye bas�n",;                                // 16
                "Print edilecek ilk kayd� se�mek i�in d��meye bas�n",;                // 17
                "Print edilecek son kayd� se�mek i�in d��meye bas�n",;                // 18
                ABM_CRLF + "Eklenecek ba�ka saha yok.   " + ABM_CRLF,;                // 19
                ABM_CRLF + "�nce eklenecek sahay� se�in"   + ABM_CRLF,;               // 20
                ABM_CRLF + "D��lanacak ba�ka saha yok   "   + ABM_CRLF,;              // 21
                ABM_CRLF + "�nce ��kar�lacak sahay� se�in   " + ABM_CRLF,;            // 22
                ABM_CRLF + "Bir saha bile se�ilmedi   " + ABM_CRLF + ;
                           "L�tfen print edilecek sahalar� se�in" + ABM_CRLF,;        // 23
                ABM_CRLF + "�ok fazla saha" + ABM_CRLF + ;
                           "Saha say�s�n� azalt�n" + ABM_CRLF,;                       // 24
                ABM_CRLF + "Printer haz�r de�il   " + ABM_CRLF,;                      // 25
                "S�ra d�zeni",;                                                       // 26
                "�lk Kay�t",;                                                         // 27
                "Son kay�t",;                                                         // 28
                "Evet",;                                                              // 29
                "Hay�r",;                                                             // 30
                "Sayfa:",;                                                            // 31
                ABM_CRLF + "L�tfen bir printer se�in" + ABM_CRLF,;                    // 32
                "S�zge� : ",;                                                         // 33
                ABM_CRLF + "Aktif s�zge� yok" + ABM_CRLF,;                            // 34
                ABM_CRLF + "Memo sahalar s�zge�lenemiyor    " + ABM_CRLF,;            // 35
                ABM_CRLF + "S�zge�elenecek sahay� se�in    " + ABM_CRLF,;             // 36
                ABM_CRLF + "S�zge� i�in bir operat�r se�in    " + ABM_CRLF,;          // 37
                ABM_CRLF + "S�zge� i�i bir de�er yaz�n    " + ABM_CRLF,;              // 38
                ABM_CRLF + "Aktif bir s�zge� yok    " + ABM_CRLF,;                    // 39
                ABM_CRLF + "S�zge� kald�r�ls�n m�   " + ABM_CRLF,;                    // 40
                ABM_CRLF + "Kayd� ba�ka bir kullan�c� kilitlemi�    " + ABM_CRLF }    // 41

        // case cLang ==  "CS" .OR. cLang == "CSWIN"
        case cLang ==  "CS"
	/////////////////////////////////////////////////////////////
	// CZECH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES (ENGLISH DEFAULT)

		_hMG_SYSDATA [ 331 ] [1] := 'Jste si jist(a)?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zav�i okno'
		_hMG_SYSDATA [ 331 ] [3] := 'Uzav�en� zak�z�no'
		_hMG_SYSDATA [ 331 ] [4] := 'Program u� b��'
		_hMG_SYSDATA [ 331 ] [5] := '�prava'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Storno'
		_hMG_SYSDATA [ 331 ] [8] := 'Str.'

		// BROWSE MESSAGES (ENGLISH DEFAULT)

        	_HMG_SYSDATA [ 136 ]  := { "Okno: "                                              ,;
                                     " nen� definov�no. Program ukon�en"                   ,;
                                     "HMG Error"                                         ,;
                                     "Prvek: "                                             ,;
                                     " z "                                                  ,;
				     " u� definov�n. Program ukon�en"                  ,;
				     "Browse: Typ nepovolen. Program ukon�en"          ,;
				     "Browse: Append fr�zi nelze pou��t s poli nepat��c�mi do Browse pracovn� oblasti. Program ukon�en",;
				     "Z�znam edituje jin� u�ivatel"                ,;
				     "Varov�n�"                                              ,;
				     "Chybn� vstup"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Jste si jist(a)?' , 'Smazat z�znam' }

		// EDIT MESSAGES (ENGLISH DEFAULT)

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Smazat z�znam"+CHR(13)+"Jste si jist(a)?"+CHR(13)                  ,;
                     CHR(13)+"Chyb� indexov� soubor"+CHR(13)+"Nemohu hledat"+CHR(13)            ,;
                     CHR(13)+"Nemohu naj�t indexovan� pole"+CHR(13)+"Nemohu hledat"+CHR(13)        ,;
                     CHR(13)+"Nemohu hledat podle"+CHR(13)+"pole memo nebo logick�"+CHR(13)       ,;
                     CHR(13)+"Z�znam nenalezen"+CHR(13)                                        ,;
                     CHR(13)+"P��li� mnoho sloupc�"+CHR(13)+"Sestava se nevejde na plochu"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Z�znam"      ,;
                     "Po�et z�znam�"         ,;
                     "      (Nov�)"          ,;
                     "     (�prava)"         ,;
                     "Zadejte ��slo z�znamu" ,;
                     "Hledej"                ,;
                     "Hledan� text"          ,;
                     "Hledan� datum"         ,;
                     "Hledan� ��slo"         ,;
                     "Definice sestavy"      ,;
                     "Sloupce sestavy"       ,;
                     "Dostupn� sloupce"      ,;
                     "Prvn� z�znam"          ,;
                     "Posledn� z�znam"       ,;
                     "Sestava "              ,;
                     "Datum:"                ,;
                     "Prvn� z�znam:"         ,;
                     "Posledn� z�znam:"      ,;
                     "T��d�no dle:"          ,;
                     "Ano"                   ,;
                     "Ne"                    ,;
                     "Strana "               ,;
                     " z "                   }

		_HMG_SYSDATA [ 133 ] := { "Zav��t"    ,;
                     "Nov�"      ,;
                     "�prava"    ,;
                     "Sma�"      ,;
                     "Najdi"     ,;
                     "Jdi"       ,;
                     "Sestava"   ,;
                     "Prvn�"     ,;
                     "P�edchoz�" ,;
                     "Dal��"     ,;
                     "Posledn�"  ,;
                     "Ulo�"      ,;
                     "Storno"    ,;
                     "P�idej"    ,;
                     "Odstra�"   ,;
                     "Tisk"      ,;
                     "Zav�i"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, chyb� jm�no pracovn� oblasti"                              ,;
                     "EDIT, pracovn� oblast m� v�c jak 16 pol�"              ,;
                     "EDIT, refresh mode mimo rozsah (pros�m, nahlaste chybu)"      ,;
                     "EDIT, hlavn� event ��slo mimo rozsah (pros�m, nahlaste chybu)" ,;
                     "EDIT, list event ��slomimo rozsah (pros�m, nahlaste chybu)"  }

		// EDIT EXTENDED (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Zav�i",            ; // 1
                "&Nov�",             ; // 2
                "�&prava",           ; // 3
                "S&ma�  ",           ; // 4
                "Na&jdi",            ; // 5
                "&Tisk",             ; // 6
                "&Storno",           ; // 7
                "&Ok",               ; // 8
                "&Kop�ruj",          ; // 9
                "Aktivuj &filtr",    ; // 10
                "&Vypni filtr" }       // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "��dn�",                        ; // 1
                "Z�znam",                       ; // 2
                "Suma",                         ; // 3
                "Aktivn� t��d�n�",              ; // 4
                "Volby",                        ; // 5
                "Nov� z�znam",                  ; // 6
                "Uprav z�znam",                 ; // 7
                "Vyber z�znam",                 ; // 8
                "Najdi z�znam",                 ; // 9
                "Tiskni volby",                 ; // 10
                "Dostupn� pole",                ; // 11
                "Pole k tisku",                 ; // 12
                "Dostupn� tisk�rny",            ; // 13
                "Prvn� z�znam k tisku",         ; // 14
                "Posledn� z�znam k tisku",      ; // 15
                "Sma� z�znam",                  ; // 16
                "N�hled",                       ; // 17
                "Zobraz miniatury stran",       ; // 18
                "Filtr: ",                      ; // 19
                "Filtrov�n: ",                  ; // 20
                "Volby filtru",                 ; // 21
                "Pole datab�ze",                ; // 22
                "Oper�tor porovn�n�",           ; // 23
                "Hodnota filtru",               ; // 24
                "Vyber pole do filtru",         ; // 25
                "Vyber oper�tor porovn�n�",     ; // 26
                "rovno",                        ; // 27
                "nerovno",                      ; // 28
                "v�t�� ne�",                    ; // 29
                "men�� ne�",                    ; // 30
                "v�t�� nebo rovno ne�",         ; // 31
                "men�� nebo rovno ne�",         } // 32

	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Nelze naj�t aktivn� oblast   "  + ABM_CRLF + "Pros�m vyberte n�kterou p�ed vol�n�m EDIT   " + ABM_CRLF,     ; // 1
                "Zadejte hodnotu pole (libovoln� text)",                                                                                ; // 2
                "Zadejte hodnotu pole (libovoln� ��slo)",                                                                               ; // 3
                "Vyberte datum",                                                                                                        ; // 4
                "Zatrhn�te pro hodnotu true",                                                                                           ; // 5
                "Zadejte hodnotu pole",                                                                                                 ; // 6
                "Vyberte jak�koliv z�znam s stiskn�te OK",                                                                              ; // 7
                ABM_CRLF + "Chcete smazat tento z�znam  " + ABM_CRLF + "Jste si jist(a)?    " + ABM_CRLF,                               ; // 8
                ABM_CRLF + "Nen� vybr�no ��dn� t��d�n�   " + ABM_CRLF + "Pros�m zvolte jedno   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Nelze hledat podle pole memo nebo logic   " + ABM_CRLF,                                                     ; // 10
                ABM_CRLF + "Z�znam nenalezen   " + ABM_CRLF,                                                                            ; // 11
                "Vyberte pole k za�azen� do seznamu",                                                                                   ; // 12
                "Vyberte pole k vy�azen� ze seznamu",                                                                                   ; // 13
                "Vyberte tisk�rnu",                                                                                                     ; // 14
                "Stiskn�te tla��tko pro za�azen� pole",                                                                                 ; // 15
                "Stiskn�t� tla��tko k vy�azen� pole",                                                                                   ; // 16
                "Stiskn�te tla��tko k v�b�ru prvn�ho z�znamu k tisku",                                                                  ; // 17
                "Stiskn�t� tla��tko k v�b�ru posledn�ho z�znamu k tisku",                                                               ; // 18
                ABM_CRLF + "K za�azen� nezb�vaj� pole   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "Prvn� v�b�r pole k za�azen�   " + ABM_CRLF,                                                                 ; // 20
                ABM_CRLF + "Nelze vy�adit dal�� pole   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "Prvn� v�b�r pole k vy�azen�   " + ABM_CRLF,                                                                 ; // 22
                ABM_CRLF + "Nebylo vybr�no ��dn� pole   " + ABM_CRLF + "Pros�m vyberte pole pro za�azen� do tisku   " + ABM_CRLF,       ; // 23
                ABM_CRLF + "P��li� mnoho pol�   " + ABM_CRLF + "odeberte n�kter� pole   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Tisk�rna nen� p�ipravena   " + ABM_CRLF,                                                                    ; // 25
                "T��d�no dle",                                                                                                          ; // 26
                "Od z�znamu",                                                                                                           ; // 27
                "Do z�znamu",                                                                                                           ; // 28
                "Ano",                                                                                                                  ; // 29
                "Ne",                                                                                                                   ; // 30
                "Strana:",                                                                                                              ; // 31
                ABM_CRLF + "Pros�m vyberte tisk�rnu   " + ABM_CRLF,                                                                     ; // 32
                "Filtrov�no dle",                                                                                                       ; // 33
                ABM_CRLF + "Filtr nen� aktivn�    " + ABM_CRLF,                                                                         ; // 34
                ABM_CRLF + "Nelze filtrovat podle memo    " + ABM_CRLF,                                                                 ; // 35
                ABM_CRLF + "Vyberte pole do filtru    " + ABM_CRLF,                                                                     ; // 36
                ABM_CRLF + "Vybarte oper�tor do filtru    " + ABM_CRLF,                                                                 ; // 37
                ABM_CRLF + "Zadejte hodnotu do filtru    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "Nen� ��dn� aktivn� filtr    " + ABM_CRLF,                                                                   ; // 39
                ABM_CRLF + "Deactivovat filtr?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Z�znam uzam�en jin�m u�ivatelem  " + ABM_CRLF                                                                   } // 41

	/////////////////////////////////////////////////////////////
	// CROATIAN
	////////////////////////////////////////////////////////////
        // case cLang == "HR852" // Croatian
        case cLang == "HR"

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zatvori prozor'
		_hMG_SYSDATA [ 331 ] [3] := 'Zatvaranje nije dozvoljeno'
		_hMG_SYSDATA [ 331 ] [4] := 'Program je ve� pokrenut'
		_hMG_SYSDATA [ 331 ] [5] := 'Uredi'
		_hMG_SYSDATA [ 331 ] [6] := 'U redu'
		_hMG_SYSDATA [ 331 ] [7] := 'Prekid'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE MESSAGES 

        	_HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED MESSAGES

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
	        _HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
        	_HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

        case cLang == "EU"        // Basque.
	/////////////////////////////////////////////////////////////
	// BASQUE
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Close Window'
		_hMG_SYSDATA [ 331 ] [3] := 'Close not allowed'
		_hMG_SYSDATA [ 331 ] [4] := 'Program Already Running'
		_hMG_SYSDATA [ 331 ] [5] := 'Edit'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancel'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	


		// BROWSE MESSAGES 

        	_HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {            ;
                                "&Itxi",             ; // 1
                                "&Berria",           ; // 2
                                "&Aldatu",           ; // 3
                                "&Ezabatu",          ; // 4
                                "Bi&latu",           ; // 5
                                "In&primatu",        ; // 6
                                "&Utzi",             ; // 7
                                "&Ok",               ; // 8
                                "&Kopiatu",          ; // 9
                                "I&ragazkia Ezarri", ; // 10
                                "Ira&gazkia Kendu"   } // 11
                        _HMG_SYSDATA [ 129 ] := {                              ;
                                "Bat ere ez",                         ; // 1
                                "Erregistroa",                        ; // 2
                                "Guztira",                            ; // 3
                                "Orden Aktiboa",                      ; // 4
                                "Aukerak",                            ; // 5
                                "Erregistro Berria",                  ; // 6
                                "Erregistroa Aldatu",                 ; // 7
                                "Erregistroa Aukeratu",               ; // 8
                                "Erregistroa Bilatu",                 ; // 9
                                "Inprimatze-aukerak",                 ; // 10
                                "Eremu Libreak",                      ; // 11
                                "Inprimatzeko Eremuak",               ; // 12
                                "Inprimagailu Libreak",               ; // 13
                                "Inprimatzeko Lehenengo Erregistroa", ; // 14
                                "Inprimatzeko Azken Erregistroa",     ; // 15
                                "Erregistroa Ezabatu",                ; // 16
                                "Aurreikusi",                         ; // 17
                                "Orrien Irudi Txikiak Ikusi",         ; // 18
                                "Iragazkiaren Baldintza: ",           ; // 19
                                "Iragazita: ",                        ; // 20
                                "Iragazte-aukerak" ,                  ; // 21
                                "Datubasearen Eremuak" ,              ; // 22
                                "Konparaketa Eragilea",               ; // 23
                                "Iragazkiaren Balioa",                ; // 24
                                "Iragazteko Eremua Aukeratu",         ; // 25
                                "Konparaketa Eragilea Aukeratu",      ; // 26
                                "Berdin",                             ; // 27
                                "Ezberdin",                           ; // 28
                                "Handiago",                           ; // 29
                                "Txikiago",                           ; // 30
                                "Handiago edo Berdin",                ; // 31
                                "Txikiago edo Berdin"                 } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Ezin da area aktiborik aurkitu.   "  + ABM_CRLF + "Mesedez aukeratu area EDIT deitu baino lehen   " + ABM_CRLF,  ; // 1
                                "Eremuaren balioa idatzi (edozein testu)",                                                                                   ; // 2
                                "Eremuaren balioa idatzi (edozein zenbaki)",                                                                                 ; // 3
                                "Data aukeratu",                                                                                                             ; // 4
                                "Markatu egiazko baliorako",                                                                                                 ; // 5
                                "Eremuaren balioa sartu",                                                                                                    ; // 6
                                "Edozein erregistro aukeratu eta OK sakatu",                                                                                 ; // 7
                                ABM_CRLF + "Erregistro aktiboa ezabatuko duzu   " + ABM_CRLF + "Ziur zaude?    " + ABM_CRLF,                                 ; // 8
                                ABM_CRLF + "Ez dago orden aktiborik   " + ABM_CRLF + "Mesedez aukeratu bat   " + ABM_CRLF,                                   ; // 9
                                ABM_CRLF + "Memo edo eremu logikoen arabera ezin bilaketarik egin   " + ABM_CRLF,                                            ; // 10
                                ABM_CRLF + "Erregistroa ez da aurkitu   " + ABM_CRLF,                                                                        ; // 11
                                "Zerrendan sartzeko eremua aukeratu",                                                                                        ; // 12
                                "Zerrendatik kentzeko eremua aukeratu",                                                                                      ; // 13
                                "Inprimagailua aukeratu",                                                                                                    ; // 14
                                "Sakatu botoia eremua sartzeko",                                                                                             ; // 15
                                "Sakatu botoia eremua kentzeko",                                                                                             ; // 16
                                "Sakatu botoia inprimatzeko lehenengo erregistroa aukeratzeko",                                                              ; // 17
                                "Sakatu botoia inprimatzeko azken erregistroa aukeratzeko",                                                                  ; // 18
                                ABM_CRLF + "Sartzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 19
                                ABM_CRLF + "Lehenago aukeratu sartzeko eremua   " + ABM_CRLF,                                                                ; // 20
                                ABM_CRLF + "Kentzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 21
                                ABM_CRLF + "Lehenago aukeratu kentzeko eremua   " + ABM_CRLF,                                                                ; // 22
                                ABM_CRLF + "Ez duzu eremurik aukeratu  " + ABM_CRLF + "Mesedez aukeratu inprimaketan sartzeko eremuak   " + ABM_CRLF,        ; // 23
                                ABM_CRLF + "Eremu gehiegi   " + ABM_CRLF + "Murriztu eremu kopurua   " + ABM_CRLF,                                           ; // 24
                                ABM_CRLF + "Inprimagailua ez dago prest   " + ABM_CRLF,                                                                      ; // 25
                                "Ordenatuta honen arabera:",                                                                                                 ; // 26
                                "Erregistro honetatik:",                                                                                                     ; // 27
                                "Erregistro honetara:",                                                                                                      ; // 28
                                "Bai",                                                                                                                       ; // 29
                                "Ez",                                                                                                                        ; // 30
                                "Orrialdea:",                                                                                                                ; // 31
                                ABM_CRLF + "Mesedez aukeratu inprimagailua   " + ABM_CRLF,                                                                   ; // 32
                                "Iragazita honen arabera:",                                                                                                  ; // 33
                                ABM_CRLF + "Iragazki aktiboa dago    " + ABM_CRLF,                                                                           ; // 34
                                ABM_CRLF + "Ezin iragazi Memo eremuen arabera    " + ABM_CRLF,                                                               ; // 35
                                ABM_CRLF + "Iragazteko eremua aukeratu    " + ABM_CRLF,                                                                      ; // 36
                                ABM_CRLF + "Iragazteko edozein eragile aukeratu    " + ABM_CRLF,                                                             ; // 37
                                ABM_CRLF + "Idatzi edozein balio iragazteko    " + ABM_CRLF,                                                                 ; // 38
                                ABM_CRLF + "Ez dago iragazki aktiborik    " + ABM_CRLF,                                                                      ; // 39
                                ABM_CRLF + "Iragazkia kendu?   " + ABM_CRLF,                                                                                  ; // 40                
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

        case cLang == "EN"        // English
	/////////////////////////////////////////////////////////////
	// ENGLISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES (ENGLISH DEFAULT)

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Close Window'
		_hMG_SYSDATA [ 331 ] [3] := 'Close not allowed'
		_hMG_SYSDATA [ 331 ] [4] := 'Program Already Running'
		_hMG_SYSDATA [ 331 ] [5] := 'Edit'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancel'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE MESSAGES (ENGLISH DEFAULT)

        	_HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES (ENGLISH DEFAULT)

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

        case cLang == "FR"        // French
	/////////////////////////////////////////////////////////////
	// FRENCH
	////////////////////////////////////////////////////////////


		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Etes-vous s�re ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Fermer la fen�tre'
		_hMG_SYSDATA [ 331 ] [3] := 'Fermeture interdite'
		_hMG_SYSDATA [ 331 ] [4] := 'Programme d�j� activ�'
		_hMG_SYSDATA [ 331 ] [5] := 'Editer'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Abandonner'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Fen�tre: "                                             ,;
                                     " n'est pas d�finie. Programme termin�"                 ,;
                                     "Erreur HMG"                                        ,;
                                     "Contr�le: "                                            ,;
                                     " De "                                                  ,;
				     " D�j� d�fini. Programme termin�"                       ,;
				     "Modification: Type non autoris�. Programme termin�"    ,;
				     "Modification: La clause Ajout ne peut �tre utilis�e avec des champs n'appartenant pas � la zone de travail de Modification. Programme termin�",;
				     "L'enregistrement est utilis� par un autre utilisateur"  ,;
				     "Erreur"                                                ,;
				     "Entr�e invalide"                                        }
                _HMG_SYSDATA [ 137 ] := { 'Etes-vous s�re ?' , 'Enregistrement d�truit' }

		// EDIT 

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Suppression d'enregistrement"+CHR(13)+"Etes-vous s�re ?"+CHR(13)  ,;
                                     CHR(13)+"Index manquant"+CHR(13)+"Recherche impossible"+CHR(13)            ,;
                                     CHR(13)+"Champ Index introuvable"+CHR(13)+"Recherche impossible"+CHR(13)   ,;
                                     CHR(13)+"Recherche impossible"+CHR(13)+"sur champs memo ou logique"+CHR(13),;
                                     CHR(13)+"Enregistrement non trouv�"+CHR(13)                                                     ,;
                                     CHR(13)+"Trop de colonnes"+CHR(13)+"L'�tat ne peut �tre imprim�"+CHR(13)      }
                _HMG_SYSDATA [ 132 ]  := { "Enregistrement"                       ,;
                                     "Nb. total enr."                       ,;
                                     "   (Ajouter)"                        ,;
                                     "  (Modifier)"                        ,;
                                     "Entrez le num�ro de l'enregistrement" ,;
                                     "Trouver"                              ,;
                                     "Chercher texte"                       ,;
                                     "Chercher date"                        ,;
                                     "Chercher num�ro"                      ,;
                                     "D�finition de l'�tat"                 ,;
                                     "Colonnes de l'�tat"                   ,;
                                     "Colonnes disponibles"                 ,;
                                     "Enregistrement de d�but"              ,;
                                     "Enregistrement de fin"                ,;
                                     "Etat de "                             ,;
                                     "Date:"                                ,;
                                     "Enregistrement de d�but:"             ,;
                                     "Enregistrement de fin:"               ,;
                                     "Tri� par:"                            ,;
                                     "Oui"                                  ,;
                                     "Non"                                  ,;
                                     " Page"                                ,;
                                     " de "                                 }
                _HMG_SYSDATA [ 133 ] := { "Fermer"      ,;
                                     "Nouveau"     ,;
                                     "Modifier"    ,;
                                     "Supprimer"   ,;
                                     "Trouver"     ,;
                                     "Aller �"     ,;
                                     "Etat"   ,;
                                     "Premier"     ,;
                                     "Pr�c�dent"   ,;
                                     "Suivant"     ,;
                                     "Dernier"     ,;
                                     "Enregistrer" ,;
                                     "Annuler"     ,;
                                     "Ajouter"     ,;
                                     "Retirer"     ,;
                                     "Imprimer"    ,;
                                     "Fermer"      }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, nom de la table manquant"                                         ,;
                                     "EDIT, la table a plus de 16 champs"                                     ,;
                                     "EDIT, mode rafraichissement hors limite (Rapport d'erreur merci)"       ,;
                                     "EDIT, �v�nement principal nombre hors limite (Rapport d'erreur merci)"  ,;
                                     "EDIT, liste d'�v�nements nombre hors limite (Rapport d'erreur merci)"   }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {           ;
                                "&Fermer",          ; // 1
                                "&Nouveau",         ; // 2
                                "&Modifier",        ; // 3
                                "&Supprimer",       ; // 4
                                "&Trouver",         ; // 5
                                "&Imprimer",        ; // 6
                                "&Abandon",         ; // 7
                                "&Ok",              ; // 8
                                "&Copier",          ; // 9
                                "&Activer Filtre",  ; // 10
                                "&D�activer Filtre" } // 11
                        _HMG_SYSDATA [ 129 ] := {                                   ;
                                "Aucun",                                   ; // 1
                                "Enregistrement",                          ; // 2
                                "Total",                                   ; // 3
                                "Ordre actif",                             ; // 4
                                "Options",                                 ; // 5
                                "Nouvel enregistrement",                   ; // 6
                                "Modifier enregistrement",                 ; // 7
                                "Selectionner enregistrement",             ; // 8
                                "Trouver enregistrement",                  ; // 9
                                "Imprimer options",                        ; // 10
                                "Champs disponibles",                      ; // 11
                                "Champs � imprimer",                       ; // 12
                                "Imprimantes connect�es",                  ; // 13
                                "Premier enregistrement � imprimer",       ; // 14
                                "Dernier enregistrement � imprimer",       ; // 15
                                "Enregistrement supprim�",                 ; // 16
                                "Pr�visualisation",                        ; // 17
                                "Aper�u pages",                            ; // 18
                                "Condition filtre : ",                     ; // 19
                                "Filtr� : ",                               ; // 20
                                "Options de filtrage" ,                    ; // 21
                                "Champs de la Bdd" ,                       ; // 22
                                "Op�rateurs de comparaison",               ; // 23
                                "Valeur du filtre",                        ; // 24
                                "Selectionner le champ � filtrer",         ; // 25
                                "Selectionner l'op�rateur de comparaison", ; // 26
                                "Egal",                                    ; // 27
                                "Diff�rent",                               ; // 28
                                "Plus grand",                              ; // 29
                                "Plus petit",                              ; // 30
                                "Plus grand ou �gal",                      ; // 31
                                "Plus petit ou �gal"                       } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Ne peut trouver une base active.   "  + ABM_CRLF + "S�lectionner une base avant la fonction EDIT  " + ABM_CRLF,           ; // 1
                                "Entrer la valeur du champ (du texte)",                                                                                               ; // 2
                                "Entrer la valeur du champ (un nombre)",                                                                                              ; // 3
                                "S�lectionner la date",                                                                                                               ; // 4
                                "V�rifier la valeur logique",                                                                                                         ; // 5
                                "Entrer la valeur du champ",                                                                                                          ; // 6
                                "S�lectionner un enregistrement et appuyer sur OK",                                                                                   ; // 7
                                ABM_CRLF + "Vous voulez d�truire l'enregistrement actif  " + ABM_CRLF + "Etes-vous s�re?   " + ABM_CRLF,                              ; // 8
                                ABM_CRLF + "Il n'y a pas d'ordre actif   " + ABM_CRLF + "S�lectionner en un   " + ABM_CRLF,                                           ; // 9
                                ABM_CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + ABM_CRLF,                                                      ; // 10
                                ABM_CRLF + "Enregistrement non trouv�  " + ABM_CRLF,                                                                                  ; // 11
                                "S�lectionner le champ � inclure � la liste",                                                                                         ; // 12
                                "S�lectionner le champ � exclure de la liste",                                                                                        ; // 13
                                "S�lectionner l'imprimante",                                                                                                          ; // 14
                                "Appuyer sur le bouton pour inclure un champ",                                                                                        ; // 15
                                "Appuyer sur le bouton pour exclure un champ",                                                                                        ; // 16
                                "Appuyer sur le bouton pour s�lectionner le premier enregistrement � imprimer",                                                       ; // 17
                                "Appuyer sur le bouton pour s�lectionner le dernier champ � imprimer",                                                                ; // 18
                                ABM_CRLF + "Plus de champs � inclure   " + ABM_CRLF,                                                                                  ; // 19
                                ABM_CRLF + "S�lectionner d'abord les champs � inclure   " + ABM_CRLF,                                                                 ; // 20
                                ABM_CRLF + "Plus de champs � exclure   " + ABM_CRLF,                                                                                  ; // 21
                                ABM_CRLF + "S�lectionner d'abord les champs � exclure   " + ABM_CRLF,                                                                 ; // 22
                                ABM_CRLF + "Vous n'avez s�lectionn� aucun champ   " + ABM_CRLF + "S�lectionner les champs � inclure dans l'impression   " + ABM_CRLF, ; // 23
                                ABM_CRLF + "Trop de champs   " + ABM_CRLF + "R�duiser le nombre de champs   " + ABM_CRLF,                                             ; // 24
                                ABM_CRLF + "Imprimante pas pr�te   " + ABM_CRLF,                                                                                      ; // 25
                                "Tri� par",                                                                                                                           ; // 26
                                "De l'enregistrement",                                                                                                                ; // 27
                                "A l'enregistrement",                                                                                                                 ; // 28
                                "Oui",                                                                                                                                ; // 29
                                "Non",                                                                                                                                ; // 30
                                "Page:",                                                                                                                              ; // 31
                                ABM_CRLF + "S�lectionner une imprimante   " + ABM_CRLF,                                                                               ; // 32
                                "Filtr� par",                                                                                                                         ; // 33
                                ABM_CRLF + "Il y a un filtre actif    " + ABM_CRLF,                                                                                   ; // 34
                                ABM_CRLF + "Filtre impossible sur champ memo    " + ABM_CRLF,                                                                         ; // 35
                                ABM_CRLF + "S�lectionner un champ de filtre    " + ABM_CRLF,                                                                          ; // 36
                                ABM_CRLF + "S�lectionner un op�rateur de filtre   " + ABM_CRLF,                                                                       ; // 37
                                ABM_CRLF + "Entrer une valeur au filtre    " + ABM_CRLF,                                                                              ; // 38
                                ABM_CRLF + "Il n'y a aucun filtre actif    " + ABM_CRLF,                                                                              ; // 39
                                ABM_CRLF + "D�sactiver le filtre?   " + ABM_CRLF,                                                                                     ; // 40
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

       // case cLang == "DEWIN" .OR. cLang == "DE"       // German
       case cLang == "DE"
	/////////////////////////////////////////////////////////////
	// GERMAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Sind Sie sicher ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Fenster schlie�en'
		_hMG_SYSDATA [ 331 ] [3] := 'Schlie�en nicht erlaubt'
		_hMG_SYSDATA [ 331 ] [4] := 'Programm l�uft bereits'
		_hMG_SYSDATA [ 331 ] [5] := 'Bearbeiten'
		_hMG_SYSDATA [ 331 ] [6] := 'OK'
		_hMG_SYSDATA [ 331 ] [7] := 'Abbrechen'
		_hMG_SYSDATA [ 331 ] [8] := 'Seite'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
                _HMG_SYSDATA [ 137 ] := { 'Sind Sie sicher ?' , 'Datensatz l�schen' }

		// EDIT

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Datensatz loeschen"+CHR(13)+"Sind Sie sicher ?"+CHR(13)                 ,;
                                     CHR(13)+" Falscher Indexdatensatz"+CHR(13)+"Suche unmoeglich"+CHR(13)         ,;
                                     CHR(13)+"Man kann nicht Indexdatenfeld finden"+CHR(13)+"Suche unmoeglich"+CHR(13) ,;
                                     CHR(13)+"Suche unmoeglich nach"+CHR(13)+"Feld memo oder logisch"+CHR(13)         ,;
                                     CHR(13)+"Datensatz nicht gefunden"+CHR(13)                                                     ,;
                                     CHR(13)+" zu viele Spalten"+CHR(13)+"Zu wenig Platz  fuer die Meldung auf dem Blatt" + CHR(13) }
                _HMG_SYSDATA [ 132 ]  := { "Datensatz"              ,;
                                     "Menge der Dat."        ,;
                                     "       (Neu)"        ,;
                                     " (Editieren)"        ,;
                                     "Datensatznummer eintragen" ,;
                                     "Suche"                ,;
                                     "Suche Text"         ,;
                                     "Suche Datum"         ,;
                                     "Suche Zahl"       ,;
                                     "Definition der Meldung"   ,;
                                     "Spalten der Meldung"      ,;
                                     "Zugaengliche Spalten"     ,;
                                     "Anfangsdatensatz"      ,;
                                     "Endedatensatz"        ,;
                                     "Datensatz vom "          ,;
                                     "Datum:"               ,;
                                     "Anfangsdatensatz:"     ,;
                                     "Endedatensatz:"       ,;
                                     "Sortieren nach:"         ,;
                                     "Ja"                 ,;
                                     "Nein"                  ,;
                                     "Seite "               ,;
                                     " von "                 }
                _HMG_SYSDATA [ 133 ] := { "Schliesse"    ,;
                                     "Neu"      ,;
                                     "Editiere"     ,;
                                     "Loesche"   ,;
                                     "Finde"     ,;
                                     "Gehe zu"     ,;
                                     "Meldung"   ,;
                                     "Erster"    ,;
                                     "Zurueck" ,;
                                     "Naechst"     ,;
                                     "Letzter"     ,;
                                     "Speichern"     ,;
                                     "Aufheben"   ,;
                                     "Hinzufuegen"      ,;
                                     "Loeschen"   ,;
                                     "Drucken"    ,;
                                     "Schliessen"     }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, falscher Name von Datenbank"                                  ,;
                                     "EDIT, Datenbank hat mehr als 16 Felder"                   ,;
                                     "EDIT, Auffrische-Modus ausser dem Bereich (siehe Fehlermeldungen)"      ,;
                                     "EDIT, Menge der Basisereignisse ausser dem Bereich (siehe Fehlermeldungen)" ,;
                                     "EDIT, Liste der Ereignisse ausser dem Bereich (siehe Fehlermeldungen)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {              ;
                                "S&chlie�en",          ; // 1
                                "&Neu",                ; // 2
                                "&Bearbeiten",         ; // 3
                                "&L�schen",            ; // 4
                                "&Suchen",             ; // 5
                                "&Drucken",            ; // 6
                                "&Abbruch",            ; // 7
                                "&Ok",                 ; // 8
                                "&Kopieren",           ; // 9
                                "&Filter aktivieren",  ; // 10
                                "&Filter deaktivieren" } // 11
                        _HMG_SYSDATA [ 129 ] := {                                         ;
                                "Keine",                                         ; // 1
                                "Datensatz",                                     ; // 2
                                "Gesamt",                                        ; // 3
                                "Aktive Sortierung",                             ; // 4
                                "Einstellungen",                                 ; // 5
                                "Neuer Datensatz",                               ; // 6
                                "Datensatz bearbeiten",                          ; // 7
                                "Datensatz ausw�hlen",                           ; // 8
                                "Datensatz finden",                              ; // 9
                                "Druckeinstellungen",                            ; // 10
                                "Verf�gbare Felder",                             ; // 11
                                "Zu druckende Felder",                           ; // 12
                                "Verf�gbare Drucker",                            ; // 13
                                "Erster zu druckender Datensatz",                ; // 14
                                "Letzter zu druckender Datensatz",               ; // 15
                                "Datensatz l�schen",                             ; // 16
                                "Vorschau",                                      ; // 17
                                "�bersicht",                                     ; // 18
                                "Filterbedingung: ",                             ; // 19
                                "Gefiltert: ",                                   ; // 20
                                "Filter-Einstellungen" ,                         ; // 21
                                "Datenbank-Felder" ,                             ; // 22
                                "Vergleichs-Operator",                           ; // 23
                                "Filterwert",                                    ; // 24
                                "Zu filterndes Feld ausw�hlen",                  ; // 25
                                "Vergleichs-Operator ausw�hlen",                 ; // 26
                                "Gleich",                                        ; // 27
                                "Ungleich",                                      ; // 28
                                "Gr��er als",                                    ; // 29
                                "Kleiner als",                                   ; // 30
                                "Gr��er oder gleich als",                        ; // 31
                                "Kleiner oder gleich als"                        } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Kein aktiver Arbeitsbereich gefunden.   "  + ABM_CRLF + "Bitte einen Arbeitsbereich ausw�hlen vor dem Aufruf von EDIT   " + ABM_CRLF,       ; // 1
                                "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 2
                                "Eine Zahl eingeben",                                                                                                                                   ; // 3
                                "Datum ausw�hlen",                                                                                                                                      ; // 4
                                "F�r positive Auswahl einen Haken setzen",                                                                                                              ; // 5
                                "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 6
                                "Einen Datensatz w�hlen und mit OK best�tigen",                                                                                                         ; // 7
                                ABM_CRLF + "Sie sind im Begriff, den aktiven Datensatz zu l�schen.   " + ABM_CRLF + "Sind Sie sicher?    " + ABM_CRLF,                                  ; // 8
                                ABM_CRLF + "Es ist keine Sortierung aktiv.   " + ABM_CRLF + "Bitte w�hlen Sie eine Sortierung   " + ABM_CRLF,                                           ; // 9
                                ABM_CRLF + "Suche nach den Feldern memo oder logisch nicht m�glich.   " + ABM_CRLF,                                                                     ; // 10
                                ABM_CRLF + "Datensatz nicht gefunden   " + ABM_CRLF,                                                                                                    ; // 11
                                "Bitte ein Feld zum Hinzuf�gen zur Liste w�hlen",                                                                                                       ; // 12
                                "Bitte ein Feld zum Entfernen aus der Liste w�hlen ",                                                                                                   ; // 13
                                "Drucker ausw�hlen",                                                                                                                                    ; // 14
                                "Schaltfl�che  Feld hinzuf�gen",                                                                                                                        ; // 15
                                "Schaltfl�che  Feld Entfernen",                                                                                                                         ; // 16
                                "Schaltfl�che  Auswahl erster zu druckender Datensatz",                                                                                                 ; // 17
                                "Schaltfl�che  Auswahl letzte zu druckender Datensatz",                                                                                                 ; // 18
                                ABM_CRLF + "Keine Felder zum Hinzuf�gen mehr vorhanden   " + ABM_CRLF,                                                                                  ; // 19
                                ABM_CRLF + "Bitte erst ein Feld zum Hinzuf�gen w�hlen   " + ABM_CRLF,                                                                                   ; // 20
                                ABM_CRLF + "Keine Felder zum Entfernen vorhanden   " + ABM_CRLF,                                                                                        ; // 21
                                ABM_CRLF + "Bitte ein Feld zum Entfernen w�hlen   " + ABM_CRLF,                                                                                         ; // 22
                                ABM_CRLF + "Kein Feld ausgew�hlt   " + ABM_CRLF + "Bitte die Felder f�r den Ausdruck ausw�hlen   " + ABM_CRLF,                                          ; // 23
                                ABM_CRLF + "Zu viele Felder   " + ABM_CRLF + "Bitte Anzahl der Felder reduzieren   " + ABM_CRLF,                                                        ; // 24
                                ABM_CRLF + "Drucker nicht bereit   " + ABM_CRLF,                                                                                                        ; // 25
                                "Sortiert nach",                                                                                                                                        ; // 26
                                "Von Datensatz",                                                                                                                                        ; // 27
                                "Bis Datensatz",                                                                                                                                        ; // 28
                                "Ja",                                                                                                                                                   ; // 29
                                "Nein",                                                                                                                                                 ; // 30
                                "Seite:",                                                                                                                                               ; // 31
                                ABM_CRLF + "Bitte einen Drucker w�hlen   " + ABM_CRLF,                                                                                                  ; // 32
                                "Filtered by",                                                                                                                                          ; // 33
                                ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 34
                                ABM_CRLF + "Kann nicht nach Memo-Feldern filtern    " + ABM_CRLF,                                                                                       ; // 35
                                ABM_CRLF + "Feld zum Filtern ausw�hlen    " + ABM_CRLF,                                                                                                 ; // 36
                                ABM_CRLF + "Einen Operator zum Filtern ausw�hlen    " + ABM_CRLF,                                                                                       ; // 37
                                ABM_CRLF + "Bitte einen Wert f�r den Filter angeben    " + ABM_CRLF,                                                                                    ; // 38
                                ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 39
                                ABM_CRLF + "Filter deaktivieren?   " + ABM_CRLF,                                                                                                         ; // 40
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

	case cLang == "IT"        // Italian
	/////////////////////////////////////////////////////////////
	// ITALIAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Sei sicuro ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Chiudi la finestra'
		_hMG_SYSDATA [ 331 ] [3] := 'Chiusura non consentita'
		_hMG_SYSDATA [ 331 ] [4] := 'Il programma � gi� in esecuzione'
		_hMG_SYSDATA [ 331 ] [5] := 'Edita'
		_hMG_SYSDATA [ 331 ] [6] := 'Conferma'
		_hMG_SYSDATA [ 331 ] [7] := 'Annulla'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

		_HMG_SYSDATA [ 136 ]  := { "Window: " ,;
                    " non � definita. Programma terminato" ,;
                    "Errore HMG"  ,;
                    "Controllo: " ,;
                    " Di " ,;
                    " Gi� definito. Programma Terminato" ,;
               	"Browse: Tipo non valido. Programma Terminato"  ,;
                "Browse: Modifica non possibile: il campo non � pertinente l'area di lavoro.Programma Terminato",;
                "Record gi� utilizzato da altro utente"                 ,;     
		"Attenzione!"                                           ,;
                "Dato non valido" }
                _HMG_SYSDATA [ 137 ] := { 'Sei sicuro ?' , 'Cancella Record' }

		// EDIT 

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Cancellare il record"+CHR(13)+"Sei sicuro ?"+CHR(13)                  ,;
                 	             CHR(13)+"File indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)            ,;
                     		     CHR(13)+"Campo indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)        ,;
                     		     CHR(13)+"Ricerca impossibile per"+CHR(13)+"campi memo o logici"+CHR(13)       ,;
                     		     CHR(13)+"Record non trovato"+CHR(13)                                        ,;
                                     CHR(13)+"Troppe colonne"+CHR(13)+"Il report non pu� essere stampato"+CHR(13) }
		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     		     "Record totali"       ,;
                     		     "  (Aggiungi)"        ,;
                     		     "     (Nuovo)"        ,;
                     		     "Inserire il numero del record" ,;
                     		     "Ricerca"                ,;
                     		     "Testo da cercare"         ,;
                     		     "Data da cercare"         ,;
                     		     "Numero da cercare"       ,;
                      		     "Definizione del report"   ,;
                     		     "Colonne del report"      ,;
                     		     "Colonne totali"     ,;
                     		     "Record Iniziale"      ,;
                     		     "Record Finale"        ,;
                     		     "Report di "          ,;
                     		     "Data:"               ,;
                     		     "Primo Record:"     ,;
                     		     "Ultimo Record:"       ,;
                     		     "Ordinare per:"         ,;
                     		     "S�"                 ,;
                     		     "No"                  ,;
                     		     "Pagina "               ,;
                     		     " di "                 }
		_HMG_SYSDATA [ 133 ] := { "Chiudi"    ,;
                     		     "Nuovo"      ,;
                     		     "Modifica"     ,;
                     		     "Cancella"   ,;
                     		     "Ricerca"     ,;
                     		     "Vai a"     ,;
                     		     "Report"   ,;
                     		     "Primo"    ,;
                     		     "Precedente" ,;
                     		     "Successivo"     ,;
                     		     "Ultimo"     ,;
                     		     "Salva"     ,;
                     		     "Annulla"   ,;
                     		     "Aggiungi"      ,;
                     		     "Rimuovi"   ,;
                     		     "Stampa"    ,;
                     		     "Chiudi"     }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, il nome dell'area � mancante"                              ,;
                       		     "EDIT, quest'area contiene pi� di 16 campi"              ,;
                     		     "EDIT, modalit� aggiornamento fuori dal limite (segnalare l'errore)"      ,;
                     		     "EDIT, evento pricipale fuori dal limite (segnalare l'errore)" ,;
                     		     "EDIT, lista eventi fuori dal limite (segnalare l'errore)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {           ;
                                "&Chiudi",          ; // 1
                                "&Nuovo",           ; // 2
                                "&Modifica",        ; // 3
                                "&Cancella",        ; // 4
                                "&Trova",           ; // 5
                                "&Stampa",          ; // 6
                                "&Annulla",         ; // 7
                                "&Ok",              ; // 8
                                "C&opia",           ; // 9
                                "A&ttiva Filtro",   ; // 10
                                "&Disattiva Filtro" } // 11
                        _HMG_SYSDATA [ 129 ] := {                            ;
                                "Nessuno",                          ; // 1
                                "Record",                           ; // 2
                                "Totale",                           ; // 3
                                "Ordinamento attivo",               ; // 4
                                "Opzioni",                          ; // 5
                                "Nuovo record",                     ; // 6
                                "Modifica record",                  ; // 7
                                "Seleziona record",                 ; // 8
                                "Trova record",                     ; // 9
                                "Stampa opzioni",                   ; // 10
                                "Campi disponibili",                ; // 11
                                "Campi da stampare",                ; // 12
                                "Stampanti disponibili",            ; // 13
                                "Primo  record da stampare",        ; // 14
                                "Ultimo record da stampare",        ; // 15
                                "Cancella record",                  ; // 16
                                "Anteprima",                        ; // 17
                                "Visualizza pagina miniature",      ; // 18
                                "Condizioni Filtro: ",              ; // 19
                                "Filtrato: ",                       ; // 20
                                "Opzioni Filtro" ,                  ; // 21
                                "Campi del Database" ,              ; // 22
                                "Operatori di comparazione",        ; // 23
                                "Valore Filtro",                    ; // 24
                                "Seleziona campo da filtrare",      ; // 25
                                "Seleziona operatore comparazione", ; // 26
                                "Uguale",                           ; // 27
                                "Non Uguale",                       ; // 28
                                "Maggiore di",                      ; // 29
                                "Minore di",                        ; // 30
                                "Maggiore o uguale a",              ; // 31
                                "Minore o uguale a"                 } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Nessuna area attiva.   "  + ABM_CRLF + "Selezionare un'area prima della chiamata a EDIT   " + ABM_CRLF,  ; // 1
                                "Digitare valore campo (testo)",                                                                                     ; // 2
                                "Digitare valore campo (numerico)",                                                                                  ; // 3
                                "Selezionare data",                                                                                                  ; // 4
                                "Attivare per valore TRUE",                                                                                          ; // 5
                                "Inserire valore campo",                                                                                             ; // 6
                                "Seleziona un record and premi OK",                                                                                  ; // 7
                                ABM_CRLF + "Cancellazione record attivo   " + ABM_CRLF + "Sei sicuro?      " + ABM_CRLF,                             ; // 8
                                ABM_CRLF + "Nessun ordinamento attivo     " + ABM_CRLF + "Selezionarne uno " + ABM_CRLF,                             ; // 9
                                ABM_CRLF + "Ricerca non possibile su campi MEMO o LOGICI   " + ABM_CRLF,                                             ; // 10
                                ABM_CRLF + "Record non trovato   " + ABM_CRLF,                                                                       ; // 11
                                "Seleziona campo da includere nel listato",                                                                          ; // 12
                                "Seleziona campo da escludere dal listato",                                                                          ; // 13
                                "Selezionare la stampante",                                                                                          ; // 14
                                "Premi per includere il campo",                                                                                      ; // 15
                                "Premi per escludere il campo",                                                                                      ; // 16
                                "Premi per selezionare il primo record da stampare",                                                                 ; // 17
                                "Premi per selezionare l'ultimo record da stampare",                                                                 ; // 18
                                ABM_CRLF + "Nessun altro campo da inserire   " + ABM_CRLF,                                                           ; // 19
                                ABM_CRLF + "Prima seleziona il campo da includere " + ABM_CRLF,                                                      ; // 20
                                ABM_CRLF + "Nessun altro campo da escludere       " + ABM_CRLF,                                                      ; // 21
                                ABM_CRLF + "Prima seleziona il campo da escludere " + ABM_CRLF,                                                      ; // 22
                                ABM_CRLF + "Nessun campo selezionato     " + ABM_CRLF + "Selezionare campi da includere nel listato   " + ABM_CRLF,  ; // 23
                                ABM_CRLF + "Troppi campi !   " + ABM_CRLF + "Redurre il numero di campi   " + ABM_CRLF,                              ; // 24
                                ABM_CRLF + "Stampante non pronta..!   " + ABM_CRLF,                                                                  ; // 25
                                "Ordinato per",                                                                                                      ; // 26
                                "Dal record",                                                                                                        ; // 27
                                "Al  record",                                                                                                        ; // 28
                                "Si",                                                                                                                ; // 29
                                "No",                                                                                                                ; // 30
                                "Pagina:",                                                                                                           ; // 31
                                ABM_CRLF + "Selezionare una stampante   " + ABM_CRLF,                                                                ; // 32
                                "Filtrato per ",                                                                                                     ; // 33
                                ABM_CRLF + "Esiste un filtro attivo     " + ABM_CRLF,                                                                ; // 34
                                ABM_CRLF + "Filtro non previsto per campi MEMO   " + ABM_CRLF,                                                       ; // 35
                                ABM_CRLF + "Selezionare campo da filtrare        " + ABM_CRLF,                                                       ; // 36
                                ABM_CRLF + "Selezionare un OPERATORE per filtro  " + ABM_CRLF,                                                       ; // 37
                                ABM_CRLF + "Digitare un valore per filtro        " + ABM_CRLF,                                                       ; // 38
                                ABM_CRLF + "Nessun filtro attivo    " + ABM_CRLF,                                                                    ; // 39
                                ABM_CRLF + "Disattivare filtro ?   " + ABM_CRLF,                                                                     ; // 40
                                ABM_CRLF + "Record bloccato da altro utente" + ABM_CRLF                                                              } // 41

        // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish 
        case cLang == "PL"
	/////////////////////////////////////////////////////////////
	// POLISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Czy jeste� pewny ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zamknij okno'
		_hMG_SYSDATA [ 331 ] [3] := 'Zamkni�cie niedozwolone'
		_hMG_SYSDATA [ 331 ] [4] := 'Program ju� uruchomiony'
		_hMG_SYSDATA [ 331 ] [5] := 'Edycja'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Porzu�'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "Okno: "                                              ,;
                                     " nie zdefiniowane.Program zako�czony"         ,;
                                     "B��d HMG"                                         ,;
                                     "Kontrolka: "                                             ,;
                                     " z "                                                  ,;
				     " ju� zdefiniowana. Program zako�czony"                  ,;
				     "Browse: Niedozwolony typ danych. Program zako�czony"          ,;
				     "Browse: Klauzula Append nie mo�e by� stosowana do p�l nie nale��cych do aktualnego obszaru roboczego. Program zako�czony",;
				     "Rekord edytowany przez innego u�ytkownika"                ,;
				     "Ostrze�enie"                                               ,;
				     "Nieprawid�owy wpis"                                          }
                _HMG_SYSDATA [ 137 ] := { 'Czy jesteo pewny ?' , 'Skasuj rekord' }  

		// EDIT

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Usuni�cie rekordu"+CHR(13)+"Jeste� pewny ?"+CHR(13)                 ,;
                                     CHR(13)+"B��dny zbi�r Indeksowy"+CHR(13)+"Nie mo�na szuka�"+CHR(13)         ,;
                                     CHR(13)+"Nie mo�na znale�� pola indeksu"+CHR(13)+"Nie mo�na szuka�"+CHR(13) ,;
                                     CHR(13)+"Nie mo�na szuka� wg"+CHR(13)+"pola memo lub logicznego"+CHR(13)         ,;
                                     CHR(13)+"Rekordu nie znaleziono"+CHR(13)                                                     ,;
                                     CHR(13)+"Zbyt wiele kolumn"+CHR(13)+"Raport nie mo�e zmie�ci� si� na arkuszu"+CHR(13)      }
                _HMG_SYSDATA [ 132 ]  := { "Rekord"              ,;
                                     "Liczba rekord�w"        ,;
                                     "      (Nowy)"        ,;
                                     "    (Edycja)"        ,;
                                     "Wprowad� numer rekordu" ,;
                                     "Szukaj"                ,;
                                     "Szukaj tekstu"         ,;
                                     "Szukaj daty"         ,;
                                     "Szukaj liczby"       ,;
                                     "Definicja Raportu"   ,;
                                     "Kolumny Raportu"      ,;
                                     "Dost�pne kolumny"     ,;
                                     "Pocz�tkowy rekord"      ,;
                                     "Ko�cowy rekord"        ,;
                                     "Raport z "          ,;
                                     "Data:"               ,;
                                     "Pocz�tkowy rekord:"     ,;
                                     "Ko�cowy rekord:"       ,;
                                     "Sortowanie wg:"         ,;
                                     "Tak"                 ,;
                                     "Nie"                  ,;
                                     "Strona "               ,;
                                     " z "                 }
                _HMG_SYSDATA [ 133 ] := { "Zamknij"    ,;
                                     "Nowy"      ,;
                                     "Edytuj"     ,;
                                     "Usu�"   ,;
                                     "Znajd�"     ,;
                                     "Id� do"     ,;
                                     "Raport"   ,;
                                     "Pierwszy"    ,;
                                     "Poprzedni" ,;
                                     "Nast�pny"     ,;
                                     "Ostatni"     ,;
                                     "Zapisz"     ,;
                                     "Rezygnuj"   ,;
                                     "Dodaj"      ,;
                                     "Usu�"   ,;
                                     "Drukuj"    ,;
                                     "Zamknij"     }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, b��dna nazwa bazy"                                  ,;
                                     "EDIT, baza ma wi�cej ni� 16 p�l"                   ,;
                                     "EDIT, tryb od�wierzania poza zakresem (zobacz raport b��d�w)"      ,;
                                     "EDIT, liczba zdarz� podstawowych poza zakresem (zobacz raport b��d�w)" ,;
                                     "EDIT, lista zdarze� poza zakresem (zobacz raport b��d�w)"  }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {          ;
                                "&Zamknij",        ; // 1
                                "&Nowy",           ; // 2
                                "&Modyfikuj",      ; // 3
                                "&Kasuj",          ; // 4
                                "&Znajd�",         ; // 5
                                "&Drukuj",         ; // 6
                                "&Porzu�",         ; // 7
                                "&Ok",             ; // 8
                                "&Kopiuj",         ; // 9
                                "&Aktywuj Filtr",  ; // 10
                                "&Deaktywuj Filtr" } // 11
                        _HMG_SYSDATA [ 129 ] := {                       ;
                                "Brak",                        ; // 1
                                "Rekord",                      ; // 2
                                "Suma",                        ; // 3
                                "Aktywny indeks",              ; // 4
                                "Opcje",                       ; // 5
                                "Nowy rekord",                 ; // 6
                                "Modyfikuj rekord",            ; // 7
                                "Wybierz rekord",              ; // 8
                                "Znajd� rekord",               ; // 9
                                "Opcje druku",                 ; // 10
                                "Dost�pne pola",               ; // 11
                                "Pola do druku",               ; // 12
                                "Dost�pne drukarki",           ; // 13
                                "Pierwszy rekord do druku",    ; // 14
                                "Ostatni rekord do druku",     ; // 15
                                "Skasuj rekord",               ; // 16
                                "Podgl�d",                     ; // 17
                                "Poka� miniatury",             ; // 18
                                "Stan filtru: ",               ; // 19
                                "Filtrowane: ",                ; // 20
                                "Opcje filtrowania" ,          ; // 21
                                "Pola bazy danych" ,           ; // 22
                                "Operator por�wnania",         ; // 23
                                "Warto�� filtru",              ; // 24
                                "Wybierz pola do filtru",      ; // 25
                                "Wybierz operator por�wnania", ; // 26
                                "R�wna si�",                   ; // 27
                                "Nie r�wna si�",               ; // 28
                                "Wi�kszy ",                    ; // 29
                                "Mniejszy ",                   ; // 30
                                "Wi�kszy lub r�wny ",          ; // 31
                                "Mniejszy lub r�wny"           } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "Aktywny obszar nie odnaleziony   "  + ABM_CRLF + "Wybierz obszar przed wywo�aniem EDIT   " + ABM_CRLF,   ; // 1
                                "Poszukiwany ci�g znak�w (dowolny tekst)",                                                                           ; // 2
                                "Poszukiwana warto�� (dowolna liczba)",                                                                              ; // 3
                                "Wybierz dat�",                                                                                                      ; // 4
                                "Check for true value",                                                                                              ; // 5
                                "Wprowa� warto��",                                                                                                   ; // 6
                                "Wybierz dowolny rekord i naci�cij OK",                                                                              ; // 7
                                ABM_CRLF + "Wybra�e� opcj� kasowania rekordu   " + ABM_CRLF + "Czy jeste� pewien?    " + ABM_CRLF,                   ; // 8
                                ABM_CRLF + "Brak aktywnych indeks�w   " + ABM_CRLF + "Wybierz    " + ABM_CRLF,                                       ; // 9
                                ABM_CRLF + "Nie mo�na szuka� w polach typu MEMO lub LOGIC   " + ABM_CRLF,                                            ; // 10
                                ABM_CRLF + "Rekord nie znaleziony   " + ABM_CRLF,                                                                    ; // 11
                                "Wybierz rekord kt�ry nale�y doda� do listy",                                                                        ; // 12
                                "Wybierz rekord kt�ry nale�y wy��czy� z listy",                                                                      ; // 13
                                "Wybierz drukark�",                                                                                                  ; // 14
                                "Kliknij na przycisk by doda� pole",                                                                                 ; // 15
                                "Kliknij na przycisk by odj�� pole",                                                                                 ; // 16
                                "Kliknij, aby wybra� pierwszy rekord do druku",                                                                      ; // 17
                                "Kliknij, aby wybra� ostatni rekord do druku",                                                                       ; // 18
                                ABM_CRLF + "Brak p�l do w��czenia   " + ABM_CRLF,                                                                    ; // 19
                                ABM_CRLF + "Najpierw wybierz pola do w��czenia   " + ABM_CRLF,                                                       ; // 20
                                ABM_CRLF + "Brak p�l do wy��czenia   " + ABM_CRLF,                                                                   ; // 21
                                ABM_CRLF + "Najpierw wybierz pola do wy��czenia   " + ABM_CRLF,                                                      ; // 22
                                ABM_CRLF + "Nie wybra�e� �adnych p�l   " + ABM_CRLF + "Najpierw wybierz pola do w��czenia do wydruku   " + ABM_CRLF, ; // 23
                                ABM_CRLF + "Za wiele p�l   " + ABM_CRLF + "Zredukuj liczb� p�l   " + ABM_CRLF,                                       ; // 24
                                ABM_CRLF + "Drukarka nie gotowa   " + ABM_CRLF,                                                                      ; // 25
                                "Porz�dek wg",                                                                                                       ; // 26
                                "Od rekordu",                                                                                                        ; // 27
                                "Do rekordu",                                                                                                        ; // 28
                                "Tak",                                                                                                               ; // 29
                                "Nie",                                                                                                               ; // 30
                                "Strona:",                                                                                                           ; // 31
                                ABM_CRLF + "Wybierz drukark�   " + ABM_CRLF,                                                                         ; // 32
                                "Filtrowanie wg",                                                                                                    ; // 33
                                ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 34
                                ABM_CRLF + "Nie mo�na filtrowa� wg. p�l typu MEMO    " + ABM_CRLF,                                                   ; // 35
                                ABM_CRLF + "Wybierz pola dla filtru    " + ABM_CRLF,                                                                 ; // 36
                                ABM_CRLF + "Wybierz operator por�wnania dla filtru    " + ABM_CRLF,                                                  ; // 37
                                ABM_CRLF + "Wpisz dowoln� warto�� dla filtru    " + ABM_CRLF,                                                        ; // 38
                                ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 39
                                ABM_CRLF + "Deaktywowa� filtr?   " + ABM_CRLF,                                                                        ;
                                ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

        // case cLang == "pt.PT850"        // Portuguese
        case cLang == "PT"
	/////////////////////////////////////////////////////////////
	// PORTUGUESE
	////////////////////////////////////////////////////////////

// MISC MESSAGES

_hMG_SYSDATA [ 331 ] [1] := 'Voc� tem Certeza ?'
_hMG_SYSDATA [ 331 ] [2] := 'Fechar Janela'
_hMG_SYSDATA [ 331 ] [3] := 'Fechamento n�o permitido'
_hMG_SYSDATA [ 331 ] [4] := 'O programa j� est� em execu��o'
_hMG_SYSDATA [ 331 ] [5] := 'Edita'
_hMG_SYSDATA [ 331 ] [6] := 'Ok'
_hMG_SYSDATA [ 331 ] [7] := 'Cancela'
_hMG_SYSDATA [ 331 ] [8] := 'P�g.'	


// BROWSE

_HMG_SYSDATA [ 136 ]:= {"Window: ",											;
               		" Erro n�o definido. O programa ser� fechado",							;
               		"Erro na HMG.lib",										;
               		"Control: ",											;
               		" Of ",												;
               		" N�o pronto. O programa ser� fechado",								;
               		"Browse: Tipo Inv�lido !!!. O programa ser� fechado",						;
               		"Browse: A edi��o n�o � poss�vel, o campo n�o pertence a essa �rea. O programa ser� fechado",	;
              		"O arquivo est� em uso e n�o pode ser editado !!!",						;
      		 	"Aguarde...",											;
            		"Dado Inv�lido"											}
_HMG_SYSDATA [ 137 ] := { 'Voc� tem Certeza ?' , 'Apagar Registro' }




// EDIT

_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Excluir o registro atual"+CHR(13)+"Tem certeza?"+CHR(13),					;
	                    CHR(13)+"N�o existe nenhum �ndice ativo"+CHR(13)+"N�o � poss�vel realizar a busca"+CHR(13),		;
        	            CHR(13)+"N�o foi encontrado o campo �ndice"+CHR(13)+"N�o � poss�vel realizar a busca"+CHR(13),	;
                	    CHR(13)+"N�o � poss�vel realizar busca"+CHR(13)+"por campos Memo ou L�gicos"+CHR(13),		;
                            CHR(13)+"Registro n�o encontrado"+CHR(13),								;
                            CHR(13)+"Inclu�das colunas em excesso"+CHR(13)+"A listagem completa n�o caber� na tela"+CHR(13)     }

_HMG_SYSDATA [ 132 ]  := { "Registro Atual",				;
                           "Total de Registros",			;
                           "      (Novo)",				;
                           "    (Editar)",				;
                           "Introduza o n�mero do registro",		;
                           "Buscar",					;
                           "Texto � buscar",				;
                           "Data � buscar",				;
                           "N�mero � buscar",				;
                           "Definic�o da lista",			;
                           "Colunas da lista",				;
                           "Colunas dispon�veis",			;
                           "Registro inicial",				;
                           "Registro final",				;
                           "Lista de ",					;
                           "Data:",					;
                           "Primeiro registro:",			;
                           "�ltimo registro:",				;
                           "Ordenado por:",				;
                           "Sim",					;
                           "N�o",					;
                           "P�gina ",					;
                           " de "					}

_HMG_SYSDATA [ 133 ] := { "Fechar",					;
                           "Novo",					;
                           "Alterar",					;
                           "Excluir",					;
                           "Buscar",					;
                           "Ir ao registro",				;
                           "Listar",					;
                           "Primeiro",					;
                           "Anterior",					;
                           "Seguinte",					;
                           "�ltimo",					;
                           "Salvar",					;
                           "Cancelar",					;
                           "Juntar",					;
                           "Sair",					;
                           "Imprimir",					;
                           "Fechar"					}
     
_HMG_SYSDATA [ 134 ]  := { "EDIT, Nenhuma �rea foi especificada",					;
                           "EDIT, A �rea selecionada possui mais de 16 campos",				;
                           "EDIT, Atualiza��o est� fora do limite (Favor comunicar este erro)",		;
                           "EDIT, Evento principal est� fora do limite (Favor comunicar este erro)",	;
                           "EDIT, Evento mostrado est�fora do limite (Favor comunicar este erro)"	}



// EDIT EXTENDED

_HMG_SYSDATA [ 128 ] :={"&Sair", 		; // 1
        	      	"&Novo",		; // 2
	              	"&Alterar",		; // 3
        	      	"&Excluir",		; // 4
	              	"&Localizar",		; // 5
        	      	"&Imprimir",		; // 6
	              	"&Cancelar",		; // 7
        	      	"&Aceitar",		; // 8
	              	"&Copiar",		; // 9
        	      	"&Ativar Filtro",	; // 10
	              	"&Desativar Filtro"	} // 11

_HMG_SYSDATA [ 129 ] :={"Nenhum",					; // 1
              		"Registro",					; // 2
              		"Total",					; // 3
              		"�ndice ativo",					; // 4
              		"Op��o",					; // 5
              		"Novo registro",				; // 6
             		"Modificar registro",				; // 7
              		"Selecionar registro",				; // 8
              		"Localizar registro",				; // 9
              		"Op��o de impress�o",				; // 10
              		"Campos dispon�veis",				; // 11
              		"Campos selecionados",				; // 12
              		"Impressoras dispon�veis",			; // 13
              		"Primeiro registro a imprimir",			; // 14
              		"�ltimo registro a imprimir",			; // 15
              		"Apagar registro",				; // 16
              		"Visualizar impress�o",				; // 17
              		"Miniaturas das p�ginas",			; // 18
              		"Condi��o do filtro: ",				; // 19
              		"Filtrado: ",					; // 20
              		"Op��es do filtro" ,				; // 21
              		"Campos do BDD" ,				; // 22
              		"Operador de compara��o",			; // 23
              		"Argumento de compara��o",			; // 24
              		"Selecione o campo � filtrar",			; // 25
              		"Selecione o operador de compara��o",		; // 26
              		"Igual",					; // 27
              		"Diferente",					; // 28
              		"Maior que",					; // 29
              		"Menor que",					; // 30
              		"Maior ou igual que",				; // 31
              		"Menor ou igual que"				} // 32

_HMG_SYSDATA [ 130 ] := { ABM_CRLF + "N�o h� uma �rea ativa   "  + ABM_CRLF + 								;
				"Por favor selecione uma �rea antes de executar o EDIT EXTENDED   " + ABM_CRLF,				; // 1
              		"Introduza o valor do campo (texto)",										; // 2
              		"Introduza o valor do campo (num�rico)",									; // 3
              		"Selecione a data",												; // 4
              		"Ative o indicar para valor verdadero",										; // 5
              		"Introduza o valor do campo",											; // 6
              		"Selecione um registro e tecle Ok",										; // 7
              		ABM_CRLF + "Confirma exclus�o do registro selecionado ??   " + ABM_CRLF + "Tem certeza?    " + ABM_CRLF,	; // 8
              		ABM_CRLF + "N�o ha um �ndice seleccionado    " + ABM_CRLF + "Por favor selecione um   " + ABM_CRLF,		; // 9
              		ABM_CRLF + "N�o � poss�vel excutar buscas em campos tipo Memo ou L�gico   " + ABM_CRLF,				; // 10
              		ABM_CRLF + "Registro n�o encontrado   " + ABM_CRLF,								; // 11
              		"Selecione o campo a incluir na lista",										; // 12
              		"Selecione o campo a excluir da lista",										; // 13
              		"Selecione a Impressora",											; // 14
              		"Pressione o bot�o para incluir o campo",									; // 15
              		"Pressione o bot�o para excluir o campo",									; // 16
              		"Pressione o bot�o para selecionar o primeiro registro a imprimir",						; // 17
              		"Pressione o bot�o para selecionar o �ltimo registro a imprimir",						; // 18
              		ABM_CRLF + "Foram inclu�dos todos os campos   " + ABM_CRLF,							; // 19
              		ABM_CRLF + "Primeiro seleccione o campo a incluir   " + ABM_CRLF,						; // 20
              		ABM_CRLF + "N�o ha campos para excluir   " + ABM_CRLF,								; // 21
              		ABM_CRLF + "Primeiro selecione o campo a excluir   " + ABM_CRLF,						; // 22
              		ABM_CRLF + "N�o h� mais campos selecion�veis   " + ABM_CRLF,							; // 23
              		ABM_CRLF + "A lista n�o cabe na p�gina   " + ABM_CRLF + "Reduza o n�mero de campos   " + ABM_CRLF,		; // 24
              		ABM_CRLF + "A impressora n�o est� dispon�vel   " + ABM_CRLF,							; // 25
              		"Ordenado por",													; // 26
              		"Do registro",													; // 27
              		"At� o registro",												; // 28
              		"Sim",														; // 29
              		"N�o",														; // 30
              		"P�gina:",													; // 31
              		ABM_CRLF + "Por favor selecione uma impressora   " + ABM_CRLF,							; // 32
              		"Filtrado por",													; // 33
              		ABM_CRLF + "N�o h� nenhum filtro ativo    " + ABM_CRLF,								; // 34
              		ABM_CRLF + "N�o � poss�vel filtrar por campos Memo    " + ABM_CRLF,						; // 35
              		ABM_CRLF + "Selecione o campo a filtrar    " + ABM_CRLF,							; // 36
              		ABM_CRLF + "Selecione o operador de compara��o    " + ABM_CRLF,							; // 37
              		ABM_CRLF + "Introduza o valor do filtro    " + ABM_CRLF,							; // 38
              		ABM_CRLF + "N�o ha nenhum filtro ativo    " + ABM_CRLF,								; // 39
              		ABM_CRLF + "Limpar o filtro ativo?   " + ABM_CRLF,								; // 40
  			ABM_CRLF + "Registro est� bloqueado por outro usu�rio" + ABM_CRLF						} // 41


        // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
        case cLang == "RU"
	/////////////////////////////////////////////////////////////
	// RUSSIAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := '�� ������� ?'
		_hMG_SYSDATA [ 331 ] [2] := '������� ����'
		_hMG_SYSDATA [ 331 ] [3] := '�������� �� ��������'
		_hMG_SYSDATA [ 331 ] [4] := '��������� ��� ��������'
		_hMG_SYSDATA [ 331 ] [5] := '��������'
		_hMG_SYSDATA [ 331 ] [6] := '��'
		_hMG_SYSDATA [ 331 ] [7] := '������'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE

                _HMG_SYSDATA [ 136 ]  := { "����: "                                              ,;
                                     " �� ����������. ��������� ��������"                 ,;
                                     "HMG ������"                                     ,;
                                     "������� ���������: "                               ,;
                                     " �� "                                               ,;
				     " ��� ���������. ��������� ��������"                         ,;
				     "Browse: ����� ��� �� �������������. ��������� ��������"    ,;
				     "Browse: Append ����� �� ����� ���� ����������� � ����� �� ������ ������� �������. ��������� ��������",;
				     "������ ������ ������������ ������ �������������"           ,;
				     "��������������"                                             ,;
				     "������� ������������ ������"                                 }
                _HMG_SYSDATA [ 137 ] := { '�� ������� ?' , '������� ������' }

		// EDIT

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"�������� ������."+CHR(13)+"�� ������� ?"+CHR(13)                  ,;
                                     CHR(13)+"����������� ��������� ����"+CHR(13)+"����� ����������"+CHR(13)   ,;
                                     CHR(13)+"����������� ��������� ����"+CHR(13)+"����� ����������"+CHR(13)   ,;
                                     CHR(13)+"����� ���������� ��"+CHR(13)+"���� ��� ���������� �����"+CHR(13) ,;
                                     CHR(13)+"������ �� �������"+CHR(13)                                       ,;
                                     CHR(13)+"������� ����� �������"+CHR(13)+"����� �� ���������� �� �����"+CHR(13) }
                _HMG_SYSDATA [ 132 ]  := { "������"              ,;
                                     "����� �������"       ,;
                                     "     (�����)"        ,;
                                     "  (��������)"        ,;
                                     "������� ����� ������",;
                                     "�����"               ,;
                                     "����� �����"         ,;
                                     "����� ����"          ,;
                                     "����� �����"         ,;
                                     "��������� ������"    ,;
                                     "������� ������"      ,;
                                     "��������� �������"   ,;
                                     "��������� ������"    ,;
                                     "�������� ������"     ,;
                                     "����� ��� "          ,;
                                     "����:"               ,;
                                     "������ ������:"      ,;
                                     "�������� ������:"    ,;
                                     "����������� ��:"     ,;
                                     "��"                  ,;
                                     "���"                 ,;
                                     "�������� "           ,;
                                     " �� "                 }
                _HMG_SYSDATA [ 133 ] := { "�������"   ,;
                                     "�����"     ,;
                                     "��������"  ,;
                                     "�������"   ,;
                                     "�����"     ,;
                                     "�������"   ,;
                                     "�����"     ,;
                                     "������"    ,;
                                     "�����"     ,;
                                     "������"    ,;
                                     "���������" ,;
                                     "���������" ,;
                                     "������"    ,;
                                     "��������"  ,;
                                     "�������"   ,;
                                     "������"    ,;
                                     "�������"    }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, �� ������� ��� ������� �������"                     ,;
                                     "EDIT, ����������� ������ �� 16 �����"                     ,;
                                     "EDIT, ����� ���������� ��� ��������� (�������� �� ������)",;
                                     "EDIT, ����� ������� ��� ��������� (�������� �� ������)"   ,;
                                     "EDIT, ����� ������� �������� ��� ��������� (�������� �� ������)" }

		// EDIT EXTENDED

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

        // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
        case cLang == "ES"
	/////////////////////////////////////////////////////////////
	// SPANISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Est� seguro ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Cerrar Ventana'
		_hMG_SYSDATA [ 331 ] [3] := 'Operaci�n no permitida'
		_hMG_SYSDATA [ 331 ] [4] := 'EL programa ya est� ejecut�ndose'
		_hMG_SYSDATA [ 331 ] [5] := 'Editar'
		_hMG_SYSDATA [ 331 ] [6] := 'Aceptar'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancelar'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'	

		// BROWSE		

                _HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " no est� definida. Ejecuci�n terminada"                ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " De "                                                  ,;
				     " ya definido. Ejecuci�n terminada"                     ,;
				     "Browse: Tipo no permitido. Ejecuci�n terminada"        ,;
				     "Browse: La calusula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. Ejecuci�n terminada",;
				     "El registro est� siendo editado por otro usuario"      ,;
				     "Peligro"                                               ,;
				     "Entrada no v�lida"                                      }
                _HMG_SYSDATA [ 137 ] := { 'Est� Seguro ?' , 'Eliminar Registro' }

		// EDIT 

                _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Va a eliminar el registro actual"+CHR(13)+"� Est� seguro ?"+CHR(13)                 ,;
                                     CHR(13)+"No hay un indice activo"+CHR(13)+"No se puede realizar la busqueda"+CHR(13)         ,;
                                     CHR(13)+"No se encuentra el campo indice"+CHR(13)+"No se puede realizar la busqueda"+CHR(13) ,;
                                     CHR(13)+"No se pueden realizar busquedas"+CHR(13)+"por campos memo o l�gico"+CHR(13)         ,;
                                     CHR(13)+"Registro no encontrado"+CHR(13)                                                     ,;
                                     CHR(13)+"Ha inclido demasiadas columnas"+CHR(13)+"El listado no cabe en la hoja"+CHR(13)      }
                _HMG_SYSDATA [ 132 ]  := { "Registro Actual"                  ,;
                                     "Registros Totales"                ,;
                                     "     (Nuevo)"                     ,;
                                     "    (Editar)"                     ,;
                                     "Introducca el n�mero de registro" ,;
                                     "Buscar"                           ,;
                                     "Texto a buscar"                   ,;
                                     "Fecha a buscar"                   ,;
                                     "N�mero a buscar"                  ,;
                                     "Definici�n del listado"           ,;
                                     "Columnas del listado"             ,;
                                     "Columnas disponibles"             ,;
                                     "Registro inicial"                 ,;
                                     "Registro final"                   ,;
                                     "Listado de "                      ,;
                                     "Fecha:"                           ,;
                                     "Primer registro:"                 ,;
                                     "Ultimo registro:"                 ,;
                                     "Ordenado por:"                    ,;
                                     "Si"                               ,;
                                     "No"                               ,;
                                     "Pagina "                          ,;
                                     " de "                              }
                _HMG_SYSDATA [ 133 ] := { "Cerrar"           ,;
                                     "Nuevo"            ,;
                                     "Modificar"        ,;
                                     "Eliminar"         ,;
                                     "Buscar"           ,;
                                     "Ir al registro"   ,;
                                     "Listado"          ,;
                                     "Primero"          ,;
                                     "Anterior"         ,;
                                     "Siguiente"        ,;
                                     "Ultimo"           ,;
                                     "Guardar"          ,;
                                     "Cancelar"         ,;
                                     "A�adir"           ,;
                                     "Quitar"           ,;
                                     "Imprimir"         ,;
                                     "Cerrar"            }
                _HMG_SYSDATA [ 134 ]  := { "EDIT, No se ha especificado el area"                                  ,;
                                     "EDIT, El area contiene m�s de 16 campos"                              ,;
                                     "EDIT, Refesco fuera de rango (por favor comunique el error)"          ,;
                                     "EDIT, Evento principal fuera de rango (por favor comunique el error)" ,;
                                     "EDIT, Evento listado fuera de rango (por favor comunique el error)"    }

		// EDIT EXTENDED

                        _HMG_SYSDATA [ 128 ] := {            ;
                                "&Cerrar",           ; // 1
                                "&Nuevo",            ; // 2
                                "&Modificar",        ; // 3
                                "&Eliminar",         ; // 4
                                "&Buscar",           ; // 5
                                "&Imprimir",         ; // 6
                                "&Cancelar",         ; // 7
                                "&Aceptar",          ; // 8
                                "&Copiar",           ; // 9
                                "&Activar Filtro",   ; // 10
                                "&Desactivar Filtro" } // 11
                        _HMG_SYSDATA [ 129 ] := {                                 ;
                                "Ninguno",                               ; // 1
                                "Registro",                              ; // 2
                                "Total",                                 ; // 3
                                "Indice activo",                         ; // 4
                                "Opciones",                              ; // 5
                                "Nuevo registro",                        ; // 6
                                "Modificar registro",                    ; // 7
                                "Seleccionar registro",                  ; // 8
                                "Buscar registro",                       ; // 9
                                "Opciones de impresi�n",                 ; // 10
                                "Campos disponibles",                    ; // 11
                                "Campos del listado",                    ; // 12
                                "Impresoras disponibles",                ; // 13
                                "Primer registro a imprimir",            ; // 14
                                "Ultimo registro a imprimir",            ; // 15
                                "Borrar registro",                       ; // 16
                                "Vista previa",                          ; // 17
                                "P�ginas en miniatura",                  ; // 18
                                "Condici�n del filtro: ",                ; // 19
                                "Filtrado: ",                            ; // 20
                                "Opciones de filtrado" ,                 ; // 21
                                "Campos de la bdd" ,                     ; // 22
                                "Operador de comparaci�n",               ; // 23
                                "Valor de comparaci�n",                  ; // 24
                                "Seleccione el campo a filtrar",         ; // 25
                                "Seleccione el operador de comparaci�n", ; // 26
                                "Igual",                                 ; // 27
                                "Distinto",                              ; // 28
                                "Mayor que",                             ; // 29
                                "Menor que",                             ; // 30
                                "Mayor o igual que",                     ; // 31
                                "Menor o igual que"                      } // 32
                        _HMG_SYSDATA [ 130 ] := { ;
                                ABM_CRLF + "No hay un area activa   "  + ABM_CRLF + "Por favor seleccione un area antes de llamar a EDIT EXTENDED   " + ABM_CRLF,       ; // 1
                                "Introduzca el valor del campo (texto)",                                                                                      ; // 2
                                "Introduzca el valor del campo (num�rico)",                                                                                    ; // 3
                                "Seleccione la fecha",                                                                                                      ; // 4
                                "Active la casilla para indicar un valor verdadero",                                                                                                 ; // 5
                                "Introduzca el valor del campo",                                                                                                ; // 6
                                "Seleccione un registro y pulse aceptar",                                                                                       ; // 7
                                ABM_CRLF + "Se dispone a borrar el registro activo   " + ABM_CRLF + "�Esta seguro?    " + ABM_CRLF,                  ; // 8
                                ABM_CRLF + "No se ha seleccionado un indice   " + ABM_CRLF + "Por favor seleccione uno   " + ABM_CRLF,                            ; // 9
                                ABM_CRLF + "No se pueden realizar busquedad por campos tipo memo o l�gico   " + ABM_CRLF,                                                   ; // 10
                                ABM_CRLF + "Registro no encontrado   " + ABM_CRLF,                                                                            ; // 11
                                "Seleccione el campo a incluir en el listado",                                                                                  ; // 12
                                "Seleccione el campo a excluir del listado",                                                                                ; // 13
                                "Seleccione la impresora",                                                                                                   ; // 14
                                "Pulse el bot�n para incluir el campo",                                                                                         ; // 15
                                "Pulse el bot�n para excluir el campo",                                                                                         ; // 16
                                "Pulse el bot�n para seleccionar el primer registro a imprimir",                                                                      ; // 17
                                "Pulse el bot�n para seleccionar el �ltimo registro a imprimir",                                                                       ; // 18
                                ABM_CRLF + "Ha incluido todos los campos   " + ABM_CRLF,                                                                   ; // 19
                                ABM_CRLF + "Primero seleccione el campo a incluir   " + ABM_CRLF,                                                           ; // 20
                                ABM_CRLF + "No hay campos para excluir   " + ABM_CRLF,                                                                    ; // 21
                                ABM_CRLF + "Primero seleccione el campo a excluir   " + ABM_CRLF,                                                            ; // 22
                                ABM_CRLF + "No ha seleccionado ning�n campo   " + ABM_CRLF,                                              ; // 23
                                ABM_CRLF + "El listado no cabe en la p�gina   " + ABM_CRLF + "Reduzca el numero de campos   " + ABM_CRLF,                                   ; // 24
                                ABM_CRLF + "La impresora no est� disponible   " + ABM_CRLF,                                                                           ; // 25
                                "Ordenado por",                                                                                                           ; // 26
                                "Del registro",                                                                                                          ; // 27
                                "Al registro",                                                                                                            ; // 28
                                "Si",                                                                                                                  ; // 29
                                "No",                                                                                                                   ; // 30
                                "P�gina:",                                                                                                                ; // 31
                                ABM_CRLF + "Por favor seleccione una impresora   " + ABM_CRLF,                                                                     ; // 32
                                "Filtrado por",                                                                                                          ; // 33
                                ABM_CRLF + "No hay un filtro activo    " + ABM_CRLF,                                                                  ; // 34
                                ABM_CRLF + "No se puede filtrar por campos memo    " + ABM_CRLF,                                                                ; // 35
                                ABM_CRLF + "Seleccione el campo a filtrar    " + ABM_CRLF,                                                                 ; // 36
                                ABM_CRLF + "Seleccione el operador de comparaci�n    " + ABM_CRLF,                                                              ; // 37
                                ABM_CRLF + "Introduzca el valor del filtro    " + ABM_CRLF,                                                                   ; // 38
                                ABM_CRLF + "No hay ning�n filtro activo    " + ABM_CRLF,                                                              ; // 39
                                ABM_CRLF + "�Eliminar el filtro activo?   " + ABM_CRLF,                                                                           ; // 40
                                ABM_CRLF + "Registro bloqueado por otro usuario    " + ABM_CRLF                                                                   } // 41

        case cLang == "FI"        // Finnish
	///////////////////////////////////////////////////////////////////////
	// FINNISH
	///////////////////////////////////////////////////////////////////////
	// MISC MESSAGES

	_hMG_SYSDATA [ 331 ] [1] := 'Oletko varma ?'
	_hMG_SYSDATA [ 331 ] [2] := 'Sulje ikkuna'
	_hMG_SYSDATA [ 331 ] [3] := 'Sulkeminen ei sallittu'
	_hMG_SYSDATA [ 331 ] [4] := 'Ohjelma on jo k�ynniss�'
	_hMG_SYSDATA [ 331 ] [5] := 'Korjaa'
	_hMG_SYSDATA [ 331 ] [6] := 'Ok'
	_hMG_SYSDATA [ 331 ] [7] := 'Keskeyt�'
	_hMG_SYSDATA [ 331 ] [8] := 'Sivu.'      

	// BROWSE

	_HMG_SYSDATA [ 136 ]  := { "Ikkuna: " ,;
		" m��rittelem�t�n. Ohjelma lopetettu" ,;
		"HMG Virhe",;
		"Kontrolli: ",;
		" / " ,;
		" On jo m��ritelty. Ohjelma lopetettu" ,;
		"Browse: Virheellinen tyyppi. Ohjelma lopetettu" ,;
		"Browse: Et voi lis�t� kentti� jotka eiv�t ole BROWSEN m��rityksess�. Ohjelma lopetettu",;
		"Toinen k�ytt�j� korjaa juuri tietuetta" ,;
		"Varoitus" ,;
		"Virheellinen arvo" }

		_HMG_SYSDATA [ 137 ] := { 'Oletko varma ?' , 'Poista tietue' }

		// EDIT 
		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Poista tietue"+CHR(13)+"Oletko varma?"+CHR(13)                  ,;
			CHR(13)+"Indeksi tiedosto puuttuu"+CHR(13)+"En voihakea"+CHR(13)            ,;
			CHR(13)+"Indeksikentt� ei l�ydy"+CHR(13)+"En voihakea"+CHR(13)        ,;
			CHR(13)+"En voi hakea memo"+CHR(13)+"tai loogisen kent�n mukaan"+CHR(13)       ,;
			CHR(13)+"Tietue ei l�ydy"+CHR(13),;
			CHR(13)+"Liian monta saraketta"+CHR(13)+"raportti ei mahdu sivulle"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Tietue"              ,;
			"Tietue lukum��r�"    ,;
			"       (Uusi)"       ,;
			"      (Korjaa)"      ,;
			"Anna tietue numero"  ,;
			"Hae"                 ,;
			"Hae teksti"          ,;
			"Hae p�iv�ys"         ,;
			"Hae numero"          ,;
			"Raportti m��ritys"   ,;
			"Raportti sarake"     ,;
			"Sallitut sarakkeet"  ,;
			"Alku tietue"         ,;
			"Loppu tietue"        ,;
			"Raportti "           ,;
			"Pvm:"                ,;
			"Alku tietue:"        ,;
			"Loppu tietue:"       ,;
			"Lajittelu:"         ,;
			"Kyll�"                 ,;
			"Ei"                  ,;
			"Sivu "               ,;
			" / "                 }

		_HMG_SYSDATA [ 133 ] := { "Sulje"    ,;
			"Uusi"     ,;
			"Korjaa"   ,;
			"Poista"   ,;
			"Hae"      ,;
			"Mene"     ,;
			"Raportti" ,;
			"Ensimm�inen" ,;
			"Edellinen"   ,;
			"Seuraava"    ,;
			"Viimeinen"   ,;
			"Tallenna"    ,;
			"Keskeyt�"    ,;
			"Lis��"       ,;
			"Poista"      ,;
			"Tulosta"     ,;
			"Sulje"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, ty�alue puuttuu"   ,;
			"EDIT, ty�alueella yli 16 kentt��",;
			"EDIT, p�ivitysalue ylitys (raportoi virhe)"      ,;
			"EDIT, tapahtuma numero ylitys (raportoi virhe)" ,;
			"EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

		// EDIT EXTENDED

		_HMG_SYSDATA [ 128 ] := {            ;
			" Sulje",            ; // 1
			" Uusi",              ; // 2
			" Muuta",           ; // 3
			" Poista",           ; // 4
			" Hae",             ; // 5
			" Tulosta",            ; // 6
			" Keskeyt�",           ; // 7
			" Ok",               ; // 8
			" Kopioi",             ; // 9
			" Aktivoi Filtteri",  ; // 10
			" Deaktivoi Filtteri" } // 11

		_HMG_SYSDATA [ 129 ] := {                        ;
			"Ei mit��n",                         ; // 1
			"Tietue",                       ; // 2
			"Yhteens�",                        ; // 3
			"Aktiivinen lajittelu",                 ; // 4
			"Optiot",                      ; // 5
			"Uusi tietue",                   ; // 6
			"Muuta tietue",                ; // 7
			"Valitse tietue",                ; // 8
			"Hae tietue",                  ; // 9
			"Tulostus optiot",                ; // 10
			"Valittavat kent�t",               ; // 11
			"Tulostettavat kent�t",              ; // 12
			"Valittavat tulostimet",           ; // 13
			"Ensim. tulostuttava tietue",        ; // 14
			"Viim. tulostettava tietue",         ; // 15
			"Poista tietue",                ; // 16
			"Esikatselu",                      ; // 17
			"N�yt� sivujen miniatyyrit",         ; // 18
			"Suodin ehto: ",           ; // 19
			"Suodatettu: ",                   ; // 20
			"Suodatus Optiot" ,           ; // 21
			"Tietokanta kent�t" ,             ; // 22
			"Vertailu operaattori",        ; // 23
			"Suodatus arvo",                 ; // 24
			"Valitse suodatus kentt�",       ; // 25
			"Valitse vertailu operaattori", ; // 26
			"Yht� kuin",                        ; // 27
			"Erisuuri kuin",                    ; // 28
			"Isompi kuin",                 ; // 29
			"Pienempi kuin",                   ; // 30
			"Isompi tai sama kuin",        ; // 31
			"Pienempi tai sama kuin"           } // 32

		_HMG_SYSDATA [ 130 ] := { ;
			ABM_CRLF + "Ty�alue ei l�ydy.   "  + ABM_CRLF + "Valitse ty�aluetta ennenkun kutsut Edit  " + ABM_CRLF,       ; // 1
			"Anna kentt� arvo (teksti�)",                                  ; // 2
			"Anna kentt� arvo (numeerinen)",                                  ; // 3
			"Valitse p�iv�ys",                            ; // 4
			"Tarkista tosi arvo",                     ; // 5
			"Anna kentt� arvo",                    ; // 6
			"Valitse joku tietue ja paina OK",                                     ; // 7
			ABM_CRLF + "Olet poistamassa aktiivinen tietue   "+ABM_CRLF + "Oletko varma?    " + ABM_CRLF,                  ; // 8
			ABM_CRLF + "Ei aktiivista lajittelua   " + ABM_CRLF+"Valitse lajittelu   " + ABM_CRLF,                            ; // 9
			ABM_CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + ABM_CRLF,; // 10
			ABM_CRLF + "Tietue ei l�ydy   " + ABM_CRLF,                                                ; // 11
			"Valitse listaan lis�tt�v�t kent�t",                                                    ; // 12
			"Valitse EI lis�tt�v�t kent�t",                                        ; // 13
			"Valitse tulostin",                   ; // 14
			"Paina n�pp�in lis��t�ksesi kentt�",                                                                  ; // 15
			"Paina n�pp�in poistaaksesi kentt�",                                                       ; //16
			"Paina n�pp�in valittaaksesi ensimm�inen tulostettava tietue",  ; // 17
			"Paina n�pp�in valittaaksesi viimeinen tulostettava tietue",   ; // 18
			ABM_CRLF + "Ei lis�� kentti�   " + ABM_CRLF,                                 ; // 19
			ABM_CRLF + "Valitse ensin lis�tt�v� kentt�   "+ABM_CRLF,                                                           ; //20
			ABM_CRLF + "EI Lis�� ohitettavia kentti�   " +ABM_CRLF,; // 21
			ABM_CRLF + "Valitse ensin ohitettava kentt�   " +ABM_CRLF,                                                            ;//22
			ABM_CRLF + "Et valinnut kentti�   " + ABM_CRLF + "Valitse tulosteen kent�t   " + ABM_CRLF,   ; // 23
			ABM_CRLF + "Liikaa kentti�   " + ABM_CRLF + "V�henn� kentt� lukum��r�   " + ABM_CRLF,; // 24
			ABM_CRLF + "Tulostin ei valmiina   " + ABM_CRLF,                                                  ; // 25
			"Lajittelu",             ; // 26
			"Tietueesta",              ; // 27
			"Tietueeseen",                  ; // 28
			"Kyll�",                ; // 29
			"EI",       ; // 30
			"Sivu:",          ; // 31
			ABM_CRLF + "Valitse tulostin   " + ABM_CRLF,                                       ; // 32
			"Lajittelu",            ; // 33
			ABM_CRLF + "Aktiivinen suodin olemassa    " + ABM_CRLF,                                                          ; // 34
			ABM_CRLF + "En voi suodattaa memo kentti�    "+ABM_CRLF,;// 35
			ABM_CRLF + "Valitse suodattava kentt�    " + ABM_CRLF,                                                           ; // 36
			ABM_CRLF + "Valitse suodattava operaattori    " +ABM_CRLF,                                                             ; //37
			ABM_CRLF + "Anna suodatusarvo    " + ABM_CRLF,                                         ; // 38
			ABM_CRLF + "Ei aktiivisia suotimia    " + ABM_CRLF,                                              ; // 39
			ABM_CRLF + "Poista suodin?   " + ABM_CRLF,                                        ; // 40
			ABM_CRLF + "Tietue lukittu    " + ABM_CRLF                                 } // 41
	
        case cLang == "NL"        // Dutch
	/////////////////////////////////////////////////////////////
	// DUTCH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Weet u het zeker?'
		_hMG_SYSDATA [ 331 ] [2] := 'Sluit venster'
		_hMG_SYSDATA [ 331 ] [3] := 'Sluiten niet toegestaan'
		_hMG_SYSDATA [ 331 ] [4] := 'Programma is al actief'
		_hMG_SYSDATA [ 331 ] [5] := 'Bewerken'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Annuleren'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE

                  _HMG_SYSDATA [ 136 ]  := { "Scherm: ",;
                                       " is niet gedefinieerd. Programma be�indigd"           ,;
                                       "HMG fout",;
                                       "Control: ",;
                                       " Van ",;
	           " Is al gedefinieerd. Programma be�indigd"                   ,;
        	   "Browse: Type niet toegestaan. Programma be�indigd"          ,;
	           "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma be�indigd",;
        	   "Regel word al veranderd door een andere gebruiker"          ,;
	           "Waarschuwing"                                               ,;
        	   "Onjuiste invoer"                                            }

                  _HMG_SYSDATA [ 137 ] := { 'Weet u het zeker?' , 'Verwijder regel' }

	    // EDIT

	    _HMG_SYSDATA [ 131 ]   := { CHR(13)+"Verwijder regel"+CHR(13)+"Weet u het zeker ?"+CHR(13)    ,;
                       CHR(13)+"Index bestand is er niet"+CHR(13)+"Kan niet zoeken"+CHR(13)          ,;
                       CHR(13)+"Kan index veld niet vinden"+CHR(13)+"Kan niet zoeken"+CHR(13)        ,;
                       CHR(13)+"Kan niet zoeken op"+CHR(13)+"Memo of logische velden"+CHR(13)        ,;
                       CHR(13)+"Regel niet gevonden"+CHR(13) ,;
                       CHR(13)+"Te veel rijen"+CHR(13)+"Het rapport past niet op het papier"+CHR(13) }

	    _HMG_SYSDATA [ 132 ]  := { "Regel"     ,;
                       "Regel aantal"          ,;
                       "       (Nieuw)"        ,;
                       "      (Bewerken)"      ,;
                       "Geef regel nummer"     ,;
                       "Vind"                  ,;
                       "Zoek tekst"            ,;
                       "Zoek datum"            ,;
                       "Zoek nummer"           ,;
                       "Rapport definitie"     ,;
                       "Rapport rijen"         ,;
                       "Beschikbare rijen"     ,;
                       "Eerste regel"          ,;
                       "Laatste regel"         ,;
                       "Rapport van "          ,;
                       "Datum:"                ,;
                       "Eerste regel:"         ,;
                       "Laatste tegel:"        ,;
                       "Gesorteerd op:"        ,;
                       "Ja"                    ,;
                       "Nee"                   ,;
                       "Pagina "               ,;
                       " van "                 }

	    _HMG_SYSDATA [ 133 ] := { "Sluiten"   ,;
                       "Nieuw"                 ,;
                       "Bewerken"              ,;
                       "Verwijderen"           ,;
                       "Vind"                  ,;
                       "Ga naar"               ,;
                       "Rapport"               ,;
                       "Eerste"                ,;
                       "Vorige"                ,;
                       "Volgende"              ,;
                       "Laatste"               ,;
                       "Bewaar"                ,;
                       "Annuleren"             ,;
                       "Voeg toe"              ,;
                       "Verwijder"             ,;
                       "Print"                 ,;
                       "Sluiten"               }
	    _HMG_SYSDATA [ 134 ]  := { "BEWERKEN, werkgebied naam bestaat niet",;
                       "BEWERKEN, dit werkgebied heeft meer dan 16 velden",;
                       "BEWERKEN, ververs manier buiten bereik (a.u.b. fout melden)"           ,;
                       "BEWERKEN, hoofd gebeurtenis nummer buiten bereik (a.u.b. fout melden)" ,;
                       "BEWERKEN, list gebeurtenis nummer buiten bereik (a.u.b. fout melden)"  }

	    // EDIT EXTENDED
                          _HMG_SYSDATA [ 128 ] := {            ;
                                  "&Sluiten",          ; // 1
                                  "&Nieuw",            ; // 2
                                  "&Aanpassen",        ; // 3
                                  "&Verwijderen",      ; // 4
                                  "&Vind",             ; // 5
                                  "&Print",            ; // 6
                                  "&Annuleren",        ; // 7
                                  "&Ok",               ; // 8
                                  "&Kopieer",          ; // 9
                                  "&Activeer filter",  ; // 10
                                  "&Deactiveer filter" } // 11
                          _HMG_SYSDATA [ 129 ] := {                            ;
                                  "Geen",                             ; // 1
                                  "Regel",                            ; // 2
                                  "Totaal",                           ; // 3
                                  "Actieve volgorde",                 ; // 4
                                  "Opties",                           ; // 5
                                  "Nieuw regel",                      ; // 6
                                  "Aanpassen regel",                  ; // 7
                                  "Selecteer regel",                  ; // 8
                                  "Vind regel",                       ; // 9
                                  "Print opties",                     ; //10
                                  "Beschikbare velden",               ; //11
                                  "Velden te printen",                ; //12
                                  "Beschikbare printers",             ; //13
                                  "Eerste regel te printen",          ; //14
                                  "Laatste regel te printen",         ; //15
                                  "Verwijder regel",                  ; //16
                                  "Voorbeeld",                        ; //17
                                  "Laat pagina klein zien",           ; //18
                                  "Filter condities: ",               ; //19
                                  "Gefilterd: ",                      ; //20
                                  "Filter opties" ,                   ; //21
                                  "Database velden" ,                 ; //22
                                  "Vergelijkings operator",           ; //23
                                  "Filter waarde",                    ; //24
                                  "Selecteer velden om te filteren",  ; //25
                                  "Selecteer vergelijkings operator", ; //26
                                  "Gelijk",                           ; //27
                                  "Niet gelijk",                      ; //28
                                  "Groter dan",                       ; //29
                                  "Kleiner dan",                      ; //30
                                  "Groter dan of gelijk aan",         ; //31
                                  "Kleiner dan of gelijk aan"         } //32
                          _HMG_SYSDATA [ 130 ] := { ;
                                  ABM_CRLF + "Kan geen actief werkgebied vinden   "  + ABM_CRLF + "Selecteer A.U.B. een actief werkgebied voor BEWERKEN aan te roepen   " + ABM_CRLF, ; // 1
                                  "Geef de veld waarde (een tekst)",; // 2
                                  "Geef de veld waarde (een nummer)",; // 3
                                  "Selecteer de datum",; // 4
                                  "Controleer voor geldige waarde",; // 5
                                  "Geef de veld waarde",; // 6
                                  "Selecteer een regel en druk op OK",; // 7
                                  ABM_CRLF + "Je gaat het actieve regel verwijderen  " + ABM_CRLF + "Zeker weten?    " + ABM_CRLF,; // 8
                                  ABM_CRLF + "Er is geen actieve volgorde " + ABM_CRLF + "Selecteer er A.U.B. een   " + ABM_CRLF,; // 9
                                  ABM_CRLF + "Kan niet zoeken in memo of logische velden   " + ABM_CRLF,; // 10
                                  ABM_CRLF + "Regel niet gevonden   " +ABM_CRLF,; // 11
                                  "Selecteer het veld om in de lijst in te sluiten",; // 12
                                  "Selecteer het veld om uit de lijst te halen",; // 13
                                  "Selecteer de printer",; // 14
                                  "Druk op de knop om het veld in te sluiten",; // 15
                                  "Druk op de knop om het veld uit te sluiten",; // 16
                                  "Druk op de knop om het eerste veld te selecteren om te printen",; // 17
                                  "Druk op de knop om het laatste veld te selecteren om te printen",; // 18
                                  ABM_CRLF + "Geen velden meer om in te sluiten   " + ABM_CRLF,; // 19
                                  ABM_CRLF + "Selecteer eerst het veld om in te sluiten   " + ABM_CRLF,; // 20
                                  ABM_CRLF + "Geen velden meer om uit te sluiten   " + ABM_CRLF,; // 21
                                  ABM_CRLF + "Selecteer eerst het veld om uit te sluiten   " + ABM_CRLF,; // 22
                                  ABM_CRLF + "Je hebt geen velden geselecteerd   " + ABM_CRLF + "Selecteer A.U.B. de velden om in te sluiten om te printen   " + ABM_CRLF, ; // 23
                                  ABM_CRLF + "Teveel velden   " + ABM_CRLF + "Selecteer minder velden   " + ABM_CRLF,; // 24
                                  ABM_CRLF + "Printer niet klaar   " + ABM_CRLF,; // 25
                                  "Volgorde op",; // 26
                                  "Van regel",; // 27
                                  "Tot regel",; // 28
                                  "Ja",; // 29
                                  "Nee",; // 30
                                  "Pagina:",; // 31
                                  ABM_CRLF + "Selecteer A.U.B. een printer " + ABM_CRLF,; // 32
                                  "Gefilterd op", ; // 33
                                  ABM_CRLF + "Er is een actief filter    " + ABM_CRLF,; // 34
                                  ABM_CRLF + "Kan niet filteren op memo velden    " + ABM_CRLF,; // 35 
                                  ABM_CRLF + "Selecteer het veld om op te filteren    " + ABM_CRLF, ; // 36
                                  ABM_CRLF + "Selecteer een operator om te filteren    " + ABM_CRLF,; // 37
                                  ABM_CRLF + "Type een waarde om te filteren " + ABM_CRLF,; // 38
                                  ABM_CRLF + "Er is geen actief filter    "+ ABM_CRLF,; // 39
                                  ABM_CRLF + "Deactiveer filter?   " + ABM_CRLF,; // 40
                                  ABM_CRLF + "Regel geblokkeerd door een andere gebuiker" + ABM_CRLF } // 41

        // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
        case cLang == "SL"
  	/////////////////////////////////////////////////////////////
	// SLOVENIAN
	////////////////////////////////////////////////////////////

		// MISC MESSAGES

		_hMG_SYSDATA [ 331 ] [1] := 'Ste prepri�ani ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Zapri okno'
		_hMG_SYSDATA [ 331 ] [3] := 'Zapiranje ni dovoljeno'
		_hMG_SYSDATA [ 331 ] [4] := 'Program je �e zagnan'
		_hMG_SYSDATA [ 331 ] [5] := 'Popravi'
		_hMG_SYSDATA [ 331 ] [6] := 'V redu'
		_hMG_SYSDATA [ 331 ] [7] := 'Prekini'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE MESSAGES

		_HMG_SYSDATA [ 136 ]  := { "Window: "                        ,;     
                           " not defined. Program terminated"     ,;
                           "HMG Error"                        ,;
                           "Control: "                            ,;
                           " Of "                                 ,;
                           " Already defined. Program Terminated" ,;
                           "Type Not Allowed. Program terminated" ,;
                           "False WorkArea. Program Terminated"   ,;
                           "Zapis ureja drug uporabnik"           ,;
                           "Opozorilo"                            ,;
                           "Narobe vnos" }

	       _HMG_SYSDATA [ 137 ] := { 'Ste prepri�ani ?' , 'Bri�i vrstico' }

		// EDIT MESSAGES

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Bri�i vrstico"+CHR(13)+"Ste prepri�ani ?"+CHR(13)     ,;
                     CHR(13)+"Manjka indeksna datoteka"+CHR(13)+"Ne morem iskati"+CHR(13)       ,;
                     CHR(13)+"Ne najdem indeksnega polja"+CHR(13)+"Ne morem iskati"+CHR(13)     ,;
                     CHR(13)+"Ne morem iskati po"+CHR(13)+"memo ali logi�nih poljih"+CHR(13)    ,;
                     CHR(13)+"Ne najdem vrstice"+CHR(13)                                        ,;
                     CHR(13)+"Preve� kolon"+CHR(13)+"Poro�ilo ne gre na list"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Vrstica"    ,;
                     "�tevilo vrstic"         ,;
                     "       (Nova)"          ,;
                     "      (Popravi)"        ,;
                     "Vnesi �tevilko vrstice" ,;
                     "Poi��i"                 ,;
                     "Besedilo za iskanje"    ,;
                     "Datum za iskanje"       ,;
                     "�tevilka za iskanje"    ,;
                     "Parametri poro�ila"     ,;
                     "Kolon v poro�ilu"       ,;
                     "Kolon na razpolago"     ,;
                     "Za�etna vrstica"        ,;
                     "Kon�na vrstica"         ,;
                     "Pporo�ilo za "          ,;
                     "Datum:"                 ,;
                     "Za�etna vrstica:"       ,;
                     "Kon�na vrstica:"        ,;
                     "Urejeno po:"            ,;
                     "Ja"                     ,;
                     "Ne"                     ,;
                     "Stran "                 ,;
                     " od "                 }

		_HMG_SYSDATA [ 133 ] := { "Zapri" ,;
                     "Nova"              ,;
                     "Uredi"             ,;
                     "Bri�i"             ,;
                     "Poi��i"            ,;
                     "Pojdi na"          ,;
                     "Poro�ilo"          ,;
                     "Prva"              ,;
                     "Prej�nja"          ,;
                     "Naslednja"         ,;
                     "Zadnja"            ,;
                     "Shrani"            ,;
                     "Prekini"           ,;
                     "Dodaj"             ,;
                     "Odstrani"          ,;
                     "Natisni"           ,;
                     "Zapri"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                  ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED

	        _HMG_SYSDATA [ 128 ] := {     ;
                "&Zapri",             ; // 1
                "&Nova",              ; // 2
                "&Spremeni",          ; // 3
                "&Bri�i",             ; // 4
                "&Poi��i",            ; // 5
                "&Natisni",           ; // 6
                "&Prekini",           ; // 7
                "&V redu",            ; // 8
                "&Kopiraj",           ; // 9
                "&Aktiviraj Filter",  ; // 10
                "&Deaktiviraj Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                 ;
                "Prazno",                        ; // 1
                "Vrstica",                       ; // 2
                "Skupaj",                        ; // 3
                "Activni indeks",                ; // 4
                "Mo�nosti",                      ; // 5
                "Nova vrstica",                  ; // 6
                "Spreminjaj vrstico",            ; // 7
                "Ozna�i vrstico",                ; // 8
                "Najdi vrstico",                 ; // 9
                "Mo�nosti tiskanja",             ; // 10
                "Polja na razpolago",            ; // 11
                "Polja za tiskanje",             ; // 12
                "Tiskalniki na razpolago",       ; // 13
                "Prva vrstica za tiskanje",      ; // 14
                "Zadnja vrstica za tiskanje",    ; // 15
                "Bri�i vrstico",                 ; // 16
                "Pregled",                       ; // 17
                "Mini pregled strani",           ; // 18
                "Pogoj za filter: ",             ; // 19
                "Filtrirano: ",                  ; // 20
                "Mo�nosti filtra" ,              ; // 21
                "Polja v datoteki" ,             ; // 22
                "Operator za primerjavo",        ; // 23
                "Vrednost filtra",               ; // 24
                "Izberi polje za filter",        ; // 25
                "Izberi operator za primerjavo", ; // 26
                "Enako",                         ; // 27
                "Neenako",                       ; // 28
                "Ve�je od",                      ; // 29
                "Manj�e od",                     ; // 30
                "Ve�je ali enako od",            ; // 31
                "Manj�e ali enako od"            } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,; // 1
                "Vnesi vrednost (tekst)",                                                                                        ; // 2
                "Vnesi vrednost (�tevilka)",                                                                                     ; // 3
                "Izberi datum",                                                                                                  ; // 4
                "Ozna�i za logi�ni DA",                                                                                          ; // 5
                "Vnesi vrednost",                                                                                                ; // 6
                "Izberi vrstico in pritisni <V redu>",                                                                           ; // 7
                ABM_CRLF + "Pobrisali boste trenutno vrstico   " + ABM_CRLF + "Ste prepri�ani?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "Ni aktivnega indeksa   " + ABM_CRLF + "Prosimo, izberite ga   " + ABM_CRLF,                          ; // 9
                ABM_CRLF + "Ne morem iskati po logi�nih oz. memo poljih   " + ABM_CRLF,                                          ; // 10
                ABM_CRLF + "Ne najdem vrstice   " + ABM_CRLF,                                                                    ; // 11
                "Izberite polje, ki bo vklju�eno na listo",                                                                      ; // 12
                "Izberite polje, ki NI vklju�eno na listo",                                                                      ; // 13
                "Izberite tisklanik",                                                                                            ; // 14
                "Pritisnite gumb za vklju�itev polja",                                                                           ; // 15
                "Pritisnite gumb za izklju�itev polja",                                                                          ; // 16
                "Pritisnite gumb za izbor prve vrstice za tiskanje",                                                             ; // 17
                "Pritisnite gumb za izbor zadnje vrstice za tiskanje",                                                           ; // 18
                ABM_CRLF + "Ni ve� polj za dodajanje   " + ABM_CRLF,                                                             ; // 19
                ABM_CRLF + "Najprej izberite ppolje za vklju�itev   " + ABM_CRLF,                                                ; // 20
                ABM_CRLF + "Ni ve� polj za izklju�itev   " + ABM_CRLF,                                                           ; // 21
                ABM_CRLF + "Najprej izberite polje za izklju�itev   " + ABM_CRLF,                                                ; // 22
                ABM_CRLF + "Niste izbrali nobenega polja   " + ABM_CRLF + "Prosom, izberite polje za tiskalnje   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Preve� polj   " + ABM_CRLF + "Zmanj�ajte �tevilo polj   " + ABM_CRLF,                                ; // 24
                ABM_CRLF + "Tiskalnik ni pripravljen   " + ABM_CRLF,                                                             ; // 25
                "Urejeno po",                                                                                                    ; // 26
                "Od vrstice",                                                                                                    ; // 27
                "do vrstice",                                                                                                    ; // 28
                "Ja",                                                                                                            ; // 29
                "Ne",                                                                                                            ; // 30
                "Stran:",                                                                                                        ; // 31
                ABM_CRLF + "Izberite tiskalnik   " + ABM_CRLF,                                                                   ; // 32
                "Filtrirano z",                                                                                                  ; // 33
                ABM_CRLF + "Aktiven filter v uporabi    " + ABM_CRLF,                                                            ; // 34
                ABM_CRLF + "Ne morem filtrirati z memo polji    " + ABM_CRLF,                                                    ; // 35
                ABM_CRLF + "Izberi polje za filtriranje    " + ABM_CRLF,                                                         ; // 36
                ABM_CRLF + "Izberi operator za filtriranje    " + ABM_CRLF,                                                      ; // 37
                ABM_CRLF + "Vnesi vrednost za filtriranje    " + ABM_CRLF,                                                       ; // 38
                ABM_CRLF + "Ni aktivnega filtra    " + ABM_CRLF,                                                                 ; // 39
                ABM_CRLF + "Deaktiviram filter?   " + ABM_CRLF,                                                                  ; // 40
                ABM_CRLF + "Vrstica zaklenjena - uporablja jo drug uporabnik    " + ABM_CRLF                                     } // 41

	OtherWise
	/////////////////////////////////////////////////////////////
	// DEFAULT ENGLISH
	////////////////////////////////////////////////////////////

		// MISC MESSAGES (ENGLISH DEFAULT)

		_hMG_SYSDATA [ 331 ] [1] := 'Are you sure ?'
		_hMG_SYSDATA [ 331 ] [2] := 'Close Window'
		_hMG_SYSDATA [ 331 ] [3] := 'Close not allowed'
		_hMG_SYSDATA [ 331 ] [4] := 'Program Already Running'
		_hMG_SYSDATA [ 331 ] [5] := 'Edit'
		_hMG_SYSDATA [ 331 ] [6] := 'Ok'
		_hMG_SYSDATA [ 331 ] [7] := 'Cancel'
		_hMG_SYSDATA [ 331 ] [8] := 'Pag.'

		// BROWSE MESSAGES (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 136 ]  := { "Window: "                                              ,;
                                     " is not defined. Program terminated"                   ,;
                                     "HMG Error"                                         ,;
                                     "Control: "                                             ,;
                                     " Of "                                                  ,;
				     " Already defined. Program Terminated"                  ,;
				     "Browse: Type Not Allowed. Program terminated"          ,;
				     "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
				     "Record Is Being Edited By Another User"                ,;
				     "Warning"                                               ,;
				     "Invalid Entry"                                          }
	       _HMG_SYSDATA [ 137 ] := { 'Are you sure ?' , 'Delete Record' }

		// EDIT MESSAGES (ENGLISH DEFAULT)

		_HMG_SYSDATA [ 131 ]   := { CHR(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  ,;
                     CHR(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            ,;
                     CHR(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        ,;
                     CHR(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       ,;
                     CHR(13)+"Record not found"+CHR(13)                                        ,;
                     CHR(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

		_HMG_SYSDATA [ 132 ]  := { "Record"              ,;
                     "Record count"        ,;
                     "       (New)"        ,;
                     "      (Edit)"        ,;
                     "Enter record number" ,;
                     "Find"                ,;
                     "Search text"         ,;
                     "Search date"         ,;
                     "Search number"       ,;
                     "Report definition"   ,;
                     "Report columns"      ,;
                     "Available columns"   ,;
                     "Initial record"      ,;
                     "Final record"        ,;
                     "Report of "          ,;
                     "Date:"               ,;
                     "Initial record:"     ,;
                     "Final record:"       ,;
                     "Ordered by:"         ,;
                     "Yes"                 ,;
                     "No"                  ,;
                     "Page "               ,;
                     " of "                 }

		_HMG_SYSDATA [ 133 ] := { "Close"    ,;
                     "New"      ,;
                     "Edit"     ,;
                     "Delete"   ,;
                     "Find"     ,;
                     "Goto"     ,;
                     "Report"   ,;
                     "First"    ,;
                     "Previous" ,;
                     "Next"     ,;
                     "Last"     ,;
                     "Save"     ,;
                     "Cancel"   ,;
                     "Add"      ,;
                     "Remove"   ,;
                     "Print"    ,;
                     "Close"     }
		_HMG_SYSDATA [ 134 ]  := { "EDIT, workarea name missing"                              ,;
                     "EDIT, this workarea has more than 16 fields"              ,;
                     "EDIT, refresh mode out of range (please report bug)"      ,;
                     "EDIT, main event number out of range (please report bug)" ,;
                     "EDIT, list event number out of range (please report bug)"  }

		// EDIT EXTENDED (ENGLISH DEFAULT)

	        _HMG_SYSDATA [ 128 ] := {            ;
                "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
        	_HMG_SYSDATA [ 129 ] := {                        ;
                "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",               ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
	        _HMG_SYSDATA [ 130 ] := { ;
                ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
                "Type the field value (any text)",                                                                                      ; // 2
                "Type the field value (any number)",                                                                                    ; // 3
                "Select the date",                                                                                                      ; // 4
                "Check for true value",                                                                                                 ; // 5
                "Enter the field value",                                                                                                ; // 6
                "Select any record and press OK",                                                                                       ; // 7
                ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
                ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
                ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
                ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
                "Select the field to include to list",                                                                                  ; // 12
                "Select the field to exclude from list",                                                                                ; // 13
                "Select the printer",                                                                                                   ; // 14
                "Push button to include field",                                                                                         ; // 15
                "Push button to exclude field",                                                                                         ; // 16
                "Push button to select the first record to print",                                                                      ; // 17
                "Push button to select the last record to print",                                                                       ; // 18
                ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
                ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
                ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
                ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
                ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
                ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
                ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
                "Ordered by",                                                                                                           ; // 26
                "From record",                                                                                                          ; // 27
                "To record",                                                                                                            ; // 28
                "Yes",                                                                                                                  ; // 29
                "No",                                                                                                                   ; // 30
                "Page:",                                                                                                                ; // 31
                ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
                "Filtered by",                                                                                                          ; // 33
                ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
                ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
                ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
                ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
                ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
                ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
                ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
                ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

	endcase

ENDIF // HMG_IsCurrentCodePageUnicode()

Return



