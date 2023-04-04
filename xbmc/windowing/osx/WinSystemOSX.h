/*
 *  Copyright (C) 2005-2018 Team Kodi
 *  This file is part of Kodi - https://kodi.tv
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 *  See LICENSES/README.md for more information.
 */

#pragma once

#include "threads/CriticalSection.h"
#include "threads/SystemClock.h"
#include "threads/Timer.h"
#include "windowing/WinSystem.h"

#include <memory>
#include <string>
#include <vector>

typedef struct _CGLContextObject* CGLContextObj;
typedef struct CGRect NSRect;

class IDispResource;
class CWinEventsOSX;
#ifdef __OBJC__
@class NSWindow;
@class OSXGLView;
@class NSEvent;
#else
struct NSWindow;
struct OSXGLView;
struct NSEvent;
#endif

class CWinSystemOSX : public CWinSystemBase, public ITimerCallback
{
public:
  CWinSystemOSX();
  ~CWinSystemOSX() override;

  // ITimerCallback interface
  void OnTimeout() override;

  // CWinSystemBase
  bool InitWindowSystem() override;
  bool DestroyWindowSystem() override;
  bool CreateNewWindow(const std::string& name, bool fullScreen, RESOLUTION_INFO& res) override;
  bool DestroyWindow() override;
  bool ResizeWindow(int newWidth, int newHeight, int newLeft, int newTop) override;
  bool SetFullScreen(bool fullScreen, RESOLUTION_INFO& res, bool blankOtherDisplays) override;
  void UpdateResolutions() override;
  bool Minimize() override;
  bool Restore() override;
  bool Hide() override;
  bool HasCursor() override;
  bool Show(bool raise = true) override;
  void OnMove(int x, int y) override;

  std::string GetClipboardText() override;

  /*! \brief Check if the windowing system supports moving windows across screens
   *  \return true if the windowing system supports moving windows across screens, false otherwise
  */
  bool SupportsScreenMove() override;

  /**
   * \brief Used to signal the windowing system about the intention of the user to change the main display
   * \details triggered, for example, when the user manually changes the monitor setting
  */
  void NotifyScreenChangeIntention() override;

  void Register(IDispResource* resource) override;
  void Unregister(IDispResource* resource) override;

  void ToggleFloatOnTop() override;

  std::unique_ptr<CVideoSync> GetVideoSync(void* clock) override;

  void WindowChangedScreen();

  void AnnounceOnLostDevice();
  void AnnounceOnResetDevice();
  void HandleOnResetDevice();
  void StartLostDeviceTimer();
  void StopLostDeviceTimer();

  int CheckDisplayChanging(uint32_t flags);
  void SetFullscreenWillToggle(bool toggle) { m_fullscreenWillToggle = toggle; }
  bool GetFullscreenWillToggle() { return m_fullscreenWillToggle; }

  CGLContextObj GetCGLContextObj();

  std::vector<std::string> GetConnectedOutputs() override;

  // winevents override
  bool MessagePump() override;

  NSRect GetWindowDimensions();
  void enableInputEvents();
  void disableInputEvents();

  void signalMouseEntered();
  void signalMouseExited();
  void SendInputEvent(NSEvent* nsEvent);

protected:
  std::unique_ptr<KODI::WINDOWING::IOSScreenSaver> GetOSScreenSaverImpl() override;

  void GetScreenResolution(size_t* w, size_t* h, double* fps, unsigned long screenIdx);
  void EnableVSync(bool enable);
  bool SwitchToVideoMode(int width, int height, double refreshrate);
  void FillInVideoModes();
  bool FlushBuffer();

  bool DestroyWindowInternal();

  std::unique_ptr<CWinEventsOSX> m_winEvents;

  std::string m_name;
  NSWindow* m_appWindow;
  OSXGLView* m_glView;
  unsigned long m_lastDisplayNr;
  double m_refreshRate;

  CCriticalSection m_resourceSection;
  std::vector<IDispResource*> m_resources;
  CTimer m_lostDeviceTimer;
  bool m_delayDispReset;
  XbmcThreads::EndTime<> m_dispResetTimer;
  bool m_fullscreenWillToggle;
  bool m_hasCursor{false};
  CCriticalSection m_critSection;
};
