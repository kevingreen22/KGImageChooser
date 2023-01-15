//
//  CameraView.swift
//  Special Order Keeper iPhone
//
//  Created by Kevin Green on 8/23/22.
//

import SwiftUI
import AVFoundation
import Photos

public struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var uiImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var completion: ()->()

    public init(uiImage: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType, completion: @escaping () -> Void) {
        _uiImage = uiImage
        self.sourceType = sourceType
        self.completion = completion
    }
    
    public func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        print("\(type(of: self)).\(#function)")
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        public init(_ parent: CameraView) {
            self.parent = parent
        }
        
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            print("\(type(of: self)).\(#function)")
            if let uiimage = info[.originalImage] as? UIImage {
                self.parent.uiImage = uiimage
            }
            self.parent.completion()
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

