//
//  CameraView.swift
//  Special Order Keeper iPhone
//
//  Created by Kevin Green on 8/23/22.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var uiImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var completion: ()->()

    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        print("\(type(of: self)).\(#function)\n")
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            print("\(type(of: self)).\(#function)\n")
            if let uiimage = info[.originalImage] as? UIImage {
                self.parent.uiImage = uiimage
            }
            self.parent.completion()
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

