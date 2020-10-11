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
#include "postgres.ch"

FUNCTION connect2db(cHost,cUser,cPass,cDb,nPort)
local dbo1 := nil
default nPort := 5432
dbo1 := PQConnect(cDb, cHost, cUser, cPass, nPort)
IF PQStatus(dbo1) != CONNECTION_OK 
   msginfo("Database could not be connected!")
   RETURN nil
ENDIF
RETURN dbo1

function sql(dbo1,qstr)
local aTable := {}
local tablearr := {}
local rowarr := {}
local i := 0
local j := 0
local oRes := nil
local aMetaData := {}
local cDate := ""
if empty(dbo1)
   msgstop("Database Connection Error!")
   return tablearr
endif
oRes := PQexec(dbo1,qstr)
if oRes == nil
   msgstop("Error in execution!")
   return .f.
else
   if PQresultStatus(oRes) == PGRES_TUPLES_OK
      aMetaData := PQmetadata(oRes)
      aTable := PQRESULT2ARRAY(oRes)
      for i := 1 to HMG_LEN(aTable)
         asize(rowarr,0)     
         for j := 1 to HMG_LEN(aTable[i])
            do case
               case HMG_UPPER(aMetaData[j,2]) == "BIGINT".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "DOUBLE PRECISION".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "INTEGER".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "NUMERIC".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "DECIMAL".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "REAL".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "SMALLINT"
                  aadd(rowarr,val(alltrim(aTable[i,j])))
               case HMG_UPPER(aMetaData[j,2]) == "CHAR".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "CHARACTER VARYING".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "CHARACTER".or. ;
                    HMG_UPPER(aMetaData[j,2]) == "VARCHAR" 
                  aadd(rowarr,aTable[i,j])
               case HMG_UPPER(aMetaData[j,2]) == "BOOLEAN"
                  aadd(rowarr,iif(aTable[i,j]=="t",.t.,.f.))
               case HMG_UPPER(aMetaData[j,2]) == "DATE"
                  cDate := HB_USUBSTR(aTable[i,j],1,4)+HB_USUBSTR(aTable[i,j],6,2)+HB_USUBSTR(aTable[i,j],9,2)
                  aadd(rowarr,stod(cDate))
               otherwise //bit, bit varying,interval
                  aadd(rowarr,aTable[i,j])
            endcase
         next j
         aadd(tablearr,rowarr)
      next i                        
   endif
   PQclear(oRes)
endif
return aclone(tablearr)


function miscsql(dbo1,qstr)
local oRes := nil
if empty(dbo1)
   msgstop("Database Connection Error!")
   return .f.
endif
oRes := PQexec(dbo1,qstr)
if oRes == nil
   msgstop("Error in execution!")
   return .f.
else
   if PQResultStatus(oRes) != PGRES_COMMAND_OK
      msgstop("Query Execution Error!")
      PQclear(oRes)
      return .f.
   endif    
   PQclear(oRes)
endif
return .t.

function closedb(dbo)
   PQClose(dbo)
return nil


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
      cValue := AllTrim(Str(iif(Value == .F., '0', '1')))
   otherwise
      cValue := "''"       // NOTE: Here we lose values we cannot convert
endcase
return cValue
