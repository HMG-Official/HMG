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

FUNCTION connect2db(host,user,password,dbname)
local dbo := tmysqlserver():new(AllTrim(host),AllTrim(user),AllTrim(password))
IF dbo:NetErr()
   msginfo(dbo:ERROR())
   RETURN nil
ENDIF
dbo:selectdb(dbname)
IF dbo:NetErr()
   msginfo(dbo:ERROR())
   RETURN nil
ENDIF
//msginfo("Successfully Connected to the MySQL Server")
RETURN dbo
	
function sql(dbo1,qstr)
local table := nil
local currow := nil
local tablearr := {}
local rowarr := {}
local curdateformat := set(_SET_DATEFORMAT)
local i := 0
local j := 0
local aTinyIntFields := {}
local firstrow  // ADD
set date ansi
table := dbo1:query(qstr)
if table:neterr()
   msgstop(table:error())
   table:destroy()
   set(_SET_DATEFORMAT,curdateformat)
   return tablearr
else
   if table:lastrec() > 0
      asize( aTinyIntFields, 0 )
      firstrow := table:getrow( 1 )
      for j := 1 to HMG_LEN( table:aFieldStruct )
         if table:aFieldStruct[ j, 4 ] == 1 // tiny integer
            aadd( aTinyIntFields, j )
         endif
      next j
      asize(tablearr,0)
      for i := 1 to table:lastrec()
         asize(rowarr,0)     
         currow := table:getrow(i)
         for j := 1 to table:fcount()         
            aadd(rowarr,currow:fieldget(j))
         next j
         for j := 1 to HMG_LEN( aTinyIntFields )
            if rowarr[ aTinyIntFields[ j ] ] > 0
               rowarr[ aTinyIntFields[ j ] ] := .t.
            else
               rowarr[ aTinyIntFields[ j ] ] := .f.
            endif
         next j
         aadd(tablearr,aclone(rowarr))
      next i
   endif
   table:destroy()
   set(_SET_DATEFORMAT,curdateformat)
   return tablearr
endif
return tablearr

function miscsql(dbo,qstr)
local curdateformat := set( _SET_DATEFORMAT)
local table // ADD 

set date ansi
table := dbo:query(qstr)
set( _SET_DATEFORMAT,curdateformat)
if table:NetErr()
    msgstop(table:ERROR())
    table:destroy()
    return  .f.
endif
table:destroy()
return .t.

function C2SQL(Value)
local cValue := ""
local cdate := ""
if valtype(value) == "C" .and. HMG_LEN(alltrim(value)) > 0
   value := HB_UTF8STRTRAN(value,"'","''")
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


