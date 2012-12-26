//==================================================================================================================================
// OMWidget.h
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
#import <atropine/OMRectangle.h>
@class OMSurface;
@class OMWidget;

//==================================================================================================================================
@protocol OMWidgetContainer <OFObject>
//----------------------------------------------------------------------------------------------------------------------------------
-(OFArray *)children;
-(int)appendChild:(OMWidget *)child;
-(int)insertChild:(OMWidget *)child atIndex:(int)index;
-(void)removeChild:(OMWidget *)child;
-(OMWidget *)removeChildAtIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMWidget *)childWithKeyboardFocus;
-(void)setChildWithKeyboardFocus:(OMWidget *)widget;
-(OMWidget *)childWithPointerFocus;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)invalidate;
-(void)invalidateDimension:(OMDimension)dimension;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)drawDimension:(OMDimension)dimension toSurface:(OMSurface *)surface;
-(void)drawBackgroundDimension:(OMDimension)dimension toSurface:(OMSurface *)surface;
-(void)drawChildrenDimension:(OMDimension)dimension toSurface:(OMSurface *)surface;
//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
