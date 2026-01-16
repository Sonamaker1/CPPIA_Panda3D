#pragma once
#include "direct_api.h"

#ifdef _WIN32
  #define HAXE_BRIDGE_EXPORT __declspec(dllexport)
  #define HAXE_BRIDGE_CALL __cdecl
#else
  #define HAXE_BRIDGE_EXPORT
  #define HAXE_BRIDGE_CALL
#endif

extern "C" {

// Boots hxcpp + stores the DirectApi pointer in the DLL.
// Returns 0 on success.
HAXE_BRIDGE_EXPORT int HAXE_BRIDGE_CALL haxe_bridge_boot(DirectApi* api);

// Runs a .cppia script file (entrypoint is its static main()).
// Returns 0 on success.
HAXE_BRIDGE_EXPORT int HAXE_BRIDGE_CALL haxe_bridge_run_cppia(const char* cppia_path);

// Optional: call from your main loop (script can register callbacks, etc.)
HAXE_BRIDGE_EXPORT void HAXE_BRIDGE_CALL haxe_bridge_tick(float dt);

// Optional: shutdown (safe to no-op)
HAXE_BRIDGE_EXPORT void HAXE_BRIDGE_CALL haxe_bridge_shutdown();

} // extern "C"
