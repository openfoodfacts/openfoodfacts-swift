//
//  ImagePickerViewModel.swift
//
//
//  Created by Henadzi Rabkin on 12/10/2023.
//

import Foundation
import SwiftUI

class ImagesHelper: ObservableObject {
    
    @Published var isPresented: Bool = false
    @Published var showingCropper: Bool = false
    @Published var isPresentedSourcePicker: Bool = false
    
    @Published var source = UIImagePickerController.SourceType.camera
    
    @Published var imageFieldToEdit = ImageField.front
    
    @Published var isPresentedImagePreview = false
    @Published var previewImage = UIImage()
}
