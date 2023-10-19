//
//  EditProductPage.swift
//
//  TODO: send entered product data
//  TODO: error handling
// -------------------------
//  TODO: support editing
//  TODO: add localizations
//  TODO: OCR
//
//  Created by Henadzi Rabkin on 15/10/2023.
//

import Foundation
import SwiftUI

public struct ProductPage: View {
    
    @Binding public var barcode: String
    @Binding public var isPresented: Bool
    
    @State private var imageIsTooSmall = false
    
    @StateObject var pageConfig = ProductPageConfig()
    @StateObject var imagesHelper = ImagesHelper()
    
    let onSubmit: ((_ product: [String: String]) -> Void)?
    
    public init(barcode: Binding<String>, isPresented: Binding<Bool>, onSubmit: (([String: String]) -> Void)? = nil) {
        _barcode = barcode
        _isPresented = isPresented
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            if let error = pageConfig.errorMessage { // TODO: remove, was used for debug
                Text("Error: \(error.description)").foregroundColor(.red).padding()
            } else if !self.pageConfig.isInitialised {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea() // Full screen
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                }
            } else {
                ProductDetails(barcode: $barcode)
                    .environmentObject(pageConfig)
                    .environmentObject(imagesHelper)
            }
        }.onAppear(perform: {
            
            UIApplication.shared.addTapGestureRecognizer()
            Task {
                await pageConfig.fetchData(barcode: barcode)
            }
        })
        .actionSheet(isPresented: $imagesHelper.isPresentedSourcePicker) { () -> ActionSheet in
            
            ActionSheet(
                title: Text("Choose source"),
                message: Text("Please choose your preferred source to add product's image"),
                buttons: [
                    .default(Text("Camera"), action: {
                        self.imagesHelper.isPresented = true
                        self.imagesHelper.source = .camera
                    }),
                    .default(Text("Gallery"), action: {
                        self.imagesHelper.isPresented = true
                        self.imagesHelper.source = .photoLibrary
                    }),
                    .cancel()
                ]
            )
        }
//        .alert("Editor not ready", isPresented:  $pageConfig.pageState.isEqualTo(ProductPageState.edit)) {
//            Button("OK") {
//                self.pageConfig.pageState = .new
//                self.isPresented = false
//            }
//        } message: {
//            Text("Product with barcode \(barcode) already exists. Editing is in progress.")
//        }
        .alert("Image is too small", isPresented: $imageIsTooSmall) {
            Button("OK") {
                self.imageIsTooSmall = false
            }
        } message: {
            Text("The image is too small! Minimum WxH 640x160")
        }
        .fullScreenCover(isPresented: $imagesHelper.isPresentedImagePreview, content: {
            ImageViewer(
                viewerShown: $imagesHelper.isPresentedImagePreview,
                image: $imagesHelper.previewImage,
                closeButtonTopRight: true
            )
        })
        .fullScreenCover(isPresented: $imagesHelper.isPresented) {
            ImagePickerView(
                isPresented: $imagesHelper.isPresented,
                image: pageConfig.binding(for: imagesHelper.imageFieldToEdit),
                source: $imagesHelper.source
            ) { withImage in
                imagesHelper.showingCropper = withImage
            }.ignoresSafeArea()
            
        }.fullScreenCover(isPresented: $imagesHelper.showingCropper, content: {
            ImageCropper(
                image: pageConfig.binding(for: imagesHelper.imageFieldToEdit),
                isPresented: $imagesHelper.showingCropper,
                imageIsTooSmall: $imageIsTooSmall
            ).ignoresSafeArea()
        })
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresented = false
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                if pageConfig.isNewMode {
                    Button("Submit") {
                        if (!pageConfig.isInitialised) { return }
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    ProductPage(barcode: .constant("5900259127761"), isPresented: .constant(true))
}
