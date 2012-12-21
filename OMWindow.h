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
#import <aspartame/OMWidget.h>
#import <aspartame/OMEvent.h>
@class OMDisplay;
@class OMScreen;
@class OMVisual;

//==================================================================================================================================
// Enumerations (castable)
//==================================================================================================================================
typedef enum
{
  OMWINDOW_TYPE_ROOT,
  OMWINDOW_TYPE_WINDOW,
  OMWINDOW_TYPE_CHILD,
  OMWINDOW_TYPE_TEMP,
  OMWINDOW_TYPE_FOREIGN,
  OMWINDOW_TYPE_OFFSCREEN
} OMWindowType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWINDOW_STYLE_NORMAL,
  OMWINDOW_STYLE_DIALOG,
  OMWINDOW_STYLE_MENU_TORN,
  OMWINDOW_STYLE_TOOLBAR,
  OMWINDOW_STYLE_SPLASHSCREEN,
  OMWINDOW_STYLE_UTILITY,
  OMWINDOW_STYLE_DOCK,
  OMWINDOW_STYLE_DESKTOP,
  OMWINDOW_STYLE_MENU_DROPDOWN,
  OMWINDOW_STYLE_MENU_POPUP,
  OMWINDOW_STYLE_TOOLTIP,
  OMWINDOW_STYLE_NOTIFICATION,
  OMWINDOW_STYLE_COMBO,
  OMWINDOW_STYLE_DRAGDROP
} OMWindowStyle;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWINDOW_STATE_NORMAL     =    0,
  OMWINDOW_STATE_HIDDEN     = 1<<0,
  OMWINDOW_STATE_MINIMIZED  = 1<<1,
  OMWINDOW_STATE_MAXIMIZED  = 1<<2,
  OMWINDOW_STATE_STICKY     = 1<<3,
  OMWINDOW_STATE_FULLSCREEN = 1<<4,
  OMWINDOW_STATE_TOP        = 1<<5,
  OMWINDOW_STATE_BOTTOM     = 1<<6,
  OMWINDOW_STATE_FOCUSED    = 1<<7
} OMWindowState;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWINDOW_GRAVITY_NORTHWEST = 1,
  OMWINDOW_GRAVITY_NORTH,
  OMWINDOW_GRAVITY_NORTHEAST,
  OMWINDOW_GRAVITY_WEST,
  OMWINDOW_GRAVITY_CENTER,
  OMWINDOW_GRAVITY_EAST,
  OMWINDOW_GRAIVTY_SOUTHWEST,
  OMWINDOW_GRAVITY_SOUTH,
  OMWINDOW_GRAVITY_SOUTHEAST,
  OMWINDOW_GRAVITY_STATIC
} OMWindowGravity;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWINDOW_EDGE_NORTHWEST,
  OMWINDOW_EDGE_NORTH,
  OMWINDOW_EDGE_NORTHEAST,
  OMWINDOW_EDGE_WEST,
  OMWINDOW_EDGE_EAST,
  OMWINDOW_EDGE_SOUTHWEST,
  OMWINDOW_EDGE_SOUTH,
  OMWINDOW_EDGE_SOUTHEAST
} OMWindowEdge;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWINDOW_EVENT_NONE                   = 1<< 0,
  OMWINDOW_EVENT_EXPOSED                = 1<< 1,
  OMWINDOW_EVENT_POINTER_MOTION         = 1<< 2,
  OMWINDOW_EVENT_POINTER_MOTION_FEED    = 1<< 3,
  OMWINDOW_EVENT_POINTER_BUTTON_MOTION  = 1<< 4,
  OMWINDOW_EVENT_POINTER_BUTTON1_MOTION = 1<< 5,
  OMWINDOW_EVENT_POINTER_BUTTON2_MOTION = 1<< 6,
  OMWINDOW_EVENT_POINTER_BUTTON3_MOTION = 1<< 7,
  OMWINDOW_EVENT_POINTER_BUTTON_PRESS   = 1<< 8,
  OMWINDOW_EVENT_POINTER_BUTTON_RELEASE = 1<< 9,
  OMWINDOW_EVENT_KEY_PRESS              = 1<<10,
  OMWINDOW_EVENT_KEY_RELEASE            = 1<<11,
  OMWINDOW_EVENT_POINTER_ENTER          = 1<<12,
  OMWINDOW_EVENT_POINTER_LEAVE          = 1<<13,
  OMWINDOW_EVENT_FOCUS_CHANGE           = 1<<14,
  OMWINDOW_EVENT_STRUCTURE_CHANGE       = 1<<15,
  OMWINDOW_EVENT_PROPERTY_CHANGE        = 1<<16,
  OMWINDOW_EVENT_VISIBILITY_CHANGE      = 1<<17,
  OMWINDOW_EVENT_PROXIMITY_IN           = 1<<18,
  OMWINDOW_EVENT_PROXIMITY_OUT          = 1<<19,
  OMWINDOW_EVENT_CHILD_STRUCTURE        = 1<<20,
  OMWINDOW_EVENT_SCROLL                 = 1<<21,
  OMWINDOW_EVENT_TOUCH                  = 1<<22,
  OMWINDOW_EVENT_SCROLL_SMOOTH          = 1<<23,
  OMWINDOW_EVENT_ALL                    = 0xFFFFFFFE
} OMWindowEvent;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMWINDOW_GEOMETRY_POSITION        = 1<<0,
  OMWINDOW_GEOMETRY_SIZE_MIN        = 1<<1,
  OMWINDOW_GEOMETRY_SIZE_MAX        = 1<<2,
  OMWINDOW_GEOMETRY_SIZE_BASE       = 1<<3,
  OMWINDOW_GEOMETRY_ASPECT          = 1<<4,
  OMWINDOW_GEOMETRY_INCREMENT       = 1<<5,
  OMWINDOW_GEOMETRY_GRAVITY         = 1<<6,
  OMWINDOW_GEOMETRY_USER_POSITIONED = 1<<7,
  OMWINDOW_GEOMETRY_USER_SIZED      = 1<<8
} OMWindowGeometryFlags;

//==================================================================================================================================
// Structures (non-castable)
//==================================================================================================================================
typedef struct
{
  int x, y;
  int    widthMin,  widthMax,  widthBase,  widthInc;
  int   heightMin, heightMax, heightBase, heightInc;
  float aspectMin, aspectMax;
  OMWindowGravity       gravity;
  OMWindowGeometryFlags flags;
} OMWindowGeometry;

//==================================================================================================================================
@interface OMWindow : OFObject <OMWidgetContainer>
{
  void            *_gdkWindow;
  OFString        *_title;     //gdk won't retrieve titles, so we'll store them
  OMWindowGeometry _geometry;
  float            _opacity;   //only provides writing
  OFArray         *_children;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *gdkWindow;
@property (retain  ) OFString        *title;
@property (assign  ) int              x;
@property (assign  ) int              y;
@property (assign  ) int              width;
@property (assign  ) int              height;
@property (assign  ) OMWindowGeometry geometry;
@property (assign  ) OMWindowEvent    eventMask;
@property (readonly) OMWindowType     type;
@property (assign  ) OMWindowStyle    style;
@property (assign  ) OMWindowState    state;
@property (assign  ) void            *nativeParent;
@property (assign  ) float            opacity;
@property (assign  ) BOOL             isVisible;
@property (readonly) BOOL             isDestroyed;
@property (assign  ) BOOL             isComposited;
//@property (retain  ) OMCursor        *cursor;

//----------------------------------------------------------------------------------------------------------------------------------
+ (OMWindow *)nativeToWrapper:(void *)gdkWindow;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height;
+ windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style;
+ windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events;
+ windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events visual:(OMVisual *)visual;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height;
- initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style;
- initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events;
- initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events visual:(OMVisual *)visual;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setupWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events visual:(OMVisual *)visual;

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
-(void)reorderRelativeToNative:(OMNativeWindow *)sibling above:(BOOL)above;
//----------------------------------------------------------------------------------------------------------------------------------
-(void)moveX:(int)x Y:(int)y;
-(void)moveX:(int)x Y:(int)y andResizeWidth:(int)width Height:(int)height;
-(void)                         resizeWidth:(int)width Height:(int)height;
-(void)setOrigin   :(OMCoordinate)pos;
-(void)setOrigin   :(OMCoordinate)pos andSize:(OMSize)size;
-(void)setSize                               :(OMSize)size;
-(void)setDimension:(OMDimension)dimension;
//----------------------------------------------------------------------------------------------------------------------------------
-(void)registerDropTarget;
-(void)scrollX:(int)x Y:(int)y;
-(void)showInTaskbar:(BOOL)taskbar;
-(void)showInPager:(BOOL)pager;
-(void)showUrgency:(BOOL)urgency;
-(void)setModalParent:(OMWindow *)modalParent;
-(void)flush;
-(void)forceRefresh;
//----------------------------------------------------------------------------------------------------------------------------------
-(void)translateEvent:(void *)gdkEvent withData:(void *)gdkData;
-(void *)dispatchEvent:(OMEventType)event withData:(void *)data;

@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
