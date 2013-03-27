//==================================================================================================================================
// OMVisual.h
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
