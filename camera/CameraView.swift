//
//  CameraView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI
import AVFoundation

struct CameraView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        let captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return view }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return view
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return view
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        //previewLayer.videoGravity = .resizeAspectFill
        view.layer = previewLayer
        captureSession.startRunning()
        return view
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
}
