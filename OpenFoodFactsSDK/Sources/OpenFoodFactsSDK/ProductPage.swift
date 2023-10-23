//
//  EditProductPage.swift
//
// -------------------------
//  TODO: support editing
//  TODO: add localizations
//  TODO: OCR on client for nutriments, product name maybe
//
//  Created by Henadzi Rabkin on 15/10/2023.
//

import Foundation
import SwiftUI

public struct ProductPage: View {
    
    @Binding public var barcode: String
    @Binding public var isPresented: Bool
    
    @State private var isAlertPresent = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @StateObject var pageConfig = ProductPageConfig()
    @StateObject var imagesHelper = ImagesHelper()
    
    let onSubmit: ((_ product: [String: String]) -> Void)?
    
    public init(barcode: Binding<String>, isPresented: Binding<Bool>, onSubmit: (([String: String]) -> Void)? = nil) {
        _barcode = barcode
        _isPresented = isPresented
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        Group {
            switch pageConfig.pageState {
            case .loading, .completed:
                PageOverlay(state: $pageConfig.pageState, stateAfterCompleted: .productDetails)
            case .productDetails:
                ProductDetails(barcode: $barcode)
                    .environmentObject(pageConfig)
                    .environmentObject(imagesHelper)
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
                    .alert("What's next?", isPresented:  $pageConfig.isProductJustUploaded) {
                        Button("Leave") {
                            self.isPresented = false
                        }
                        Button("View") {
                            pageConfig.isProductJustUploaded = false
                            Task {
                                await pageConfig.fetchData(barcode: barcode)
                            }
                        }
                    } message: {
                        Text("Would you like to view uploaded product or leave?")
                    }
                    .alert(alertTitle, isPresented:  $isAlertPresent) {
                        Button("OK") {
                            self.isAlertPresent = false
                        }
                    } message: {
                        Text(alertMessage)
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
                            isAlertPresented: $isAlertPresent,
                            alertTitle: $alertTitle,
                            alertMessage: $alertMessage
                        ).ignoresSafeArea()
                    })
                    .onChange(of: pageConfig.errorMessage) { newValue in
                        if let error = newValue {
                            alertTitle = "Error"
                            alertMessage = error.localizedDescription
                        }
                    }
                    .onChange(of: pageConfig.missingRequiredTitles) { newValue in
                        
                        if pageConfig.missingRequiredTitles.isEmpty {
                            // Send data, show success animation
                            pageConfig.pageState = .loading
                        } else {
                            alertMessage = "Fields: \(self.pageConfig.getMissingFieldsMessage())"
                            alertTitle = "Missing required data"
                            isAlertPresent = true
                        }
                    }
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
                                    pageConfig.getMissingFields()
                                    
                                    if (pageConfig.missingRequiredTitles.isEmpty) {
                                        Task {
                                            await pageConfig.uploadAllProductData(barcode: barcode)
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            UIApplication.shared.addTapGestureRecognizer()
        })
        .task {
            await pageConfig.fetchData(barcode: barcode)
        }
    }
}

#Preview {
    ProductPage(barcode: .constant("5900259127761"), isPresented: .constant(true))
}
