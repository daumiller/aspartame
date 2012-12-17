//==================================================================================================================================
// OMDisplay.h
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
#import "OMDisplay.h"
#include <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_DISPLAY ((GdkDisplay *)_gdkDisplay)

//==================================================================================================================================
@implementation OMDisplay

//----------------------------------------------------------------------------------------------------------------------------------
+ defaultDisplay
{
  GdkDisplay *defDisp = gdk_display_manager_get_default_display(gdk_display_manager_get());
  return [[[OMDisplay alloc] initWithNativeDisplay:defDisp] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ openDisplay:(OFString *)displayName
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GdkDisplay *disp = gdk_display_open([displayName UTF8String]);
  [pool drain];
  if(disp == NULL) return nil;
  return [[[OMDisplay alloc] initWithNativeDisplay:disp] autorelease];
}

//----------------------------------------------------------------------------------------------------------------------------------
- initWithNativeDisplay:(void *)gdkDisplay
{
  self = [super init];
  if(self)
    _gdkDisplay = gdkDisplay;
  return self;
}

//----------------------------------------------------------------------------------------------------------------------------------
@synthesize gdkDisplay = _gdkDisplay;
- (OFString *)name { return [OFString stringWithUTF8String:gdk_display_get_name(NATIVE_DISPLAY)]; }
- (OFScreen *)defaultScreen { return [[[OFScreen alloc] initWithNativeScreen:] autorelease]; };

@property (readonly) void     *gdkDisplay;
@property (readonly) OFString *name;
@property (readonly) OFScreen *defaultScreen;
//@property (readonly) OFDeviceManager *deviceManager;

//----------------------------------------------------------------------------------------------------------------------------------
- (OFArray *)getScreens;
- (void) sync;
- (void) flush;
- (BOOL) isClosed;
- (void) close;

// - (OFEvent *)popEvent
// - (OFEvent *)peekEvent
// - (void)pushEvent;
// - (BOOL)hasPendingEvents

// - (OFArray *)listDevices;
// - ... captureDevice (_device_grab)
// - ... uncaptureDevice (_device_ungrab)
// - (BOOL) isDeviceCaptured

// - (OFWindow *)windowAtLocation

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
