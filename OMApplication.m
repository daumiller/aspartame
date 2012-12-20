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
    case OMEVENT_NOTHING:                 eventData = NULL; break;
    case OMEVENT_DELETE:                  eventData = NULL; break;
    case OMEVENT_DESTROY:                 eventData = NULL; break;
    case OMEVENT_EXPOSE:
    case OMEVENT_POINTER_MOTION:
    case OMEVENT_POINTER_BUTTON_PRESS:
    case OMEVENT_POINTER_BUTTON_PRESS_X2:
    case OMEVENT_POINTER_BUTTON_PRESS_X3:
    case OMEVENT_POINTER_BUTTON_RELEASE:
    case OMEVENT_KEY_PRESS:
    case OMEVENT_KEY_RELEASE:
    case OMEVENT_POINTER_ENTER:
    case OMEVENT_POINTER_LEAVE:
    case OMEVENT_FOCUS_CHANGE:
    case OMEVENT_CONFIGURE:
    case OMEVENT_MAP:
    case OMEVENT_UNMAP:
    case OMEVENT_PROPERTY_CHANGE:
    case OMEVENT_SELECTION_CLEAR:
    case OMEVENT_SELECTION_REQUEST:
    case OMEVENT_SELECTION_NOTIFY:
    case OMEVENT_PROXIMITY_IN:
    case OMEVENT_PROXIMITY_OUT:
    case OMEVENT_DRAG_ENTER:
    case OMEVENT_DRAG_LEAVE:
    case OMEVENT_DRAG_MOTION:
    case OMEVENT_DRAG_STATUS:
    case OMEVENT_DROP_START:
    case OMEVENT_DROP_FINISHED:
    case OMEVENT_CLIENT_EVENT:
    case OMEVENT_VISIBILITY_CHANGE:
    case OMEVENT_SCROLL:
    case OMEVENT_WINDOW_STATE:
    case OMEVENT_SETTING:
    case OMEVENT_OWNER_CHANGE:
    case OMEVENT_GRAB_BROKEN:
    case OMEVENT_DAMAGE:
    case OMEVENT_TOUCH_BEGIN:
    case OMEVENT_TOUCH_UPDATE:
    case OMEVENT_TOUCH_END:
    case OMEVENT_TOUCH_CANCEL:
    default:
      eventData = NULL;
      break;
  }
  [widget eventHandler:eventType data:eventData];
}

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
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
