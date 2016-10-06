//
//  Recorder.swift
//  GifShot
//
//  Created by David Buchan-Swanson on 5/10/2016.
//  Copyright © 2016 David Buchan-Swanson. All rights reserved.
//

import Foundation
import AVFoundation
import NSGIF2
import Cocoa

class Recorder: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    var recordingSession: AVCaptureSession?;
    var destinationUrl: URL?;
    var movieOutput: AVCaptureMovieFileOutput?;
    var screenshotWindow: ScreenshotWindow!;
    
    func preRecord(){
        let windowRect = NSMakeRect(0, 0, NSScreen.main()!.frame.size.width, NSScreen.main()!.frame.size.height)
        
        if screenshotWindow == nil {
            screenshotWindow = ScreenshotWindow(window: NSWindow(contentRect: windowRect, styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.buffered, defer: false))
        }
        
        screenshotWindow!.showWindow(self);
        screenshotWindow.recorder = self;
        screenshotWindow.visibliseWindow();
        NSApp.activate(ignoringOtherApps: true);
        
    }
    
    func startRecording(x: Double, y: Double, width: Double, height: Double) {
        // disable mouse interaction with the window
        screenshotWindow.ignoreClicks();
        destinationUrl = URL(fileURLWithPath: "/Users/david/gifs/\(NSUUID().uuidString).mov");
        recordingSession = AVCaptureSession();
        recordingSession?.sessionPreset = AVCaptureSessionPresetHigh;
        let displayId: CGDirectDisplayID = CGDirectDisplayID(CGMainDisplayID());
        let input: AVCaptureScreenInput = AVCaptureScreenInput(displayID: displayId);
        input.capturesCursor = true;
        input.capturesMouseClicks = true;
        let boundingRect = CGRect(x: x + 1, y: y + 1, width: width - 1, height: height - 1);
        input.cropRect = boundingRect;
        print("Looking good so far.");
        
        if ((recordingSession?.canAddInput(input)) != nil) {
            recordingSession?.addInput(input);
        }
        
        movieOutput = AVCaptureMovieFileOutput();
        
        if ((recordingSession?.canAddOutput(movieOutput)) != nil) {
            recordingSession?.addOutput(movieOutput);
        }
        
        recordingSession?.startRunning();
        movieOutput?.startRecording(toOutputFileURL: destinationUrl, recordingDelegate: self);
        
    }
    
    func complete(url: URL?) {
        
        let pb = NSPasteboard.general();
        if let nofElements = pb.pasteboardItems?.count {
            if nofElements > 0 {
                for element in pb.pasteboardItems! {
                    print(element);
                    print(element.types);
                }
            }
        }
        
        print(url);
        var data: Data;
        do {
            data = try Data(contentsOf: url!);
            NSPasteboard.general().setData(data, forType:"public.file-url");
            print("item on clipboard");
        } catch {
            print("uh-oh");
        }
        cancelRecording();
    }
    
    func stopRecording() {
        print("recording stopped");
        movieOutput?.stopRecording();
        recordingSession?.stopRunning();
        let outputPath = destinationUrl!.deletingPathExtension().appendingPathExtension("gif");
        let request = NSGIFRequest(sourceVideo: destinationUrl, destination: outputPath);
        
        NSGIF.create(request, completion: complete);        
    }
    
    func cancelRecording() {
        if screenshotWindow != nil {
            // fade it out
            screenshotWindow.listenClicks();
            screenshotWindow.hideWindow();
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("this should be okay");
    }
    
}
