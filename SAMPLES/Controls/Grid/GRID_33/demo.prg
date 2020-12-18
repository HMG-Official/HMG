/*
* HMG Virtual Grid Demo
* (c) 2009 Roberto Lopez
*/

#include "hmg.ch"

Function Main

Local aValue := { 0 , 0 }

	* Grid Column Controls Definitions

	aCtrl_1 := {'TEXTBOX','NUMERIC','9999999999'}
	aCtrl_2 := {'TEXTBOX','CHARACTER'}
	aCtrl_3 := {'TEXTBOX','CHARACTER'}
	aCtrl_4 := {'DATEPICKER','UPDOWN'}
	aCtrl_5 := { 'CHECKBOX' , 'Yes' , 'No' }
	aCtrl_6 := { 'EDITBOX' }

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 800 ;
		HEIGHT 510 ;
		TITLE 'GRID INDEX...FOR TEST' ;
		MAIN

		DEFINE MAIN MENU
			POPUP 'File'
				ITEM 'Append (Alt+A)'				ACTION Form_1.Grid_1.Append
				ITEM 'Set RecNo'				ACTION Form_1.Grid_1.RecNo := val(InputBox('',''))
				ITEM 'Get RecNo'				ACTION MsgInfo( Str(Form_1.Grid_1.RecNo) )
				ITEM 'Get Value'				ACTION ( aValue := Form_1.Grid_1.Value , MsgInfo( Str( aValue [1] ) + ' , ' + Str( aValue [2] ) ) )
				ITEM 'Set Value'				ACTION ( aValue [ 1 ] :=  val(InputBox('New Row','Selected Cell (Value)')) , aValue [ 2 ] :=  val(InputBox('New Col','Selected Cell (Value)')) , Form_1.Grid_1.Value := { aValue [ 1 ] , aValue [ 2 ] } )
				ITEM 'Delete (Alt+D)'				ACTION Form_1.Grid_1.Delete
				ITEM 'Recall (Alt+R)'				ACTION Form_1.Grid_1.Recall
				ITEM 'Save Pending Changes (Alt+S)'		ACTION Form_1.Grid_1.Save
				ITEM 'Clear Changes Buffer (Undo) (ALt+U)'	ACTION Form_1.Grid_1.ClearBuffer
			END POPUP
		END MENU

		USE TEST SHARED
		INDEX ON CODE TO CODE FOR CODE/3 == INT(CODE/3)

		GO TOP

		@ 10,10 GRID Grid_1 ;
			WIDTH 770 ;
			HEIGHT 440 ;
			HEADERS {'Column 1','Column 2','Column 3','Column 4','Column 5','Column 6'} ;
			WIDTHS {140,140,140,100,100,100};
			VALUE { 1 , 1 } ;
			ROWSOURCE "Test" ;
			COLUMNFIELDS { 'Code' ,  'First' , 'Last' ,  'Birth' , 'Married' , 'Bio' } ;
			COLUMNCONTROLS { aCtrl_1 , aCtrl_2 , aCtrl_3 , aCtrl_4 , aCtrl_5 , aCtrl_6 } ;
			EDIT ;
			ALLOWAPPEND ;
			ALLOWDELETE
		
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return
