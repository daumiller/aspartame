#import "aspartame.h"

@interface TestApp : OFObject <OMApplicationDelegate, OMWindowDelegate>
-(void) applicationDidFinishLaunching;
-(void) applicationWillTerminate;
-(BOOL) windowShouldClose:(OMWindow *)window;
@end

@implementation TestApp
- (id) init
{
  self = [super init];

  OMWindow *wnd = [OMWindow windowWithTitle:@"Hello アスパルテーム!" x:32 y:32 width:960 height:640];
  [wnd retain];
  [wnd show];
  wnd.delegate = self;
  wnd.quitOnClose = YES;

  return self;
}
-(void) applicationDidFinishLaunching { printf("applicationDidFinishLaunching!!\n"); }
-(void) applicationWillTerminate      { printf("applicationWillTerminate\n");        }
-(BOOL) windowShouldClose:(OMWindow *)window { printf("windowShouldClose\n"); return YES; }
@end

int main(int argc, char **argv)
{
  [OMApplication runWithClass:[TestApp class]];
}


/*
//http://www.gtkforums.com/viewtopic.php?t=3998
//http://openbooks.sourceforge.net/books/wga/gdk.html
#include <glib.h>
#include <gdk/gdk.h>

GMainLoop *mainloop;

void event_func(GdkEvent *ev, gpointer data)
{
  switch(ev->type)
  {
    case GDK_KEY_PRESS: printf("[%s]\n", ev->key.string); break;
    case GDK_DELETE:    g_main_loop_quit(mainloop);       break;
  }
}

int main(int argc, char **argv)
{
  gdk_init(&argc, &argv);

  GdkWindowAttr attr;
  attr.title = "GDK Test 0";
  attr.event_mask = GDK_KEY_PRESS_MASK;
  attr.window_type = GDK_WINDOW_TOPLEVEL;
  attr.wclass = GDK_INPUT_OUTPUT;
  attr.width  = 960;
  attr.height = 640;
  GdkWindow *win = gdk_window_new(NULL, &attr, 0);

  gdk_window_show(win);
  gdk_event_handler_set(event_func, NULL, NULL);

  mainloop = g_main_loop_new(g_main_context_default(), FALSE);
  g_main_loop_run(mainloop);

  gdk_window_destroy(win);
  return 0;
}
*/