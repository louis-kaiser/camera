//
//  ContentView.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            CameraView()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
