//
//  WindowHandler.swift
//  GifShot
//
//  Created by David Buchan-Swanson on 6/10/2016.
//  Copyright © 2016 David Buchan-Swanson. All rights reserved.
//

import Foundation
import Cocoa
import QuartzCore

class ScreenshotWindow: NSWindowController, NSWindowDelegate {
    
    var screens: Array<NSRect> = [];
    
    override init(window: NSWindow!) {
        super.init(window: window);
        window.delegate = self;
        window.isReleasedWhenClosed = false;
        window.collectionBehavior = NSWindowCollectionBehavior.canJoinAllSpaces;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func visibliseWindow() {
        window!.makeKeyAndOrderFront(self)
        window!.alphaValue = 0;
        // Set level to screensaver level
        window!.level = 1000
        window!.backgroundColor = NSColor.white;
        window!.animator().alphaValue = 0.3;
    }
    
    func closeWindow() {
        print("closing");
        window!.close();
    }
    
    func hideWindow() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.25;
            window!.animator().alphaValue = 0;
            }, completionHandler: closeWindow)
    }
    
}
