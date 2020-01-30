//
//  ImagePicker.swift
//  iDiary
//
//  Created by Bibin Benny on 30/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//


import SwiftUI
import Combine


 class ImagePicker : ObservableObject {
    
    static let shared : ImagePicker = ImagePicker()
    
    
    
    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()
    
    
    
    // Bindable Object part
    let willChange = PassthroughSubject<UIImage?, Never>()
    
    @Published var image: UIImage? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }
}


extension ImagePicker {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            ImagePicker.shared.image = uiImage
           
            picker.dismiss(animated:true)
            
            
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated:true)
        }
    }
    
    
    struct View: UIViewControllerRepresentable {
        
        func makeCoordinator() -> Coordinator {
            ImagePicker.shared.coordinator
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController,
                                    context: UIViewControllerRepresentableContext<ImagePicker.View>) {
            
        }
        
    }
    
}
