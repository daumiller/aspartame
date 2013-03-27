//==================================================================================================================================
// OMEvent.h
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
#import <atropine/OMRectangle.h>
@class OMWidget;
@class OMSurface;

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
  OMEVENT_STATE_CHANGE            =  32, // state changed
  OMEVENT_SETTING                 =  33, // 
  OMEVENT_OWNER_CHANGE            =  34, // window content has changed (huh?)
  OMEVENT_GRAB_BROKEN             =  35, // 
  OMEVENT_DAMAGE                  =  36, // 
  OMEVENT_TOUCH_BEGIN             =  37, // 
  OMEVENT_TOUCH_UPDATE            =  38, // 
  OMEVENT_TOUCH_END               =  39, // 
  OMEVENT_TOUCH_CANCEL            =  40  // 
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
  OMDimension area;
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
