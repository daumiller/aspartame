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
  if(eAny->window == NULL) return;
  OMWindow *window = [OMWindow nativeToWrapper:eAny->window];
  if(window == nil) return;
  [window translateEvent:e withData:crap];
}

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
