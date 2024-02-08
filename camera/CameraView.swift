//
//  CameraView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI
import AVFoundation

struct CameraView: NSViewRepresentable {
    
    @EnvironmentObject private var globalModel: GlobalModel
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let session = AVCaptureSession()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer = previewLayer
        
        if let camera = globalModel.selectedCamera {
            let input = try? AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input!) {
                session.addInput(input!)
            }
        }
        
        session.startRunning()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        let previewLayer = nsView.layer as! AVCaptureVideoPreviewLayer
        let session = previewLayer.session!
        session.beginConfiguration()
        if let input = session.inputs.first {
            session.removeInput(input)
        }
        if let camera = globalModel.selectedCamera {
            let input = try? AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input!) {
                session.addInput(input!)
            }
        }
        session.commitConfiguration()
    }
}

