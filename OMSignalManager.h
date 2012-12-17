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
  @private
    OFMutableDictionary *_signals;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *gdkScreen;


//----------------------------------------------------------------------------------------------------------------------------------
+ signalManagerForNative:(void *)gdkObject;

//----------------------------------------------------------------------------------------------------------------------------------
- initWithNative:(void *)gdkObject;

//----------------------------------------------------------------------------------------------------------------------------------
- (int)connectSignal:(OFString *)signalName toFunction:(void (*)(void))function;
- (void)disconnectSignal:(OFString *)signalName;
- (void)disconnectSignalById:(int)connectionId;
- (BOOL)doesHandle:(OFString *)signalName;

//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
