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
#import <ObjFW/ObjFW.h>
@class OMScreen;
@class OMDisplay;
@class OMSignalManager;
//@class OMDeviceManager;

//==================================================================================================================================
@protocol OMDisplayDelegate <OFObject>
@optional
-(void)displayClosed:(OMDisplay *)display dueToError:(BOOL)dueToError;
-(void)displayOpened:(OMDisplay *)display;
@end

//==================================================================================================================================
@interface OMDisplay : OFObject
{
  void                 *_gdkDisplay;
  OFString             *_name;
  OMScreen             *_defaultScreen;
  id<OMDisplayDelegate> _delegate;
  OMSignalManager      *_signalManager;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void                 *gdkDisplay;
@property (readonly) OFString             *name;
@property (readonly) OMScreen             *defaultScreen;
@property (retain  ) id<OMDisplayDelegate> delegate;
@property (readonly) BOOL                  supportsCompositing;
//@property (readonly) OMDeviceManager *deviceManager;
//----------------------------------------------------------------------------------------------------------------------------------
+ defaultDisplay;
+ openDisplay:(OFString *)displayName;
//----------------------------------------------------------------------------------------------------------------------------------
+ displayWithNativeDisplay:(void *)gdkDisplay;
- initWithNativeDisplay:(void *)gdkDisplay;
//----------------------------------------------------------------------------------------------------------------------------------
- (OFArray *)listScreens;
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

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
