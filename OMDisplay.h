//==================================================================================================================================
// OMDisplay.h
//==================================================================================================================================
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
