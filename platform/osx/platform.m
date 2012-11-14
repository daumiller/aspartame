//==================================================================================================================================
// osx/platform.m
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
#include <Cocoa/Cocoa.h>
#import <ObjFW/ObjFW.h>
#import "OMCoordinate.h"
#import "OMRectangle.h"
#import "OMNativeSurface.h"
#import "OMWindow.h"
#import "OMControl.h"
#import "platform.h"
//==================================================================================================================================
@interface ilWindowManager : NSView <NSWindowDelegate>
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
{
  OMWindow   *ilWindow;
  OMDimension restoreDimension;
  BOOL        isMaximized;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (assign) OMWindow   *ilWindow;
@property (assign) OMDimension restoreDimension;
@property (assign) BOOL        isMaximized;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) windowWillClose:(NSNotification *)notification;
- (void) windowDidResize:(NSNotification *)notification;
//still need to catch events for ilWindow.selClosing, ilWindow.selMoved, ilWindow.selMinimized, and ilWindow.selMaximized
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@end
//----------------------------------------------------------------------------------------------------------------------------------
@implementation ilWindowManager
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@synthesize ilWindow;
@synthesize restoreDimension;
@synthesize isMaximized;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) drawRect:(NSRect)frame
{
  OMRectangle glRect;
  glRect.topLeft.x     = frame.origin.x;
  glRect.topLeft.y     = frame.origin.y;
  glRect.bottomRight.x = frame.size.width  + frame.origin.x;
  glRect.bottomRight.y = frame.size.height + frame.origin.y;
  [ilWindow paintRectangle:glRect];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) windowWillClose:(NSNotification *)notification
{
  if([ilWindow quitOnClose])
    platform_Application_Quit();
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) windowDidResize:(NSNotification *)notification
{
  if(ilWindow.child != nil)
  {
    NSRect currSz = [self bounds]; //i'm already resized, right?
    ((OMControl *)ilWindow.child).dimension = OMMakeDimensionFloats(0.0f, 0.0f, (float)currSz.size.width, (float)currSz.size.height);
    [self setNeedsDisplay:YES];
  }
  if(ilWindow.controller != nil)
    if(ilWindow.selResized != NULL)
      [ilWindow.controller performSelector:ilWindow.selResized];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@end
//==================================================================================================================================
//OMApplication Helpers
void platform_Application_Init()
{
  [NSApplication sharedApplication];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}
//----------------------------------------------------------------------------------------------------------------------------------
OFList *platform_Application_Arguments()
{
  OFList *args = [OFList list];
  NSArray *cocoaArgs = [[NSProcessInfo processInfo] arguments];
  for(NSString *str in cocoaArgs)
    [args appendObject:[OFString stringWithUTF8String:[str UTF8String]]];
  return args;
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Application_Loop()
{
  [NSApp run];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Application_Quit()
{
  [NSApp stop:nil];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Application_Terminate()
{
  [NSApp terminate:nil];
}
//==================================================================================================================================
//OMWindow Helpers
void *platform_Window_Create(OMWindow *window)
{
  NSWindow *nsWnd = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0f, 0.0f, 32.0f, 32.0f)
                                                styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                                                  backing:NSBackingStoreBuffered
                                                    defer:NO];
  ilWindowManager *ilVew = [[ilWindowManager alloc] init];
  ilVew.ilWindow         = window;
  ilVew.restoreDimension = OMMakeDimensionFloats(0.0f, 0.0f, 32.0f, 32.0f);
  ilVew.isMaximized     = NO;
  
  [nsWnd setContentView:ilVew];
  [nsWnd setDelegate   :ilVew];
  [ilVew setNeedsDisplay:YES];
  
  return (void *)ilVew;
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_Close(void *data)
{
  [[(ilWindowManager *)data window] close];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_Cleanup(void *data)
{
}
//----------------------------------------------------------------------------------------------------------------------------------
OMNativeSurface *platform_Window_GetSurface(void *data)
{
  //NOTE: i don't autorelease!
  //WHY: this call will mainly be used during tight painting loops, where we'd like to avoid autorelease pools
  return [[OMNativeSurface alloc] initWithData:data];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_Redraw(void *data)
{
  [[NSColor whiteColor] set];
  NSRectFill([(NSView *)data bounds]);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void platform_Window_RedrawRect(void *data, OMRectangle Rectangle)
{
  [[NSColor whiteColor] set];
  OMDimension dim = OMDimensionFromRectangle(Rectangle);
  NSRectFill(NSMakeRect(dim.origin.x, dim.origin.y, dim.size.width, dim.size.height));
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetTitle(void *data, OFString *Title)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  NSString *nsTitle = [NSString stringWithUTF8String:[Title UTF8String]];
  [[(NSView *)data window] setTitle:nsTitle];
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
OMCoordinate platform_Window_GetLocation(void *data)
{
  NSRect frame = [[(NSView *)data window] frame];
  return OMMakeCoordinate((float)frame.origin.x, (float)frame.origin.y);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void platform_Window_SetLocation(void *data, OMCoordinate Location)
{
  [[(NSView *)data window] setFrameTopLeftPoint:NSMakePoint(Location.x, Location.y)];
}
//----------------------------------------------------------------------------------------------------------------------------------
OMSize platform_Window_GetSize(void *data)
{
  NSRect frame = [[(NSView *)data window] frame];
  return OMMakeSize((float)frame.size.width, (float)frame.size.height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void platform_Window_SetSize(void *data, OMSize Size)
{
  NSRect frame = [[(NSView *)data window] frame];
  frame.size.width  = Size.width;
  frame.size.height = Size.height;
  [[(NSView *)data window] setFrame:frame display:YES];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetVisible(void *data, BOOL visible)
{
  if(visible)
    [[(NSView *)data window] orderFront:(NSView *)data];
  else
    [[(NSView *)data window] orderOut:(NSView *)data];
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetMaximized(void *data, BOOL maximized)
{
  if(maximized == YES)
  {
    ((ilWindowManager *)data).isMaximized = YES;
    NSRect nr = [[(NSView *)data window] frame];
    ((ilWindowManager *)data).restoreDimension = OMMakeDimensionFloats(nr.origin.x, nr.origin.y, nr.size.width, nr.size.height);
    [[(NSView *)data window] setFrame:[[NSScreen mainScreen] visibleFrame] display:YES];
  }
  else
  {
    ((ilWindowManager *)data).isMaximized = NO;
    NSRect restoredRect;
    restoredRect.origin.x    = ((ilWindowManager *)data).restoreDimension.origin.x;
    restoredRect.origin.y    = ((ilWindowManager *)data).restoreDimension.origin.y;
    restoredRect.size.width  = ((ilWindowManager *)data).restoreDimension.size.width;
    restoredRect.size.height = ((ilWindowManager *)data).restoreDimension.size.height;
    [[(NSView *)data window] setFrame:restoredRect display:YES];
  }
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BOOL platform_Window_GetMaximized(void *data)
{
  return ((ilWindowManager *)data).isMaximized;
}
//----------------------------------------------------------------------------------------------------------------------------------
void platform_Window_SetMinimized(void *data, BOOL minimized)
{
  platform_Window_SetVisible(data, minimized); //same thing for us, right?
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BOOL platform_Window_GetMinimized(void *data)
{
  return ((ilWindowManager *)data).ilWindow.visible;
}
//==================================================================================================================================
