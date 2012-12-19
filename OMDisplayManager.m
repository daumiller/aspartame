//==================================================================================================================================
// OMDisplayManager.m
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
#import "OMDisplayManager.h"
#import "OMSignalManager.h"
#import "OMDisplay.h"
#include <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_DISPLAYMANAGER ((GdkDisplayManager *)_gdkDisplayManager)

//==================================================================================================================================
// Signal Handling Proxies
//==================================================================================================================================
static void signal_displayOpened(void *nativeManager, void *nativeDisplay, void *data)
{
  OMDisplayManager *dispMan = (OMDisplayManager *)[OMSignalManager nativeToWrapper:nativeManager];
  OMDisplay *disp = [[OMDisplay alloc] initWithNativeDisplay:nativeDisplay];
  [dispMan.delegate displayManager:dispMan displayOpened:disp]; //respondsToSelector: is checked before connection
  [disp release];
}

//==================================================================================================================================
@implementation OMDisplayManager
//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ sharedManager
{
  static OMDisplayManager *singleton = nil;
  @synchronized(self)
  {
    if(singleton == nil)
      singleton = [[self alloc] init];
  }
  return singleton;
}

//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self)
  {
    _gdkDisplayManager = (void *)gdk_display_manager_get();
    _signalManager = [[OMSignalManager alloc] initWithNative:_gdkDisplayManager forObject:self];
    _defaultDisplay = nil;
    _delegate = nil;
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) dealloc
{
  self.delegate = nil; //will handle the [_signalManager breakAll] call for us
  [_signalManager release];
  [_defaultDisplay release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize gdkDisplayManager = _gdkDisplayManager;
//----------------------------------------------------------------------------------------------------------------------------------
- (OMDisplay *)defaultDisplay
{
  if(_defaultDisplay == nil)
  {
    GdkDisplay *defDisp = gdk_display_manager_get_default_display(NATIVE_DISPLAYMANAGER);
    _defaultDisplay = [[OMDisplay alloc] initWithNativeDisplay:defDisp];
  }
  return _defaultDisplay;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void)setDefaultDisplay:(OMDisplay *)display
{
  if(_defaultDisplay) [_defaultDisplay release];
  gdk_display_manager_set_default_display(NATIVE_DISPLAYMANAGER, (GdkDisplay *)(display.gdkDisplay));
  _defaultDisplay = [display retain];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (id<OMDisplayManagerDelegate>)delegate { return _delegate; }
- (void)setDelegate:(id<OMDisplayManagerDelegate>)delegate
{
  if(_delegate)
  {
    [_signalManager breakAll];
    [_delegate release];
  }
  _delegate = [delegate retain];
  if([_delegate respondsToSelector:@selector(displayManager:displayOpened:)])
    [_signalManager makeConnection:@"display-opened" toFunction:(void (*)(void))signal_displayOpened];
}

//----------------------------------------------------------------------------------------------------------------------------------
- (OFArray *)listDisplays
{
  OFMutableArray *displays = [[OFMutableArray alloc] init];
  
  GSList *gdkDisplays = gdk_display_manager_list_displays(NATIVE_DISPLAYMANAGER);
  unsigned int displayCount = g_slist_length(gdkDisplays);
  for(unsigned int i=0; i<displayCount; i++)
    [displays addObject:[OMDisplay displayWithNativeDisplay:g_slist_nth_data(gdkDisplays, i)]];
  g_slist_free(gdkDisplays);

  OFArray *retArr = [OFArray arrayWithArray:displays];
  [displays release];
  return retArr;
}

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
