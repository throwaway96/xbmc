/*
*  Copyright (C) 2023 Team Kodi
*  This file is part of Kodi - https://kodi.tv
*
*  SPDX-License-Identifier: GPL-2.0-or-later
*  See LICENSES/README.md for more information.
*/

#pragma once

#include "WinSystemWayland.h"
#include "Registry.h"

#include <wayland-webos-protocols.hpp>

namespace KODI::WINDOWING::WAYLAND
{

class CWinSystemWaylandWebOS : public CWinSystemWayland
{

public:
  bool InitWindowSystem() override;

  /**
   * Gets the exported window name. May return an empty string on non wayland-webos-foreign devices (pre webOS 5)
   * @return Exported window name
   */
  std::string GetExportedWindowName();

  /**
   * Sets up the an exported window for display. The display engine will merge the exported window with the UI layer.
   * Therefore any UI element must be transparent for the exported window to punch through. Not available on non
   * wayland-webos-foreign devices (pre webOS 5)
   * @param src Original source window rect (video size)
   * @param src Source window rect crop window
   * @param dst Destination rect
   * @return True on success, else false
   */
  bool SetExportedWindow(CRect orig, CRect src, CRect dest);

  IShellSurface* CreateShellSurface(const std::string& name) override;
  bool CreateNewWindow(const std::string& name, bool fullScreen, RESOLUTION_INFO& res) override;
  ~CWinSystemWaylandWebOS() noexcept override;
  bool HasCursor() override;

private:
  std::unique_ptr<CRegistry> m_registry;

  // WebOS foreign surface
  std::string m_exported_window_name;
  wayland::webos_exported_t m_exported_surface;
  wayland::webos_foreign_t m_webos_foreign;
};

}
