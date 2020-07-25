
/*
File:		MyCrypt.prg
Author:		Grigory Filatov
Description:	Crypto Library for HMG
Status:		Public Domain
Notes:		This is very simple crypt algorithm based on XOR encryption.
*/
MEMVAR _HMG_SYSDATA
#define MSGALERT( c ) MsgEXCLAMATION( c, "Attention" )
#define MSGSTOP( c ) MsgStop( c, "Stop!" )
/*
*/
FUNCTION _ENCRYPT(cStr, cPass)

   LOCAL cXorStr := CHARXOR( cStr, "<ORIGINAL>" )

   IF !Empty(cPass)

	cXorStr := CHARXOR( cXorStr, cPass )

   ENDIF

RETURN cXorStr

FUNCTION _DECRYPT(cStr, cPass)

   LOCAL cXorStr := CHARXOR( cStr, cPass )

RETURN CHARXOR( cXorStr, "<ORIGINAL>" )

/*
*/
FUNCTION FI_CODE(cInFile, cPass, cOutFile, lDelete)

   LOCAL nHandle, cBuffer, cStr, nRead := 1
   LOCAL nOutHandle

   IF Empty(cInFile) .OR. .NOT. FILE(cInFile)

      MSGSTOP("No such file")
      RETURN NIL

   ENDIF

   IF ALLTRIM(HMG_UPPER(cInFile)) == ALLTRIM(HMG_UPPER(cOutFile))

      MSGALERT("New and old filenames must not be the same")
      RETURN NIL

   ENDIF

   IF cPass == NIL

      cPass := "<PRIMARY>"

   ENDIF

   IF lDelete == NIL

      lDelete := .F.

   ENDIF

   IF HMG_LEN(cPass) > 10

      cPass := hb_USubStr(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   nHandle := FOpen(cInFile, 2)

   IF FError() <> 0

      MSGSTOP("File I/O error, cannot proceed")

   ENDIF

   cBuffer := Space(30)
   FRead(nHandle, @cBuffer, 30)

   IF cBuffer == "ENCRYPTED FILE (C) ODESSA 2002"

      MSGSTOP("File already encrypted")
      FClose(nHandle)
      RETURN NIL

   ENDIF

   FSeek(nHandle, 0)
   nOutHandle := FCreate(cOutFile, 0)

   IF FError() <> 0

      MSGSTOP("File I/O error, cannot proceed")
      FClose(nHandle)
      RETURN NIL

   ENDIF

   FWrite(nOutHandle, "ENCRYPTED FILE (C) ODESSA 2002")
   cStr := _ENCRYPT(cPass)
   FWrite(nOutHandle, cStr)
   cBuffer := Space(512)

   DO WHILE nRead <> 0

      nRead := FRead(nHandle, @cBuffer, 512)

      IF nRead <> 512

         cBuffer := hb_USubStr(cBuffer, 1, nRead)

      ENDIF

      cStr := _ENCRYPT(cBuffer, cPass)
      FWrite(nOutHandle, cStr)

   ENDDO

   FClose(nHandle)
   FClose(nOutHandle)

   IF lDelete

      FErase(cInFile)

   ENDIF

RETURN NIL

/*
*/
FUNCTION FI_DECODE(cInFile, cPass, cOutFile, lDelete)

   LOCAL nHandle, cBuffer, cStr, nRead := 1
   LOCAL nOutHandle

   IF Empty(cInFile) .OR. .NOT. FILE(cInFile)

      MSGSTOP("No such file")
      RETURN NIL

   ENDIF

   IF ALLTRIM(HMG_UPPER(cInFile)) == ALLTRIM(HMG_UPPER(cOutFile))

      MSGALERT("New and old filenames must not be the same")
      RETURN NIL

   ENDIF

   IF cPass == NIL

      cPass := "<PRIMARY>"

   ENDIF

   IF lDelete == NIL

      lDelete := .F.

   ENDIF

   IF HMG_LEN(cPass) > 10

      cPass := hb_USubStr(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   nHandle := FOpen(cInFile, 2)

   IF FError() <> 0

      MSGSTOP("File I/O error, cannot proceed")

   ENDIF

   cBuffer := Space(30)
   FRead(nHandle, @cBuffer, 30)

   IF cBuffer <> "ENCRYPTED FILE (C) ODESSA 2002"

      MSGSTOP("File is not encrypted")
      FClose(nHandle)
      RETURN NIL

   ENDIF

   cBuffer := Space(10)
   FRead(nHandle, @cBuffer, 10)

   IF cBuffer <> _ENCRYPT(cPass)

      MSGALERT("You have entered the wrong password")
      FClose(nHandle)
      RETURN NIL

   ENDIF

   nOutHandle := FCreate(cOutFile, 0)

   IF FError() <> 0

      MSGSTOP("File I/O error, cannot proceed")
      FClose(nHandle)
      RETURN NIL

   ENDIF

   cBuffer := Space(512)

   DO WHILE nRead <> 0

      nRead := FRead(nHandle, @cBuffer, 512)

      IF nRead <> 512

         cBuffer := hb_USubStr(cBuffer, 1, nRead)

      ENDIF

      cStr := _DECRYPT(cBuffer, cPass)
      FWrite(nOutHandle, cStr)

   ENDDO

   FClose(nHandle)
   FClose(nOutHandle)

   IF lDelete

      FErase(cInFile)

   ENDIF

RETURN NIL

/*
*/
FUNCTION DB_ENCRYPT(cFile, cPass)

   LOCAL nHandle, cBuffer := Space(4), cFlag := Space(3)

   IF cPass == NIL

      cPass := "<PRIMARY>"

   ENDIF

   IF cFile == NIL

      cFile := "TEMP.DBF"

   ENDIF

   IF HMG_LEN(cPass) > 10

      cPass := hb_USubStr(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   IF hb_UAt(".", cFileName(cFile)) = 0

      cFile := cFile + ".DBF"

   ENDIF

   IF FILE(cFile)

      nHandle := FOpen(cFile, 2)

      IF FError() <> 0

         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FSeek(nHandle, 28)

      IF FError() <> 0

         MSGSTOP("File I/O error, cannot encrypt file")
         FClose(nHandle)
         RETURN NIL

      ENDIF

      IF FRead(nHandle, @cFlag, 3) <> 3

         MSGSTOP("File I/O error, cannot encrypt file")
         FClose(nHandle)
         RETURN NIL

      ENDIF

      IF cFlag == "ENC"

         MSGSTOP("This database already encrypted!")
         FClose(nHandle)
         RETURN NIL

      ENDIF

      FSeek(nHandle, 8)

      IF FError() <> 0

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      IF FRead(nHandle, @cBuffer, 4) <> 4

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _ENCRYPT(cBuffer, cPass)
      FSeek(nHandle, 8)

      IF FError() <> 0

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      IF FWrite(nHandle, cBuffer) <> 4

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FSeek(nHandle, 12)

      IF FError() <> 0

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _ENCRYPT(cPass)

      IF FWrite(nHandle, cBuffer) <> HMG_LEN(cPass)

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FSeek(nHandle, 28)

      IF FWrite(nHandle, "ENC") <> 3

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FClose(nHandle)

   ELSE

      MSGSTOP("No such file")

   ENDIF


RETURN NIL

/*
*/
FUNCTION DB_UNENCRYPT(cFile, cPass)

   LOCAL nHandle, cBuffer := Space(4), cSavePass := Space(10), cFlag := Space(3)

   IF cPass == NIL

      cPass := "<PRIMARY>"

   ENDIF

   IF cFile == NIL

      cFile := "TEMP.DBF"

   ENDIF

   IF HMG_LEN(cPass) > 10

      cPass := hb_USubStr(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   IF hb_UAt(".", cFile) = 0

      cFile := cFile + ".DBF"

   ENDIF

   IF FILE(cFile)

      nHandle := FOpen(cFile, 2)

      IF FError() <> 0

         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      FSeek(nHandle, 28)

      IF FError() <> 0

         MSGSTOP("File I/O error, cannot unencrypt file")
         FClose(nHandle)
         RETURN NIL

      ENDIF

      IF FRead(nHandle, @cFlag, 3) <> 3

         MSGSTOP("File I/O error, cannot unencrypt file")
         FClose(nHandle)
         RETURN NIL

      ENDIF

      IF cFlag <> "ENC"

         MSGSTOP("This database is not encrypted!")
         FClose(nHandle)
         RETURN NIL

      ENDIF

      FSeek(nHandle, 12)

      IF FError() <> 0

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _ENCRYPT(cPass)

      IF FRead(nHandle, @cSavePass, 10) <> HMG_LEN(cPass)

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      IF cBuffer <> cSavePass

         FClose(nHandle)
         MSGALERT("You have entered the wrong password")
         RETURN NIL

      ENDIF

      cBuffer := Space(4)
      FSeek(nHandle, 8)

      IF FError() <> 0

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      IF FRead(nHandle, @cBuffer, 4) <> 4

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _DECRYPT(cBuffer, cPass)
      FSeek(nHandle, 8)

      IF FError() <> 0

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      IF FWrite(nHandle, cBuffer) <> 4

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      FSeek(nHandle, 12)

      IF FWrite(nHandle, Replicate(CHR(0), 20)) <> 20

         FClose(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      FClose(nHandle)

   ELSE

      MSGSTOP("No such file")

   ENDIF


RETURN NIL

/*
*/
STATIC Function cFileName( cMask )

   Local cName := ALLTRIM( cMask )
   Local n     := hb_UAt( ".", cName )

Return ALLTRIM( If( n > 0, hb_ULeft( cName, n - 1 ), cName ) )

/*
*/
FUNCTION DB_CODE(cData, cKey, aFields, cPass, cFor, cWhile)
local cTmpFile := "__temp__.dbf", nRecno := RecNo(), cVal, cBuf 

Local aString[HMG_LEN(aFields)] , nFields , cSeek , i , cAlias , cTmpAlias // RL

cData:=If(cData=nil,Alias()+".DBF",cData)
cData:=If(hb_UAt(".",cData)=0,cData+".DBF",cData)
cWhile:=If(cWhile=nil, ".t.",cWhile)
cFor:=If(cFor=nil,".t.",cFor)
cSeek:=cKey

IF cPass == NIL

   cPass := "<PRIMARY>"

ENDIF

Copy Stru to &(cTmpFile)
cAlias:=Alias()
nFields:=FCount()

Use (cTmpFile) New Exclusive
cTmpAlias:=Alias()

Select &cAlias
Do while .not. Eof() .and. &(cWhile)
   If !&(cFor)                         && Select records that meet for condition
      Skip
      Loop
   Endif

   Select &cTmpAlias
   dbAppend()                          && Create record at target file

   For i=1 to nFields
       FieldPut(i, &cAlias->(FieldGet(i)))
   Next

   Select &cAlias
   afill(aString, '')

   cBuf:=&cSeek
   cVal:=cBuf
   Do while cBuf=cVal .and. !Eof()    && Evaluate records with same key
      If !&(cFor)                     && Evaluate For condition within
         Skip
         Loop
      Endif

      For i=1 to HMG_LEN(aString)         && Crypt values
          aString[i]:=_ENCRYPT(FieldGet(FieldPos(aFields[i])), cPass)
      Next

      skip                            && Evaluate condition in next record
      cVal:=&cSeek
   Enddo

   Select &cTmpAlias
   For i=1 to HMG_LEN(aString)            && Place Crypts in target file
       FieldPut(FieldPos(aFields[i]), aString[i])
   Next

   Select &cAlias
Enddo

Select &cTmpAlias
go top
Do while .not. Eof()
      cVal:=&cSeek
      Select &cAlias
      seek cVal
	RLock()
      For i=1 to nFields
         FieldPut(i, &cTmpAlias->(FieldGet(i)))
      Next
	dbUnlock()
      Select &cTmpAlias
      skip
Enddo
use                                   && Close target file
FErase(cTmpFile)
Select &cAlias                        && Select prior file
go nRecno

RETURN NIL
