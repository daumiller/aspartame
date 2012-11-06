//==================================================================================================================================
// OMApplication.m
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
#import "OMApplication.h"
#import "platform/platform.h"
//==================================================================================================================================
static OFObject <ApplicationHandler> *ilapplication_handler_object = nil;
//==================================================================================================================================
@implementation OMApplication
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)startWithClass:(Class)cls
{
  if(cls == Nil) return;
  int argc=0; char *_argv=""; char **argv=&_argv;
  ilapplication_handler_object = (OFObject <ApplicationHandler> *)[cls alloc];
  of_application_main(&argc, &argv, [OMApplication class]);
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)quit
{
  platform_Application_Terminate();
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) applicationDidFinishLaunching
{
  OFAutoreleasePool *pool = [OFAutoreleasePool new];
  platform_Application_Init();
  if(ilapplication_handler_object != nil)
  {
    OFList *args = platform_Application_Arguments();
    if([ilapplication_handler_object initWithArguments:args] == NO)
    {
      [pool release];
      platform_Application_Terminate();
      return;
    }
  }
  [pool release];
  platform_Application_Loop();
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) applicationWillTerminate
{
  if(ilapplication_handler_object != nil)
    if([ilapplication_handler_object respondsToSelector:@selector(cleanup)])
      [ilapplication_handler_object cleanup];
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
