include(${CMAKE_SOURCE_DIR}/cmake/platform/${CORE_SYSTEM_NAME}/wayland.cmake)

# add wayland as platform, as we require it.
# saves reworking other assumptions for linux windowing as the platform name.
list(APPEND CORE_PLATFORM_NAME_LC wayland)

list(APPEND PLATFORM_REQUIRED_DEPS WaylandProtocolsWebOS PlayerAPIs)
list(APPEND PLATFORM_GLOBAL_TARGET_DEPS generate-wayland-webos-protocols)
list(APPEND ARCH_DEFINES -DTARGET_WEBOS)
set(TARGET_WEBOS TRUE)
set(PREFER_TOOLCHAIN_PATH ${TOOLCHAIN}/${HOST}/sysroot)
