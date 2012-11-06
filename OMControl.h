//==================================================================================================================================
// OMControl.h
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
#import "OMCoordinate.h"
#import "OMRectangle.h"
#import "OMSurface.h"
#import "OMBufferSurface.h"
@class OMWindow;
//==================================================================================================================================
@interface OMControl : OFObject
{
  @protected
    id               parent;
    OMBufferSurface *buffer;
    OMDimension      dimension;
    BOOL             focused;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign)   id               parent;
@property (nonatomic, readonly) OMBufferSurface *buffer;
@property (nonatomic, assign)   OMDimension      dimension;
@property (nonatomic, assign)   BOOL             focused;
//----------------------------------------------------------------------------------------------------------------------------------
+ control;
+ controlWithDimension:(OMDimension)Dimension;
- init;
- initWithDimension:(OMDimension)Dimension;
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paint;
- (void) paintDimension:(OMDimension)Dimension;
- (void) paintRectangle:(OMRectangle)Rectangle;
//----------------------------------------------------------------------------------------------------------------------------------
- (void) renderToSurface:(OMSurface *)Surface;
- (void) renderToSurface:(OMSurface *)Surface Dimension:(OMDimension)Dimension;
- (void) renderToSurface:(OMSurface *)Surface Rectangle:(OMRectangle)Rectangle;
//----------------------------------------------------------------------------------------------------------------------------------
- (void) removeChild:(id)Child;
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
