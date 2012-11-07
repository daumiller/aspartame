//==================================================================================================================================
// OMControl.m
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
#import "OMControl.h"
#import "OMWindow.h"
//==================================================================================================================================
@implementation OMControl
//==================================================================================================================================
@synthesize parent;
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize buffer;
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize dimension;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setDimension:(OMDimension)inDimension
{
  dimension = inDimension;
  [buffer resizeWidth:dimension.size.width Height:dimension.size.height];
  [self paint];
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize focused;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setFocused:(BOOL)inFocused
{
  focused = inFocused;
  [self paint];
}
//==================================================================================================================================
+ control
{
  return [[[self alloc] init] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ controlWithDimension:(OMDimension)Dimension
{
  return [[[self alloc] initWithDimension:Dimension] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  dimension = OMMakeDimension(OMMakeCoordinate(0.0f, 0.0f), OMMakeSize(1.0f, 1.0f));
  buffer    = [[OMBufferSurface alloc] initWithWidth:1 Height:1];
  [self paint];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithDimension:(OMDimension)Dimension
{
  self = [super init];
  dimension = Dimension;
  buffer    = [[OMBufferSurface alloc] initWithWidth:dimension.size.width Height:dimension.size.height];
  [self paint];
  return self;
}
//==================================================================================================================================
- (void) paint
{
  [buffer fillWithColor:OMMakeColorRGBA(0.5f, 1.0f, 0.75f, 1.0f)];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paintDimension:(OMDimension)Dimension
{
  [self paint];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paintRectangle:(OMRectangle)Rectangle
{
  [self paint];
}
//==================================================================================================================================
- (void) renderToSurface:(OMSurface *)Surface
{
  [self paint];
  [buffer copyToSurface:Surface DestinationX:dimension.origin.x DestinationY:dimension.origin.y];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) renderToSurface:(OMSurface *)Surface Dimension:(OMDimension)Dimension
{
  [buffer copyToSurface:Surface DestinationCoordinate:dimension.origin SourceDimension:Dimension];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) renderToSurface:(OMSurface *)Surface Rectangle:(OMRectangle)Rectangle
{
  [buffer copyToSurface:Surface DestinationCoordinate:dimension.origin SourceRectangle:Rectangle];
}
//==================================================================================================================================
- (void) removeChild:(id)Child
{
  @throw [OFNotImplementedException exceptionWithClass:isa selector:_cmd];
}
//==================================================================================================================================
- (void)dealloc
{
  if(buffer != nil) [buffer release];
  [super dealloc];
}
//==================================================================================================================================
@end
//==================================================================================================================================
