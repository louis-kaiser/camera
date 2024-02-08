//
//  CameraView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI
import AVFoundation

struct CameraView: NSViewRepresentable {
    @Binding var camera: AVCaptureDevice?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let session = AVCaptureSession()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer = previewLayer
        
        if let camera = camera {
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
        if let camera = camera {
            let input = try? AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input!) {
                session.addInput(input!)
            }
        }
        session.commitConfiguration()
    }
}

struct CameraPicker: NSViewRepresentable {
    @Binding var camera: AVCaptureDevice?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSPopUpButton()
        view.target = context.coordinator
        view.action = #selector(Coordinator.cameraChanged(_:))
        // Use AVCaptureDeviceDiscoverySession instead of devices(for:)
        let cameras = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .external], mediaType: .video, position: .unspecified).devices
        view.addItems(withTitles: ["None"] + cameras.map { $0.localizedName })
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        let popupButton = nsView as! NSPopUpButton
        if let camera = camera {
            popupButton.selectItem(withTitle: camera.localizedName)
        } else {
            popupButton.selectItem(at: 0)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        @objc func cameraChanged(_ sender: NSPopUpButton) {
            let index = sender.indexOfSelectedItem
            if index == 0 {
                parent.camera = nil
            } else {
                let cameras = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .external], mediaType: .video, position: .unspecified).devices
                parent.camera = cameras[index - 1]
            }
        }
    }
}
