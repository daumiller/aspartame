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

    default:
    break;
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
