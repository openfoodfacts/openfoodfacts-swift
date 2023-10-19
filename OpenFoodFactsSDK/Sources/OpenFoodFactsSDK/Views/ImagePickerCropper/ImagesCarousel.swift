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
                ForEach(Array(ImageField.allCases.enumerated()), id: \.1) { index,imageField in
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
}

#Preview {
    ImagesCarousel()
}
