//
//  ImagesCarousel.swift
//
//
//  Created by Henadzi Rabkin on 11/10/2023.
//

import SwiftUI
import Foundation

struct ImagesCarousel: View {
    
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5, content: {
                ForEach(Array(displayImages().enumerated()), id: \.1) { index,imageField in
                    HStack {
                        ProductImageButton(
                            imageKey: imageField,
                            image: pageConfig.binding(for: imageField)
                        )
                        
                        if index < ImageField.allCases.count-1 {
                            Divider()
                        }
                    }
                }
            })
        }.frame(minWidth: 0, maxWidth: .infinity).cornerRadius(6)
    }
    
    private func displayImages() -> [ImageField] {
        return ImageField.allCases.filter { imageField in
            return pageConfig.isNewMode || !pageConfig.images[imageField]!.isEmpty()
        }
    }
}

#Preview {
    ImagesCarousel()
}
