
#include 'hmg.ch'

FUNCTION Main()

    DEFINE WINDOW Win_1 ; 
        AT 0,0 ; 
        WIDTH 500 ; 
        HEIGHT 500 ; 
        TITLE 'Win_1' ; 
        MAIN ; 
        NOSIZE  

	DEFINE MAIN MENU
		DEFINE POPUP 'Test'
			MENUITEM 'Set Row' ACTION Win_1.Control_1.Row := Val(InputBox('Enter Row',''))
			MENUITEM 'Set Col' ACTION Win_1.Control_1.Col := Val(InputBox('Enter Col',''))

			MENUITEM 'Get Row' ACTION MsgInfo ( Str ( Win_1.Control_1.Row ) )
			MENUITEM 'Get Col' ACTION MsgInfo ( Str ( Win_1.Control_1.Col ) )
			MENUITEM 'Get Width' ACTION MsgInfo ( Str ( Win_1.Control_1.Width ) )
			MENUITEM 'Get Height' ACTION MsgInfo ( Str ( Win_1.Control_1.Height ) )

		END POPUP
	END MENU

        @ 10,10 MONTHCALENDAR CONTROL_1 ; 
            OF Win_1 ; 
            FONT 'Arial' ; 
            SIZE 8.00


    END WINDOW

    ACTIVATE WINDOW Win_1

RETURN NIL


