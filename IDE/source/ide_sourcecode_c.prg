
#pragma BEGINDUMP

#include "HMG_UNICODE.h"

#include <windows.h>
#include <commctrl.h>
#include <wingdi.h>
#include <winuser.h>
#include "hbapi.h"


HB_FUNC ( IDECHOOSEFONT )
{

	CHOOSEFONT cf;
	LOGFONT lf;
	long PointSize ;
	int bold ;
	HDC hdc ;
	HWND hwnd ;

	lstrcpy ( lf.lfFaceName , HMG_parc(1) ) ;

	hwnd = GetActiveWindow() ;
	hdc = GetDC(hwnd) ;

	lf.lfHeight = -MulDiv( hb_parnl(2) , GetDeviceCaps(hdc, LOGPIXELSY) , 72 ) ;

	if ( hb_parl (3) )
	{
		lf.lfWeight = 700 ;
	}
	else
	{
		lf.lfWeight = 400 ;
	}

	if ( hb_parl (4) )
	{
		lf.lfItalic = TRUE ;
	}
	else
	{
		lf.lfItalic = FALSE ;
	}

	if ( hb_parl (6) )
	{
		 lf.lfUnderline = TRUE ;
	}
	else
	{
		 lf.lfUnderline = FALSE ;
	}

	if ( hb_parl (7) )
	{
		 lf.lfStrikeOut = TRUE ;
	}
	else
	{
		 lf.lfStrikeOut = FALSE ;
	}

	lf.lfCharSet = hb_parni (8) ;

	cf.lStructSize = sizeof(CHOOSEFONT);
	cf.hwndOwner = (HWND)GetActiveWindow();
	cf.hDC = (HDC)NULL;
	cf.lpLogFont = &lf;

	cf.Flags = CF_LIMITSIZE | CF_SCREENFONTS | CF_NOVECTORFONTS | CF_NOSCRIPTSEL | CF_NOVERTFONTS | CF_INITTOLOGFONTSTRUCT ;

	cf.rgbColors = hb_parnl(5) ;
	cf.lCustData = 0L;
	cf.lpfnHook = NULL;
	cf.lpTemplateName = NULL;
	cf.hInstance = NULL;
	cf.lpszStyle = NULL;
	cf.nFontType = SCREEN_FONTTYPE;
	cf.nSizeMin = 8;
	cf.nSizeMax = 11;

	if ( ! ChooseFont(&cf) )
	{
		hb_reta( 8 );
		HMG_storvc( _TEXT("") , -1, 1 );
		hb_storvnl( (LONG) 0 , -1, 2 );
		hb_storvl( 0 , -1, 3 );
		hb_storvl( 0 , -1, 4 );
		hb_storvnl( 0 , -1, 5 );
		hb_storvl( 0 , -1, 6 );
		hb_storvl( 0 , -1, 7 );
		hb_storvni( 0 , -1, 8 );
		return;
	}

	PointSize = -MulDiv ( lf.lfHeight , 72 , GetDeviceCaps(GetDC(GetActiveWindow()), LOGPIXELSY) ) ;

	if (lf.lfWeight == 700)
	{
		bold = 1;
	}
	else
	{
		bold = 0;
	}

	hb_reta( 8 );
	HMG_storvc( lf.lfFaceName , -1, 1 );
	hb_storvnl( (LONG) PointSize , -1, 2 );
	hb_storvl( bold , -1, 3 );
	hb_storvl( lf.lfItalic , -1, 4 );
	hb_storvnl( cf.rgbColors , -1, 5 );
	hb_storvl( lf.lfUnderline , -1, 6 );
	hb_storvl( lf.lfStrikeOut , -1, 7 );
	hb_storvni( lf.lfCharSet , -1, 8 );

	ReleaseDC (hwnd,hdc) ;
}

HB_FUNC( OSVERSION )
{
	OSVERSIONINFO osvi;

	ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx(&osvi);

	hb_reta( 3 ) ;

	hb_storvni ( osvi.dwMajorVersion , -1 , 1 ) ;
	hb_storvni ( osvi.dwMinorVersion , -1 , 2 ) ;
	hb_storvni ( osvi.dwBuildNumber  , -1 , 3 ) ;
}

HB_FUNC ( SETVIRTUALON )
{
	RECT rect;
	int x , y , w , h ;

	GetWindowRect((HWND) HMG_parnl (1), &rect) ;

	x = rect.left ;
	y = rect.top ;
	w = rect.right - rect.left ;
	h = rect.bottom - rect.top ;

	SetWindowLongPtr ( (HWND) HMG_parnl(1) , GWL_STYLE , WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_VSCROLL | WS_HSCROLL | WS_SIZEBOX ) ;

	SetWindowPos(
		(HWND) HMG_parnl(1),             // handle to window
		HWND_TOP,	 // placement-order handle
		0,                 // horizontal position
		0,                 // vertical position
		0,                // width
		0,                // height
		SWP_SHOWWINDOW // window-positioning flags
	);

	SetWindowPos(
		(HWND) HMG_parnl(1),             // handle to window
		HWND_TOP,	 // placement-order handle
		x,                 // horizontal position
		y,                 // vertical position
		w,                // width
		h,                // height
		SWP_SHOWWINDOW // window-positioning flags
	);
}

HB_FUNC ( SETVIRTUALOFF )
{

	RECT rect;
	int x , y , w , h ;

	GetWindowRect((HWND) HMG_parnl (1), &rect) ;

	x = rect.left ;
	y = rect.top ;
	w = rect.right - rect.left ;
	h = rect.bottom - rect.top ;

	SetWindowLongPtr ( (HWND) HMG_parnl(1) , GWL_STYLE , WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_SIZEBOX ) ;

	SetWindowPos(
		(HWND) HMG_parnl(1),             // handle to window
		HWND_TOP,	 // placement-order handle
		0,                 // horizontal position
		0,                 // vertical position
		0,                // width
		0,                // height
		SWP_SHOWWINDOW // window-positioning flags
	);

	SetWindowPos(
		(HWND) HMG_parnl(1),             // handle to window
		HWND_TOP,	 // placement-order handle
		x,                 // horizontal position
		y,                 // vertical position
		w,                // width
		h,                // height
		SWP_SHOWWINDOW // window-positioning flags
	);
}

HB_FUNC ( SETWINDOWHELPBUTTON )
{
   LONG_PTR Style = GetWindowLongPtr( (HWND) HMG_parnl(1), GWL_STYLE );
   if (hb_parl(2))
   {
    SetWindowLongPtr( (HWND) HMG_parnl(1), GWL_STYLE, Style | WS_TABSTOP );
   }
   else
   {
    SetWindowLongPtr( (HWND) HMG_parnl(1), GWL_STYLE, Style - WS_TABSTOP );
   }
}

HB_FUNC( SETWINDOWBACKCOLOR )
{
	HWND hWnd ;

	HBRUSH hbrush ;

	hWnd = (HWND) HMG_parnl(1) ;

	hbrush = CreateSolidBrush ( RGB ( hb_parvni ( 2 , 1 ) , hb_parvni ( 2 , 2 ) , hb_parvni ( 2 , 3 ) ) ) ;

	SetClassLongPtr(
	(HWND) hWnd		,	// handle of window
	GCLP_HBRBACKGROUND,	// index of value to change
	(LONG_PTR) hbrush			// new value
	);
}

/*
HB_FUNC( GETMODULEFILENAME )
{
   TCHAR szBuffer[ MAX_PATH + 1 ] = {0} ;
   GetModuleFileName( HB_ISNIL(1) ? GetModuleHandle(NULL) : (HMODULE) HMG_parnl( 1 ),
                       szBuffer  ,
                       MAX_PATH
                     ) ;
   HMG_retc(szBuffer);
}
*/

HB_FUNC ( DRAWDESIGNGRID )
{
	int r , c , rto , cto ;
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   hWnd1 = (HWND) HMG_parnl(1);
   hdc1 = GetDC( (HWND) hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) 1 , (COLORREF) RGB( (int) 0, (int) 0, (int) 0 ) );
   hgdiobj1 = SelectObject( (HDC) hdc1, hpen );


	rto = hb_parni(2);
	cto = hb_parni(3);

	for ( r=10 ; r<=rto; r+=10 )
	{

		for ( c=10 ; c<=cto ; c+=10 )
		{
			MoveToEx( (HDC) hdc1, (int) c, (int) r, NULL );
			LineTo( (HDC) hdc1, (int) c+1, (int) r+1 );
		}

	}

   SelectObject( (HDC) hdc1, (HGDIOBJ) hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}


HB_FUNC ( REDRAWRECT )
{
	RECT r;

	r.top 	= hb_parni(2) ;
	r.left 	= hb_parni(3) ;
	r.bottom= hb_parni(4) ;
	r.right	= hb_parni(5) ;

	RedrawWindow(
		(HWND) HMG_parnl( 1 ),
		&r,
		NULL,
		RDW_ERASE | RDW_INVALIDATE | RDW_ERASENOW | RDW_UPDATENOW
	);
}

HB_FUNC ( DRAWDESIGNGRIDRECT )
{
	int r , c , rto , cto , rfrom , cfrom ;
	HWND hWnd1;
	HDC hdc1;
	HGDIOBJ hgdiobj1;
	HPEN hpen;
	hWnd1 = (HWND) HMG_parnl(1);
	hdc1 = GetDC( (HWND) hWnd1 );
	hpen = CreatePen( (int) PS_SOLID, (int) 1 , (COLORREF) RGB( (int) 0, (int) 0, (int) 0 ) );
	hgdiobj1 = SelectObject( (HDC) hdc1, hpen );

	rfrom = hb_parni(2);
	cfrom = hb_parni(3);

	rto = hb_parni(4);
	cto = hb_parni(5);

	for ( r=rfrom ; r<=rto; r+=10 )
	{

		for ( c=cfrom ; c<=cto ; c+=10 )
		{
			MoveToEx( (HDC) hdc1, (int) c, (int) r, NULL );
			LineTo( (HDC) hdc1, (int) c+1, (int) r+1 );
		}

	}

   SelectObject( (HDC) hdc1, (HGDIOBJ) hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( REDRAWALL )
{
	RedrawWindow(
		(HWND) HMG_parnl( 1 ),
		NULL,
		NULL,
		RDW_ERASE | RDW_INVALIDATE | RDW_ERASENOW
	);
}

HB_FUNC ( GETWINDOWSYSCOLOR )
{
	hb_retnl ( GetSysColor ( COLOR_3DFACE ) ) ;
}

HB_FUNC ( GETCONTROLSYSCOLOR )
{
	hb_retnl ( GetSysColor ( COLOR_WINDOW ) ) ;
}

#pragma ENDDUMP
