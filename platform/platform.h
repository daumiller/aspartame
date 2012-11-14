//==================================================================================================================================
// platform.h
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
@class OFList;
@class OMWindow;
#import "atropine.h"
//==================================================================================================================================
//ILApplication Helpers
void    platform_Application_Init();
OFList *platform_Application_Arguments();
void    platform_Application_Loop();
void    platform_Application_Quit();
void    platform_Application_Terminate();
//==================================================================================================================================
//ILWindow Helpers
void            *platform_Window_Create       (OMWindow *window);
void             platform_Window_Close        (void *data);
void             platform_Window_Cleanup      (void *data); //DestroyWindow
OMNativeSurface *platform_Window_GetSurface   (void *data);
void             platform_Window_Redraw       (void *data);
void             platform_Window_RedrawRect   (void *data, OMRectangle Rectangle);
void             platform_Window_SetTitle     (void *data, OFString *Title);
OMCoordinate     platform_Window_GetLocation  (void *data);
void             platform_Window_SetLocation  (void *data, OMCoordinate Location);
OMSize           platform_Window_GetSize      (void *data);
void             platform_Window_SetSize      (void *data, OMSize Size);
void             platform_Window_SetVisible   (void *data, BOOL visible);
void             platform_Window_SetMaximized (void *data, BOOL maximized);
BOOL             platform_Window_GetMaximized (void *data);
void             platform_Window_SetMinimized (void *data, BOOL minimized);
BOOL             platform_Window_GetMinimized (void *data);
//==================================================================================================================================
