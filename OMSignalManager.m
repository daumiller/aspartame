//==================================================================================================================================
// OMSignalManager.m
//==================================================================================================================================
#import <atropine/atropine.h>
#import <aspartame/aspartame.h>
#import <aspartame/OMSignalManager.h>
#import <gdk/gdk.h>

//==================================================================================================================================
@implementation OMSignalManager

//==================================================================================================================================
// Class Utilities
//==================================================================================================================================
+ (id)nativeToWrapper:(void *)native
{
  return (id)g_object_get_data((GObject *)native, ASPARTAME_NATIVE_LOOKUP_STRING);
}

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+signalManagerWithNative:(void *)gdkObject forObject:(OFObject *)wrapper
{
  return [[[self alloc] initWithNative:gdkObject forObject:wrapper] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
-initWithNative:(void *)gdkObject forObject:(OFObject *)wrapper
{
  self = [super init];
  if(self)
  {
    _gdkObject = gdkObject;
    _signals = [[OFMutableDictionary alloc] init];
    g_object_set_data(_gdkObject, ASPARTAME_NATIVE_LOOKUP_STRING, wrapper);
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_signals release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize gdkObject = _gdkObject;

//==================================================================================================================================
// Signal Connection Management
//==================================================================================================================================
-(int)makeConnection:(OFString *)signalName toFunction:(void (*)(void))function
{
  return [self makeConnection:signalName toFunction:function withData:NULL];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)makeConnection:(OFString *)signalName toFunction:(void (*)(void))function withData:(void *)data
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  int id = g_signal_connect(_gdkObject, [signalName UTF8String], G_CALLBACK(function), data);
  [_signals setObject:[OFNumber numberWithInt:id] forKey:signalName];
  [pool drain];
  return id;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)breakConnection:(OFString *)signalName
{
  if(![self hasConnection:signalName]) return;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  g_signal_handler_disconnect(_gdkObject, [(OFNumber *)[_signals objectForKey:signalName] intValue]);
  [_signals removeObjectForKey:signalName];
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)breakAll
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFArray *pack = [_signals allKeys];
  for(OFString *cig in pack) [self breakConnection:cig];
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)hasConnection:(OFString *)signalName
{
  return [_signals containsObject:signalName];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFArray *)listConnections;
{
  return [_signals allKeys];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
