//==================================================================================================================================
// OMVisual.h
//==================================================================================================================================
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
