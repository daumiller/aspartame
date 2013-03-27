//==================================================================================================================================
// OMDisplay.h
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
#import <atropine/atropine.h>
#import <aspartame/aspartame.h>
#import <aspartame/OMSignalManager.h>
#include <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_DISPLAY ((GdkDisplay *)_gdkDisplay)

//==================================================================================================================================
// Signal Handling Proxies
//==================================================================================================================================
static void signal_closed(void *nativeDisplay, BOOL dueToError, void *data)
{
  OMDisplay *disp = (OMDisplay *)[OMSignalManager nativeToWrapper:nativeDisplay];
  [disp.delegate displayClosed:disp dueToError:dueToError];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void signal_opened(void *nativeDisplay, void *data)
{
  OMDisplay *disp = (OMDisplay *)[OMSignalManager nativeToWrapper:nativeDisplay];
  [disp.delegate displayOpened:disp];
}

//==================================================================================================================================
@implementation OMDisplay

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ defaultDisplay
{
  GdkDisplay *defDisp = gdk_display_manager_get_default_display(gdk_display_manager_get());
  return [[[OMDisplay alloc] initWithNativeDisplay:defDisp] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
+ openDisplay:(OFString *)displayName
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GdkDisplay *disp = gdk_display_open([displayName UTF8String]);
  [pool drain];
  if(disp == NULL) return nil;
  return [[[OMDisplay alloc] initWithNativeDisplay:disp] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
+ displayWithNativeDisplay:(void *)gdkDisplay
{
  return [[[self alloc] initWithNativeDisplay:gdkDisplay] autorelease];
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
-(void)dealloc
{
  self.delegate = nil; //will clean up _signalManager for us
  [_signalManager release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize gdkDisplay = _gdkDisplay;
//----------------------------------------------------------------------------------------------------------------------------------
- (OFString *)name { return [OFString stringWithUTF8String:gdk_display_get_name(NATIVE_DISPLAY)]; }
- (OMScreen *)defaultScreen { return [[[OMScreen alloc] initWithNativeScreen:gdk_display_get_default_screen(NATIVE_DISPLAY)] autorelease]; };
//@property (readonly) OFDeviceManager *deviceManager;
-(BOOL)supportsCompositing { return gdk_display_supports_composite(NATIVE_DISPLAY); }
//----------------------------------------------------------------------------------------------------------------------------------
- (id<OMDisplayDelegate>)delegate { return _delegate; }
- (void)setDelegate:(id<OMDisplayDelegate>)delegate
{
  if(_delegate)
  {
    [_signalManager breakAll];
    [_delegate release];
  }
  _delegate = [delegate retain];
  if([_delegate respondsToSelector:@selector(displayClosed:dueToError:)]) [_signalManager makeConnection:@"closed" toFunction:(void (*)(void))signal_closed];
  if([_delegate respondsToSelector:@selector(displayOpened:           )]) [_signalManager makeConnection:@"opened" toFunction:(void (*)(void))signal_opened];
}

//==================================================================================================================================
// Instance Methods
//==================================================================================================================================
- (OFArray *)listScreens
{
  int count = gdk_display_get_n_screens(NATIVE_DISPLAY);
  OFMutableArray *listBuilder = [[OFMutableArray alloc] init];
  for(int i=0; i<count; i++)
    [listBuilder addObject:[[[OMScreen alloc] initWithNativeScreen:(gdk_display_get_screen(NATIVE_DISPLAY, i))] autorelease] ];
  OFArray *list = [OFArray arrayWithArray:listBuilder];
  [listBuilder release];
  return list;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) sync  { gdk_display_sync (NATIVE_DISPLAY); }
- (void) flush { gdk_display_flush(NATIVE_DISPLAY); }
- (void) close { gdk_display_close(NATIVE_DISPLAY); }
- (BOOL) isClosed { return (BOOL)gdk_display_is_closed(NATIVE_DISPLAY); }
//----------------------------------------------------------------------------------------------------------------------------------

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
