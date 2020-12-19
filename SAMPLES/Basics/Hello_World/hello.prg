/*
* HMG Hello World Demo
* (c) 2002-2009 Roberto Lopez <mail.box.hmg@gmail.com>
*/

#include "hmg.ch"

FUNCTION Main

   DEFINE WINDOW Win_1 ;
         ROW 0 ;
         COL 0 ;
         WIDTH 400 ;
         HEIGHT 400 ;
         TITLE 'Hello World!' ;
         WINDOWTYPE MAIN

   END WINDOW

   Win_1.Center

   Win_1.Activate

   RETURN Nil
