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
@synthesize controller;
@synthesize selClosing;
@synthesize selMaximized;
@synthesize selMinimized;
@synthesize selMoved;
@synthesize selResized;
//==================================================================================================================================
//'Real' Properties
@synthesize title;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setTitle:(OFString *)inTitle
{
  if(title != nil) [title release];
  title = [[OFString alloc] initWithString:inTitle];
  platform_Window_SetTitle(platformData, title);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setLocation:(OMCoordinate)inLocation
{
  platform_Window_SetLocation(platformData, inLocation);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (OMCoordinate)location
{
  return platform_Window_GetLocation(platformData);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setSize:(OMSize)inSize
{
  platform_Window_SetSize(platformData, inSize);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (OMSize)size
{
  return platform_Window_GetSize(platformData);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setDimension:(OMDimension)inDimension
{
  platform_Window_SetLocation(platformData, inDimension.origin);
  platform_Window_SetSize    (platformData, inDimension.size  );
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (OMDimension)dimension
{
  return OMMakeDimension(platform_Window_GetLocation(platformData), platform_Window_GetSize(platformData));
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize quitOnClose;
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize visible;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setVisible:(BOOL)inVisible
{
  visible = inVisible;
  platform_Window_SetVisible(platformData, visible);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setMaximized:(BOOL)inMaximized
{
  platform_Window_SetMaximized(platformData, inMaximized);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (BOOL) maximized
{
  return platform_Window_GetMaximized(platformData);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setMinimized:(BOOL)inMinimized
{
  platform_Window_SetMinimized(platformData, inMinimized);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (BOOL) minimized
{
  return platform_Window_GetMinimized(platformData);
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize child;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setChild:(id)inChild
{
  if(child != nil) [child release];
  child = inChild;
  if(child != nil)
  {
    [child retain];
    OFObject *childsParent = (OFObject *)((OMControl *)child).parent;
    if(childsParent != nil)
    {
           if(object_getClass(childsParent) == [OMWindow  class]) [(OMWindow  *)childsParent removeChild:child];
      else if(object_getClass(childsParent) == [OMControl class]) [(OMControl *)childsParent removeChild:child];
    }
    ((OMControl *)child).parent = self;
  }
  [self paint];
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize focus;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) setFocus:(id)inFocus
{
  if(focus != nil) ((OMControl *)focus).focused = NO;
  focus = inFocus;
  if(focus != nil) ((OMControl *)focus).focused = YES;
}
//==================================================================================================================================
//Constructors
+ window
{
  return [[[self alloc] init] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title
{
  return [[[self alloc] initWithTitle:Title] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Size:(OMSize)Size
{
  return [[[self alloc] initWithTitle:Title Width:Size.width Height:Size.height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Width:(float)Width Height:(float)Height
{
  return [[[self alloc] initWithTitle:Title Width:Width Height:Height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Location:(OMCoordinate)Location
{
  return [[[self alloc] initWithTitle:Title Left:Location.x Top:Location.y] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top
{
  return [[[self alloc] initWithTitle:Title Left:Left Top:Top] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Location:(OMCoordinate)Location Size:(OMSize)Size
{
  return [[[self alloc] initWithTitle:Title Left:Location.x Top:Location.y Width:Size.width Height:Size.height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top Width:(float)Width Height:(float)Height
{
  return [[[self alloc] initWithTitle:Title Left:Left Top:Top Width:Width Height:Height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Dimension:(OMDimension)Dimension
{
  return [[[self alloc] initWithTitle:Title Left:Dimension.origin.x Top:Dimension.origin.y Width:Dimension.size.width Height:Dimension.size.height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)Title Rectangle:(OMRectangle)Rectangle
{
  return [[[self alloc] initWithTitle:Title
                                 Left:Rectangle.topLeft.x
                                  Top:Rectangle.topLeft.y
                                Width:Rectangle.bottomRight.x - Rectangle.topLeft.x
                               Height:Rectangle.bottomRight.y - Rectangle.topLeft.y] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  platformData = platform_Window_Create(self);
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)Title
{
  self = [super init];
  platformData = platform_Window_Create(self);
  self.title   = Title;
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)Title Width:(float)Width Height:(float)Height
{
  self = [super init];
  platformData = platform_Window_Create(self);
  self.title   = Title;
  self.size    = OMMakeSize(Width, Height);
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top
{
  self = [super init];
  platformData  = platform_Window_Create(self);
  self.title    = Title;
  self.location = OMMakeCoordinate(Left, Top);
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top Width:(float)Width Height:(float)Height
{
  self = [super init];
  platformData  = platform_Window_Create(self);
  self.title    = Title;
  self.location = OMMakeCoordinate(Left, Top);
  self.size    = OMMakeSize(Width, Height);
  return self;
}
//==================================================================================================================================
//Functions
- (void) close
{
  platform_Window_Close(platformData);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paint
{
  if(child == nil)
    platform_Window_Redraw(platformData);
  else
  {
    OMNativeSurface *surf = platform_Window_GetSurface(platformData);
    [child renderToSurface:surf];
    [surf release];
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) paintRectangle:(OMRectangle)Rectangle
{
  if(child == nil)
    platform_Window_RedrawRect(platformData, Rectangle);
  else
  {
    OMNativeSurface *surf = platform_Window_GetSurface(platformData);
    [child renderToSurface:surf Rectangle:Rectangle];
    [surf release];
  }
}
//==================================================================================================================================
- (void) removeChild:(id)Child
{
  if(child == Child) [self setChild:nil];
}
//==================================================================================================================================
//Cleanup
- (void)dealloc
{
  if(title != nil) [title release];
  if(child != nil) [child release];
  if(platformData != NULL) platform_Window_Cleanup(platformData);
  [super dealloc];
}
//==================================================================================================================================
@end
//==================================================================================================================================
