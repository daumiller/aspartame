//==================================================================================================================================
// OMWindow.m
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
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
