//
//  cameraApp.swift
//  camera
//
//  Created by Louis Kaiser on 28.01.24.
//

import SwiftUI

@main
struct cameraApp: App {
    
    @StateObject var globalModel = GlobalModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalModel)
        }
    }
}
