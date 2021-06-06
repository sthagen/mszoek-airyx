/*
 * Airyx QtKit: a simple Cocoa binding to Qt5
 *
 * Copyright (C) 2021 Zoe Knox <zoe@pixin.net>
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

#import "QKView.h"
#import <QWidget>
#import <QPushButton>
#import <AppKit/NSDisplay.h>

extern "C" {
    #include <X11/Xlib.h>
}

@implementation QKView

- initWithFrame:(NSRect)frame {
    [super initWithFrame:frame];
    w = new QWidget();
    ((QWidget *)w)->setFixedSize(frame.size.width - frame.origin.x, frame.size.height - frame.origin.y);
    ((QWidget *)w)->show();
    return self;
}

/* called by [NSWindow setContentView] */
- (void) setFrame:(NSRect)frame {
    [super setFrame:frame];
    ((QWidget *)w)->setFixedSize(frame.size.width - frame.origin.x, frame.size.height - frame.origin.y);
}

/* called by [NSWindow setContentView] via [NSView insertSubview] */
- (void) _setWindow:(NSWindow *)window {
    int child = ((QWidget *)w)->winId();
    XReparentWindow((Display *)[[NSDisplay currentDisplay] getDisplay], child, (Window)[[window platformWindow] windowHandle], _frame.origin.x, _frame.origin.y);
    [super _setWindow:window];
}

- (void) button {
    QPushButton *button = new QPushButton("Hello!", (QWidget *)w);
    button->setGeometry(10,10,80,30);
    button->show();

}

- (void) mouseDown:(NSEvent *)event {
    NSLog(@"mouse down %@", event);
}

- (void) mouseUp:(NSEvent *)event {
    NSLog(@"mouse up %@", event);
}

- (void) rightMouseDown:(NSEvent *)event {
    NSLog(@"right mouse down %@", event);
}

- (void) rightMouseUp:(NSEvent *)event {
    NSLog(@"right mouse up %@", event);
}

- (void) mouseMoved:(NSEvent *)event {
    NSLog(@"mouse moved %@", event);
}

- (void) mouseDragged:(NSEvent *)event {
    NSLog(@"mouse dragged %@",event);
}

- (void) rightMouseDragged:(NSEvent *)event {
    NSLog(@"right mouse dragged %@",event);
}

- (void) mouseEntered:(NSEvent *)event {
    NSLog(@"mouse entered %@",event);
}

- (void) mouseExited:(NSEvent *)event {
    NSLog(@"mouse exited %@",event);
}

@end