//==================================================================================================================================
// OMWindow.h
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
//==================================================================================================================================
@interface OMWindow : OFObject
//Internal Properties
{
  @protected
    void     *_platformData;
    id        _controller;
    SEL       _selClosing;
    SEL       _selMaximized;
    SEL       _selMinimized;
    SEL       _selMoved;
    SEL       _selResized;
    BOOL      _quitOnClose;
    BOOL      _visible;
    OFString *_title;
    id        _child;
}
//----------------------------------------------------------------------------------------------------------------------------------
//Forward-to-Controller Event Properties
@property (retain) id  controller;
@property (assign) SEL selClosing;    //return NO to cancel
@property (assign) SEL selMaximized;
@property (assign) SEL selMinimized;
@property (assign) SEL selMoved;
@property (assign) SEL selResized;
//----------------------------------------------------------------------------------------------------------------------------------
//'Real' Properties
@property (nonatomic, retain) id            child;
@property (nonatomic, copy  ) OFString     *title;
@property (nonatomic, assign) OMCoordinate  location;
@property (nonatomic, assign) OMSize        size;
@property (nonatomic, assign) OMDimension   dimension;
@property (nonatomic, assign) BOOL          quitOnClose;
@property (nonatomic, assign) BOOL          visible;
@property (nonatomic, assign) BOOL          maximized;
@property (nonatomic, assign) BOOL          minimized;
//@property (nonatomic, retain) menu
//----------------------------------------------------------------------------------------------------------------------------------
//Constructors
+ window;
+ windowWithTitle:(OFString *)Title;
+ windowWithTitle:(OFString *)Title Size:(OMSize)Size;
+ windowWithTitle:(OFString *)Title Width:(float)width Height:(float)height;
+ windowWithTitle:(OFString *)Title Location:(OMCoordinate)Location;
+ windowWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top;
+ windowWithTitle:(OFString *)Title Location:(OMCoordinate)Location Size:(OMSize)Size;
+ windowWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top Width:(float)Width Height:(float)Height;
+ windowWithTitle:(OFString *)Title Dimension:(OMDimension)Dimension;
+ windowWithTitle:(OFString *)Title Rectangle:(OMRectangle)Rectangle;
- initWithTitle:(OFString *)Title;
- initWithTitle:(OFString *)Title Width:(float)Width Height:(float)Height;
- initWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top;
- initWithTitle:(OFString *)Title Left:(float)Left Top:(float)Top Width:(float)Width Height:(float)Height;
//----------------------------------------------------------------------------------------------------------------------------------
//Functions
- (void) close;
- (void) paint;
- (void) paintRectangle:(OMRectangle)Rectangle;
//----------------------------------------------------------------------------------------------------------------------------------
- (void) removeChild:(id)Child;
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
