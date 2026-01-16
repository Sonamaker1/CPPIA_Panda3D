# Created by and for Qt Creator This file was created for editing the project sources only.
# You may attempt to use it for building too, by modifying this file here.

#TARGET = CPPIA_Toontown_Qt

QT = core gui widgets

HEADERS = \
   $$PWD/haxe/host/cpp/api_shim.h \
   $$PWD/include/direct_api.h \
   $$PWD/include/haxe_bridge_exports.h \
   $$PWD/src/direct_api_impl.h \
   $$PWD/src/directfunctions.h

SOURCES = \
   $$PWD/build/scripts/open_panda_window.cppia \
   $$PWD/haxe/api/src/Bridge.hx \
   $$PWD/haxe/api/src/DirectApiExtern.hx \
   $$PWD/haxe/host/cpp/api_shim.cpp \
   $$PWD/haxe/host/cpp/bridge_exports.cpp \
   $$PWD/haxe/host/src/Bridge.hx \
   $$PWD/haxe/host/src/DirectApiExtern.hx \
   $$PWD/haxe/host/src/HaxeBridge.hx \
   $$PWD/haxe/scripts/src/OpenPandaWindow.hx \
   $$PWD/src/direct_api_impl.cpp \
   $$PWD/src/directfunctions.cpp \
   $$PWD/src/my_program.cpp

INCLUDEPATH = \
    $$PWD/haxe/host/cpp \
    $$PWD/include \
    $$PWD/src

#DEFINES = 

