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
  @Binding var errorMessage: ErrorAlert?
    
  func makeCoordinator() -> Coordinator {
      return Coordinator(parent: self)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let cropViewController = CropViewController(image: self.image)
    cropViewController.delegate = context.coordinator
    return cropViewController
  }
}

class Coordinator: NSObject, CropViewControllerDelegate {
    
  var parent: ImageCropper
  
  init(parent: ImageCropper) {
      self.parent = parent
  }
  
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    
    // FIXME: it doesn't work, image has original size
    if (!image.isPictureBigEnough()) {
        parent.errorMessage = ErrorAlert(message: "Invalid image", title: "The image is too small! Minimum WxH 640x160")
    } else {
        self.parent.image = image
    }
      withAnimation {
          parent.isPresented = false
      }
  }
  
  func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
    withAnimation {
        parent.isPresented = false
    }
  }
}
