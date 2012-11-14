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
static OFObject *OMApplication_mainInstance = nil;

//==================================================================================================================================
static void atexit_handler(void)
{
  if(OMApplication_mainInstance)
    if([OMApplication_mainInstance respondsToSelector:@selector(applicationWillTerminate)])
      [OMApplication_mainInstance applicationWillTerminate];
  [OMApplication_mainInstance release];
}

//==================================================================================================================================
@implementation OMApplication
//----------------------------------------------------------------------------------------------------------------------------------
+ (int)runWithClass:(Class)cls;
{
  if(OMApplication_mainInstance) return -1;
  if(cls == Nil)                 return -1;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  platform_Application_Init();
  OMApplication_mainInstance = [[cls alloc] init];
  if([OMApplication_mainInstance respondsToSelector:@selector(applicationDidFinishLaunching)])
  {
    printf("responds\n");
    [OMApplication_mainInstance applicationDidFinishLaunching];
  }
  else
    printf("doesn't respond\n");
  platform_Application_Loop();
  atexit_handler();
  [pool drain];
  return 0;
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)quit
{
  platform_Application_Quit();
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)terminate
{
  platform_Application_Terminate();
}
//==================================================================================================================================
@end

//==================================================================================================================================
