//==================================================================================================================================
// OMScreen.h
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
@interface OMScreen : OFObject
{
  @private
    void     *_gdkScreen;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *gdkScreen;
@property (readonly) int screenIndex;
@property (readonly) int width;
@property (readonly) int height;
@property (readonly) int mmWidth;
@property (readonly) int mmHeight;
@property (readonly) int monitorCount;
@property (readonly) int primaryMonitor;

//----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
- initWithNativeScreen:(void *)gdkScreen;

//----------------------------------------------------------------------------------------------------------------------------------
- (BOOL) isComposited;

// -(OMRectangle)monitorGeometry:(int)monitorIndex;  //monitor coordinates relative to screen
// -(OMRectangle)monitorWorkspace:(int)monitorIndex; //monitor coordinates relative to screen, minus system panels/areas
// -(int)monitorAtPoint:(OMCoordinate)point;

// -(OMWindow *)rootWindow;
// -(OFArray *)listTopLevelWindows;

//-(OFArray *)listVisuals;
//-(OMVisual *)systemVisual;
//-(OMVisual *)rgbaVisual;



//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
