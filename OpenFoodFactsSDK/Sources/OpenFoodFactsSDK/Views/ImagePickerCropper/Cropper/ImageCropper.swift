//
//  ImageCropper.swift
//
//
//  Created by Henadzi Rabkin on 10/13/23.
//
import SwiftUI

struct ImageCropper: UIViewControllerRepresentable {
    
  @Binding var image: UIImage
  @Binding var isPresented: Bool
  @Binding var imageIsTooSmall: Bool
    
  func makeCoordinator() -> Coordinator {
      return Coordinator(image: $image, isPresented: $isPresented, imageIsTooSmall: $imageIsTooSmall)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let img = self.image
    let cropViewController = CropViewController(image: img)
    cropViewController.delegate = context.coordinator
    return cropViewController
  }
}

class Coordinator: NSObject, CropViewControllerDelegate {
    
  @Binding var image: UIImage
  @Binding var isPresented: Bool
  @Binding var imageIsTooSmall: Bool
  
  init(image: Binding<UIImage>, isPresented: Binding<Bool>, imageIsTooSmall: Binding<Bool>) {
      _image = image
      _isPresented = isPresented
      _imageIsTooSmall = imageIsTooSmall
  }
  
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    withAnimation {
      isPresented = false
    }
    
    if (!image.isPictureBigEnough()) {
        imageIsTooSmall = true
    } else {
      self.image = image
    }
  }
  
  func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
    withAnimation {
      isPresented = false
    }
  }
}
