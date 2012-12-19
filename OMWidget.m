//==================================================================================================================================
// OMWidget.m
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
#import "aspartame.h"
#import <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_WINDOW ((GdkWindow *)_gdkWindow)

//==================================================================================================================================
@implementation OMWidget

//==================================================================================================================================
// Constructors/Converter/Cleanup
//==================================================================================================================================
+widgetWithNativeWindow:(void *)gdkWindow
{
  return [[[OMWidget alloc] initWithNativeWindow:gdkWindow] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-initWithNativeWindow:(void *)gdkWindow
{
  self = [super init];
  if(self)
  {
    _gdkWindow = gdkWindow;
    _opacity   = 1.0f;
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
+(OMWidget *)nativeToWrapper:(void *)gdkWindow
{
  return (OMWidget *)g_object_get_data((GObject *)gdkWindow, ASPARTAME_NATIVE_LOOKUP_STRING);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)destroyNativeWindow
{
  //child classes inheriting OMWidget should probably call this during dealloc,
  //but OMWidget itself should not, as it is also used for information about external/non-app windows
  gdk_window_destroy(NATIVE_WINDOW);
}
//----------------------------------------------------------------------------------------------------------------------------------
+ widgetWithParent:(OMWidget *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style
{
  return [[[OMWidget alloc] initWithParent:(void *)parent title:title x:x y:y width:width height:height style:style] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ widgetWithNativeParent:(void *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style
{
  return [[[OMWidget alloc] initWithParent:parent title:title x:x y:y width:width height:height style:style] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ widgetWithParent:(OMWidget *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual
{
  return [[[OMWidget alloc] initWithParent:(void *)parent title:title events:events x:x y:y width:width height:height class:class type:type style:style visual:visual] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ widgetWithNativeParent:(void *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual
{
  return [[[OMWidget alloc] initWithParent:parent title:title events:events x:x y:y width:width height:height class:class type:type style:style visual:visual] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- initWithParent:(OMWidget *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style
{
  self = [super init];
  if(self) [self setupWithParent:(void *)parent title:title events:0 x:x y:y width:width height:height class:0 type:0 style:style visual:nil isExtended:NO isNative:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithNativeParent:(void *)parent title:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWidgetStyle)style
{
  self = [super init];
  if(self) [self setupWithParent:parent title:title events:0 x:x y:y width:width height:height class:0 type:0 style:style visual:nil isExtended:NO isNative:YES];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithParent:(OMWidget *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual
{
  self = [super init];
  if(self) [self setupWithParent:(void *)parent title:title events:events x:x y:y width:width height:height class:class type:type style:style visual:visual isExtended:YES isNative:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithNativeParent:(void *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual
{
  self = [super init];
  if(self) [self setupWithParent:parent title:title events:events x:x y:y width:width height:height class:class type:type style:style visual:visual isExtended:YES isNative:YES];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setupWithParent:(void *)parent title:(OFString *)title events:(OMWidgetEvent)events x:(int)x y:(int)y width:(int)width height:(int)height class:(OMWidgetClass)class type:(OMWidgetType)type style:(OMWidgetStyle)style visual:(OMVisual *)visual isExtended:(BOOL)isExtended isNative:(BOOL)isNative
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
 
  if((parent != NULL) && (isNative == NO))
    parent = ((OMWidget *)parent).gdkWindow;
  if(!isExtended)
  {
    class  = OMWIDGET_CLASS_INPUT_OUTPUT;
    type   = (parent == NULL) ? OMWIDGET_TYPE_WINDOW : OMWIDGET_TYPE_CHILD;
    events = OMWIDGET_EVENT_EXPOSED              | OMWIDGET_EVENT_TOUCH                  |
             OMWIDGET_EVENT_POINTER_BUTTON_PRESS | OMWIDGET_EVENT_POINTER_BUTTON_RELEASE |
             OMWIDGET_EVENT_KEY_PRESS            | OMWIDGET_EVENT_KEY_RELEASE            |
             OMWIDGET_EVENT_POINTER_ENTER        | OMWIDGET_EVENT_POINTER_LEAVE          |
             OMWIDGET_EVENT_SCROLL               | OMWIDGET_EVENT_SCROLL_SMOOTH          ;
  }

  GdkWindowAttr attr; 
  attr.title         = NULL;
  attr.event_mask    = events;
  attr.x             = x;
  attr.y             = y;
  attr.width         = width;
  attr.height        = height;
  attr.wclass        = (GdkWindowWindowClass)class;
  attr.visual        = NULL;
  attr.window_type   = (GdkWindowType)type;
  attr.cursor        = NULL;
  attr.wmclass_name  = NULL;
  attr.wmclass_class = NULL;
  attr.type_hint     = (GdkWindowTypeHint)style;

  GdkWindowAttributesType flags = GDK_WA_X | GDK_WA_Y | GDK_WA_TYPE_HINT;
  if(title  != nil) { flags |= GDK_WA_TITLE;  attr.title  = (gchar *)[title UTF8String]; }
  if(visual != nil) { flags |= GDK_WA_VISUAL; attr.visual = visual.gdkVisual;   }

  _gdkWindow  = gdk_window_new(parent, &attr, flags);
  _title      = [title retain];
  _type       = type;
  _geometry.x = x;
  _geometry.y = y;
  _geometry.widthBase  = width;
  _geometry.heightBase = height;
  _geometry.flags     |= OMWIDGET_GEOMETRY_POSITION | OMWIDGET_GEOMETRY_SIZE_BASE;
  _opacity             = 1.0f;

  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_title release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize gdkWindow = _gdkWindow;
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)title { return _title; }
-(void)setTitle:(OFString *)title { [_title release]; _title = [title retain]; }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)x
{
  int ret;
  if(_type == OMWIDGET_TYPE_WINDOW)
    gdk_window_get_geometry(NATIVE_WINDOW, &ret, NULL, NULL, NULL);
  else
    gdk_window_get_position(NATIVE_WINDOW, &ret, NULL);
  return ret;
}
-(void)setX:(int)x { [self moveX:x Y:self.y]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)y
{
  int ret;
  if(_type == OMWIDGET_TYPE_WINDOW)
    gdk_window_get_geometry(NATIVE_WINDOW, NULL, &ret, NULL, NULL);
  else
    gdk_window_get_position(NATIVE_WINDOW, NULL, &ret);
  return ret;
}
-(void)setY:(int)y { [self moveX:self.x Y:y]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)width
{
  if(_type != OMWIDGET_TYPE_WINDOW) return gdk_window_get_width(NATIVE_WINDOW);
  int ret; gdk_window_get_geometry(NATIVE_WINDOW, NULL, NULL, &ret, NULL); return ret;
}
-(void)setWidth:(int)width { [self resizeWidth:width Height:self.height]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)height
{
  if(_type != OMWIDGET_TYPE_WINDOW) return gdk_window_get_height(NATIVE_WINDOW);
  int ret; gdk_window_get_geometry(NATIVE_WINDOW, NULL, NULL, NULL, &ret); return ret;
}
-(void)setHeight:(int)height { [self resizeWidth:self.width Height:height]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMWidgetGeometry)geometry { return _geometry; }
-(void)setGeometry:(OMWidgetGeometry)geometry
{
  _geometry = geometry;
  GdkGeometry nativeGeometry;
  nativeGeometry.min_width   = geometry.widthMin;   nativeGeometry.max_width  = geometry.widthMax;
  nativeGeometry.base_width  = geometry.widthBase;  nativeGeometry.width_inc  = geometry.widthInc;
  nativeGeometry.min_height  = geometry.heightMin;  nativeGeometry.max_height = geometry.heightMax;
  nativeGeometry.base_height = geometry.heightBase; nativeGeometry.height_inc = geometry.heightInc;
  nativeGeometry.win_gravity = (GdkGravity)geometry.gravity;
  nativeGeometry.min_aspect  = (gdouble)geometry.aspectMin;
  nativeGeometry.max_aspect  = (gdouble)geometry.aspectMax;
  gdk_window_set_geometry_hints(NATIVE_WINDOW, &nativeGeometry, (GdkWindowHints)geometry.flags);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWidgetEvent)eventMask { return (OMWidgetEvent)gdk_window_get_events(NATIVE_WINDOW); }
-(void)setEventMask:(OMWidgetEvent)eventMask { gdk_window_set_events(NATIVE_WINDOW, (GdkEventMask)eventMask); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWidgetType)type { return (OMWidgetType)gdk_window_get_window_type(NATIVE_WINDOW); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWidgetStyle)style { return (OMWidgetStyle)gdk_window_get_type_hint(NATIVE_WINDOW); }
-(void)setStyle:(OMWidgetStyle)style
{
  if(gdk_window_is_visible(NATIVE_WINDOW)) return; //can't change after 'mapping' completed
  gdk_window_set_type_hint(NATIVE_WINDOW, (GdkWindowTypeHint)style);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWidgetState)state { return (OMWidgetState)gdk_window_get_state(NATIVE_WINDOW); }
-(void)setState:(OMWidgetState)state
{
  OMWidgetState current = (OMWidgetState)gdk_window_get_state(NATIVE_WINDOW);
  OMWidgetState diff    = current ^ state;

  //handle cleared min/max/full first
  if( (current & OMWIDGET_STATE_MINIMIZED ) && !(state & OMWIDGET_STATE_MINIMIZED )) gdk_window_deiconify   (NATIVE_WINDOW); //no longer mimized
  if( (current & OMWIDGET_STATE_MAXIMIZED ) && !(state & OMWIDGET_STATE_MAXIMIZED )) gdk_window_unmaximize  (NATIVE_WINDOW); //no longer maximized
  if( (current & OMWIDGET_STATE_FULLSCREEN) && !(state & OMWIDGET_STATE_FULLSCREEN)) gdk_window_unfullscreen(NATIVE_WINDOW); //no longer fullscreen
  //handle set min/max/full next
  if(!(current & OMWIDGET_STATE_MINIMIZED ) &&  (state & OMWIDGET_STATE_MINIMIZED )) gdk_window_iconify     (NATIVE_WINDOW); //now minimized
  if(!(current & OMWIDGET_STATE_MAXIMIZED ) &&  (state & OMWIDGET_STATE_MAXIMIZED )) gdk_window_maximize    (NATIVE_WINDOW); //now maximized
  if(!(current & OMWIDGET_STATE_FULLSCREEN) &&  (state & OMWIDGET_STATE_FULLSCREEN)) gdk_window_fullscreen  (NATIVE_WINDOW); //now fullscreen
  //then ordering flags
  if( (current & OMWIDGET_STATE_STICKY    ) && !(state & OMWIDGET_STATE_STICKY    )) gdk_window_unstick     (NATIVE_WINDOW); //no longer sticky
  if(!(current & OMWIDGET_STATE_STICKY    ) &&  (state & OMWIDGET_STATE_STICKY    )) gdk_window_stick       (NATIVE_WINDOW); //now sticky
  if(diff & OMWIDGET_STATE_TOP   ) gdk_window_set_keep_above(NATIVE_WINDOW, ((state & OMWIDGET_STATE_TOP   ) != 0));         //toggled above
  if(diff & OMWIDGET_STATE_BOTTOM) gdk_window_set_keep_below(NATIVE_WINDOW, ((state & OMWIDGET_STATE_BOTTOM) != 0));         //toggled below
  //finally, hide
  if(!(current & OMWIDGET_STATE_HIDDEN    ) &&  (state & OMWIDGET_STATE_HIDDEN    )) gdk_window_hide        (NATIVE_WINDOW); //now hidden
  //or show
  if((current & OMWIDGET_STATE_HIDDEN) && !(state & OMWIDGET_STATE_HIDDEN))
  {
    if(state & OMWIDGET_STATE_FOCUSED)
      gdk_window_show(NATIVE_WINDOW);
    else
      gdk_window_show_unraised(NATIVE_WINDOW);
  }
  else if(!(current & OMWIDGET_STATE_FOCUSED) && (state & OMWIDGET_STATE_FOCUSED))
    gdk_window_focus(NATIVE_WINDOW,0); //now focused
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWidget *)parent
{
  GdkWindow *gdkParent = gdk_window_get_parent(NATIVE_WINDOW);
  OMWidget  *omParent = [OMWidget nativeToWrapper:gdkParent];
  if(omParent) return omParent;
  return [OMWidget widgetWithNativeWindow:gdkParent];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setParent:(OMWidget *)parent
{
  BOOL visible = gdk_window_is_visible(NATIVE_WINDOW);
  gdk_window_reparent(NATIVE_WINDOW, parent.gdkWindow, _geometry.x, _geometry.y);
  if(visible) gdk_window_show(NATIVE_WINDOW);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void *)nativeParent { return gdk_window_get_parent(NATIVE_WINDOW); }
-(void)setNativeParent:(void *)nativeParent
{
  BOOL visible = gdk_window_is_visible(NATIVE_WINDOW);
  gdk_window_reparent(NATIVE_WINDOW, nativeParent, _geometry.x, _geometry.y);
  if(visible) gdk_window_show(NATIVE_WINDOW);
}
//----------------------------------------------------------------------------------------------------------------------------------
//@property (retain  ) OMCursor        *cursor;
//----------------------------------------------------------------------------------------------------------------------------------
-(float)opacity { return _opacity; }
-(void)setOpacity:(float)opacity { _opacity = opacity; gdk_window_set_opacity(NATIVE_WINDOW, (double)_opacity); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isVisible { return gdk_window_is_visible(NATIVE_WINDOW); }
-(void)setIsVisible:(BOOL)isVisible
{
  if(isVisible)
    gdk_window_show(NATIVE_WINDOW);
  else
    gdk_window_hide(NATIVE_WINDOW);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isModal { return gdk_window_get_modal_hint(NATIVE_WINDOW); }
-(void)setIsModal:(BOOL)isModal { gdk_window_set_modal_hint(NATIVE_WINDOW, isModal); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isDestroyed { return gdk_window_is_destroyed(NATIVE_WINDOW); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isComposited { return gdk_window_get_composited(NATIVE_WINDOW); }
-(void)setIsComposited:(BOOL)isComposited { gdk_window_set_composited(NATIVE_WINDOW, isComposited); }

//==================================================================================================================================
// Owning Display/Screen/Visual
//==================================================================================================================================
-(void *)getNativeDisplay { return (void *)gdk_window_get_display(NATIVE_WINDOW); }
-(void *)getNativeScreen  { return (void *)gdk_window_get_screen (NATIVE_WINDOW); }
-(void *)getNativeVisual  { return (void *)gdk_window_get_visual (NATIVE_WINDOW); }
-(OMDisplay *)getDisplay  { return [OMDisplay displayWithNativeDisplay:(void *)gdk_window_get_display(NATIVE_WINDOW)]; }
-(OMScreen *)getScreen    { return [OMScreen  screenWithNativeScreen  :(void *)gdk_window_get_screen (NATIVE_WINDOW)]; }
-(OMVisual *)getVisual    { return [OMVisual  visualWithNativeVisual  :(void *)gdk_window_get_visual (NATIVE_WINDOW)]; }

//==================================================================================================================================
// Z-Order & Focus
//==================================================================================================================================
-(void)show               { gdk_window_show         (NATIVE_WINDOW);    }
-(void)showWithoutRaising { gdk_window_show_unraised(NATIVE_WINDOW);    }
-(void)raise              { gdk_window_raise        (NATIVE_WINDOW);    }
-(void)lower              { gdk_window_lower        (NATIVE_WINDOW);    }
-(void)focus              { gdk_window_focus        (NATIVE_WINDOW, 0); }
-(void)reorderRelativeTo:(OMWidget *)sibling above:(BOOL)above
{
  gdk_window_restack(NATIVE_WINDOW, (GdkWindow *)sibling.gdkWindow, above);
}

//==================================================================================================================================
// Move/Resize
//==================================================================================================================================
-(void)moveX:(int)x Y:(int)y
{
  _geometry.flags |= OMWIDGET_GEOMETRY_POSITION;
  _geometry.x = x;
  _geometry.y = y;
  gdk_window_move(NATIVE_WINDOW, x, y);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)resizeWidth:(int)width Height:(int)height
{
  _geometry.flags |= OMWIDGET_GEOMETRY_SIZE_BASE;
  _geometry.widthBase  = width;
  _geometry.heightBase = height;
  gdk_window_resize(NATIVE_WINDOW, width, height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)moveX:(int)x Y:(int)y andResizeWidth:(int)width Height:(int)height
{
  _geometry.flags |= OMWIDGET_GEOMETRY_POSITION | OMWIDGET_GEOMETRY_SIZE_BASE;
  _geometry.x = x;
  _geometry.y = y;
  _geometry.widthBase  = width;
  _geometry.heightBase = height;
  gdk_window_move_resize(NATIVE_WINDOW, x, y, width, height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setOrigin:(OMCoordinate)pos { [self       moveX:(int)pos.x           Y:(int)pos.y      ]; }
-(void)setSize:(OMSize)size        { [self resizeWidth:(int)size.width Height:(int)size.height]; }
-(void)setOrigin:(OMCoordinate)pos andSize:(OMSize)size
{
  [self moveX:(int)pos.x Y:(int)pos.y andResizeWidth:(int)size.width Height:(int)size.height];
}
-(void)setDimension:(OMDimension)dimension
{
  [self moveX:(int)dimension.origin.x Y:(int)dimension.origin.y andResizeWidth:(int)dimension.size.width Height:(int)dimension.size.height];
}
//----------------------------------------------------------------------------------------------------------------------------------
//-(void)beginPointerResize
//-(void)beginPointerMove
//-(void)beginDeviceResize
//-(void)beginDeviceMove

//==================================================================================================================================
// Miscellaneous
//==================================================================================================================================
-(void)registerDropTarget                 { gdk_window_register_dnd(NATIVE_WINDOW);                           }
-(void)scrollX:(int)x Y:(int)y            { gdk_window_scroll(NATIVE_WINDOW, x, y);                           }
-(void)showInTaskbar:(BOOL)taskbar        { gdk_window_set_skip_taskbar_hint(NATIVE_WINDOW, !taskbar);        }
-(void)showInPager:(BOOL)pager            { gdk_window_set_skip_pager_hint(NATIVE_WINDOW, !pager);            }
-(void)showUrgency:(BOOL)urgency          { gdk_window_set_urgency_hint(NATIVE_WINDOW, urgency);              }
-(void)setAppWindow:(OMWidget *)appWindow { gdk_window_set_transient_for(NATIVE_WINDOW, appWindow.gdkWindow); }
-(void)flush                              { gdk_window_flush(NATIVE_WINDOW);                                  }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
