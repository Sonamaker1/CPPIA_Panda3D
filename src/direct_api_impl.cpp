#include "direct_api_impl.h"
#include <cstdio>

static void DIRECT_API_CALL api_log(DirectUserData user, const char* msg) {
    (void)user;
    std::printf("[Haxe] %s\n", msg ? msg : "(null)");
}

static void DIRECT_API_CALL api_set_bg(DirectUserData user, float r, float g, float b, float a) {
    auto* d = reinterpret_cast<Direct*>(user);
    if (!d || !d->setBackgroundColor) return;
    d->setBackgroundColor(d, LColor(r, g, b, a));
}

static void DIRECT_API_CALL api_print(DirectUserData user, const char* msg) {
    auto* d = reinterpret_cast<Direct*>(user);
    if (!d || !d->printLog) return;
    d->printLog(d, msg);
}

static void DIRECT_API_CALL api_tick(DirectUserData user, float dt) {
    (void)user;
    (void)dt;
    // Optional: drive engine tasks, etc.
}

DirectApi make_direct_api(Direct* direct) {
    DirectApi api{};
    api.user = direct;
    api.log = api_log;
    api.setBackgroundColorRGBA = api_set_bg;
    api.tick = api_tick;
    return api;
}
