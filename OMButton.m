//==================================================================================================================================
// OMButton.m
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
