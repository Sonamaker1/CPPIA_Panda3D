# CPPIA Panda3D

This intended to grow into a full rewrite of the Panda3D python-bridge using Haxe and a dll for CPPIA. It's a bit rough around the edges for now. I was able to open a window and recolor it with haxe code though, which is great! Support for multiple haxe source files seems to work as well.

# How to Add a New Function to the Cppia Bridge

This guide explains how to expose a new C++ function to the Cppia scripting layer. The system uses a bridge architecture to pass calls from the interpreted Cppia script (`api`) to the compiled Haxe host (`host`), which then calls into Native C++.

We will use the **logging function** as a concrete example of this complete flow.

## Architecture Overview

1.  **Native C++** (`haxe/host/cpp/api_shim.cpp`):
    Exports C-compatible functions using `dllexport`.
2.  **Haxe Host** (`haxe/host/src/DirectApiExtern.hx`):
    Declares the C functions as Haxe `extern`s allowing the Host DLL to call them.
3.  **Haxe Host Bridge** (`haxe/host/src/Bridge.hx`):
    Implementing the public API that calls the externs.
4.  **Haxe Script API** (`haxe/api/src/Bridge.hx`):
    Defines the interface visible to the Cppia script.

---

## Step-by-Step Guide

### 1. Native C++ Layer
**File:** `haxe/host/cpp/api_shim.cpp`

You must define and export the function so it can be dynamically linked or found by the Haxe C++ backend. Use `HAXE_NATIVE_EXPORT` and `HAXE_NATIVE_CALL` macros ensuring cross-platform compatibility and correct calling conventions.

```cpp
// 1. Define the function with C linkage and export it
HAXE_NATIVE_EXPORT void HAXE_NATIVE_CALL direct_api_log_global_hx(::String msg) {
  // 2. Safety check the global API pointer
  if (!g_api || !g_api->log) return;
  
  // 3. Convert Haxe string to UTF8 and call the engine
  g_api->log(g_api->user, msg.utf8_str());
}
```

*Note: If your function takes simple types like `float`, you can use them directly. For `String`, `::String` is the Haxe C++ string type.*

### 2. Haxe Host Externs
**File:** `haxe/host/src/DirectApiExtern.hx`

Map the exported C++ function to a Haxe static function. This tells the Haxe compiler that this function exists in the native context.

```haxe
extern class DirectApiShim {
    // ... existing functions ...

    // The @:native string MUST match the C++ exported name exactly
    @:native("direct_api_log_global_hx")
    static function log(msg:String):Void;
}
```

### 3. Haxe Host Bridge Implementation
**File:** `haxe/host/src/Bridge.hx`

This is the compiled code that lives in the Host DLL. It acts as the "server" that the script calls into. You must define the static wrapper function here.

**Crucial:** You must use `@:keep` to prevent DCE (Dead Code Elimination) from removing this function, as it is only called via reflection/linking from the script side.

```haxe
class Bridge {
    // ...
    
    @:keep
    public static function log(msg:String):Int {
        // Forward the call to the Shim
        DirectApiShim.log("Log: " + msg);
        return 0;
    }
}
```

### 4. Haxe Script API Definition
**File:** `haxe/api/src/Bridge.hx`

This file is used when compiling the *script*. It tells the script what functions are available on the Host key. It must match the signature in Step 3 exactly.

```haxe
// Extern-only: provides typing for the script
extern class Bridge {
  // ...
  public static function log(msg:String):Int;
}
```

---

## Build Steps

Once you have added the code in all 4 locations, rebuild the layers in order:

1.  **Build Host DLL**:
    ```bat
    makehost.bat
    ```
    *Compiles `haxe/host/src` + C++ shims into a DLL.*

2.  **Build Script**:
    ```bat
    makescript.bat
    ```
    *Compiles your Cppia scripts against `haxe/api/src`.*

3.  **Build Binary**:
    ```bat
    build.bat
    ```
    *Links everything into the final executable.*
