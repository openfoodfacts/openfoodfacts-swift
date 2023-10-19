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
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    var onDelete: (() -> Void)?
    
    public var body: some View {
        HStack {
            if deletable && pageConfig.isNewMode {
                Button("", systemImage: "trash", action: {
                    onDelete?()
                })
            }
            VStack(alignment: .leading, content: {
                FloatingLabelTextField(
                    placeholder: nutrient.name,
                    text: $nutrient.value,
                    isRequired: pageConfig.isNewMode && ProductPageConfig.requiredNutrients.contains(nutrient.id))
                .numbersOnly($nutrient.value, includeDecimal: true)
                .disableAutocorrection(true)
                .disabled(pageConfig.isViewMode)
                Divider()
            })
            Spacer()
            Button(action: {
                if nutrient.currentUnit.isWeightUnit() { // verifies unit is present in nextWeightUnits
                    nutrient.currentUnit = nextWeightUnits[nutrient.currentUnit]!
                }
            }, label: {
                Text(nutrient.currentUnit.rawValue).padding().frame(width: 80, height: 30)
            }).background(Color.blue).cornerRadius(6).foregroundColor(Color.white).disabled(pageConfig.isViewMode)
        }
        .onAppear {
            if pageConfig.isNewMode {
                nutrient.currentUnit = pageConfig.nutrientsMeta?.nutrients?[nutrient.id]?.unit?.en ?? Unit.g
            }
        }
    }
}
