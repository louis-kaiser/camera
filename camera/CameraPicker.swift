//
//  CameraPicker.swift
//  camera
//
//  Created by Louis Kaiser on 08.02.24.
//

import SwiftUI
import AVFoundation

struct CameraPicker: View {
    @State private var cameras: [AVCaptureDevice] = []
    @State private var selectedCamera: AVCaptureDevice?

    var body: some View {
        List(cameras, id: \.uniqueID) { camera in
            Button(action: {
                self.selectedCamera = camera
            }) {
                Text(camera.localizedName)
            }
            .background(selectedCamera == camera ? Color.blue : Color.clear)
        }
        .onAppear(perform: loadCameras)
    }

    func loadCameras() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .external], mediaType: .video, position: .unspecified)
        cameras = discoverySession.devices
    }
}

struct CameraPicker_Previews: PreviewProvider {
    static var previews: some View {
        CameraPicker()
    }
}
