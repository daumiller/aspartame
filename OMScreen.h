//==================================================================================================================================
// OMScreen.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <atropine/OMRectangle.h>
@class OMScreen;
@class OMSignalManager;
@class OMWidget;
@class OMVisual;

//==================================================================================================================================
@protocol OMScreenDelegate <OFObject>
@optional
-(void)screenCompositedChanged:(OMScreen *)screen;
-(void)screenMonitorsChanged  :(OMScreen *)screen;
-(void)screenDimensionsChanged:(OMScreen *)screen;
@end

//==================================================================================================================================
@interface OMScreen : OFObject
{
  void                *_gdkScreen;
  id<OMScreenDelegate> _delegate;
  OMSignalManager     *_signalManager;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *gdkScreen;
@property (readonly) int   screenIndex;
@property (readonly) int   width;
@property (readonly) int   height;
@property (readonly) int   mmWidth;
@property (readonly) int   mmHeight;
@property (readonly) int   monitorCount;
@property (readonly) int   primaryMonitor;
@property (readonly) BOOL  isComposited;
@property (retain  ) id<OMScreenDelegate> delegate;

//----------------------------------------------------------------------------------------------------------------------------------
+ screenWithNativeScreen:(void *)gdkScreen;
- initWithNativeScreen:(void *)gdkScreen;

//----------------------------------------------------------------------------------------------------------------------------------
-(OMDimension)monitorGeometry:(int)monitorIndex;  //monitor coordinates relative to screen
-(OMDimension)monitorWorkspace:(int)monitorIndex; //monitor coordinates relative to screen, minus system panels/areas
-(int)monitorAtPoint:(OMCoordinate)point;

-(OMWidget *)getRootWindow;
-(OFArray *)listTopLevelWindows;

-(OFArray *)listVisuals;
-(OMVisual *)getSystemVisual;
-(OMVisual *)getRGBAVisual;

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
