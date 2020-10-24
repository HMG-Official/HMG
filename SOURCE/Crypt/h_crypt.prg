
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

   IF !EMPTY(cPass)

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

   IF EMPTY(cInFile) .OR. .NOT. FILE(cInFile)

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

      cPass := HB_USUBSTR(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   nHandle := FOPEN(cInFile, 2)

   IF FERROR() <> 0

      MSGSTOP("File I/O error, cannot proceed")

   ENDIF

   cBuffer := SPACE(30)
   FREAD(nHandle, @cBuffer, 30)

   IF cBuffer == "ENCRYPTED FILE (C) ODESSA 2002"

      MSGSTOP("File already encrypted")
      FCLOSE(nHandle)
      RETURN NIL

   ENDIF

   FSEEK(nHandle, 0)
   nOutHandle := FCREATE(cOutFile, 0)

   IF FERROR() <> 0

      MSGSTOP("File I/O error, cannot proceed")
      FCLOSE(nHandle)
      RETURN NIL

   ENDIF

   FWRITE(nOutHandle, "ENCRYPTED FILE (C) ODESSA 2002")
   cStr := _ENCRYPT(cPass)
   FWRITE(nOutHandle, cStr)
   cBuffer := SPACE(512)

   DO WHILE nRead <> 0

      nRead := FREAD(nHandle, @cBuffer, 512)

      IF nRead <> 512

         cBuffer := HB_USUBSTR(cBuffer, 1, nRead)

      ENDIF

      cStr := _ENCRYPT(cBuffer, cPass)
      FWRITE(nOutHandle, cStr)

   ENDDO

   FCLOSE(nHandle)
   FCLOSE(nOutHandle)

   IF lDelete

      FERASE(cInFile)

   ENDIF

RETURN NIL

/*
*/
FUNCTION FI_DECODE(cInFile, cPass, cOutFile, lDelete)

   LOCAL nHandle, cBuffer, cStr, nRead := 1
   LOCAL nOutHandle

   IF EMPTY(cInFile) .OR. .NOT. FILE(cInFile)

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

      cPass := HB_USUBSTR(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   nHandle := FOPEN(cInFile, 2)

   IF FERROR() <> 0

      MSGSTOP("File I/O error, cannot proceed")

   ENDIF

   cBuffer := SPACE(30)
   FREAD(nHandle, @cBuffer, 30)

   IF cBuffer <> "ENCRYPTED FILE (C) ODESSA 2002"

      MSGSTOP("File is not encrypted")
      FCLOSE(nHandle)
      RETURN NIL

   ENDIF

   cBuffer := SPACE(10)
   FREAD(nHandle, @cBuffer, 10)

   IF cBuffer <> _ENCRYPT(cPass)

      MSGALERT("You have entered the wrong password")
      FCLOSE(nHandle)
      RETURN NIL

   ENDIF

   nOutHandle := FCREATE(cOutFile, 0)

   IF FERROR() <> 0

      MSGSTOP("File I/O error, cannot proceed")
      FCLOSE(nHandle)
      RETURN NIL

   ENDIF

   cBuffer := SPACE(512)

   DO WHILE nRead <> 0

      nRead := FREAD(nHandle, @cBuffer, 512)

      IF nRead <> 512

         cBuffer := HB_USUBSTR(cBuffer, 1, nRead)

      ENDIF

      cStr := _DECRYPT(cBuffer, cPass)
      FWRITE(nOutHandle, cStr)

   ENDDO

   FCLOSE(nHandle)
   FCLOSE(nOutHandle)

   IF lDelete

      FERASE(cInFile)

   ENDIF

RETURN NIL

/*
*/
FUNCTION DB_ENCRYPT(cFile, cPass)

   LOCAL nHandle, cBuffer := SPACE(4), cFlag := SPACE(3)

   IF cPass == NIL

      cPass := "<PRIMARY>"

   ENDIF

   IF cFile == NIL

      cFile := "TEMP.DBF"

   ENDIF

   IF HMG_LEN(cPass) > 10

      cPass := HB_USUBSTR(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   IF HB_UAT(".", cFileName(cFile)) = 0

      cFile := cFile + ".DBF"

   ENDIF

   IF FILE(cFile)

      nHandle := FOPEN(cFile, 2)

      IF FERROR() <> 0

         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 28)

      IF FERROR() <> 0

         MSGSTOP("File I/O error, cannot encrypt file")
         FCLOSE(nHandle)
         RETURN NIL

      ENDIF

      IF FREAD(nHandle, @cFlag, 3) <> 3

         MSGSTOP("File I/O error, cannot encrypt file")
         FCLOSE(nHandle)
         RETURN NIL

      ENDIF

      IF cFlag == "ENC"

         MSGSTOP("This database already encrypted!")
         FCLOSE(nHandle)
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 8)

      IF FERROR() <> 0

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      IF FREAD(nHandle, @cBuffer, 4) <> 4

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _ENCRYPT(cBuffer, cPass)
      FSEEK(nHandle, 8)

      IF FERROR() <> 0

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      IF FWRITE(nHandle, cBuffer) <> 4

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 12)

      IF FERROR() <> 0

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _ENCRYPT(cPass)

      IF FWRITE(nHandle, cBuffer) <> HMG_LEN(cPass)

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 28)

      IF FWRITE(nHandle, "ENC") <> 3

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL

      ENDIF

      FCLOSE(nHandle)

   ELSE

      MSGSTOP("No such file")

   ENDIF


RETURN NIL

/*
*/
FUNCTION DB_UNENCRYPT(cFile, cPass)

   LOCAL nHandle, cBuffer := SPACE(4), cSavePass := SPACE(10), cFlag := SPACE(3)

   IF cPass == NIL

      cPass := "<PRIMARY>"

   ENDIF

   IF cFile == NIL

      cFile := "TEMP.DBF"

   ENDIF

   IF HMG_LEN(cPass) > 10

      cPass := HB_USUBSTR(cPass, 1, 10)

   ELSE

      cPass := HMG_PADR(cPass, 10)

   ENDIF

   IF HB_UAT(".", cFile) = 0

      cFile := cFile + ".DBF"

   ENDIF

   IF FILE(cFile)

      nHandle := FOPEN(cFile, 2)

      IF FERROR() <> 0

         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 28)

      IF FERROR() <> 0

         MSGSTOP("File I/O error, cannot unencrypt file")
         FCLOSE(nHandle)
         RETURN NIL

      ENDIF

      IF FREAD(nHandle, @cFlag, 3) <> 3

         MSGSTOP("File I/O error, cannot unencrypt file")
         FCLOSE(nHandle)
         RETURN NIL

      ENDIF

      IF cFlag <> "ENC"

         MSGSTOP("This database is not encrypted!")
         FCLOSE(nHandle)
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 12)

      IF FERROR() <> 0

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _ENCRYPT(cPass)

      IF FREAD(nHandle, @cSavePass, 10) <> HMG_LEN(cPass)

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      IF cBuffer <> cSavePass

         FCLOSE(nHandle)
         MSGALERT("You have entered the wrong password")
         RETURN NIL

      ENDIF

      cBuffer := SPACE(4)
      FSEEK(nHandle, 8)

      IF FERROR() <> 0

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      IF FREAD(nHandle, @cBuffer, 4) <> 4

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      cBuffer := _DECRYPT(cBuffer, cPass)
      FSEEK(nHandle, 8)

      IF FERROR() <> 0

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      IF FWRITE(nHandle, cBuffer) <> 4

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      FSEEK(nHandle, 12)

      IF FWRITE(nHandle, REPLICATE(CHR(0), 20)) <> 20

         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL

      ENDIF

      FCLOSE(nHandle)

   ELSE

      MSGSTOP("No such file")

   ENDIF


RETURN NIL

/*
*/
STATIC Function cFileName( cMask )

   Local cName := ALLTRIM( cMask )
   Local n     := HB_UAT( ".", cName )

Return ALLTRIM( If( n > 0, HB_ULEFT( cName, n - 1 ), cName ) )

/*
*/
FUNCTION DB_CODE(cData, cKey, aFields, cPass, cFor, cWhile)
local cTmpFile := "__temp__.dbf", nRecno := recno(), cVal, cBuf

Local aString[HMG_LEN(aFields)] , nFields , cSeek , i , cAlias , cTmpAlias // RL

cData:=If(cData=nil,Alias()+".DBF",cData)
cData:=If(HB_UAT(".",cData)=0,cData+".DBF",cData)
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
Do while .not. eof() .and. &(cWhile)
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
Do while .not. eof()
      cVal:=&cSeek
      Select &cAlias
      seek cVal
	rlock()
      For i=1 to nFields
         FieldPut(i, &cTmpAlias->(FieldGet(i)))
      Next
	dbunlock()
      Select &cTmpAlias
      skip
Enddo
use                                   && Close target file
ferase(cTmpFile)
Select &cAlias                        && Select prior file
go nRecno

RETURN NIL
