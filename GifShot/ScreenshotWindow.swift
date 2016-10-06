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
    
    var recorder: Recorder?;
    var croppingRect: CropRect!;
    
    override init(window: NSWindow!) {
        super.init(window: window);
        window.delegate = self;
        window.isReleasedWhenClosed = false;
        // window.collectionBehavior = NSWindowCollectionBehavior.canJoinAllSpaces;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func ignoreClicks() {
        window!.ignoresMouseEvents = true;
    }
    
    func listenClicks() {
        window!.ignoresMouseEvents = false;
    }
    
    func visibliseWindow() {
        window!.makeKeyAndOrderFront(self)
        window!.alphaValue = 0;
        // Set level to screensaver level
        window!.level = 1000
        window!.backgroundColor = NSColor.white;
        window!.animator().alphaValue = 0.5;
        croppingRect = CropRect(frame: window!.frame);
        if recorder != nil {
            croppingRect.recorder = recorder;
        }
        window!.contentView = croppingRect!;
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
