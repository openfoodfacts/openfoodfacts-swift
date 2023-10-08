//
//  ProductImageButton.swift
//
//
//  Created by Henadzi Rabkin on 12/10/2023.
//

import Foundation
import SwiftUI

struct ProductImageButton: View {
    
    var showDivider: Bool
    var imageKey: ImageField
    
    @Binding var image: UIImage
    @EnvironmentObject var pickerModel: ImagesHelper
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    public var body: some View {
        Button(action: {
            self.pickerModel.isPresentedSourcePicker = true
            self.pickerModel.imageFieldToEdit = imageKey
        }) {
            HStack(alignment: .center, content: {
                
                if self.image.isEmpty() {
                    Image(systemName: "photo.badge.plus.fill")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 55).padding(5)
                } else {
                    Image(uiImage: self.image)
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 55).padding(5)
                        .background(RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 2))
                }
                VStack(alignment: .leading, content: {
                    Text("\(imageKey.rawValue)")
                    Text("photo")
                })
                if showDivider {
                    Divider()
                }
            })
            .padding(5)
        }.disabled(pageConfig.isViewMode)
    }
}

#Preview {
    ProductImageButton(showDivider: false, imageKey: .front, image: .constant(UIImage.init(systemName: "pensil")!))
}
