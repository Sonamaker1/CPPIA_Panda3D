#define NOMINMAX
#include <windows.h>
#include <cstdio>
#include "pandaFramework.h"
#include "pandaSystem.h"

#include "directfunctions.h"
#include "direct_api_impl.h"
#include "haxe_bridge_exports.h"

static void die(const char* msg) {
  std::fprintf(stderr, "Fatal: %s\n", msg);
  std::exit(1);
}

int main(int argc, char** argv) {
  // --- Panda3D boot (minimal skeleton; adapt to your real setup) ---
  PandaFramework framework;
  framework.open_framework(argc, argv);
  framework.set_window_title("Panda3D + Haxe Cppia");
  WindowFramework* win = framework.open_window();
  if (!win) die("Failed to open Panda3D window.");

  Direct direct{};
  initDirect(&direct, win);

  // --- Build the POD API table we hand to the Haxe DLL ---
  DirectApi api = make_direct_api(&direct);

  // --- Load embedded Haxe bridge DLL ---
  HMODULE dll = LoadLibraryA("haxe_bridge.dll");
  if (!dll) die("LoadLibraryA('haxe_bridge.dll') failed (is it next to the exe?)");

  auto p_boot = (decltype(&haxe_bridge_boot))GetProcAddress(dll, "haxe_bridge_boot");
  auto p_run  = (decltype(&haxe_bridge_run_cppia))GetProcAddress(dll, "haxe_bridge_run_cppia");
  auto p_tick = (decltype(&haxe_bridge_tick))GetProcAddress(dll, "haxe_bridge_tick");

  if (!p_boot || !p_run || !p_tick) die("Missing expected exports from haxe_bridge.dll");

  if (p_boot(&api) != 0) die("haxe_bridge_boot failed");

  // Script entrypoint (hardcode like you wanted)
  const char* entryCppia = "open_panda_window.cppia";
  if (p_run(entryCppia) != 0) die("haxe_bridge_run_cppia failed");

  // --- Main loop ---
  double last = 0.0;
  Thread *current_thread = Thread::get_current_thread();
  while (framework.do_frame(current_thread)) {
    // You’ll probably want a real dt; this is placeholder
    float dt = 1.0f / 60.0f;
    p_tick(dt);
  }

  framework.close_framework();
  return 0;
}
