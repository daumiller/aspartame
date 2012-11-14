#import "atropine.h"
#import "aspartame.h"
#include <stdio.h>

@interface TestApp : OFObject
//- (void) applicationDidFinishLaunching;
- (id) init;
- (void) applicationWillTerminate;
@end
@implementation TestApp
//- (void) applicationDidFinishLaunching
- (id) init
{
  self = [super init];
  OMWindow  *wnd  = [OMWindow windowWithTitle:@"Hello アスパルテーム!"];
  OMControl *ctrl = [OMControl control];
  //ctrl.visible    = YES;
  wnd.child       = ctrl;
  wnd.visible     = YES;
  wnd.quitOnClose = YES;
  wnd.size = OMMakeSize(640.0f, 480.0f); //set window size AFTER creating control to autosize up to window (minus title bar)
  [wnd retain];
  return self;
}
- (void) applicationWillTerminate
{
  printf("applicationWillTerminate\n");
}
@end

int main(int argc, char **argv)
{
  [OMApplication runWithClass:[TestApp class]];
}
