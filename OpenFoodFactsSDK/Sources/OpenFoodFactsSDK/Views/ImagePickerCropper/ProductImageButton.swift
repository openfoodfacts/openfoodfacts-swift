//
//  ProductImageButton.swift
//
//
//  Created by Henadzi Rabkin on 12/10/2023.
//

import Foundation
import SwiftUI

struct ProductImageButton: View {
    
    var imageKey: ImageField
    
    @Binding var image: UIImage
    @EnvironmentObject var pickerModel: ImagesHelper
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    @ViewBuilder
    func imageView() -> some View {
        if self.image.isEmpty() {
            Image(systemName: "photo.badge.plus.fill")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 80)
                .padding(5)
        } else {
            Image(uiImage: self.image)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 80)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 2))
        }
    }
    
    public var body: some View {
        VStack {
            Button(action: {
                if pageConfig.isViewMode {
                    self.pickerModel.isPresentedImagePreview = true
                    self.pickerModel.previewImage = image
                } else {
                    self.pickerModel.isPresentedSourcePicker = true
                    self.pickerModel.imageFieldToEdit = imageKey
                }
            }) {
                imageView()
            }
            Text("\(imageKey.rawValue)").required(isActive: ProductPageConfig.requiredImageFields.contains(imageKey) && pageConfig.isNewMode)
        }
        .padding(5)
    }
}

#Preview {
    ProductImageButton(imageKey: .front, image: .constant(UIImage.init(systemName: "pensil")!))
}
