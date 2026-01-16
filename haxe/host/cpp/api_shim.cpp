#include <hxcpp.h>
#include "direct_api.h"

static DirectApi* g_api = nullptr;

#ifdef _WIN32
  #define HAXE_NATIVE_EXPORT extern "C" __declspec(dllexport)
  #define HAXE_NATIVE_CALL __cdecl
#else
  #define HAXE_NATIVE_EXPORT extern "C"
  #define HAXE_NATIVE_CALL
#endif

// NOTE:
// These symbols MUST be exported for CPPIA "linking" to succeed.
// Your .cppia clearly references:
//   - direct_api_log_global
//   - direct_api_tick_global
//   - direct_api_set_bg_global
// So we export them explicitly.

HAXE_NATIVE_EXPORT void HAXE_NATIVE_CALL direct_api_set_global(DirectApi* api) {
  g_api = api;
}

HAXE_NATIVE_EXPORT void HAXE_NATIVE_CALL direct_api_log_global(const char* msg) {
  if (!g_api || !g_api->log) return;
  g_api->log(g_api->user, msg ? msg : "(null)");
}

// Safe for Haxe String (Bridge uses this)
HAXE_NATIVE_EXPORT void HAXE_NATIVE_CALL direct_api_log_global_hx(::String msg) {
  if (!g_api || !g_api->log) return;
  g_api->log(g_api->user, msg.utf8_str());
}

HAXE_NATIVE_EXPORT void HAXE_NATIVE_CALL direct_api_set_bg_global(float r, float g, float b, float a) {
  if (!g_api || !g_api->setBackgroundColorRGBA) return;
  g_api->setBackgroundColorRGBA(g_api->user, r, g, b, a);
}

HAXE_NATIVE_EXPORT void HAXE_NATIVE_CALL direct_api_tick_global(float dt) {
  if (!g_api || !g_api->tick) return;
  g_api->tick(g_api->user, dt);
}
