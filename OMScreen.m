//==================================================================================================================================
// OMScreen.m
//==================================================================================================================================
#import <atropine/atropine.h>
#import <aspartame/aspartame.h>
#import <aspartame/OMSignalManager.h>
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
+ screenWithNativeScreen:(void *)gdkScreen
{
  return [[[OMScreen alloc] initWithNativeScreen:gdkScreen] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
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
-(OMWidget *)getRootWindow
{
  return [OMWidget widgetWithNativeWindow:gdk_screen_get_root_window(NATIVE_SCREEN)];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFArray *)listTopLevelWindows
{
  OFMutableArray *omWidgets = [[OFMutableArray alloc] init];

  GList *gdkWindows = gdk_screen_get_toplevel_windows(NATIVE_SCREEN);
  unsigned int gdkCount = g_list_length(gdkWindows);
  for(unsigned int i=0; i<gdkCount; i++)
    [omWidgets addObject:[OMWidget widgetWithNativeWindow:g_list_nth_data(gdkWindows, i)]];
  g_list_free(gdkWindows);

  OFArray *retArray = [OFArray arrayWithArray:omWidgets];
  [omWidgets release];
  return retArray;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFArray *)listVisuals
{
  OFMutableArray *omVisuals = [[OFMutableArray alloc] init];

  GList *gdkVisuals = gdk_screen_get_toplevel_windows(NATIVE_SCREEN);
  unsigned int gdkCount = g_list_length(gdkVisuals);
  for(unsigned int i=0; i<gdkCount; i++)
    [omVisuals addObject:[OMVisual visualWithNativeVisual:g_list_nth_data(gdkVisuals, i)]];
  g_list_free(gdkVisuals);

  OFArray *retArray = [OFArray arrayWithArray:omVisuals];
  [omVisuals release];
  return retArray;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMVisual *)getSystemVisual
{
  return [OMVisual visualWithNativeVisual:gdk_screen_get_system_visual(NATIVE_SCREEN)];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMVisual *)getRGBAVisual
{
  return [OMVisual visualWithNativeVisual:gdk_screen_get_rgba_visual(NATIVE_SCREEN)];
}


//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
