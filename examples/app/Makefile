# This Makefile will generate a simple Cocoa App bundle called CocoaDemo.app
# in the current directory or in the location specified by MAKEOBJDIR
#
# APP is the name of the executable resulting from compiling SRCS
# and also the name of the bundle. RESOURCES will be copied into
# the bundle's Resources folder preserving all hierarchy.
#
# The app will be built against the headers and libraries in any
# specified FRAMEWORKS.
# 
# CFLAGS and LDFLAGS can be specified to use additional headers and
# libraries. 
#
# CocoaDemo.app
# `-- Contents
#     |-- Airyx
#     |   `-- CocoaDemo
#     |-- Info.plist
#     |-- PkgInfo
#     `-- Resources
#         |-- CocoaDemo.png
#         |-- Cloudy_Mountains.jpg
#         `-- rsc
#             `-- sample.txt

APP=CocoaDemo
SRCS=main.mm MyView.m
MK_DEBUG_FILES=no
RESOURCES=rsc Cloudy_Mountains.jpg CocoaDemo.png
SLF=/System/Library/Frameworks
FRAMEWORKS=${SLF}/AppKit ${SLF}/CoreGraphics ${SLF}/Onyx2D ${SLF}/OpenGL \
	${SLF}/Foundation ${SLF}/CoreFoundation ${SLF}/DBusKit
CFLAGS+= -g -fPIC
CXXFLAGS= -g -I/usr/local/include/qt5 -fPIC
LDFLAGS+=-L/usr/local/lib -lGL -L/usr/local/lib/qt5 -lQt5Widgets -lQt5Core

build: all

.include <he.app.mk>
