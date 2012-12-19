//==================================================================================================================================
// OMScreen.m
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
#import "OMScreen.h"
#import "OMSignalManager.h"
#import <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_SCREEN ((GdkScreen *)_gdkScreen)

//==================================================================================================================================
// Signal Handling Proxies
//==================================================================================================================================
static void signal_compositedChanged(void *nativeScreen, void *data)
{
  OMScreen *scrn = (OMScreen *)[OMSignalManager nativeToWrapper:nativeScreen];
  [scrn.delegate screenCompositedChanged:scrn];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void signal_monitorsChanged(void *nativeScreen, void *data)
{
  OMScreen *scrn = (OMScreen *)[OMSignalManager nativeToWrapper:nativeScreen];
  [scrn.delegate screenMonitorsChanged:scrn];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void signal_DimensionsChanged(void *nativeScreen, void *data)
{
  OMScreen *scrn = (OMScreen *)[OMSignalManager nativeToWrapper:nativeScreen];
  [scrn.delegate screenDimensionsChanged:scrn];
}

//==================================================================================================================================
@implementation OMScreen

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
- initWithNativeScreen:(void *)gdkScreen
{
  self = [super init];
  if(self)
    _gdkScreen = gdkScreen;
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  self.delegate = nil;
  [_signalManager release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize gdkScreen = _gdkScreen;
//----------------------------------------------------------------------------------------------------------------------------------
-(int) screenIndex    { return       gdk_screen_get_number         (NATIVE_SCREEN); }
-(int) width          { return       gdk_screen_get_width          (NATIVE_SCREEN); }
-(int) height         { return       gdk_screen_get_height         (NATIVE_SCREEN); }
-(int) mmWidth        { return       gdk_screen_get_width_mm       (NATIVE_SCREEN); }
-(int) mmHeight       { return       gdk_screen_get_height_mm      (NATIVE_SCREEN); }
-(int) monitorCount   { return       gdk_screen_get_n_monitors     (NATIVE_SCREEN); }
-(int) primaryMonitor { return       gdk_screen_get_primary_monitor(NATIVE_SCREEN); }
-(BOOL)isComposited   { return (BOOL)gdk_screen_is_composited      (NATIVE_SCREEN); }
//----------------------------------------------------------------------------------------------------------------------------------
- (id<OMScreenDelegate>)delegate { return _delegate; }
- (void)setDelegate:(id<OMScreenDelegate>)delegate
{
  if(_delegate)
  {
    [_signalManager breakAll];
    [_delegate release];
  }
  _delegate = [delegate retain];
  if([_delegate respondsToSelector:@selector(screenCompositedChanged)]) [_signalManager makeConnection:@"composited-changed" toFunction:(void (*)(void))signal_compositedChanged];
  if([_delegate respondsToSelector:@selector(screenMonitorsChanged  )]) [_signalManager makeConnection:@"monitors-changed"   toFunction:(void (*)(void))signal_monitorsChanged  ];
  if([_delegate respondsToSelector:@selector(screenDimensionsChanged)]) [_signalManager makeConnection:@"size-changed"       toFunction:(void (*)(void))signal_DimensionsChanged];
}

//==================================================================================================================================
// Instance Methods
//==================================================================================================================================
-(OMDimension)monitorGeometry:(int)monitorIndex
{
  GdkRectangle nativeRect;
  gdk_screen_get_monitor_geometry(NATIVE_SCREEN, monitorIndex, &nativeRect);
  return OMMakeDimensionFloats((float)nativeRect.x, (float)nativeRect.y, (float)nativeRect.width, (float)nativeRect.height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMDimension)monitorWorkspace:(int)monitorIndex
{
  GdkRectangle nativeRect;
  gdk_screen_get_monitor_workarea(NATIVE_SCREEN, monitorIndex, &nativeRect);
  return OMMakeDimensionFloats((float)nativeRect.x, (float)nativeRect.y, (float)nativeRect.width, (float)nativeRect.height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)monitorAtPoint:(OMCoordinate)point
{
  return gdk_screen_get_monitor_at_point(NATIVE_SCREEN, (int)point.x, (int)point.y);
}
//----------------------------------------------------------------------------------------------------------------------------------
// -(OMWindow *)rootWindow;
// -(OFArray *)listTopLevelWindows;
//----------------------------------------------------------------------------------------------------------------------------------
//-(OFArray *)listVisuals;
//-(OMVisual *)systemVisual;
//-(OMVisual *)rgbaVisual;


//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
