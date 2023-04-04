/*
 *  Copyright (C) 2021- Team Kodi
 *  This file is part of Kodi - https://kodi.tv
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 *  See LICENSES/README.md for more information.
 */

#import "OSXGLView.h"

#include "ServiceBroker.h"
#include "application/AppInboundProtocol.h"
#include "application/AppParamParser.h"
#include "application/Application.h"
#include "messaging/ApplicationMessenger.h"
#include "settings/AdvancedSettings.h"
#include "settings/SettingsComponent.h"
#include "utils/log.h"
#import "windowing/osx/WinSystemOSX.h"

#include "system_gl.h"

@implementation OSXGLView
{
  NSOpenGLContext* m_glcontext;
  NSOpenGLPixelFormat* m_pixFmt;
  NSTrackingArea* m_trackingArea;
  BOOL pause;
}

- (void)SendInputEvent:(NSEvent*)nsEvent
{
  CWinSystemOSX* winSystem = dynamic_cast<CWinSystemOSX*>(CServiceBroker::GetWinSystem());
  if (winSystem)
  {
    winSystem->SendInputEvent(nsEvent);
  }
}

- (id)initWithFrame:(NSRect)frameRect
{
  NSOpenGLPixelFormatAttribute wattrs[] = {
      NSOpenGLPFANoRecovery,    NSOpenGLPFAAccelerated,
      NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
      NSOpenGLPFAColorSize,     (NSOpenGLPixelFormatAttribute)32,
      NSOpenGLPFAAlphaSize,     (NSOpenGLPixelFormatAttribute)8,
      NSOpenGLPFADepthSize,     (NSOpenGLPixelFormatAttribute)24,
      NSOpenGLPFADoubleBuffer,  (NSOpenGLPixelFormatAttribute)0};

  self = [super initWithFrame:frameRect];
  if (self)
  {
    m_pixFmt = [[NSOpenGLPixelFormat alloc] initWithAttributes:wattrs];
    m_glcontext = [[NSOpenGLContext alloc] initWithFormat:m_pixFmt shareContext:nil];
  }

  [self updateTrackingAreas];

  GLint swapInterval = 1;
  [m_glcontext setValues:&swapInterval forParameter:NSOpenGLContextParameterSwapInterval];
  [m_glcontext makeCurrentContext];

  return self;
}

- (void)dealloc
{
  [NSOpenGLContext clearCurrentContext];
  [m_glcontext clearDrawable];
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (void)drawRect:(NSRect)rect
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self setOpenGLContext:m_glcontext];

    // clear screen on first render
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);

    [m_glcontext update];
  });
}

- (void)updateTrackingAreas
{
  if (m_trackingArea != nil)
  {
    [self removeTrackingArea:m_trackingArea];
  }

  const int opts =
      (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways);
  m_trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                options:opts
                                                  owner:self
                                               userInfo:nil];
  [self addTrackingArea:m_trackingArea];
}

- (void)mouseEntered:(NSEvent*)nsEvent
{
  CWinSystemOSX* winSystem = dynamic_cast<CWinSystemOSX*>(CServiceBroker::GetWinSystem());
  if (winSystem)
    winSystem->signalMouseEntered();
}

#pragma mark - Input Events

- (void)mouseMoved:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)mouseDown:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)mouseDragged:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)mouseUp:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)rightMouseDown:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)rightMouseDragged:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)rightMouseUp:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)otherMouseUp:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)otherMouseDown:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)scrollWheel:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)otherMouseDragged:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)keyDown:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)keyUp:(NSEvent*)nsEvent
{
  [self SendInputEvent:nsEvent];
}

- (void)mouseExited:(NSEvent*)nsEvent
{
  CWinSystemOSX* winSystem = dynamic_cast<CWinSystemOSX*>(CServiceBroker::GetWinSystem());
  if (winSystem)
    winSystem->signalMouseExited();
}

- (NSOpenGLContext*)getGLContext
{
  return m_glcontext;
}
@end
