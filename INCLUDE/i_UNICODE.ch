/*----------------------------------------------------------------------------
 HMG Source File --> i_Unicode.ch  

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay). 

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

----------------------------------------------------------------------------*/


#xtranslate UTF8_BOM => (HB_BCHAR (0xEF) + HB_BCHAR (0xBB) + HB_BCHAR (0xBF))


#xtranslate IF HMG SUPPORT UNICODE STOP   => IF ( HMG_SupportUnicode() == .T., MsgHMGError ("This program requires a HMG library compiled with support only for ANSI character set. Program Terminated"), NIL)
#xtranslate IF HMG SUPPORT UNICODE RUN    => IF ( HMG_SupportUnicode() == .F., MsgHMGError ("This program requires a HMG library compiled with support for Unicode character set. Program Terminated"), NIL)


#xtranslate DISABLE [ WINDOW ]  EVENT OF <form>   =>   StopWindowEventProcedure (<"form">, .T.)
#xtranslate ENABLE  [ WINDOW ]  EVENT OF <form>   =>   StopWindowEventProcedure (<"form">, .F.)

#xtranslate DISABLE [ CONTROL ] EVENT <control> OF <form>   =>   StopControlEventProcedure (<"control">, <"form">, .T.)
#xtranslate ENABLE  [ CONTROL ] EVENT <control> OF <form>   =>   StopControlEventProcedure (<"control">, <"form">, .F.)


// #xtranslate SET EVENT REENTRY OFF   =>   _HMG_AvoidReentryEventProcedure := .T. 
// #xtranslate SET EVENT REENTRY ON    =>   _HMG_AvoidReentryEventProcedure := .F. 
