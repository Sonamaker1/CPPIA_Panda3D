REM ~ call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=x64
set zig=D:\Dev_Toontown\compile\zig-x86_64-windows\zig.exe

%zig% build -Dtarget=x86_64-windows-msvc ^
  -Dpanda_root="C:\Panda3D-1.11.0-x64" ^
  -Dpanda_static=false ^
  -Doptimize=ReleaseSafe ^
  -Dmsvc_root="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207" ^
  -Dwin_kits_root="C:\Program Files (x86)\Windows Kits\10" ^
  -Dwin_sdk_ver=10.0.26100.0 ^
  --cache-dir "D:\Dev_Haxe\CPPIA_Toontown\cache"
