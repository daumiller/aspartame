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
#import <atropine/OMRectangle.h>
@class OMWidget;
@class OMSurface;

//==================================================================================================================================
// Enumerations
//==================================================================================================================================
typedef enum
{
  OMWINDOWEVENT_NOTHING                 = - 1, // 
  OMWINDOWEVENT_DELETE                  =   0, // top-level window close request
  OMWINDOWEVENT_DESTROY                 =   1, // cleaned-up
  OMWINDOWEVENT_EXPOSE                  =   2, // invalidated
  OMWINDOWEVENT_POINTER_MOTION          =   3, // mouse moved
  OMWINDOWEVENT_POINTER_BUTTON_PRESS    =   4, // click
  OMWINDOWEVENT_POINTER_BUTTON_PRESS_X2 =   5, // double click (in addition to two BUTTON_PRESS messages)
  OMWINDOWEVENT_POINTER_BUTTON_PRESS_X3 =   6, // triple click
  OMWINDOWEVENT_POINTER_BUTTON_RELEASE  =   7, // 
  OMWINDOWEVENT_KEY_PRESS               =   8, // 
  OMWINDOWEVENT_KEY_RELEASE             =   9, // 
  OMWINDOWEVENT_POINTER_ENTER           =  10, // 
  OMWINDOWEVENT_POINTER_LEAVE           =  11, // 
  OMWINDOWEVENT_FOCUS_CHANGE            =  12, // 
  OMWINDOWEVENT_CONFIGURE               =  13, // size, position, or z-order change
  OMWINDOWEVENT_MAP                     =  14, // "mapped"/shown/resouces allocated
  OMWINDOWEVENT_UNMAP                   =  15, // "unmapped"/hidden
  OMWINDOWEVENT_PROPERTY_CHANGE         =  16, // 
  OMWINDOWEVENT_SELECTION_CLEAR         =  17, // ?
  OMWINDOWEVENT_SELECTION_REQUEST       =  18, // ?
  OMWINDOWEVENT_SELECTION_NOTIFY        =  19, // ?
  OMWINDOWEVENT_PROXIMITY_IN            =  20, // touch/tablet/... contact began
  OMWINDOWEVENT_PROXIMITY_OUT           =  21, // touch/tablet/... contact lost
  OMWINDOWEVENT_DRAG_ENTER              =  22, // 
  OMWINDOWEVENT_DRAG_LEAVE              =  23, // 
  OMWINDOWEVENT_DRAG_MOTION             =  24, // 
  OMWINDOWEVENT_DRAG_STATUS             =  25, // 
  OMWINDOWEVENT_DROP_START              =  26, // 
  OMWINDOWEVENT_DROP_FINISHED           =  27, // 
  OMWINDOWEVENT_CLIENT_EVENT            =  28, // event from another application (huh?)
  OMWINDOWEVENT_VISIBILITY_CHANGE       =  29, // 
  //OMWINDOWEVENT_                        =  30, // 
  OMWINDOWEVENT_SCROLL                  =  31, // 
  OMWINDOWEVENT_STATE_CHANGE            =  32, // state changed
  OMWINDOWEVENT_SETTING                 =  33, // 
  OMWINDOWEVENT_OWNER_CHANGE            =  34, // window content has changed (huh?)
  OMWINDOWEVENT_GRAB_BROKEN             =  35, // 
  OMWINDOWEVENT_DAMAGE                  =  36, // 
  OMWINDOWEVENT_TOUCH_BEGIN             =  37, // 
  OMWINDOWEVENT_TOUCH_UPDATE            =  38, // 
  OMWINDOWEVENT_TOUCH_END               =  39, // 
  OMWINDOWEVENT_TOUCH_CANCEL            =  40, // 
  OMWINDOWEVENT_LAST
} OMWindowEventType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMEVENT_POINTER_MOVE,    // pointer moved over widget
  OMEVENT_POINTER_ENTER,   // pointer entered widget dimension
  OMEVENT_POINTER_LEAVE,   // pointer exited widget dimension
  OMEVENT_BUTTON_PRESS,    // pointer button depressed
  OMEVENT_BUTTON_PRESS_X2, // pointer button depressed within double-click threshold
  OMEVENT_BUTTON_PRESS_X3, // pointer button depressed within triple-click threshold
  OMEVENT_BUTTON_RELEASE,  // pointer button released
  OMEVENT_SCROLL,          // pointer/other scrolling
  OMEVENT_KEY_PRESS,       // keyboard key depressed
  OMEVENT_KEY_RELEASE,     // keyboard key released
  OMEVENT_FOCUS_GOT,       // active/keyboard focus moved to widget
  OMEVENT_FOCUS_LOST,      // active/keyboard focus removed from widget
  OMEVENT_FOCUS_NEXT,      // move active/keyboard focus to next child control <OMWidgetContainer>
  OMEVENT_FOCUS_PREV,      // move active/keyboard focus to previous child control <OMWidgetContainer>
  OMEVENT_DRAGDROP_ENTER,  // pointer entered widget while performing drag-and-drop
  OMEVENT_DRAGDROP_LEAVE,  // pointer exited widget while performing drag-and-drop
  OMEVENT_DRAGDROP_MOVE,   // pointer moved over widget while performing drag-and-drop
  OMEVENT_DRAGDROP_DROP,   // drag-and-drop completed/dropped over widget
  OMEVENT_TOUCH_BEGIN,     // touch event began on widget
  OMEVENT_TOUCH_UPDATE,    // touch event update/status-change over widget
  OMEVENT_TOUCH_END,       // touch event completed over widget
  OMEVENT_TOUCH_CANCEL     // touch event cancelled
} OMEventType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMMODIFIER_SHIFT   = 1<< 0,
  OMMODIFIER_LOCK    = 1<< 1, //CapsLock/ShiftLock
  OMMODIFIER_CONTROL = 1<< 2,
  OMMODIFIER_MOD1    = 1<< 3, //usually Alternate
  OMMODIFIER_MOD2    = 1<< 4,
  OMMODIFIER_MOD3    = 1<< 5,
  OMMODIFIER_MOD4    = 1<< 6,
  OMMODIFIER_MOD5    = 1<< 7,
  OMMODIFIER_BUTTON1 = 1<< 8,
  OMMODIFIER_BUTTON2 = 1<< 9,
  OMMODIFIER_BUTTON3 = 1<<10,
  OMMODIFIER_BUTTON4 = 1<<11,
  OMMODIFIER_BUTTON5 = 1<<12,
  OMMODIFIER_SUPER   = 1<<26,
  OMMODIFIER_HYPER   = 1<<27,
  OMMODIFIER_META    = 1<<28,
  OMMODIFIER_RELEASE = 1<<30
} OMEventModifier;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  OMSCROLL_UP,
  OMSCROLL_DOWN,
  OMSCROLL_LEFT,
  OMSCROLL_RIGHT,
  OMSCROLL_SMOOTH
} OMScrollDirection;

//==================================================================================================================================
// Structures
//==================================================================================================================================
typedef struct
{
  unsigned int    timestamp;
  OMEventModifier modifiers;
  unsigned int    keycode;
  unsigned short  keycodeRaw;
  BOOL            isModifier;
} OMEventKey;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int    timestamp;
  OMEventModifier modifiers;
  int             button;
  float           x, y;
  float           rootX, rootY;
  //float deviceX, deviceY;
  //OMDevice *device;
} OMEventButton;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int    timestamp;
  OMEventModifier modifiers;
  BOOL            isPointer;
  void           *sequenceId;
  float           x, y;
  float           rootX, rootY;
  //float           deviceX, deviceY;
  //OMDevice       *device;
} OMEventTouch;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int      timestamp;
  OMEventModifier   modifiers;
  OMScrollDirection direction;
  float             x, y;
  float             rootX, rootY;
  float             deltaX, deltaY;
  //OMDevice         *device
} OMEventScroll;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int    timestamp;
  OMEventModifier modifiers;
  float           x, y;
  float           rootX, rootY;
  BOOL            isFeed;
  //OMDevice       *device;
} OMEventPointer;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  OMSurface  *surface;
  OMDimension dimension;
  int         backlog;
} OMEventExpose;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int    timestamp;
  OMEventModifier modifiers;
  OMWidget       *other;
  void           *otherNative;
  float           x, y;
  float          rootX, rootY;
} OMEventEnterLeave;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  int changeMask;
  int newState;
} OMEventState;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  //not sure what's going on here yet... is this X specific?
  unsigned int timestamp;
  void *requestor;
  void *selection;
  void *target;
  void *property;
} OMEventSelection;
//----------------------------------------------------------------------------------------------------------------------------------
typedef struct
{
  unsigned int timestamp;
  float        rootX, rootY;
  //OMDragDrop   *context;
} OMEventDragDrop;

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
