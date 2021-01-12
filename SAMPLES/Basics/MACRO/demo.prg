#include "hmg.ch"

FUNCTION Main

   LOCAL Botoes := {'1','2','3'} , i
   LOCAL cn

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN

		FOR i := 1 to 3

			CN := 'Control_' + Alltrim( Str( i ) )

			@ i *100 ,10  BUTTON &( CN ) ;
				CAPTION Botoes[ i ] ;
				ACTION MsgInfo( 'Test' ) ;
				WIDTH 100 ;
				HEIGHT 25

		NEXT i

	END WINDOW

	ACTIVATE WINDOW Win_1

RETURN Nil
