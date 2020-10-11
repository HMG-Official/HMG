/*----------------------------------------------------------------------------
 HMG_SQL_Bridge - HMG -> SQL Bridges for MySQL,PostgreSQL and SQLite

 Copyright 2010 S. Rathinagiri <srgiri@dataone.in>
 

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
 contained in this release of HMG_SQL_Bridge.

 The exception is that, if you link the HMG_SQL_Bridge library with other 
 files to produce an executable, this does not by itself cause the resulting 
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the 
 HMG_SQL_Bridge library code into it.

 Parts of this project (especially hbmysql, hbpgsql and hbsqlit3 library contributions) are based upon:

	"Harbour Project"
	Copyright 1999-2008, http://www.harbour-project.org/
	
  "HMG - Harbour Windows GUI"
  Copyright 2002-2010 Roberto Lopez <mail.box.hmg@gmail.com>,http://sites.google.com/site/hmgweb/
	
	"HBMYSQL"  - Luiz Rafael Culik - <culik@sl.conex.net>
	"HBPGSQL"  - Rodrigo Moreno rodrigo_moreno@yahoo.com
	"HBSQLIT3" - P.Chornyj <myorg63@mail.ru>

---------------------------------------------------------------------------*/
#include <hmg.ch>

FUNCTION connect2db( dbname, lCreate, cMsg )
local dbo1 := sqlite3_open( dbname, lCreate )
default cMsg := ''
IF Empty( dbo1 )
   if PCount() > 2
      cMsg := "Database could not be connected!"
   else
      Msgstop( "Database could not be connected!" )
   endif
ENDIF   
RETURN dbo1


function sql( dbo1, qstr, cMsg )
local table := {}
local currow := nil
local tablearr := {}
local rowarr := {}
local typesarr := {}
local current := ""
local i := 0
local j := 0
local type1 := ""
local stmt := nil
local cDate
default cMsg := ''
if empty( dbo1 )
   if PCount() > 2
      cMsg := "Database Connection Error!"
   else
      msgstop( "Database Connection Error!" )
   endif   
   return tablearr
else
   cMsg := ''   
endif
table := sqlite3_get_table( dbo1, qstr )
if sqlite3_errcode( dbo1 ) > 0 // error
   if PCount() > 2
      cMsg := sqlite3_errmsg(dbo1)+" Query is : "+qstr
   else
      msgstop( sqlite3_errmsg(dbo1)+" Query is : "+qstr )
   endif   
   return nil
endif
stmt := sqlite3_prepare( dbo1, qstr )
IF ! Empty( stmt )
   for i := 1 to sqlite3_column_count( stmt )
      type1 := HMG_UPPER(alltrim(sqlite3_column_decltype( stmt,i)))
      do case
         case type1 == "INTEGER" .or. type1 == "REAL" .or. type1 == "FLOAT" .or. type1 == "DOUBLE"
            aadd(typesarr,"N")
         case type1 == "DATE" .or. type1 == "DATETIME"
            aadd(typesarr,"D")
         case type1 == "BOOL"
            aadd(typesarr,"L")
         otherwise
            aadd(typesarr,"C")
      endcase
   next i
endif
SQLITE3_FINALIZE( stmt )
stmt := nil
if HMG_LEN(table) > 1
   asize(tablearr,0)
   for i := 2 to HMG_LEN(table)
      rowarr := table[i]
      for j := 1 to HMG_LEN(rowarr)
         do case
            case typesarr[j] == "D"
               cDate := HB_USUBSTR(rowarr[j],1,4)+HB_USUBSTR(rowarr[j],6,2)+HB_USUBSTR(rowarr[j],9,2)
               rowarr[j] := stod(cDate)
            case typesarr[j] == "N"
               rowarr[j] := val(rowarr[j])
            case typesarr[j] == "L"
               if val(rowarr[j]) == 1
                  rowarr[j] := .t.
               else
                  rowarr[j] := .f.
               endif
         endcase
      next j
      aadd(tablearr,aclone(rowarr))
   next i
endif
return tablearr

function miscsql( dbo1, qstr, cMsg )
default cMsg := ''
if empty( dbo1 )
   if PCount() > 2
      cMsg := "Database Connection Error!"
   else
      MsgStop( "Database Connection Error!" )
   endif      
   return .f.
endif
sqlite3_exec( dbo1, qstr )
if sqlite3_errcode( dbo1 ) > 0 // error
   if PCount() > 2
      cMsg := sqlite3_errmsg(dbo1)+" Query is : "+qstr
   else
      MsgStop( sqlite3_errmsg(dbo1)+" Query is : "+qstr )   
   endif   
   return .f.
endif
return .t.

function C2SQL(Value)
local cValue := ""
local cdate := ""
if ( valtype(value) == "C" .or. valtype( value ) == "M" ) .and. HMG_LEN(alltrim(value)) > 0
   value := HB_UTF8STRTRAN(value, "'", "''" )
endif
do case
   case Valtype(Value) == "N"
      cValue := AllTrim(Str(Value))
   case Valtype(Value) == "D"
      if !Empty(Value)
         cdate := dtos(value)
         cValue := "'"+HB_USUBSTR(cDate,1,4)+"-"+HB_USUBSTR(cDate,5,2)+"-"+HB_USUBSTR(cDate,7,2)+"'"
      else
         cValue := "''"
      endif
   case Valtype(Value) $ "CM"
      IF Empty( Value)
         cValue="''"
      ELSE
         cValue := "'" + value + "'"
      ENDIF
   case Valtype(Value) == "L"
      cValue := AllTrim(Str(iif(Value == .F., 0, 1)))
   otherwise
      cValue := "''"       // NOTE: Here we lose values we cannot convert
endcase
return cValue
