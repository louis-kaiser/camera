//
//  ContentView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var camera: AVCaptureDevice?
    
    var body: some View {
        VStack {
            CameraView(camera: $camera)
                .frame(width: 400, height: 300)
            CameraPicker(camera: $camera)
        }
    }
}
