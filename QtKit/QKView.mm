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
#import <QWindow>
#import <QWidget>
#import <QPushButton>
#import <QApplication>
#import <QEventLoop>
#import <QMouseEvent>
#import <AppKit/NSDisplay.h>

extern "C" {
    #include <X11/Xlib.h>
}

@implementation QKView

- initWithFrame:(NSRect)frame {
    [super initWithFrame:frame];
    topWidget = new QWidget();
    ((QWidget *)topWidget)->resize(frame.size.width,frame.size.height);
    return self;
}

/* called by [NSWindow setContentView] via [NSView insertSubview] */
- (void) _setWindow:(NSWindow *)window {
    if(window != nil) {
        // Create a QWindow from the native window & reparent top-level widget to it
        qwindow = QWindow::fromWinId((Window)[[window platformWindow] windowHandle]);
        windowContainer = QWidget::createWindowContainer((QWindow *)qwindow);
        ((QWidget *)topWidget)->setParent((QWidget *)windowContainer);
        ((QWidget *)topWidget)->show(); // widget is hidden after setParent()
        ((QWidget *)windowContainer)->show();
        ((QWindow *)qwindow)->show();
        eventLoop = new QEventLoop((QWidget *)windowContainer);
        [self performSelectorInBackground:@selector(loop) withObject:nil];
    }
    [super _setWindow:window];
}

- (void) loop {
    ((QEventLoop *)eventLoop)->exec();
}

- (void) button {
    QPushButton *button = new QPushButton("Hello!", (QWidget *)topWidget);
    button->setGeometry(10,10,80,30);
    button->show();

}

- (void) mouseDown:(NSEvent *)event {
    // NSLog(@"mouse down %@", event);
    NSPoint p = [event locationInWindow];
    QMouseEvent *ev = new QMouseEvent(QEvent::MouseButtonPress, QPointF(p.x, p.y), Qt::LeftButton, 0, 0);
    QApplication::postEvent((QWindow *)qwindow, ev);
    ((QEventLoop *)eventLoop)->processEvents();
}

- (void) mouseUp:(NSEvent *)event {
    // NSLog(@"mouse up %@", event);
}

- (void) rightMouseDown:(NSEvent *)event {
    // NSLog(@"right mouse down %@", event);
}

- (void) rightMouseUp:(NSEvent *)event {
    // NSLog(@"right mouse up %@", event);
}

- (void) mouseMoved:(NSEvent *)event {
    // NSLog(@"mouse moved %@", event);
}

- (void) mouseDragged:(NSEvent *)event {
    // NSLog(@"mouse dragged %@",event);
}

- (void) rightMouseDragged:(NSEvent *)event {
    // NSLog(@"right mouse dragged %@",event);
}

- (void) mouseEntered:(NSEvent *)event {
    // NSLog(@"mouse entered %@",event);
}

- (void) mouseExited:(NSEvent *)event {
    // NSLog(@"mouse exited %@",event);
}

- (void) keyDown:(NSEvent *)event {
    // NSLog(@"key down %@",event);
}

- (void) keyUp:(NSEvent *)event {
    // NSLog(@"key down %@",event);
}

- (void) flagsChanged:(NSEvent *)event {
    // NSLog(@"flags changed %@",event);
}

- (void) scrollWheel:(NSEvent *)event {
    // NSLog(@"scroll wheel %@",event);
}

@end