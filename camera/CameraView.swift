//
//  CameraView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI
import AVFoundation

struct CameraView: NSViewRepresentable {
    
    @Binding var selectedCamera: AVCaptureDevice?
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        guard let selectedCamera = selectedCamera else {
            print("No camera selected.")
            return
        }
        
        nsView.layer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        do {
            let input = try AVCaptureDeviceInput(device: selectedCamera)
            captureSession.inputs.forEach { captureSession.removeInput($0) }
            captureSession.addInput(input)
        } catch {
            print("Error setting up capture session: \(error.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = nsView.bounds
        nsView.layer?.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}


struct CameraPicker: NSViewRepresentable {
    
    @Binding var selectedCamera: AVCaptureDevice?
    
    func makeNSView(context: Context) -> NSView {
        let popUpButton = NSPopUpButton()
        popUpButton.target = context.coordinator
        popUpButton.action = #selector(Coordinator.cameraSelected(_:))
        
        let cameras = getListOfCameras()
        
        for camera in cameras {
            let menuItem = NSMenuItem(title: camera.localizedName, action: nil, keyEquivalent: "")
            menuItem.representedObject = camera
            popUpButton.menu?.addItem(menuItem)
        }
        
        // Handle the case where the selectedCamera may have changed before the view was created
        if let selectedCamera = selectedCamera,
           let index = cameras.firstIndex(of: selectedCamera) {
            popUpButton.selectItem(at: index)
        }
        
        return popUpButton
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Handle the case where the selectedCamera may have changed after the view was created
        guard let popUpButton = nsView as? NSPopUpButton else { return }
        
        if let selectedCamera = selectedCamera,
           let index = popUpButton.itemArray.firstIndex(where: { ($0.representedObject as? AVCaptureDevice) == selectedCamera }) {
            popUpButton.selectItem(at: index)
        }
    }
    
    class Coordinator: NSObject {
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        @objc func cameraSelected(_ sender: NSPopUpButton) {
            if let camera = sender.selectedItem?.representedObject as? AVCaptureDevice {
                parent.selectedCamera = camera
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func getListOfCameras() -> [AVCaptureDevice] {
        let session = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified)
        return session.devices
    }
}
