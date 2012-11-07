//==================================================================================================================================
// OMApplication.h
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
#import <ObjFW/ObjFW.h>
//==================================================================================================================================
@protocol OMApplicationDelegate
//----------------------------------------------------------------------------------------------------------------------------------
@optional
- (BOOL) applicationShouldTerminate;
- (void) applicationWillTerminate;
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
@interface OMApplication : OFApplication <OFApplicationDelegate>
//----------------------------------------------------------------------------------------------------------------------------------
+ (int)  runWithClass:(Class)cls argc:(int *)argc argv:(char ***)argv;
+ (BOOL) quit;
+ (void) terminate;
- (void) applicationDidFinishLaunching;
- (BOOL) quit;
- (void) applicationWillTerminate;
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
#define OMAPPLICATION_MAIN(x) int main(int argc,char **argv){return [OMApplication runWithClass:[x class] argc:&argc argv:&argv];}
//==================================================================================================================================
