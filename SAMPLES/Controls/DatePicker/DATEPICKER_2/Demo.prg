/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

FUNCTION Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
    WIDTH 600 HEIGHT 540 ;
		TITLE "HMG DatePicker Demo" ;
		MAIN ;
    FONT "Arial" SIZE 12

    @  10, 10 DATEPICKER Date_1 WIDTH 270 ; 
              FONT "Arial" SIZE 12 ;
              TOOLTIP "DatePicker Control"

    @ 230, 10 DATEPICKER Date_2 WIDTH 247 ;
              FONT "Arial" SIZE 12 ;
              UPDOWN
              TOOLTIP "DatePicker Control UpDown"

/*
    @ 230,257 BUTTON Button_2 CAPTION HB_UTF8CHR(0x1F4C5) ;
              FONT "Segoe UI Symbol" SIZE 12 ;
              WIDTH 23 HEIGHT 23 FLAT ;
              ACTION (Form_1.Calendar_2.VISIBLE := ! Form_1.Calendar_2.VISIBLE ) ;
              TOOLTIP "Calendar Toggle"
*/

    @ 230,257 BUTTON Button_2 PICTURE "Calendar20" ;
              WIDTH 23 HEIGHT 23 FLAT ;
              ACTION (Form_1.Calendar_2.VISIBLE := ! Form_1.Calendar_2.VISIBLE ) ;
              TOOLTIP "Calendar Toggle"

    @ 260, 10 MONTHCALENDAR Calendar_2 WIDTH 270 HEIGHT 185 ;
              FONT "Arial" SIZE 12 ;
              NOTODAY INVISIBLE ;
              TITLEBACKCOLOR WHITE ;
              ON CHANGE (Form_1.Date_2.VALUE := Form_1.Calendar_2.VALUE, Form_1.Calendar_2.VISIBLE := .N.)

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

RETURN NIL

