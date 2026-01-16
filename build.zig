const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const panda_root =
        b.option([]const u8, "panda_root", "Path to Panda3D SDK root")
        orelse "C:\\Panda3D-1.11.0-x64";

    const panda_static =
        b.option(bool, "panda_static", "Link Panda3D statically (adds LINK_ALL_STATIC)")
        orelse false;

    // --- Windows + MSVC toolchain paths (override with -D...) ---
    const win_kits_root =
        b.option([]const u8, "win_kits_root", "Windows Kits root")
        orelse "C:\\Program Files (x86)\\Windows Kits\\10";

    const win_sdk_ver =
        b.option([]const u8, "win_sdk_ver", "Windows SDK version folder (eg 10.0.26100.0)")
        orelse "10.0.26100.0";

    const msvc_root =
        b.option([]const u8, "msvc_root", "MSVC toolchain root (…\\VC\\Tools\\MSVC\\<ver>)")
        orelse "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\VC\\Tools\\MSVC\\14.44.35207";

    const exe = b.addExecutable(.{
        .name = "my_program",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = false,
            .link_libc = false,
        }),
    });

    exe.subsystem = .Console;
    exe.entry = .{ .symbol_name = "mainCRTStartup" };

    // --- Compute include/lib directories ---
    const sdk_inc_base = b.pathJoin(&.{ win_kits_root, "Include", win_sdk_ver });
    const sdk_um_inc = b.pathJoin(&.{ sdk_inc_base, "um" });
    const sdk_shared_inc = b.pathJoin(&.{ sdk_inc_base, "shared" });
    const sdk_ucrt_inc = b.pathJoin(&.{ sdk_inc_base, "ucrt" });
    const sdk_winrt_inc = b.pathJoin(&.{ sdk_inc_base, "winrt" });

    const sdk_lib_base = b.pathJoin(&.{ win_kits_root, "Lib", win_sdk_ver });
    const sdk_um_lib_x64 = b.pathJoin(&.{ sdk_lib_base, "um", "x64" });
    const sdk_ucrt_lib_x64 = b.pathJoin(&.{ sdk_lib_base, "ucrt", "x64" });

    const msvc_inc = b.pathJoin(&.{ msvc_root, "include" });
    const msvc_lib_x64 = b.pathJoin(&.{ msvc_root, "lib", "x64" });

    // --- Common C++ flags for all translation units ---
    const cxx_flags = &.{
        "-std=c++20",

        // Take control of C++ standard library headers:
        //"-nostdinc++",
        "-isystem", msvc_inc,

        // Windows SDK headers (for Windows.h, etc.)
        "-isystem", sdk_um_inc,
        "-isystem", sdk_shared_inc,
        "-isystem", sdk_ucrt_inc,
        "-isystem", sdk_winrt_inc,
    };

    // --- C++ sources ---
    exe.root_module.addCSourceFile(.{
        .file = b.path("src/my_program.cpp"),
        .flags = cxx_flags,
    });
    exe.root_module.addCSourceFile(.{
        .file = b.path("src/directfunctions.cpp"),
        .flags = cxx_flags,
    });
    exe.root_module.addCSourceFile(.{
        .file = b.path("src/direct_api_impl.cpp"),
        .flags = cxx_flags,
    });

    // --- Library search paths (so lld-link can find .lib files) ---
    exe.root_module.addLibraryPath(.{ .cwd_relative = msvc_lib_x64 });
    exe.root_module.addLibraryPath(.{ .cwd_relative = sdk_um_lib_x64 });
    exe.root_module.addLibraryPath(.{ .cwd_relative = sdk_ucrt_lib_x64 });

    // --- Project includes ---
    exe.root_module.addIncludePath(.{ .cwd_relative = "include" });

    // --- Panda include/lib paths ---
    exe.root_module.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ panda_root, "include" }) });
    exe.root_module.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ panda_root, "lib" }) });

    // Optional python folders (keep if your SDK has them)
    exe.root_module.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ panda_root, "python", "include" }) });
    exe.root_module.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ panda_root, "python", "libs" }) });

    if (panda_static) {
        exe.root_module.addCMacro("LINK_ALL_STATIC", "1");
    }
    const mode: std.builtin.LinkMode = if (panda_static) .static else .dynamic;

    // --- Panda3D libs ---
    exe.root_module.linkSystemLibrary("libp3framework", .{ .preferred_link_mode = mode });
    exe.root_module.linkSystemLibrary("libpanda", .{ .preferred_link_mode = mode });
    exe.root_module.linkSystemLibrary("libpandaexpress", .{ .preferred_link_mode = mode });
    exe.root_module.linkSystemLibrary("libp3dtool", .{ .preferred_link_mode = mode });
    exe.root_module.linkSystemLibrary("libp3dtoolconfig", .{ .preferred_link_mode = mode });
    exe.root_module.linkSystemLibrary("libp3direct", .{ .preferred_link_mode = mode });

    // --- MSVC CRT / runtime libs (as needed) ---
    exe.root_module.linkSystemLibrary("vcruntime", .{});
    exe.root_module.linkSystemLibrary("ucrt", .{});
    exe.root_module.linkSystemLibrary("msvcrt", .{});
    exe.root_module.linkSystemLibrary("msvcprt", .{});
    exe.root_module.linkSystemLibrary("legacy_stdio_definitions", .{});

    // --- Core Win32 libs ---
    exe.root_module.linkSystemLibrary("kernel32", .{});
    exe.root_module.linkSystemLibrary("ntdll", .{});
    exe.root_module.linkSystemLibrary("advapi32", .{});
    exe.root_module.linkSystemLibrary("user32", .{});

    b.installArtifact(exe);

    // --- Copy outputs into zig-out/bin (adjust paths if hxcpp outputs differ) ---
    const copy_dll = b.addInstallFile(
        .{ .cwd_relative = "build/haxe-host/HaxeBridge.dll" },
        "bin/haxe_bridge.dll",
    );
    const copy_cppia = b.addInstallFile(
        .{ .cwd_relative = "build/scripts/open_panda_window.cppia" },
        "bin/open_panda_window.cppia",
    );
    b.getInstallStep().dependOn(&copy_dll.step);
    b.getInstallStep().dependOn(&copy_cppia.step);
}
