//
//  ContentView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI
import AVFoundation

class GlobalModel: ObservableObject {
    @Published var selectedCamera: AVCaptureDevice? = AVCaptureDevice.default(for: .video)
}

struct ContentView: View {
    
    @EnvironmentObject private var globalModel: GlobalModel
    
    var body: some View {
        VStack {
            CameraView()
                .environmentObject(globalModel)
                .frame(width: 400, height: 300)
            CameraPicker()
                .environmentObject(globalModel)
        }
    }
}
