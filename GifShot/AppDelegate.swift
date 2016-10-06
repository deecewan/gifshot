//
//  AppDelegate.swift
//  GifShot
//
//  Created by David Buchan-Swanson on 5/10/2016.
//  Copyright © 2016 David Buchan-Swanson. All rights reserved.r
//

import Cocoa
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let recorder = Recorder();

    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBAction func quitController(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self);
    }
    
    @IBOutlet weak var shortcutView: MASShortcutView!
    
    @IBAction func prefsController(_ sender: NSMenuItem) {
        if let button = statusItem.button {
            print(button.frame.origin);
            preferencePanel.setIsVisible(true);
        }
    }
    
    let keyMask = UInt(NSEventModifierFlags.command.rawValue + NSEventModifierFlags.shift.rawValue);
    
    let key = UInt(kVK_ANSI_G);
    
    func setStatusIcon() {
        let icon = NSImage(named: "statusIcon");
        icon?.isTemplate = false;
        if (!recording) {
            icon?.isTemplate = true;
        }
        
        statusItem.image = icon
    }
    
    @IBOutlet weak var preferencePanel: NSPanel!
    
    @IBOutlet weak var recordingButton: NSMenuItem!
    
    @IBAction func recordingController(_ sender: NSMenuItem) {
        if (!recording) {
            recording = true;
            recordingButton.title = "Stop Recording";
            // recorder.startRecording(x: 100, y: 100, width: 300, height: 400);
            recorder.preRecord();
        } else {
            recording = false;
            recordingButton.title = "Start Recording";
            recorder.stopRecording();
            // recorder.cancelRecording();
        }
        setStatusIcon();
        
    }
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

    var recording = false;
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setStatusIcon();
        statusItem.menu = statusMenu;
        let shortcut = MASShortcut(keyCode: key, modifierFlags: keyMask);
        MASShortcutMonitor.shared().register(shortcut, withAction: {
            print("Shortcut Pressed")
            self.recordingController(self.recordingButton);
        })
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        MASShortcutMonitor.shared().unregisterAllShortcuts();
    }


}

