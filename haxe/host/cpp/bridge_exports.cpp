#include <hxcpp.h>
#include "direct_api.h"
#include "haxe_bridge_exports.h"
#include <Bridge.h>

extern void __boot_all();

#ifdef _WIN32
  #define HAXE_NATIVE_CALL __cdecl
#else
  #define HAXE_NATIVE_CALL
#endif

// Import the exported symbol from api_shim.cpp with the same calling convention.
extern "C" void HAXE_NATIVE_CALL direct_api_set_global(DirectApi* api);

// Small RAII helper: attach the current (foreign) thread to hxcpp
struct HxcppAutoAttach {
  int top;
  HxcppAutoAttach() {
    // Attach current thread to hxcpp runtime / GC
    hx::SetTopOfStack(&top, true);
  }
  ~HxcppAutoAttach() {
    hx::SetTopOfStack(nullptr, true);
  }
};

static bool g_hx_inited = false;

extern "C" {

HAXE_BRIDGE_EXPORT int HAXE_BRIDGE_CALL haxe_bridge_boot(DirectApi* api) {
  HxcppAutoAttach attach;

  // Store API globally inside this DLL (CPPIA-friendly)
  direct_api_set_global(api);

  if (!g_hx_inited) {
    hx::Boot();
    __boot_all();
    g_hx_inited = true;
  }

  Bridge_obj::boot();
  return 0;
}

HAXE_BRIDGE_EXPORT int HAXE_BRIDGE_CALL haxe_bridge_run_cppia(const char* cppia_path) {
  HxcppAutoAttach attach;

  if (!cppia_path) return 1;
  Bridge_obj::runCppiaFile(::String(cppia_path));
  return 0;
}

HAXE_BRIDGE_EXPORT void HAXE_BRIDGE_CALL haxe_bridge_tick(float dt) {
  HxcppAutoAttach attach;
  Bridge_obj::tick(dt);
}

HAXE_BRIDGE_EXPORT void HAXE_BRIDGE_CALL haxe_bridge_shutdown() {
  HxcppAutoAttach attach;
  // optional: you can leave it empty
}

} // extern "C"
