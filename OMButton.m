//==================================================================================================================================
// OMButton.m
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
#import <gdk/gdk.h>
//==================================================================================================================================

//==================================================================================================================================
@implementation OMButton

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ buttonWithParent:(OMWidget *)parent x:(int)x y:(int)y width:(int)width height:(int)height
{
  return [[[OMButton alloc] initWithParent:parent x:x y:y width:width height:height] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithParent:(OMWidget *)parent x:(int)x y:(int)y width:(int)width height:(int)height
{
  self = [super initWithParent:parent title:nil x:x y:y width:width height:height style:OMWIDGET_STYLE_NORMAL];
  if(self)
  {
    _isHovered = NO;
    _isPressed = NO;
  }
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
      //[g rectangle:expose->area];

      //OMColor clrA = _isHovered ? OMMakeColorRGB(0.7f, 0.7f, 1.0f) : OMMakeColorRGB(0.85f, 0.85f, 0.85f);
      //OMColor clrB = _isHovered ? OMMakeColorRGB(0.6f, 0.6f, 1.0f) : OMMakeColorRGB(0.78f, 0.78f, 0.78f);
      
      cairo_pattern_t *linpat = cairo_pattern_create_linear(0.0, 0.0, 0.0, (double)self.height);
      if(_isHovered)
      {
        if(_isPressed)
        {
          cairo_pattern_add_color_stop_rgb(linpat, 0.00,  0.5, 0.5, 1.0);
          cairo_pattern_add_color_stop_rgb(linpat, 0.66,  0.4, 0.4, 1.0);
          cairo_pattern_add_color_stop_rgb(linpat, 1.00,  0.5, 0.5, 1.0);
        }
        else
        {
          cairo_pattern_add_color_stop_rgb(linpat, 0.00,  0.7, 0.7, 1.0);
          cairo_pattern_add_color_stop_rgb(linpat, 0.66,  0.5, 0.5, 1.0);
          cairo_pattern_add_color_stop_rgb(linpat, 1.00,  0.7, 0.7, 1.0);
        }
      }
      else
      {
        cairo_pattern_add_color_stop_rgb(linpat, 0.00,  0.85, 0.85, 0.85);
        cairo_pattern_add_color_stop_rgb(linpat, 0.66,  0.70, 0.70, 0.70);
        cairo_pattern_add_color_stop_rgb(linpat, 1.00,  0.85, 0.85, 0.85);
      }

      
      //[g setColor:clr];
      cairo_set_source(g.surfaceData, linpat);
      [g roundedDimension:OMMakeDimensionFloats(0.0f, 0.0f, g.width, g.height) withRadius:16.0f];
      [g fillPreserve];
      cairo_pattern_destroy(linpat);

      g.lineWidth = 1.0f;
      [g setColor:OMMakeColorRGB(0.0f, 0.0f, 0.0f)];
      [g stroke];
    }
    break;

    case OMEVENT_POINTER_ENTER: _isHovered = YES; [self invalidate]; break;
    case OMEVENT_POINTER_LEAVE: _isHovered = NO;  [self invalidate]; break;

    case OMEVENT_POINTER_BUTTON_PRESS  : _isPressed = YES; [self invalidate]; break;
    case OMEVENT_POINTER_BUTTON_RELEASE:
    {
      _isPressed = NO;  [self invalidate];
      if(_isHovered) if(_delegate) if([_delegate respondsToSelector:@selector(buttonPressed:)]) [_delegate buttonPressed:self];
    }
    break;

    default: return;
  }
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OFObject <OMButtonDelegate> *)delegate { return _delegate; }
-(void)setDelegate:(OFObject <OMButtonDelegate> *)delegate { [_delegate release]; _delegate = [delegate retain]; }
//----------------------------------------------------------------------------------------------------------------------------------

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
