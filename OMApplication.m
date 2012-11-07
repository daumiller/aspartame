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
static OMApplication *OMApp = nil;
static Class          OMApp_StartupClass    = Nil;
static id             OMApp_StartupInstance = nil;
//==================================================================================================================================
@implementation OMApplication
//----------------------------------------------------------------------------------------------------------------------------------
+ (int) runWithClass:(Class)cls argc:(int *)argc argv:(char ***)argv;
{
  if(OMApp)      return -1;
  if(cls == Nil) return -1;
  OMApp_StartupClass = cls;
  return of_application_main(argc, argv, [OMApplication class]);
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) quit
{
  return [OMApp quit];
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (void) terminate
{
  platform_Application_Terminate();  //this may only terminate GUI/message-loop (win)
  [OFApplication terminate];         //this may (win) or may not (osx) be reached
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self) OMApp = self;
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) applicationDidFinishLaunching
{
  //here, we're automatically provided an AutoreleasePool by our caller (OFApplication *self)
  platform_Application_Init();
  OMApp_StartupInstance = [[OMApp_StartupClass alloc] init];
  if(OMApp_StartupInstance == nil) [OFApplication terminateWithStatus:-1];

  platform_Application_Loop();
  [OFApplication terminateWithStatus:0]; //may or may not be needed/reached
}
//----------------------------------------------------------------------------------------------------------------------------------
- (BOOL) quit
{
  if(OMApp_StartupInstance != nil)
    if([OMApp_StartupInstance respondsToSelector:@selector(applicationShouldTerminate)])
      if([OMApp_StartupInstance applicationShouldTerminate] == NO)
        return NO;
  [OMApplication terminate];
  return YES;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) applicationWillTerminate
{
  if(OMApp_StartupInstance == nil) return;
  if([OMApp_StartupInstance respondsToSelector:@selector(applicationWillTerminate)])
    [OMApp_StartupInstance applicationWillTerminate]; 
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
