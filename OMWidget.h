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
#import <aspartame/OMEvent.h>
@class OMDisplay;
@class OMScreen;
@class OMVisual;

//==================================================================================================================================
// Enumerations (castable)
//==================================================================================================================================
typedef enum
{
  OMWIDGET_TYPE_ROOT,
  OMWIDGET_TYPE_WINDOW,
  OMWIDGET_TYPE_CHILD,
  OMWIDGET_TYPE_TEMP,
  OMWIDGET_TYPE_FOREIGN,
  OMWIDGET_TYPE_OFFSCREEN
} OMWidgetType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_CLASS_INPUT_OUTPUT,
  OMWIDGET_CLASS_INPUT_ONLY
} OMWidgetClass;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_STYLE_NORMAL,
  OMWIDGET_STYLE_DIALOG,
  OMWIDGET_STYLE_MENU_TORN,
  OMWIDGET_STYLE_TOOLBAR,
  OMWIDGET_STYLE_SPLASHSCREEN,
  OMWIDGET_STYLE_UTILITY,
  OMWIDGET_STYLE_DOCK,
  OMWIDGET_STYLE_DESKTOP,
  OMWIDGET_STYLE_MENU_DROPDOWN,
  OMWIDGET_STYLE_MENU_POPUP,
  OMWIDGET_STYLE_TOOLTIP,
  OMWIDGET_STYLE_NOTIFICATION,
  OMWIDGET_STYLE_COMBO,
  OMWIDGET_STYLE_DRAGDROP
} OMWidgetStyle;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_STATE_NORMAL     =    0,
  OMWIDGET_STATE_HIDDEN     = 1<<0,
  OMWIDGET_STATE_MINIMIZED  = 1<<1,
  OMWIDGET_STATE_MAXIMIZED  = 1<<2,
  OMWIDGET_STATE_STICKY     = 1<<3,
  OMWIDGET_STATE_FULLSCREEN = 1<<4,
  OMWIDGET_STATE_TOP        = 1<<5,
  OMWIDGET_STATE_BOTTOM     = 1<<6,
  OMWIDGET_STATE_FOCUSED    = 1<<7
} OMWidgetState;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_GRAVITY_NORTHWEST = 1,
  OMWIDGET_GRAVITY_NORTH,
  OMWIDGET_GRAVITY_NORTHEAST,
  OMWIDGET_GRAVITY_WEST,
  OMWIDGET_GRAVITY_CENTER,
  OMWIDGET_GRAVITY_EAST,
  OMWIDGET_GRAIVTY_SOUTHWEST,
  OMWIDGET_GRAVITY_SOUTH,
  OMWIDGET_GRAVITY_SOUTHEAST,
  OMWIDGET_GRAVITY_STATIC
} OMWidgetGravity;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_EDGE_NORTHWEST,
  OMWIDGET_EDGE_NORTH,
  OMWIDGET_EDGE_NORTHEAST,
  OMWIDGET_EDGE_WEST,
  OMWIDGET_EDGE_EAST,
  OMWIDGET_EDGE_SOUTHWEST,
  OMWIDGET_EDGE_SOUTH,
  OMWIDGET_EDGE_SOUTHEAST
} OMWidgetEdge;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_EVENT_NONE                   = 1<< 0,
  OMWIDGET_EVENT_EXPOSED                = 1<< 1,
  OMWIDGET_EVENT_POINTER_MOTION         = 1<< 2,
  OMWIDGET_EVENT_POINTER_MOTION_FEED    = 1<< 3,
  OMWIDGET_EVENT_POINTER_BUTTON_MOTION  = 1<< 4,
  OMWIDGET_EVENT_POINTER_BUTTON1_MOTION = 1<< 5,
  OMWIDGET_EVENT_POINTER_BUTTON2_MOTION = 1<< 6,
  OMWIDGET_EVENT_POINTER_BUTTON3_MOTION = 1<< 7,
  OMWIDGET_EVENT_POINTER_BUTTON_PRESS   = 1<< 8,
  OMWIDGET_EVENT_POINTER_BUTTON_RELEASE = 1<< 9,
  OMWIDGET_EVENT_KEY_PRESS              = 1<<10,
  OMWIDGET_EVENT_KEY_RELEASE            = 1<<11,
  OMWIDGET_EVENT_POINTER_ENTER          = 1<<12,
  OMWIDGET_EVENT_POINTER_LEAVE          = 1<<13,
  OMWIDGET_EVENT_FOCUS_CHANGE           = 1<<14,
  OMWIDGET_EVENT_STRUCTURE_CHANGE       = 1<<15,
  OMWIDGET_EVENT_PROPERTY_CHANGE        = 1<<16,
  OMWIDGET_EVENT_VISIBILITY_CHANGE      = 1<<17,
  OMWIDGET_EVENT_PROXIMITY_IN           = 1<<18,
  OMWIDGET_EVENT_PROXIMITY_OUT          = 1<<19,
  OMWIDGET_EVENT_CHILD_STRUCTURE        = 1<<20,
  OMWIDGET_EVENT_SCROLL                 = 1<<21,
  OMWIDGET_EVENT_TOUCH                  = 1<<22,
  OMWIDGET_EVENT_SCROLL_SMOOTH          = 1<<23,
  OMWIDGET_EVENT_ALL                    = 0xFFFFFFFE
} OMWidgetEvent;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWIDGET_GEOMETRY_POSITION        = 1<<0,
  OMWIDGET_GEOMETRY_SIZE_MIN        = 1<<1,
  OMWIDGET_GEOMETRY_SIZE_MAX        = 1<<2,
  OMWIDGET_GEOMETRY_SIZE_BASE       = 1<<3,
  OMWIDGET_GEOMETRY_ASPECT          = 1<<4,
  OMWIDGET_GEOMETRY_INCREMENT       = 1<<5,
  OMWIDGET_GEOMETRY_GRAVITY         = 1<<6,
  OMWIDGET_GEOMETRY_USER_POSITIONED = 1<<7,
  OMWIDGET_GEOMETRY_USER_SIZED      = 1<<8
} OMWidgetGeometryFlags;

//==================================================================================================================================
// Structures (non-castable)
//==================================================================================================================================
typedef struct
{
  int x, y;
  int    widthMin,  widthMax,  widthBase,  widthInc;
  int   heightMin, heightMax, heightBase, heightInc;
  float aspectMin, aspectMax;
  OMWidgetGravity       gravity;
  OMWidgetGeometryFlags flags;
} OMWidgetGeometry;

//==================================================================================================================================
@interface OMWidget : OFObject
{
  void            *_gdkWindow;
  OFString        *_title;     //gdk won't retrieve titles, so we'll store them
  OMWidgetGeometry _geometry;
  OMWidgetType     _type;      //cache this (for x/y/width/height)
  float            _opacity;   //only provides writing
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *gdkWindow;
@property (retain  ) OFString        *title;
@property (assign  ) int              x;
@property (assign  ) int              y;
@property (assign  ) int              width;
@property (assign  ) int              height;
@property (assign  ) OMWidgetGeometry geometry;
@property (assign  ) OMWidgetEvent    eventMask;
@property (readonly) OMWidgetType     type;
@property (assign  ) OMWidgetStyle    style;
@property (assign  ) OMWidgetState    state;
@property (assign  ) OMWidget        *parent;
@property (assign  ) void            *nativeParent;
//@property (retain  ) OMCursor        *cursor;
@property (assign  ) float            opacity;
@property (assign  ) BOOL             isVisible;
@property (readonly) BOOL             isDestroyed;
@property (assign  ) BOOL             isComposited;

//----------------------------------------------------------------------------------------------------------------------------------
+ widgetWithNativeWindow:(void *)gdkWindow;
- initWithNativeWindow:(void *)gdkWindow;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OMWidget *)nativeToWrapper:(void *)gdkWindow;
- (void)destroyNativeWindow;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ widgetWithParent  :(OMWidget *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style;
+ widgetWithNativeParent:(void *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style;
+ widgetWithParent  :(OMWidget *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual;
+ widgetWithNativeParent:(void *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual;

- initWithParent  :(OMWidget *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style;
- initWithNativeParent:(void *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style;
- initWithParent  :(OMWidget *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual;
- initWithNativeParent:(void *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual;

-(void)setupWithParent:(void *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual isExtended:(BOOL)extended isNative:(BOOL)native;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//----------------------------------------------------------------------------------------------------------------------------------
-(OMDisplay *)getDisplay;
-(OMScreen *)getScreen;
-(OMVisual *)getVisual;
-(void *)getNativeDisplay;
-(void *)getNativeScreen;
-(void *)getNativeVisual;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)show;
-(void)showWithoutRaising;
-(void)raise;
-(void)lower;
-(void)focus;
-(void)reorderRelativeTo:(OMWidget *)sibling above:(BOOL)above;
//----------------------------------------------------------------------------------------------------------------------------------
-(void)moveX:(int)x Y:(int)y;
-(void)                         resizeWidth:(int)width Height:(int)height;
-(void)moveX:(int)x Y:(int)y andResizeWidth:(int)width Height:(int)height;
-(void)setOrigin   :(OMCoordinate)pos;
-(void)setSize     :(OMSize)size;
-(void)setOrigin   :(OMCoordinate)pos andSize:(OMSize)size;
-(void)setDimension:(OMDimension)dimension;
//-(void)beginPointerResize
//-(void)beginPointerMove
//-(void)beginDeviceResize
//-(void)beginDeviceMove
//----------------------------------------------------------------------------------------------------------------------------------
-(void)registerDropTarget;
-(void)scrollX:(int)x Y:(int)y;
-(void)showInTaskbar:(BOOL)taskbar;
-(void)showInPager:(BOOL)pager;
-(void)showUrgency:(BOOL)urgency;
-(void)setAppWindow:(OMWidget *)appWindow;
-(void)flush;
//----------------------------------------------------------------------------------------------------------------------------------
-(void)invalidate;
-(void)invalidateDimension:(OMDimension)dimension;
-(void)invalidateDimensionX:(int)x Y:(int)y Width:(int)width Height:(int)height;
-(void)forceRefresh;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)eventHandler:(OMEventType)type data:(void *)data;

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
