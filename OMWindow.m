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
#import <atropine/atropine.h>
#import <aspartame/aspartame.h>
#import <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_WINDOW ((GdkWindow *)_gdkWindow)

//==================================================================================================================================
@implementation OMWindow

//==================================================================================================================================
// Constructors/Converter/Cleanup
//==================================================================================================================================
+(OMWindow *)nativeToWrapper:(void *)gdkWindow;
{
  return (OMWindow *)g_object_get_data((GObject *)gdkWindow, ASPARTAME_NATIVE_LOOKUP_STRING);
}
//----------------------------------------------------------------------------------------------------------------------------------
+windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height
{
  return [[[OMWindow alloc] initWithTitle:title x:x y:y width:width height:height] autorelease];
}

+windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style
{
  return [[[OMWindow alloc] initWithTitle:title x:x y:y width:width height:height style:style] autorelease];
}

+windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events
{
  return [[[OMWindow alloc] initWithTitle:title x:x y:y width:width height:height style:style type:type events:events] autorelease];
}

+windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events visual:(OMVisual *)visual
{
  return [[[OMWindow alloc] initWithTitle:title x:x y:y width:width height:height style:style type:type events:events visual:visual] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height
{
  self = [super init];
  if(self) [self setupWithTitle:title x:x y:y width:width height:height style:OMWINDOW_STYLE_NORMAL type:OMWINDOW_TYPE_WINDOW events:OMWINDOW_EVENT_ALL visual:nil];
  return self;
}

-initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style
{
  self = [super init];
  if(self) [self setupWithTitle:title x:x y:y width:width height:height style:style type:OMWINDOW_TYPE_WINDOW events:OMWINDOW_EVENT_ALL visual:nil];
  return self;
}

-initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events
{
  self = [super init];
  if(self) [self setupWithTitle:title x:x y:y width:width height:height style:style type:type events:events visual:nil];
  return self;
}

-initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events visual:(OMVisual *)visual
{
  self = [super init];
  if(self) [self setupWithTitle:title x:x y:y width:width height:height style:style type:type events:events visual:visual];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setupWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height style:(OMWindowStyle)style type:(OMWindowType)type events:(OMWindowEvent)events visual:(OMVisual *)visual
{
  GdkWindowAttr attr; 
  attr.title         = NULL;
  attr.event_mask    = events;
  attr.x             = x;
  attr.y             = y;
  attr.width         = width;
  attr.height        = height;
  attr.wclass        = GDK_INPUT_OUTPUT;
  attr.visual        = NULL;
  attr.window_type   = (GdkWindowType)type;
  attr.cursor        = NULL;
  attr.wmclass_name  = NULL;
  attr.wmclass_class = NULL;
  attr.type_hint     = (GdkWindowTypeHint)style;

  GdkWindowAttributesType flags = GDK_WA_X | GDK_WA_Y | GDK_WA_TYPE_HINT;
  if(title  != nil) { flags |= GDK_WA_TITLE;  attr.title  = (gchar *)[title UTF8String]; }
  if(visual != nil) { flags |= GDK_WA_VISUAL; attr.visual = visual.gdkVisual;            }

  _gdkWindow  = gdk_window_new(parent, &attr, flags);
  _title      = [title retain];
  _children   = [[OFMutableArray alloc] init];
  _geometry.x = x;
  _geometry.y = y;
  _geometry.widthBase  = width;
  _geometry.heightBase = height;
  _geometry.flags     |= OMWINDOW_GEOMETRY_POSITION | OMWINDOW_GEOMETRY_SIZE_BASE;
  _opacity             = 1.0f;

  g_object_set_data(_gdkWindow, ASPARTAME_NATIVE_LOOKUP_STRING, self);

  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  gdk_window_destroy(NATIVE_WINDOW);
  [_children release];
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
-(int)x      { int x; gdk_window_get_geometry(NATIVE_WINDOW, &x, NULL, NULL, NULL); return x; }
-(void)setX:(int)x { [self moveX:x Y:self.y]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)y      { int y; gdk_window_get_geometry(NATIVE_WINDOW, NULL, &y, NULL, NULL); return y; }
-(void)setY:(int)y { [self moveX:self.x Y:y]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)width  { int w; gdk_window_get_geometry(NATIVE_WINDOW, NULL, NULL, &w, NULL); return w; }
-(void)setWidth:(int)width { [self resizeWidth:width Height:self.height]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)height { int h; gdk_window_get_geometry(NATIVE_WINDOW, NULL, NULL, NULL, &h); return h; }
-(void)setHeight:(int)height { [self resizeWidth:self.width Height:height]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMWindowGeometry)geometry { return _geometry; }
-(void)setGeometry:(OMWindowGeometry)geometry
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
-(OMWindowEvent)eventMask { return (OMWindowEvent)gdk_window_get_events(NATIVE_WINDOW); }
-(void)setEventMask:(OMWindowEvent)eventMask { gdk_window_set_events(NATIVE_WINDOW, (GdkEventMask)eventMask); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWindowType)type { return (OMWindowType)gdk_window_get_window_type(NATIVE_WINDOW); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWindowStyle)style { return (OMWindowStyle)gdk_window_get_type_hint(NATIVE_WINDOW); }
-(void)setStyle:(OMWindowStyle)style
{
  if(gdk_window_is_visible(NATIVE_WINDOW)) return; //can't change after 'mapping' completed
  gdk_window_set_type_hint(NATIVE_WINDOW, (GdkWindowTypeHint)style);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMWindowState)state { return (OMWindowState)gdk_window_get_state(NATIVE_WINDOW); }
-(void)setState:(OMWindowState)state
{
  OMWindowState current = (OMWindowState)gdk_window_get_state(NATIVE_WINDOW);
  OMWindowState diff    = current ^ state;

  //handle cleared min/max/full first
  if( (current & OMWINDOW_STATE_MINIMIZED ) && !(state & OMWINDOW_STATE_MINIMIZED )) gdk_window_deiconify   (NATIVE_WINDOW); //no longer mimized
  if( (current & OMWINDOW_STATE_MAXIMIZED ) && !(state & OMWINDOW_STATE_MAXIMIZED )) gdk_window_unmaximize  (NATIVE_WINDOW); //no longer maximized
  if( (current & OMWINDOW_STATE_FULLSCREEN) && !(state & OMWINDOW_STATE_FULLSCREEN)) gdk_window_unfullscreen(NATIVE_WINDOW); //no longer fullscreen
  //handle set min/max/full next
  if(!(current & OMWINDOW_STATE_MINIMIZED ) &&  (state & OMWINDOW_STATE_MINIMIZED )) gdk_window_iconify     (NATIVE_WINDOW); //now minimized
  if(!(current & OMWINDOW_STATE_MAXIMIZED ) &&  (state & OMWINDOW_STATE_MAXIMIZED )) gdk_window_maximize    (NATIVE_WINDOW); //now maximized
  if(!(current & OMWINDOW_STATE_FULLSCREEN) &&  (state & OMWINDOW_STATE_FULLSCREEN)) gdk_window_fullscreen  (NATIVE_WINDOW); //now fullscreen
  //then ordering flags
  if( (current & OMWINDOW_STATE_STICKY    ) && !(state & OMWINDOW_STATE_STICKY    )) gdk_window_unstick     (NATIVE_WINDOW); //no longer sticky
  if(!(current & OMWINDOW_STATE_STICKY    ) &&  (state & OMWINDOW_STATE_STICKY    )) gdk_window_stick       (NATIVE_WINDOW); //now sticky
  if(diff & OMWINDOW_STATE_TOP   ) gdk_window_set_keep_above(NATIVE_WINDOW, ((state & OMWINDOW_STATE_TOP   ) != 0));         //toggled above
  if(diff & OMWINDOW_STATE_BOTTOM) gdk_window_set_keep_below(NATIVE_WINDOW, ((state & OMWINDOW_STATE_BOTTOM) != 0));         //toggled below
  //finally, hide
  if(!(current & OMWINDOW_STATE_HIDDEN    ) &&  (state & OMWINDOW_STATE_HIDDEN    )) gdk_window_hide        (NATIVE_WINDOW); //now hidden
  //or show
  if((current & OMWINDOW_STATE_HIDDEN) && !(state & OMWINDOW_STATE_HIDDEN))
  {
    if(state & OMWINDOW_STATE_FOCUSED)
      gdk_window_show(NATIVE_WINDOW);
    else
      gdk_window_show_unraised(NATIVE_WINDOW);
  }
  else if(!(current & OMWINDOW_STATE_FOCUSED) && (state & OMWINDOW_STATE_FOCUSED))
    gdk_window_focus(NATIVE_WINDOW,0); //now focused
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
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
-(void)reorderRelativeToNative:(void *)sibling above:(BOOL)above
{
  gdk_window_restack(NATIVE_WINDOW, (GdkWindow *)sibling, above);
}

//==================================================================================================================================
// Move/Resize
//==================================================================================================================================
-(void)moveX:(int)x Y:(int)y
{
  _geometry.flags |= OMWINDOW_GEOMETRY_POSITION;
  _geometry.x = x;
  _geometry.y = y;
  gdk_window_move(NATIVE_WINDOW, x, y);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)resizeWidth:(int)width Height:(int)height
{
  _geometry.flags |= OMWINDOW_GEOMETRY_SIZE_BASE;
  _geometry.widthBase  = width;
  _geometry.heightBase = height;
  gdk_window_resize(NATIVE_WINDOW, width, height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)moveX:(int)x Y:(int)y andResizeWidth:(int)width Height:(int)height
{
  _geometry.flags |= OMWINDOW_GEOMETRY_POSITION | OMWINDOW_GEOMETRY_SIZE_BASE;
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
//==================================================================================================================================
// Miscellaneous
//==================================================================================================================================
-(void)registerDropTarget                     { gdk_window_register_dnd(NATIVE_WINDOW);                             }
-(void)scrollX:(int)x Y:(int)y                { gdk_window_scroll(NATIVE_WINDOW, x, y);                             }
-(void)showInTaskbar:(BOOL)taskbar            { gdk_window_set_skip_taskbar_hint(NATIVE_WINDOW, !taskbar);          }
-(void)showInPager:(BOOL)pager                { gdk_window_set_skip_pager_hint(NATIVE_WINDOW, !pager);              }
-(void)showUrgency:(BOOL)urgency              { gdk_window_set_urgency_hint(NATIVE_WINDOW, urgency);                }
-(void)setModalParent:(OMWindow *)modalParent { gdk_window_set_transient_for(NATIVE_WINDOW, modalParent.gdkWindow); }
-(void)flush                                  { gdk_window_flush(NATIVE_WINDOW);                                    }
-(void)forceRefresh                           { gdk_window_process_updates(NATIVE_WINDOW, TRUE);                    }

//==================================================================================================================================
// Children <WidgetContainer>
//==================================================================================================================================
-(OFArray *)children { return _children; }

//==================================================================================================================================
// Painting <WidgetContainer>
//==================================================================================================================================
-(void)invalidate
{
  gdk_window_invalidate_rect(NATIVE_WINDOW, NULL, TRUE);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)invalidateDimension:(OMDimension)dimension
{
  GdkRectangle rc;
  rc.x      = (int)dimension.origin.x;
  rc.y      = (int)dimension.origin.y;
  rc.width  = (int)dimension.size.width;
  rc.height = (int)dimension.size.height;
  gdk_window_invalidate_rect(NATIVE_WINDOW, &rc, TRUE);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)drawDimension:(OMDimension)dimension toSurface:(OMSurface *)surface
{
  [self drawBackgroundDimension:dimension toSurface:surface];
  [self drawChildrenDimension  :dimension toSurface:surface];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)drawBackgroundDimension:(OMDimension)dimension toSurface:(OMSurface *)surface
{
  //[surface setColor:[OMWidgetTheme colorWindowBackground]];
  [surface setColor:OMMakeColorRGB(0.8f, 0.8f, 0.8f)];
  [surface dimension:dimension];
  [surface fill];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)drawChildrenDimension:(OMDimension)dimension toSurface:(OMSurface *)surface
{
  for(OMWidget *child in _children)
  {
    OMDimension updateUnion = OMDimensionUnite(dimension, child.dimension);
    if((updateUnion.size.width > 0.0f) || (updateUnion.size.height > 0.0f))
      [child drawDimension:updateUnion toSurface:surface];
}

//==================================================================================================================================
// Event Translation
//==================================================================================================================================
-(void)translateEvent:(void *)gdkEvent withData:(void *)gdkData
{
  //move over all the OMApplication translation code to it's (proper) home here
  //pass everything on to handleEvent (overridable, callable as default, ...)
}

//==================================================================================================================================
// Event Dispatch
//==================================================================================================================================
-(void *)dispatchEvent:(OMEventType)event withData:(void *)data;
{
  //distribute events to children
}

//==================================================================================================================================
// Event Handler <WidgetContainer>
//==================================================================================================================================
-(void *)handleEvent:(OMEventType)type withData:(void *)data
{
  //decide what to process and what to delegate
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
