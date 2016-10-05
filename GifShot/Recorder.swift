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

class Recorder: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    var recordingSession: AVCaptureSession?;
    var destinationUrl: URL = URL(fileURLWithPath: "/Users/david/gifs/4.mov");
    var movieOutput: AVCaptureMovieFileOutput?;
    
    func startRecording() {
        recordingSession = AVCaptureSession();
        recordingSession?.sessionPreset = AVCaptureSessionPresetHigh;
        let displayId: CGDirectDisplayID = CGDirectDisplayID(CGMainDisplayID());
        let input: AVCaptureScreenInput = AVCaptureScreenInput(displayID: displayId);
        input.capturesCursor = true;
        input.capturesMouseClicks = true;
        let boundingRect = CGRect(x: 100, y: 100, width: 500, height: 500);
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
        print(url);
        var data: Data;
        do {
            data = try Data(contentsOf: url!);
            NSPasteboard.general().setData(data, forType:NSTIFFPboardType);
            NSPasteboard.general().setString("This is a test", forType: NSStringPboardType)
            print("item on clipboard");
        } catch {
            print("uh-oh");
        }
    }
    
    func stopRecording() {
        movieOutput?.stopRecording();
        recordingSession?.stopRunning();
        let outputPath = destinationUrl.deletingPathExtension().appendingPathExtension("gif");
        let request = NSGIFRequest(sourceVideo: destinationUrl, destination: outputPath);
        
        NSGIF.create(request, completion: complete);
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("this should be okay");
    }
    
}
