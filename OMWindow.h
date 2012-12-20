//==================================================================================================================================
// OMWindow.h
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
#import "OMWidget.h"
@class OMWindow;

//==================================================================================================================================
@protocol OMWindowDelegate <OFObject>
@optional
-(BOOL)windowShouldClose:(OMWindow *)window;
-(void)windowWillClose:(OMWindow *)window;
@end

//==================================================================================================================================
@interface OMWindow : OMWidget
{
  OFObject <OMWindowDelegate> *_delegate;
  BOOL _quitOnClose;
}
//----------------------------------------------------------------------------------------------------------------------------------
@property (retain) OFObject <OMWindowDelegate> *delegate;
@property (assign) BOOL quitOnClose;
//----------------------------------------------------------------------------------------------------------------------------------
+ windowWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height;
- initWithTitle:(OFString *)title x:(int)x y:(int)y width:(int)width height:(int)height;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
