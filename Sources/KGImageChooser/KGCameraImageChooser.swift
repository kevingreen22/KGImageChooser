//
//  KGCameraImageChooser.swift
//
//  Created by Kevin Green on 8/31/22.
//

import SwiftUI

public struct KGCameraImageChooser: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @Binding var uiImage: UIImage?
    var completion: ()->()
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            // FIRST TAB
            if #available(iOS 14, *) {
                PHImagePicker(uiImage: $uiImage, completion: { completion() })
                    .tabItem {
                        Label("Image", systemImage: "photo")
                    }
            } else {
                // Fallback on earlier versions
                CameraView(uiImage: $uiImage, sourceType: .photoLibrary, completion: { completion() } )
                    .tabItem {
                        HStack {
                            Image(systemName: "photo")
                            Text("Image")
                        }
                    }
            }
            
            // SECOND TAB
            cameraView
                .tabItem {
                    if #available(iOS 14.0, *) {
                        Label("Camera", systemImage: "camera")
                    } else {
                        // Fallback on earlier versions
                        HStack {
                            Image(systemName: "camera")
                            Text("Camera")
                        }
                    }
                    
                }
        }
        .foregroundColor(.green)
    }
    
    
    @ViewBuilder fileprivate var cameraView: some View {
        if #available(iOS 14.0, *) {
            CameraView(uiImage: $uiImage, sourceType: .camera, completion: { completion() })
                .ignoresSafeArea()
        } else {
            // Fallback on earlier versions
            CameraView(uiImage: $uiImage, sourceType: .camera, completion: { completion() })
                .edgesIgnoringSafeArea(.all)
        }
    }
    
}

