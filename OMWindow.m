//==================================================================================================================================
// OMWindow.m
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
#import "OMWindow.h"
#import "OMControl.h"
#import "OMNativeSurface.h"
#import "platform/platform.h"
//==================================================================================================================================
@implementation OMWindow
//==================================================================================================================================
//Forward-to-Controller Events
@synthesize controller    = _controller;
@synthesize selClosing    = _selClosing;
@synthesize selMaximized  = _selMaximized;
@synthesize selMinimized  = _selMinimized;
@synthesize selMoved      = _selMoved;
@synthesize selResized    = _selResized;
//==================================================================================================================================
//Properties: ivar
@synthesize quitOnClose = _quitOnClose;
//==================================================================================================================================
//Properties: mixed
@synthesize title = _title;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setTitle:(OFString *)title
{
  if(_title != nil) [title release];
  _title = [[OFString alloc] initWithString:title];
  platform_Window_SetTitle(_platformData, _title);
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize child = _child;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setChild:(id)child
{
  if(_child != nil)
  {
    ((OMControl *)_child).parent = nil;
    [_child release];
  }
  _child = child;
  if(_child != nil)
  {
    [_child retain];
    OFObject *childsParent = (OFObject *)((OMControl *)_child).parent;
    if(childsParent != nil)
    {
           if(object_getClass(childsParent) == [OMWindow  class]) [(OMWindow  *)childsParent removeChild:_child];
      else if(object_getClass(childsParent) == [OMControl class]) [(OMControl *)childsParent removeChild:_child];
    }
    ((OMControl *)_child).parent = self;
  }
  [self paint];
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize visible = _visible;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setVisible:(BOOL)visible
{
  _visible = visible;
  platform_Window_SetVisible(_platformData, _visible);
}
//==================================================================================================================================
//Properties: virtual
//----------------------------------------------------------------------------------------------------------------------------------
- (void)     setLocation:(OMCoordinate)location {        platform_Window_SetLocation(_platformData, location); }
- (OMCoordinate)location                        { return platform_Window_GetLocation(_platformData);           }
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setSize:(OMSize)size {        platform_Window_SetSize(_platformData, size); }
- (OMSize)  size              { return platform_Window_GetSize(_platformData);       }
//----------------------------------------------------------------------------------------------------------------------------------
- (void)   setDimension:(OMDimension)dimension {                        platform_Window_SetLocation(_platformData, dimension.origin); platform_Window_SetSize(_platformData, dimension.size  ); }
- (OMDimension)dimension                       { return OMMakeDimension(platform_Window_GetLocation(_platformData),                   platform_Window_GetSize(_platformData));                }
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setMaximized:(BOOL)maximized {        platform_Window_SetMaximized(_platformData, maximized); }
- (BOOL)    maximized                 { return platform_Window_GetMaximized(_platformData);            }
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setMinimized:(BOOL)minimized {        platform_Window_SetMinimized(_platformData, minimized); }
- (BOOL)    minimized                 { return platform_Window_GetMinimized(_platformData);            }
//==================================================================================================================================
//Constructors
+ window
{
  return [[[self alloc] init] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title
{
  return [[[self alloc] initWithTitle:title] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Size:(OMSize)size
{
  return [[[self alloc] initWithTitle:title Width:size.width Height:size.height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Width:(float)width Height:(float)height
{
  return [[[self alloc] initWithTitle:title Width:width Height:height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Location:(OMCoordinate)location
{
  return [[[self alloc] initWithTitle:title Left:location.x Top:location.y] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Left:(float)left Top:(float)top
{
  return [[[self alloc] initWithTitle:title Left:left Top:top] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Location:(OMCoordinate)location Size:(OMSize)size
{
  return [[[self alloc] initWithTitle:title Left:location.x Top:location.y Width:size.width Height:size.height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Left:(float)left Top:(float)top Width:(float)width Height:(float)height
{
  return [[[self alloc] initWithTitle:title Left:left Top:top Width:width Height:height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Dimension:(OMDimension)dimension
{
  return [[[self alloc] initWithTitle:title Left:dimension.origin.x Top:dimension.origin.y Width:dimension.size.width Height:dimension.size.height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title Rectangle:(OMRectangle)rectangle
{
  return [[[self alloc] initWithTitle:title
                                 Left:rectangle.topLeft.x
                                  Top:rectangle.topLeft.y
                                Width:rectangle.bottomRight.x - rectangle.topLeft.x
                               Height:rectangle.bottomRight.y - rectangle.topLeft.y] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  _platformData = platform_Window_Create(self);
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)title
{
  self = [super init];
  _platformData = platform_Window_Create(self);
  self.title    = title;
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)title Width:(float)width Height:(float)height
{
  self = [super init];
  _platformData = platform_Window_Create(self);
  self.title   = title;
  self.size    = OMMakeSize(width, height);
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)title Left:(float)left Top:(float)top
{
  self = [super init];
  _platformData  = platform_Window_Create(self);
  self.title    = title;
  self.location = OMMakeCoordinate(left, top);
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)title Left:(float)left Top:(float)top Width:(float)width Height:(float)height
{
  self = [super init];
  _platformData  = platform_Window_Create(self);
  self.title    = title;
  self.location = OMMakeCoordinate(left, top);
  self.size    = OMMakeSize(width, height);
  return self;
}
//==================================================================================================================================
//Functions
- (void) close
{
  platform_Window_Close(_platformData);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paint
{
  if(_child == nil)
    platform_Window_Redraw(_platformData);
  else
  {
    OMNativeSurface *surf = platform_Window_GetSurface(_platformData);
    [_child renderToSurface:surf];
    [surf release];
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paintRectangle:(OMRectangle)rectangle
{
  if(_child == nil)
    platform_Window_RedrawRect(_platformData, rectangle);
  else
  {
    OMNativeSurface *surf = platform_Window_GetSurface(_platformData);
    [_child renderToSurface:surf Rectangle:rectangle];
    [surf release];
  }
}
//==================================================================================================================================
- (void) removeChild:(id)child
{
  if(_child == child) [self setChild:nil];
}
//==================================================================================================================================
//Cleanup
- (void)dealloc
{
  if(_title != nil) [_title release];
  if(_child != nil)
  {
    //any changes to [setChild] handling of previous _child should be reflected here
    ((OMControl *)_child).parent = nil;
    [_child release];
  }
  if(_platformData != NULL) platform_Window_Cleanup(_platformData);
  [super dealloc];
}
//==================================================================================================================================
@end
//==================================================================================================================================
