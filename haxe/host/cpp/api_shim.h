#pragma once
#include "direct_api.h"

#ifdef __cplusplus
extern "C" {
#endif

// Forward declarations for the shim functions


// Called by bridge_exports.cpp during boot
#include <hxcpp.h>
#include "direct_api.h"

static DirectApi* g_api = nullptr;

extern "C" {

void direct_api_set_global(DirectApi* api);
void direct_api_log_global(const char* msg);
void direct_api_log_global_hx(::String msg);
void direct_api_set_bg_global(float r, float g, float b, float a);
void direct_api_tick_global(float dt);

} // extern "C"

#ifdef __cplusplus
}
#endif
