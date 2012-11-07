#import "atropine.h"
#import "aspartame.h"

@interface TestApp : OFObject
-(BOOL)promptToClose;
@end
@implementation TestApp
- init
{
  self = [super init];

  OMWindow  *wnd  = [OMWindow windowWithTitle:@"Hello アスパルテーム!"];
  OMControl *ctrl = [OMControl control];
  //ctrl.visible    = YES;
  wnd.child       = ctrl;
  wnd.visible     = YES;
  wnd.quitOnClose = YES;
  wnd.size = OMMakeSize(640.0f, 480.0f); //set window size AFTER creating control to autosize up to window (minus title bar)
  wnd.controller = self;
  wnd.selClosing = @selector(promptToClose);
  [wnd retain];

  return self;
}

- (BOOL)promptToClose { return YES; }
@end

OMAPPLICATION_MAIN(TestApp);
