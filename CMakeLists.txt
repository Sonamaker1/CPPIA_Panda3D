cmake_minimum_required(VERSION 3.20)
project(CPPIA_Toontown LANGUAGES CXX)

# ----------------------------
# Options (match your build.zig knobs)
# ----------------------------
set(PANDA_ROOT "C:/Panda3D-1.11.0-x64" CACHE PATH "Path to Panda3D SDK root")
option(PANDA_STATIC "Link Panda3D statically (adds LINK_ALL_STATIC)" OFF)

set(WIN_KITS_ROOT "C:/Program Files (x86)/Windows Kits/10" CACHE PATH "Windows Kits root")
set(WIN_SDK_VER "10.0.26100.0" CACHE STRING "Windows SDK version folder (e.g. 10.0.26100.0)")
set(MSVC_ROOT "C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.44.35207"
    CACHE PATH "MSVC toolchain root (.../VC/Tools/MSVC/<ver>)")

# ----------------------------
# Compute Windows SDK / MSVC include + lib dirs
# ----------------------------
set(SDK_INC_BASE "${WIN_KITS_ROOT}/Include/${WIN_SDK_VER}")
set(SDK_UM_INC "${SDK_INC_BASE}/um")
set(SDK_SHARED_INC "${SDK_INC_BASE}/shared")
set(SDK_UCRT_INC "${SDK_INC_BASE}/ucrt")
set(SDK_WINRT_INC "${SDK_INC_BASE}/winrt")

set(SDK_LIB_BASE "${WIN_KITS_ROOT}/Lib/${WIN_SDK_VER}")
set(SDK_UM_LIB_X64 "${SDK_LIB_BASE}/um/x64")
set(SDK_UCRT_LIB_X64 "${SDK_LIB_BASE}/ucrt/x64")

set(MSVC_INC "${MSVC_ROOT}/include")
set(MSVC_LIB_X64 "${MSVC_ROOT}/lib/x64")

# ----------------------------
# Target
# ----------------------------
add_executable(my_program
    src/my_program.cpp
    src/directfunctions.cpp
    src/direct_api_impl.cpp
)

# Console subsystem / entry point are Zig-specific; CMake/MSVC handles this normally.
# If you ever need the exact same entry point, you'd use target_link_options, but for IDE parsing it's unnecessary.

# ----------------------------
# Language standard
# ----------------------------
set_target_properties(my_program PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

# ----------------------------
# Include paths (for IntelliSense/code model)
# ----------------------------
target_include_directories(my_program PRIVATE
    "${CMAKE_SOURCE_DIR}/include"
    "${CMAKE_SOURCE_DIR}/src"

    # Panda3D
    "${PANDA_ROOT}/include"
    "${PANDA_ROOT}/python/include"

    # MSVC + Windows SDK (for clangd/MSVC code model)
    "${MSVC_INC}"
    "${SDK_UM_INC}"
    "${SDK_SHARED_INC}"
    "${SDK_UCRT_INC}"
    "${SDK_WINRT_INC}"

    # Optional: so QtCreator finds hxcpp headers if you open those files
    # "C:/HaxeToolkit/haxe/lib/hxcpp/git/include"
)

# ----------------------------
# Defines
# ----------------------------
if(PANDA_STATIC)
    target_compile_definitions(my_program PRIVATE LINK_ALL_STATIC=1)
endif()

# Keep this if you want parity with your hxcpp bridge build flags; harmless for parsing.
target_compile_definitions(my_program PRIVATE
    _CRT_SECURE_NO_DEPRECATE
    _ALLOW_MSC_VER_MISMATCH
    _ALLOW_ITERATOR_DEBUG_LEVEL_MISMATCH
)

add_library(haxe_bridge_sources OBJECT
    haxe/host/cpp/api_shim.cpp
    haxe/host/cpp/bridge_exports.cpp
)

target_include_directories(haxe_bridge_sources PRIVATE
    "${CMAKE_SOURCE_DIR}/include"
    "${CMAKE_SOURCE_DIR}/haxe/host/cpp"
    # hxcpp headers:
    "C:/HaxeToolkit/haxe/lib/hxcpp/git/include"
    "${MSVC_INC}"
    "${SDK_UM_INC}"
    "${SDK_SHARED_INC}"
    "${SDK_UCRT_INC}"
    "${SDK_WINRT_INC}"
)

# ----------------------------
# Link dirs + libs (mostly for completeness; not required for parsing)
# ----------------------------
target_link_directories(my_program PRIVATE
    "${MSVC_LIB_X64}"
    "${SDK_UM_LIB_X64}"
    "${SDK_UCRT_LIB_X64}"

    "${PANDA_ROOT}/lib"
    "${PANDA_ROOT}/python/libs"
)

# Panda3D libs
target_link_libraries(my_program PRIVATE
    libp3framework
    libpanda
    libpandaexpress
    libp3dtool
    libp3dtoolconfig
    libp3direct

    # MSVC CRT / runtime libs (as needed)
    vcruntime
    ucrt
    msvcrt
    msvcprt
    legacy_stdio_definitions

    # Core Win32 libs
    kernel32
    ntdll
    advapi32
    user32
)

# If you ever hit missing symbols while actually building with CMake:
# target_link_libraries(my_program PRIVATE gdi32 ole32 shell32 winmm ws2_32)
