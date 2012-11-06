//==================================================================================================================================
// win/platform.m
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the aspartame library.

aspartame is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

aspartame is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with aspartame.  If not, see <http://www.gnu.org/licenses/>.
==================================================================================================================================*/
#define UNICODE
#define _WIN32_WINNT  0x0601 /*WIN7*/
#define  WINVER       0x0601 /*WIN7*/
#include <windows.h>
#include <malloc.h>
#import <ObjFW/ObjFW.h>
#import "GLCoordinate.h"
#import "GLRectangle.h"
#import "GLNativeSurface.h"
#import "ILWindow.h"
#import "ILControl.h"
#import "platform.h"
//==================================================================================================================================
LRESULT CALLBACK platform_Window_Message (HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
//==================================================================================================================================
//WideChar (Windows) to/from MultiByte (everybody else) string functions
char *UTF16_8(wchar_t *str16)
{
  //convert from Wide16 to UTF8
  char *buff = NULL; int buffSz = 0;
  buffSz = WideCharToMultiByte(CP_UTF8, 0, str16, -1, NULL, 0, NULL, NULL);
  buff   = (char *)malloc(buffSz);
  WideCharToMultiByte(CP_UTF8, 0, str16, -1, buff, buffSz, NULL, NULL);
  //don't forget to free() me
  return buff;
}
//----------------------------------------------------------------------------------------------------------------------------------
wchar_t *UTF8_16(char *str8)
{
  //convert UTF8 to Wide16
  wchar_t *buff = NULL; int buffSz = 0;
  buffSz = MultiByteToWideChar(CP_UTF8, 0, str8, -1, NULL, 0);
  buff   = (wchar_t *)malloc(buffSz * sizeof(wchar_t));
  MultiByteToWideChar(CP_UTF8, 0, str8, -1, buff, buffSz);
  //don't forget to free() me
  return buff;
}
//==================================================================================================================================
//ILApplication Helpers
void platform_Application_Init()
{
  //register a single, default, window class
  WNDCLASSEX wcx;
  wchar_t *clsName  = L"aspartameWndCls";
  HINSTANCE hInst   = (HINSTANCE)GetModuleHandle(NULL);
  wcx.cbSize        = sizeof(wcx);
  wcx.style         = CS_VREDRAW | CS_HREDRAW;
  wcx.lpfnWndProc   = (WNDPROC)platform_Window_Message;
  wcx.cbClsExtra    = 0;
  wcx.cbWndExtra    = 0;
  wcx.hInstance     = hInst;
  wcx.hIcon         = LoadIcon(NULL, IDI_APPLICATION);
  wcx.hCursor       = LoadCursor(NULL, IDC_ARROW);
  wcx.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
  wcx.lpszMenuName  = NULL;
  wcx.lpszClassName = clsName;
  wcx.hIconSm       = NULL;
  RegisterClassEx(&wcx);
}
//----------------------------------------------------------------------------------------------------------------------------------
OFList *platform_Application_Arguments()
{
  //we're using UTF8 (originally just because of GCC & Pango support; but UTF8 is actually very nice), so we've some processing to do...
  int i, argc; wchar_t **argv; char *buff;
  argv = CommandLineToArgvW(GetCommandLineW(), &argc);
  OFString *ofs;
  OFList *args = [OFList list];
  for(i=0; i<argc; i++)
  {
    //convert to UTF8
    buff = UTF16_8(argv[i]);
    [args appendObject : [OFString stringWithUTF8String : buff]];
    free(buff);
  }
  return args;
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Application_Loop()
{
  MSG msg; int msgCode;
  while((msgCode = GetMessage(&msg, NULL, 0, 0)) != 0)
  {
    if(msgCode == -1) return;
    else
    {
      //taking this pool out for now...
      //running an autorelease at every event message is probably way overkill
      //and could probably pretty easily throw away a needed object during heavy messaging
      //OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
      TranslateMessage(&msg);
      DispatchMessage(&msg);
      //[pool drain];
    }
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Application_Terminate()
{
  PostQuitMessage(0);
}
//==================================================================================================================================
//ILWindow Helpers
void *platform_Window_Create(ILWindow *window)
{
  HINSTANCE hInst = (HINSTANCE)GetModuleHandle(NULL);
  HWND hwnd = CreateWindowEx(WS_EX_LEFT, L"aspartameWndCls", L"", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 1, 1, NULL, NULL, hInst, NULL);
  SetWindowLongPtr(hwnd, GWL_EXSTYLE, WS_EX_OVERLAPPEDWINDOW);
  SetWindowLongPtr(hwnd, GWL_USERDATA, (LONG_PTR)window);
  return (void *)hwnd;
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_Close(void *data)
{
  PostMessage((HWND)data, WM_CLOSE, 0, 0);
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_Cleanup(void *data)
{
  DestroyWindow((HWND)data);
}
//----------------------------------------------------------------------------------------------------------------------------------
GLNativeSurface *platform_Window_GetSurface(void *data)
{
  //NOTE: i don't autorelease!
  return [[GLNativeSurface alloc] initWithData:data];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_Redraw(void *data)
{
  RECT   rec;
  HWND   wnd = (HWND)data;
  HDC    hdc = GetDC(wnd);
  HBRUSH hbr = CreateSolidBrush(RGB(255,255,255));
  GetClientRect(wnd, &rec);
  FillRect(hdc, &rec, hbr);
  DeleteObject(hbr);
  ReleaseDC(wnd, hdc);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void platform_Window_RedrawRect(void *data, GLRectangle Rectangle)
{
  RECT rec;
  rec.left   = (int)Rectangle.topLeft.x;
  rec.top    = (int)Rectangle.topLeft.y;
  rec.right  = (int)Rectangle.bottomRight.x;
  rec.bottom = (int)Rectangle.bottomRight.y;
  HWND   wnd = (HWND)data;
  HDC    hdc = GetDC(wnd);
  HBRUSH hbr = CreateSolidBrush(RGB(255,255,255));
  FillRect(hdc, &rec, hbr);
  DeleteObject(hbr);
  ReleaseDC(wnd, hdc);
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetTitle(void *data, OFString *Title)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  wchar_t *buff16; char *buff8;
  buff8  = (char *)[Title UTF8String];
  buff16 = UTF8_16(buff8);
  SetWindowText((HWND)data, buff16);
  free(buff16);
  [pool drain]; //force release of hidden OFObject containing buff8's memory
}
//----------------------------------------------------------------------------------------------------------------------------------
GLCoordinate platform_Window_GetLocation(void *data)
{
  RECT rc;
  GetWindowRect((HWND)data, &rc);
  return GLMakeCoordinate((float)rc.left, (float)rc.top);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void platform_Window_SetLocation(void *data, GLCoordinate Location)
{
  SetWindowPos((HWND)data, NULL, (int)Location.x, (int)Location.y, 0, 0, SWP_NOACTIVATE|SWP_NOOWNERZORDER|SWP_NOSIZE|SWP_NOZORDER);
}
//----------------------------------------------------------------------------------------------------------------------------------
GLSize platform_Window_GetSize(void *data)
{
  RECT rc;
  GetWindowRect((HWND)data, &rc);
  return GLMakeSize((float)(rc.right - rc.left), (float)(rc.bottom - rc.top));
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void platform_Window_SetSize(void *data, GLSize Size)
{
  SetWindowPos((HWND)data, NULL, 0, 0, (int)Size.width, (int)Size.height, SWP_NOACTIVATE|SWP_NOOWNERZORDER|SWP_NOMOVE|SWP_NOZORDER);
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetVisible(void *data, BOOL visible)
{
  //TODO: should we SW_SHOWNA (show without activating) here? or should ILWindow have an "activate" function?
  //TODO: should we (also) be using AnimateWindow()???
  if(visible == YES)
    ShowWindow((HWND)data, SW_SHOW);
  else
    ShowWindow((HWND)data, SW_HIDE);
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetMaximized(void *data, BOOL maximized)
{
  if(maximized == YES)
    ShowWindow((HWND)data, SW_SHOWMAXIMIZED);
  else
    ShowWindow((HWND)data, SW_RESTORE);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BOOL platform_Window_GetMaximized(void *data)
{
  return (BOOL)IsZoomed((HWND)data);
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetMinimized(void *data, BOOL minimized)
{
  if(minimized == YES)
    ShowWindow((HWND)data, SW_SHOWMINNOACTIVE);
  else
    ShowWindow((HWND)data, SW_RESTORE);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BOOL platform_Window_GetMinimized(void *data)
{
  return (BOOL)IsIconic((HWND)data);
}
//----------------------------------------------------------------------------------------------------------------------------------
LRESULT CALLBACK platform_Window_Message(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
{
  void *ptr = (void *)GetWindowLong(hwnd, GWL_USERDATA);
  if(ptr == NULL) return DefWindowProc(hwnd, msg, wparam, lparam);
  
  BOOL childSized = NO;
  ILWindow *wnd = (ILWindow *)ptr;
  switch(msg)
  {
    case WM_ERASEBKGND:
    return FALSE;
    
    case WM_PAINT:
      if(GetUpdateRect(hwnd, NULL, 0) != 0)
      {
        GLRectangle updateRect;
        PAINTSTRUCT ps;
        BeginPaint(hwnd, &ps);
        updateRect.topLeft.x     = (float)ps.rcPaint.left;
        updateRect.topLeft.y     = (float)ps.rcPaint.top;
        updateRect.bottomRight.x = (float)ps.rcPaint.right;
        updateRect.bottomRight.y = (float)ps.rcPaint.bottom;
        EndPaint(hwnd, &ps);
        [wnd paintRectangle:updateRect];
      }
    return 0;
    
    case WM_CLOSE:
      if(wnd.controller != nil)
        if(wnd.selClosing != NULL)
          if([wnd.controller performSelector:wnd.selClosing] == NO)
            return 0;
      if(wnd.quitOnClose == YES)
      {
        DestroyWindow(hwnd);
        PostQuitMessage(0);
      }
    break;
    
    case WM_SIZE:
      if(wnd.child != nil)
      {
        RECT rc;
        GetClientRect(hwnd, &rc);
        ((ILControl *)wnd.child).dimension = GLMakeDimension(GLMakeCoordinate(0.0f, 0.0f), GLMakeSize((float)rc.right, (float)rc.bottom));
        childSized = YES;
      }
      //check for maximization
      if(wparam == SIZE_MAXIMIZED)
        if(wnd.selMaximized != NULL)
        {
          [wnd.controller performSelector:wnd.selMaximized];
          break;
        }
      //check for minimization
      if(wparam == SIZE_MINIMIZED)
        if(wnd.selMinimized != NULL)
        {
          [wnd.controller performSelector:wnd.selMinimized];
          break;
        }
    //intentional fall-through to WM_SIZING
    case WM_SIZING:
      if((wnd.child != nil) && (childSized == NO))
      {
        //child wasn't resized by WM_SIZE
        //REFACTOR: this whole procedure spaghetti-ish, but we want to resize our child before performing any selectors
        RECT rc;
        GetClientRect(hwnd, &rc);
        ((ILControl *)wnd.child).dimension = GLMakeDimension(GLMakeCoordinate(0.0f, 0.0f), GLMakeSize((float)rc.right, (float)rc.bottom));
      }
      if(wnd.selResized != NULL)
        [wnd.controller performSelector:wnd.selResized];
    break;
    
    case WM_MOVE:
    //intentional fall-through to WM_MOVING
    case WM_MOVING:
      if(wnd.selMoved != NULL)
        [wnd.controller performSelector:wnd.selMoved];
    break;
  }

  return DefWindowProc(hwnd, msg, wparam, lparam);
}
//==================================================================================================================================
