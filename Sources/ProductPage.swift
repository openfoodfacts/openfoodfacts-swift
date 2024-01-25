//
//  EditProductPage.swift
//
// -------------------------
//  TODO: verify kJ calculation and requirement to send it along with kCal https://github.com/openfoodfacts/openfoodfacts-dart/blob/master/lib/src/utils/nutriments_helper.dart
//  TODO: support editing
//  TODO: add localizations
//  TODO: OCR on client for nutriments, product name maybe
//  TODO: match OFF requirement from README
//  TODO: coverage by tests
//
//  Created by Henadzi Rabkin on 15/10/2023.
//

import Foundation
import SwiftUI

struct ErrorAlert: Identifiable {
    let id = UUID()
    let message: String
    let title: String
}

public struct ProductPage: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var pageConfig = ProductPageConfig()
    @StateObject var imagesHelper = ImagesHelper()
    
    public let barcode: String
    public let onUploadingDone: (Product?) -> Void
    
    public init(barcode: String, onUploadingDone: @escaping (Product?) -> Void = { _ in }) {
        self.barcode = barcode
        self.onUploadingDone = onUploadingDone
    }
    
    public var body: some View {
        Group {
            switch pageConfig.pageState {
            case .loading, .completed, .error:
                PageOverlay(state: $pageConfig.pageState)
            case .productDetails:
                ProductDetails(barcode: barcode)
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
                    }
                    .fullScreenCover(isPresented: $imagesHelper.showingCropper, content: {
                        ImageCropper(
                            image: pageConfig.binding(for: imagesHelper.imageFieldToEdit),
                            isPresented: $imagesHelper.showingCropper,
                            errorMessage: $pageConfig.errorMessage
                        ).ignoresSafeArea()
                    })
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Submit") {
                                if (pageConfig.getMissingFields().isEmpty) {
                                    Task {
                                        await pageConfig.uploadAllProductData(barcode: barcode)
                                    }
                                } else {
                                    pageConfig.errorMessage = ErrorAlert(
                                        message: "Fields: \(self.pageConfig.getMissingFieldsMessage())",
                                        title: "Missing required data")
                                }
                            }.disabled(!pageConfig.isInitialised)
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: pageConfig.submittedProduct) { newValue in
            self.onUploadingDone(newValue)
            dismiss()
        }
        .alert(item: $pageConfig.errorMessage, content: { alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .cancel(Text("OK"), action: {
                self.pageConfig.errorMessage = nil
                if self.pageConfig.pageState == .error { dismiss() }
            }))
        })
        .onAppear(perform: {
            UIApplication.shared.addTapGestureRecognizer()
            Task(priority: .userInitiated) {
                await pageConfig.fetchData(barcode: barcode)
            }
        })
    }
}

#Preview {
    ProductPage(barcode: "5900259127761")
}
