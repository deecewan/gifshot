//
//  CropRect.swift
//  GifShot
//
//  Created by David Buchan-Swanson on 6/10/2016.
//  Copyright © 2016 David Buchan-Swanson. All rights reserved.
//

import Foundation
import QuartzCore
import Cocoa

class CropRect: NSView {
    
    var clickedPoint: NSPoint?;
    var shapeLayer: CAShapeLayer?;
    var draggable: Bool?;
    var recorder: Recorder?;
    
    override init(frame: NSRect) {
        super.init(frame: frame);
        
        clickedPoint = nil;
        
        self.layer = CALayer();
        self.layer!.frame = frame;
        self.wantsLayer = true;
        
        shapeLayer = CAShapeLayer();
        shapeLayer!.lineWidth = 1.0;
        shapeLayer!.strokeColor = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor;
        shapeLayer!.fillColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor;
        // shapeLayer!.fillColor = NSColor.black.cgColor;
        
        draggable = true;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect);
    }
    
    override func mouseDown(with event: NSEvent) {
        if draggable! == true {
            clickedPoint = convert(event.locationInWindow, from: nil);
            self.layer!.addSublayer(shapeLayer!);
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        draggable = false;
        let point = convert(event.locationInWindow, from: nil);
        
        let selectedRect = CGRect(x: min(point.x, clickedPoint!.x), y: min(point.y, clickedPoint!.y), width: fabs(point.x - clickedPoint!.x), height: fabs(point.y - clickedPoint!.y));
        
        Swift.print(selectedRect);
        
        if recorder != nil {
            recorder?.startRecording(x: Double(selectedRect.minX), y: Double(selectedRect.minY), width: Double(selectedRect.width), height: Double(selectedRect.height));
            shapeLayer!.strokeColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor;
        }
        
        draggable = true;
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil);
        
        let path = CGMutablePath();
        
        if let startPoint = clickedPoint {
            path.move(to: CGPoint(x: startPoint.x, y: startPoint.y));
            path.addLine(to: CGPoint(x: startPoint.x, y: point.y));
            path.addLine(to: CGPoint(x: point.x, y: point.y));
            path.addLine(to: CGPoint(x: point.x, y: startPoint.y));
            path.closeSubpath();
        }
        
        shapeLayer!.path = path;
    }
    
}
