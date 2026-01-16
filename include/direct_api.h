#pragma once

#ifdef _WIN32
  #define DIRECT_API_CALL __cdecl
#else
  #define DIRECT_API_CALL
#endif

// Opaque engine context pointer (you'll pass &Direct or whatever you want)
typedef void* DirectUserData;

// POD-only API function table (safe across DLL boundary)
typedef struct DirectApi {
  DirectUserData user;

  // Logging/debug
  void (DIRECT_API_CALL *log)(DirectUserData user, const char* msg);

  // Example engine calls (POD args only)
  void (DIRECT_API_CALL *setBackgroundColorRGBA)(DirectUserData user, float r, float g, float b, float a);

  // Optional: time-step hook, input, etc
  void (DIRECT_API_CALL *tick)(DirectUserData user, float dt);

  void (DIRECT_API_CALL *print)(DirectUserData user, const char* msg);

} DirectApi;
