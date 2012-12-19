//==================================================================================================================================
// OMSignalManager.h
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

//==================================================================================================================================
@interface OMSignalManager : OFObject
{
  void                *_gdkObject;
  OFMutableDictionary *_signals;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *gdkObject;

//----------------------------------------------------------------------------------------------------------------------------------
+ (id)nativeToWrapper:(void *)native;

//----------------------------------------------------------------------------------------------------------------------------------
+ signalManagerWithNative:(void *)gdkObject forObject:(OFObject *)wrapper;

//----------------------------------------------------------------------------------------------------------------------------------
- initWithNative:(void *)gdkObject forObject:(OFObject *)wrapper;

//----------------------------------------------------------------------------------------------------------------------------------
- (int)  makeConnection :(OFString *)signalName toFunction:(void (*)(void))function;
- (int)  makeConnection :(OFString *)signalName toFunction:(void (*)(void))function withData:(void *)data;
- (void) breakConnection:(OFString *)signalName;
- (void) breakAll;
- (BOOL) hasConnection  :(OFString *)signalName;
- (OFArray *)listConnections;

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
