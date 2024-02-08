//
//  ContentView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var globalModel: GlobalModel
    
    var body: some View {
        ZStack {
            CameraView(selectedCamera: $globalModel.selectedCamera)
                .environmentObject(globalModel)
            CameraPicker(selectedCamera: $globalModel.selectedCamera)
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalModel())
    }
}


import SwiftUI
import AVFoundation

class GlobalModel: ObservableObject {
    @Published var selectedCamera: AVCaptureDevice?
}
