/*
 * Copyright (C) 2022-2024 Zoe Knox <zoe@pixin.net>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#define WINDOWSERVER

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AppKit/NSEvent.h>
#import <AppKit/NSImage.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/event.h>
#include <pthread.h>
#include <pwd.h>
#include <grp.h>
#include <login_cap.h>
#include <kvm.h>

#import "message.h"
#import "WSDisplay.h"
#import "BSDFramebuffer.h"
#import "WSInput.h"
#import "WSWindowRecord.h"
#import "WSAppRecord.h"

// These are defined in NSThemeFrame
extern const float WSWindowTitleHeight;
extern const float WSWindowEdgePad;
extern const float NSWindowControlSpacing;
extern const float NSWindowControlDiameter;

extern pthread_mutex_t renderLock;

@interface WindowServer : NSObject {
    BOOL ready;
    char **envp;
    unsigned int nobodyUID;
    unsigned int videoGID;
    unsigned int logLevel;
    enum ShellType curShell;
    BSDFramebuffer *fb;
    NSRect _geometry;
    CGFontRef _titleFont;

    WSInput *input;
    int cursorHideCount;

    NSMutableArray *displays;
    NSMutableDictionary *apps;          // key is CFBundleID
    NSMutableArray *_windows[kCGNumReservedWindowLevels];
    WSAppRecord *curApp;
    WSWindowRecord *curWindow;

    mach_port_name_t _servicePort;
    int _kq;
    kvm_t *kvm;
}

-init;
-(void)dealloc;
-(void)setLogLevel:(int)level;
-(void)setDebugLevel:(int)level subsystem:(char)sys;
-(BOOL)launchShell;
-(BOOL)isReady;
-(NSRect)geometry;
-(void)draw;
-(WSDisplay *)displayWithID:(uint32_t)ID;
-(O2BitmapContext *)context;
-(BOOL)setUpEnviron:(uid_t)uid;
-(void)freeEnviron;
-(void)dispatchEvent:(struct libinput_event *)event;
-(uint32_t)windowCreate:(struct wsRPCWindow*)data forApp:(WSAppRecord *)app;
-(void)run;
-(void)processKernelQueue;
-(void)receiveMachMessage;
-(BOOL)sendEventToApp:(struct mach_event *)event;
-(BOOL)sendInlineData:(void *)data length:(int)length withCode:(int)code toPort:(mach_port_t)port;
-(void)watchForProcessExit:(unsigned int)pid;
-(WSAppRecord *)findAppByPID:(unsigned int)pid;
-(void)signalQuit;
-(CGFontRef)titleFont;
-(NSSize)sizeOfTitleText:(NSString *)title;
-(void)addWindowByLevel:(WSWindowRecord *)window;
-(void)removeWindowByLevel:(WSWindowRecord *)window;
-(void)removeWindowFromAllLevels:(WSWindowRecord *)window;
-(void)setShell:(int)shell;
@end
