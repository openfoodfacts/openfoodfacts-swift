//
//  ProductDetails.swift
//
//
//  Created by Henadzi Rabkin on 17/10/2023.
//

import Foundation
import SwiftUI

struct ProductDetails: View {
    
    @Binding var barcode: String
    
    @EnvironmentObject var pageConfig: ProductPageConfig
    @EnvironmentObject var pickerModel: ImagesHelper
    
    private static let productPackageLanguageTag = 110
    private static let barcodeTag = 111
    
    private static let lineSpacing = 15.0
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 20, content: {
                    ProductCode(barcodeString: barcode)
                        .scaleEffect(1.8, anchor: .top).padding([.bottom], 60)
                        .id(ProductDetails.barcodeTag)
                    
                    VStack(alignment: .leading, spacing: ProductDetails.lineSpacing, content: {
                        EditorHeader(title: "Basic details", systemImage: "pencil")
                        ExpandableText(text: "Fields with a star * - are a bare minimum.")
                        FloatingLabelTextField(placeholder: "Product's name", text: $pageConfig.productName)
                            .required(isActive: pageConfig.isNewMode)
                        FloatingLabelTextField(placeholder: "Brand name", text: $pageConfig.brand)
                        FloatingLabelTextField(placeholder: "Product's weight with units - 100g, 50ml, etc.", text: $pageConfig.weight)
                            .required(isActive: pageConfig.isNewMode)
                        HStack {
                            Text("Product's package language")
                            Spacer()
                            Picker("Product's package language", selection: $pageConfig.packageLanguage) {
                                ForEach(OpenFoodFactsLanguage.allCases) { lang in
                                    Text(lang.info.description)
                                }
                            }.disabled(pageConfig.isViewMode)
                        }.id(ProductDetails.productPackageLanguageTag)
                    }).modifier(RoundedBackgroundCard())
                    
                    VStack(alignment: .leading, spacing: ProductDetails.lineSpacing, content: {
                        EditorHeader(title: "Photos", systemImage: "photo.stack.fill")
                        Button(action: {
                            withAnimation {
                                proxy.scrollTo(ProductDetails.productPackageLanguageTag, anchor: .center)
                            }
                        }) {
                            Text("package in \(pageConfig.packageLanguage.info.description) language").font(.subheadline)
                        }
                        ExpandableText(text: "Photos of product's front and nutrients description are required for data validation. Change language in in basic details for product's package language.")
                        ImagesCarousel()
                        
                    }).modifier(RoundedBackgroundCard())
                    
                    VStack(alignment: .leading, spacing: ProductDetails.lineSpacing, content: {
                        EditorHeader(title: "Nutrition facts", systemImage: "leaf")
                        ExpandableText(text: "Indicate per what amount nutrient values: per 100g or per serving size")
                        NutrimentsEntryTable()
                        
                    }).modifier(RoundedBackgroundCard())
                    
                    VStack(alignment: .leading, spacing: ProductDetails.lineSpacing, content: {
                        EditorHeader(title: "Categories", systemImage: "fork.knife")
                        ExpandableText(text: "Indicate only the most specific category. Parent categories will be automatically added." + "\n\n" + "Examples: Sardines in olive oil, Orange juice from concentrate")
                        CategoryInputWidget(categories: $pageConfig.categories)
                    }).modifier(RoundedBackgroundCard())
                    
                    Spacer()
                    
                    Button("Scroll to Top") {
                        withAnimation {
                            proxy.scrollTo(ProductDetails.barcodeTag)
                        }
                    }
                    .padding()
                })
                .padding(20)
            }
        }
    }
}
