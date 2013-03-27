//==================================================================================================================================
// OMWindow.m
//==================================================================================================================================
#import <atropine/atropine.h>
#import <aspartame/aspartame.h>
//==================================================================================================================================

//==================================================================================================================================
@implementation OMWindow

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height
{
  return [[[OMWindow alloc] initWithTitle:title x:x y:y width:width height:height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height
{
  self = [super initWithParent:NULL title:title x:x y:y width:width height:height style:OMWIDGET_STYLE_NORMAL];
  if(self)
    ;
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_delegate release];
  [super dealloc];
}

//==================================================================================================================================
// Event Handler
//==================================================================================================================================
-(void)eventHandler:(OMEventType)type data:(void *)data
{
  switch(type)
  {
    case OMEVENT_EXPOSE:
    {
      OMEventExpose *expose = (OMEventExpose *)data;
      OMSurface *g = expose->surface;
      [g setColorR:0.8f G:0.8f B:0.8f]; //[g setColor:[OMWidgetTheme colorWindowBackground]];
      [g dimension:expose->area];
      [g fill];
    }
    break;

    case OMEVENT_DELETE:
    {
      if([_delegate respondsToSelector:@selector(windowShouldClose:)])
        if(![_delegate windowShouldClose:self])
          return;
      if(_quitOnClose) [OMApplication quit];
      [self destroyNativeWindow];
    }
    break;

    case OMEVENT_DESTROY:
    {
      if([_delegate respondsToSelector:@selector(windowWillClose:)])
        [_delegate windowWillClose:self];
    }
    break;

    default: return;
  }
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OFObject <OMWindowDelegate> *)delegate { return _delegate; }
-(void)setDelegate:(OFObject <OMWindowDelegate> *)delegate { [_delegate release]; _delegate = [delegate retain]; }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)quitOnClose { return _quitOnClose; }
-(void)setQuitOnClose:(BOOL)quitOnClose { _quitOnClose = quitOnClose; }
//----------------------------------------------------------------------------------------------------------------------------------

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
