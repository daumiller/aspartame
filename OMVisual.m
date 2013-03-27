//==================================================================================================================================
// OMVisual.m
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
#import <aspartame/OMSignalManager.h>
#import <gdk/gdk.h>

//==================================================================================================================================
#define NATIVE_VISUAL ((GdkVisual *)_gdkVisual)

//==================================================================================================================================
@implementation OMVisual

//==================================================================================================================================
// Class Methods
//==================================================================================================================================
+ (OFArray *)listDefaultDepths
{
  OFMutableArray *omDepths = [[OFMutableArray alloc] init];

  int count, *depths;
  gdk_query_depths(&depths, &count);
  for(int i=0; i<count; i++)
    [omDepths addObject:[OFNumber numberWithInt:depths[i]]];

  OFArray *ret = [OFArray arrayWithArray:omDepths];
  [omDepths release];
  return ret;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OFArray *)listDefaultVisualTypes
{
  OFMutableArray *omTypes = [[OFMutableArray alloc] init];

  int count; GdkVisualType *types;
  gdk_query_visual_types(&types, &count);
  for(int i=0; i<count; i++)
    [omTypes addObject:[OFNumber numberWithInt:types[i]]];

  OFArray *ret = [OFArray arrayWithArray:omTypes];
  [omTypes release];
  return ret;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OFArray *)listDefaultVisuals
{
  OFMutableArray *omVisuals = [[OFMutableArray alloc] init];

  GList *gdkVisuals = gdk_list_visuals();
  unsigned int gdkCount = g_list_length(gdkVisuals);
  for(unsigned int i=0; i<gdkCount; i++)
    [omVisuals addObject:[OMVisual visualWithNativeVisual:g_list_nth_data(gdkVisuals, i)]];
  g_list_free(gdkVisuals);

  OFArray *ret = [OFArray arrayWithArray:omVisuals];
  [omVisuals release];
  return ret;
}
//----------------------------------------------------------------------------------------------------------------------------------
+ (OMVisualType)bestVisualType { return (OMVisualType)gdk_visual_get_best_type (); }
+ (int) bestVisualDepth        { return               gdk_visual_get_best_depth(); }
//----------------------------------------------------------------------------------------------------------------------------------
+ (OMVisual *)getSystemVisual { return [OMVisual visualWithNativeVisual:gdk_visual_get_system()]; }
+ (OMVisual *)getBestVisual   { return [OMVisual visualWithNativeVisual:gdk_visual_get_best  ()]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OMVisual *)getBestVisualWithDepth:(int)depth
{
  GdkVisual *gdkVis = gdk_visual_get_best_with_depth(depth);
  if(gdkVis == NULL) return nil;
  return [OMVisual visualWithNativeVisual:gdkVis];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OMVisual *)getBestVisualWithType:(OMVisualType)type
{
  GdkVisual *gdkVis = gdk_visual_get_best_with_type((GdkVisualType)type);
  if(gdkVis == NULL) return nil;
  return [OMVisual visualWithNativeVisual:gdkVis];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OMVisual *)getBetsVisualWithType:(OMVisualType)type andDepth:(int)depth
{
  GdkVisual *gdkVis = gdk_visual_get_best_with_both(depth, (GdkVisualType)type);
  if(gdkVis == NULL) return nil;
  return [OMVisual visualWithNativeVisual:gdkVis];
}

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ visualWithNativeVisual:(void *)gdkVisual
{
  return [[[OMVisual alloc] initWithNativeVisual:gdkVisual] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithNativeVisual:(void *)gdkVisual
{
  self = [super init];
  if(self) _gdkVisual = gdkVisual;
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(void *)            gdkVisual { return _gdkVisual;                                                  }
-(void *)            gdkScreen { return (void *)gdk_visual_get_screen(NATIVE_VISUAL);                }
-(OMVisualType)      type      { return (OMVisualType)gdk_visual_get_visual_type(NATIVE_VISUAL);     }
-(int)               depth     { return gdk_visual_get_depth(NATIVE_VISUAL);                         }
-(OMVisualByteOrder) byteOrder { return (OMVisualByteOrder)gdk_visual_get_byte_order(NATIVE_VISUAL); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMVisualComponent)redBits
{
  OMVisualComponent rcomp;
  gdk_visual_get_red_pixel_details(NATIVE_VISUAL, &(rcomp.mask), &(rcomp.shift), &(rcomp.precision));
  return rcomp;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMVisualComponent)greenBits
{
  OMVisualComponent comp;
  gdk_visual_get_green_pixel_details(NATIVE_VISUAL, &(comp.mask), &(comp.shift), &(comp.precision));
  return comp;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMVisualComponent)blueBits
{
  OMVisualComponent comp;
  gdk_visual_get_blue_pixel_details(NATIVE_VISUAL, &(comp.mask), &(comp.shift), &(comp.precision));
  return comp;
}

//==================================================================================================================================
// Instance Methods
//==================================================================================================================================
-(OMScreen *)getScreen
{
  return [OMScreen screenWithNativeScreen:gdk_visual_get_screen(NATIVE_VISUAL)];
}

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
