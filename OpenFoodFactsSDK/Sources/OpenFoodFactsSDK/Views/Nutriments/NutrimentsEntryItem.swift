//
//  NutrimentsEntryItem.swift
//
//
//  Created by Henadzi Rabkin on 06/10/2023.
//

import Foundation
import SwiftUI

struct NutrimentsEntryItem: View {
    
    var deletable: Bool
    
    @ObservedObject var nutrient: OrderedNutrient
    @EnvironmentObject var productConfig: ProductPageConfig
    
    var onDelete: (() -> Void)?
    
    public var body: some View {
        HStack {
            if deletable && productConfig.isNewMode {
                Button("", systemImage: "trash", action: {
                    onDelete?()
                })
            }
            VStack(alignment: .leading, content: {
                FloatingLabelTextField(placeholder: nutrient.name, text: $nutrient.value)
                    .numbersOnly($nutrient.value, includeDecimal: true)
                    .disableAutocorrection(true)
                    .disabled(productConfig.isViewMode)
                Divider()
            })
            Spacer()
            Button(action: {
                if nutrient.currentUnit.isWeightUnit() { // verifies unit is present in nextWeightUnits
                    nutrient.currentUnit = nextWeightUnits[nutrient.currentUnit]!
                }
            }, label: {
                Text(nutrient.currentUnit.rawValue).padding().frame(width: 80, height: 30)
            }).background(Color.blue).cornerRadius(6).foregroundColor(Color.white).disabled(productConfig.isViewMode)
        }
        .onAppear {
            if productConfig.isNewMode {
                nutrient.currentUnit = productConfig.nutrientsMeta?.nutrients?[nutrient.id]?.unit?.en ?? Unit.g
            }
        }
    }
}
