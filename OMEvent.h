//==================================================================================================================================
// OMEvent.h
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
// Enumerations
//==================================================================================================================================
typedef enum
{
  OMEVENT_NOTHING                 = - 1, // 
  OMEVENT_DELETE                  =   0, // top-level window close request
  OMEVENT_DESTROY                 =   1, // cleaned-up
  OMEVENT_EXPOSE                  =   2, // invalidated
  OMEVENT_POINTER_MOTION          =   3, // mouse moved
  OMEVENT_POINTER_BUTTON_PRESS    =   4, // click
  OMEVENT_POINTER_BUTTON_PRESS_X2 =   5, // double click (in addition to two BUTTON_PRESS messages)
  OMEVENT_POINTER_BUTTON_PRESS_X3 =   6, // triple click
  OMEVENT_POINTER_BUTTON_RELEASE  =   7, // 
  OMEVENT_KEY_PRESS               =   8, // 
  OMEVENT_KEY_RELEASE             =   9, // 
  OMEVENT_POINTER_ENTER           =  10, // 
  OMEVENT_POINTER_LEAVE           =  11, // 
  OMEVENT_FOCUS_CHANGE            =  12, // 
  OMEVENT_CONFIGURE               =  13, // size, position, or z-order change
  OMEVENT_MAP                     =  14, // "mapped"/shown/resouces allocated
  OMEVENT_UNMAP                   =  15, // "unmapped"/hidden
  OMEVENT_PROPERTY_CHANGE         =  16, // 
  OMEVENT_SELECTION_CLEAR         =  17, // ?
  OMEVENT_SELECTION_REQUEST       =  18, // ?
  OMEVENT_SELECTION_NOTIFY        =  19, // ?
  OMEVENT_PROXIMITY_IN            =  20, // touch/tablet/... contact began
  OMEVENT_PROXIMITY_OUT           =  21, // touch/tablet/... contact lost
  OMEVENT_DRAG_ENTER              =  22, // 
  OMEVENT_DRAG_LEAVE              =  23, // 
  OMEVENT_DRAG_MOTION             =  24, // 
  OMEVENT_DRAG_STATUS             =  25, // 
  OMEVENT_DROP_START              =  26, // 
  OMEVENT_DROP_FINISHED           =  27, // 
  OMEVENT_CLIENT_EVENT            =  28, // event from another application (huh?)
  OMEVENT_VISIBILITY_CHANGE       =  29, // 
  //OMVENT_                       =  30,
  OMEVENT_SCROLL                  =  31, // 
  OMEVENT_WINDOW_STATE            =  32, // state changed
  OMEVENT_SETTING                 =  33, // 
  OMEVENT_OWNER_CHANGE            =  34, // window content has changed (huh?)
  OMEVENT_GRAB_BROKEN             =  35, // 
  OMEVENT_DAMAGE                  =  36, // 
  OMEVENT_TOUCH_BEGIN             =  37, // 
  OMEVENT_TOUCH_UPDATE            =  38, // 
  OMEVENT_TOUCH_END               =  39, // 
  OMEVENT_TOUCH_CANCEL            =  40, // 
  OMEVENT_LAST
} OMEventType;

//==================================================================================================================================
// Structures
//==================================================================================================================================


//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
