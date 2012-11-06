#import "atropine.h"
#import "aspartame.h"

@interface TestApp : OFObject <ApplicationHandler>
- (BOOL) initWithArguments:(OFList *)args;
@end
@implementation TestApp
- (BOOL) initWithArguments:(OFList *)args
{
  OMWindow  *wnd  = [OMWindow windowWithTitle:@"Hello アスパルテーム!"];
  OMControl *ctrl = [OMControl control];
  //ctrl.visible    = YES;
  wnd.child       = ctrl;
  wnd.visible     = YES;
  wnd.quitOnClose = YES;
  wnd.size = OMMakeSize(640.0f, 480.0f); //set window size AFTER creating control to autosize up to window (minus title bar)
  [wnd retain];
  return YES;
}
@end

OMAPPLICATION_MAIN(TestApp);
