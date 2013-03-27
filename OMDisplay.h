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
