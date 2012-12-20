//==================================================================================================================================
// OMApplication.m
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
#include <gdk/gdk.h>

//==================================================================================================================================
static GMainLoop *mainloop = NULL;
static OFObject  *delegate = nil;

//==================================================================================================================================
OMEventKey        translateEvent_key       (GdkEvent *e);
OMEventButton     translateEvent_button    (GdkEvent *e);
OMEventTouch      translateEvent_touch     (GdkEvent *e);
OMEventScroll     translateEvent_scroll    (GdkEvent *e);
OMEventPointer    translateEvent_pointer   (GdkEvent *e);
OMEventExpose     translateEvent_expose    (GdkEvent *e);
OMEventEnterLeave translateEvent_enterLeave(GdkEvent *e);
OMEventState      translateEvent_state     (GdkEvent *e);
OMEventSelection  translateEvent_selection (GdkEvent *e);
OMEventDragDrop   translateEvent_dragDrop  (GdkEvent *e);
//----------------------------------------------------------------------------------------------------------------------------------
static void aspartame_event_handler(GdkEvent *e, gpointer crap);

//==================================================================================================================================
@implementation OMApplication
//----------------------------------------------------------------------------------------------------------------------------------
+ (int)runWithClass:(Class)cls;
{
  if(delegate)   return -1;
  if(cls == Nil) return -1;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];

  int argc=0; char **argv=NULL;
  gdk_init(&argc, &argv);
  mainloop = g_main_loop_new(g_main_context_default(), FALSE);
  gdk_event_handler_set(aspartame_event_handler, NULL, NULL);
  
  delegate = [[cls alloc] init];
  if([delegate respondsToSelector:@selector(applicationDidFinishLaunching)])
    [delegate applicationDidFinishLaunching];
  
  g_main_loop_run(mainloop);
  return 0;
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)quit
{
  g_main_loop_quit(mainloop);
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)terminate
{
  exit(0);
}
//==================================================================================================================================
@end

//==================================================================================================================================
static void atexit_handler(void)
{
  if(delegate)
    if([delegate respondsToSelector:@selector(applicationWillTerminate)])
      [delegate applicationWillTerminate];
  [delegate release];
}

//==================================================================================================================================
static void aspartame_event_handler(GdkEvent *e, gpointer crap)
{
  GdkEventAny *eAny = (GdkEventAny *)e;
  
  OMWidget *widget = [OMWidget nativeToWrapper:eAny->window];
  if(widget == nil) return;
  OMEventType eventType = (OMEventType)(eAny->type);

  void *eventData;
  switch(eventType)
  {
    case OMEVENT_EXPOSE:
    {
      OMEventExpose expose = translateEvent_expose(e);
      [widget eventHandler:eventType data:&expose];
    }
    break;

    case OMEVENT_KEY_PRESS:
    case OMEVENT_KEY_RELEASE:
    {
      OMEventKey key = translateEvent_key(e);
      [widget eventHandler:eventType data:&key];
    }
    break;

    case OMEVENT_POINTER_BUTTON_PRESS:
    case OMEVENT_POINTER_BUTTON_PRESS_X2:
    case OMEVENT_POINTER_BUTTON_PRESS_X3:
    case OMEVENT_POINTER_BUTTON_RELEASE:
    {
      OMEventButton button = translateEvent_button(e);
      [widget eventHandler:eventType data:&button];
    }
    break;

    case OMEVENT_TOUCH_BEGIN:
    case OMEVENT_TOUCH_UPDATE:
    case OMEVENT_TOUCH_END:
    case OMEVENT_TOUCH_CANCEL:
    {
      OMEventTouch touch = translateEvent_touch(e);
      [widget eventHandler:eventType data:&touch];
    }

    case OMEVENT_POINTER_MOTION:
    {
      OMEventPointer pointer = translateEvent_pointer(e);
      [widget eventHandler:eventType data:&pointer];
    }
    break;

    case OMEVENT_POINTER_ENTER:
    case OMEVENT_POINTER_LEAVE:
    {
      OMEventEnterLeave enterLeave = translateEvent_enterLeave(e);
      [widget eventHandler:eventType data:&enterLeave];
    }
    break;

    case OMEVENT_FOCUS_CHANGE:
    {
      GdkEventFocus *gdk = (GdkEventFocus *)e;
      BOOL gotFocus = (BOOL)gdk->in;
      [widget eventHandler:eventType data:&gotFocus];
    }
    break;

    case OMEVENT_CONFIGURE:
    {
      GdkEventConfigure *gdk = (GdkEventConfigure *)e;
      OMRectangle rectangle = OMMakeRectangleFloats((float)gdk->x, (float)gdk->y, (float)gdk->width, (float)gdk->height);
      [widget eventHandler:eventType data:&rectangle];
    }
    break;

    case OMEVENT_SCROLL:
    {
      OMEventScroll scroll = translateEvent_scroll(e);
      [widget eventHandler:eventType data:&scroll];
    }
    break;

    case OMEVENT_STATE_CHANGE:
    {
      OMEventState state = translateEvent_state(e);
      [widget eventHandler:eventType data:&state];
    }
    break;

    case OMEVENT_SELECTION_CLEAR:
    case OMEVENT_SELECTION_REQUEST:
    case OMEVENT_SELECTION_NOTIFY:
    {
      OMEventSelection selection = translateEvent_selection(e);
      [widget eventHandler:eventType data:&selection];
    }
    break;
 
    case OMEVENT_DRAG_ENTER:
    case OMEVENT_DRAG_LEAVE:
    case OMEVENT_DRAG_MOTION:
    case OMEVENT_DRAG_STATUS:
    case OMEVENT_DROP_START:
    case OMEVENT_DROP_FINISHED:
    {
      OMEventDragDrop dragDrop = translateEvent_dragDrop(e);
      [widget eventHandler:eventType data:&dragDrop];
    }
    break;

    case OMEVENT_PROXIMITY_IN:
    case OMEVENT_PROXIMITY_OUT:
    case OMEVENT_CLIENT_EVENT:
    case OMEVENT_OWNER_CHANGE:
    case OMEVENT_GRAB_BROKEN:
    case OMEVENT_DAMAGE:
    case OMEVENT_NOTHING:
    case OMEVENT_DELETE:
    case OMEVENT_DESTROY:
    case OMEVENT_SETTING:
    case OMEVENT_MAP:
    case OMEVENT_UNMAP:
    case OMEVENT_VISIBILITY_CHANGE:
    case OMEVENT_PROPERTY_CHANGE:
      [widget eventHandler:eventType data:NULL];
    break;
  }
}

//==================================================================================================================================
OMEventKey translateEvent_key(GdkEvent *e)
{
  GdkEventKey *gdk = (GdkEventKey *)e;
  OMEventKey om;
  om.timestamp  = gdk->time;
  om.modifiers  = gdk->state;
  om.keycode    = gdk->keyval;
  om.keycodeRaw = gdk->hardware_keycode;
  om.isModifier = (BOOL)(gdk->is_modifier);
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventButton translateEvent_button(GdkEvent *e)
{
  GdkEventButton *gdk = (GdkEventButton *)e;
  OMEventButton om;
  om.timestamp = gdk->time;
  om.x         = (float)gdk->x;
  om.y         = (float)gdk->y;
  om.rootX     = (float)gdk->x_root;
  om.rootY     = (float)gdk->y_root;
  om.modifiers = gdk->state;
  om.button    = gdk->button;
  //om.device    = [OMDeviceManager nativeDeviceCache:gdk->device];
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventTouch translateEvent_touch(GdkEvent *e)
{
  GdkEventTouch *gdk = (GdkEventTouch *)e;
  OMEventTouch om;
  om.timestamp  = gdk->time;
  om.x          = (float)gdk->x;
  om.y          = (float)gdk->y;
  om.rootX      = (float)gdk->x_root;
  om.rootY      = (float)gdk->y_root;
  om.modifiers  = gdk->state;
  om.isPointer  = gdk->emulating_pointer;
  om.sequenceId = gdk->sequence;
  //om.device    = [OMDeviceManager nativeDeviceCache:gdk->device];
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventScroll translateEvent_scroll(GdkEvent *e)
{
  GdkEventScroll *gdk = (GdkEventScroll *)e;
  OMEventScroll om;
  om.timestamp  = gdk->time;
  om.modifiers  = gdk->state;
  om.direction  = (OMScrollDirection)gdk->direction;
  om.x          = (float)gdk->x;
  om.y          = (float)gdk->y;
  om.rootX      = (float)gdk->x_root;
  om.rootY      = (float)gdk->y_root;
  om.deltaX     = (float)gdk->delta_x;
  om.deltaY     = (float)gdk->delta_y;
  //om.device    = [OMDeviceManager nativeDeviceCache:gdk->device];
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventPointer translateEvent_pointer(GdkEvent *e)
{
  GdkEventMotion *gdk = (GdkEventMotion *)e;
  OMEventPointer om;
  om.timestamp = gdk->time;
  om.modifiers = gdk->state;
  om.x         = (float)gdk->x;
  om.y         = (float)gdk->y;
  om.rootX     = (float)gdk->x_root;
  om.rootY     = (float)gdk->y_root;
  om.isFeed    = gdk->is_hint;
  //om.device    = [OMDeviceManager nativeDeviceCache:gdk->device];
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventExpose translateEvent_expose(GdkEvent *e)
{
  GdkEventExpose *gdk = (GdkEventExpose *)e;
  OMEventExpose om;
  om.area = OMMakeRectangleFloats((float)gdk->area.x, (float)gdk->area.y, (float)gdk->area.width, (float)gdk->area.height);
  om.backlog = gdk->count;
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventEnterLeave translateEvent_enterLeave(GdkEvent *e)
{
  GdkEventCrossing *gdk = (GdkEventCrossing *)e;
  OMEventEnterLeave om;
  om.timestamp = gdk->time;
  om.modifiers = gdk->state;
  om.otherNative = gdk->subwindow;
  om.other       = (om.otherNative == NULL) ? nil : [OMWidget nativeToWrapper:om.otherNative];
  om.x           = (float)gdk->x;
  om.y           = (float)gdk->y;
  om.rootX       = (float)gdk->x_root;
  om.rootY       = (float)gdk->y_root;
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventState translateEvent_state(GdkEvent *e)
{
  GdkEventWindowState *gdk = (GdkEventWindowState *)e;
  OMEventState om;
  om.changeMask = gdk->changed_mask;
  om.newState   = gdk->new_window_state;
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventSelection translateEvent_selection(GdkEvent *e)
{
  GdkEventSelection *gdk = (GdkEventSelection *)e;
  OMEventSelection om;
  om.timestamp = gdk->time;
  om.requestor = gdk->requestor;
  om.selection = gdk->selection;
  om.target    = gdk->target;
  om.property  = gdk->property;
  return om;
}
//----------------------------------------------------------------------------------------------------------------------------------
OMEventDragDrop translateEvent_dragDrop(GdkEvent *e)
{
  GdkEventDND *gdk = (GdkEventDND *)e;
  OMEventDragDrop om;
  om.timestamp = gdk->time;
  om.rootX     = (float)gdk->x_root;
  om.rootY     = (float)gdk->y_root;
  //om.context   = [OMDragDrop dragDropWithNativeDND:gdk->context];
  return om;
}

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
