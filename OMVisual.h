//==================================================================================================================================
// OMVisual.h
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
#import <ObjFW/ObjFW.h>
@class OMScreen;

//==================================================================================================================================
typedef enum
{
  OMVISUAL_TYPE_GRAYSCALE,
  OMVISUAL_TYPE_PALETTE_GRAYSCALE,
  OMVISUAL_TYPE_PALETTE_STATIC,
  OMVISUAL_TYPE_PALETTE,
  OMVISUAL_TYPE_RGB,
  OMVISUAL_TYPE_RGB_PROFILE
} OMVisualType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMVISUAL_ORDER_LSBYTE,
  OMVISUAL_ORDER_MSBYTE
} OMVisualByteOrder;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int mask;
           int shift;
           int precision;
} OMVisualComponent;

//==================================================================================================================================
@interface OMVisual : OFObject
{
  void *_gdkVisual;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void             *gdkVisual;
@property (readonly) void             *gdkScreen;
@property (readonly) OMVisualType      type;
@property (readonly) int               depth;
@property (readonly) OMVisualByteOrder byteOrder;
@property (readonly) OMVisualComponent redBits;
@property (readonly) OMVisualComponent greenBits;
@property (readonly) OMVisualComponent blueBits;

//----------------------------------------------------------------------------------------------------------------------------------
+ visualWithNativeVisual:(void *)gdkVisual;
- initWithNativeVisual  :(void *)gdkVisual;

//----------------------------------------------------------------------------------------------------------------------------------
+ (OFArray *)listDefaultDepths;
+ (OFArray *)listDefaultVisualTypes;
+ (OFArray *)listDefaultVisuals;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OMVisualType)bestVisualType;
+ (int)         bestVisualDepth;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (OMVisual *)getSystemVisual;
+ (OMVisual *)getBestVisual;
+ (OMVisual *)getBestVisualWithDepth:(int)depth;
+ (OMVisual *)getBestVisualWithType:(OMVisualType)type;
+ (OMVisual *)getBetsVisualWithType:(OMVisualType)type andDepth:(int)depth;

//----------------------------------------------------------------------------------------------------------------------------------
- (OMScreen *)getScreen;

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
