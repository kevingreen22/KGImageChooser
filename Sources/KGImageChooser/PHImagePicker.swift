//
//  PHImagePicker.swift
//  Special Order Keeper iPhone
//
//  Created by Kevin Green on 8/31/22.
//

import SwiftUI
import PhotosUI

@available(iOS 14, *)
struct PHImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var uiImage: UIImage?
    var completion: ()->()
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        print("\n\(type(of: self)).\(#function)")
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return PHImagePicker.Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PHImagePicker
        
        init(_ parent: PHImagePicker) {
            self.parent = parent
        }
    
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("\n\(type(of: self)).\(#function)")
            let itemProviders = results.map(\.itemProvider)
            for item in itemProviders {
                // checking image can be loaded
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                self?.parent.uiImage = image
                            }
                        }
                    }
                }
            }
            self.parent.completion()
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

