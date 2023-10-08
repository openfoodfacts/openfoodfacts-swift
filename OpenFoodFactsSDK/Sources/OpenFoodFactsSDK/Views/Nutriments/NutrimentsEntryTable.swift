//
//  NutrimentsEntryTable.swift
//
//
//  Created by Henadzi Rabkin on 06/10/2023.
//

import Foundation
import SwiftUI

public struct NutrimentsEntryTable: View {
    
    @EnvironmentObject private var pageConfig: ProductPageConfig
    
    @State private var showingModal = false
    @State private var required: [OrderedNutrient] = []
    
    public var body: some View {
        
        VStack(spacing: 10, content: {
            
            FloatingLabelTextField(placeholder: "Serving size, for e.g. 15g", text: $pageConfig.servingSize).required(isActive: pageConfig.isNewMode)
                .numbersOnly($pageConfig.servingSize, includeDecimal: true)
                .disableAutocorrection(true)
            PerWeightToggle(dataFor: $pageConfig.dataFor)
            
            ForEach(displayed(), id: \.id) { nutrient in
                NutrimentsEntryItem(deletable: !required.contains(nutrient), nutrient: nutrient) {
                    pageConfig.selectedNutrients.remove(nutrient.id)
                }.required(isActive: pageConfig.isNewMode && ProductPageConfig.requiredNutrients.contains(nutrient.id))
            }
            if pageConfig.isNewMode {
                Button(action: {
                    showingModal = true
                }) {
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                        Text("Add a nutrient")
                        Spacer()
                    }.frame(maxWidth: .infinity).padding()
                }
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(8)
            }
        })
        .onChange(of: pageConfig.orderedNutrients) { newValue in
            if let importantNutrients = pageConfig.orderedNutrients?.nutrients.filter({ $0.important && $0.displayInEditForm }) {
                self.required = importantNutrients
                pageConfig.selectedNutrients = Set(self.required.map { $0.id })
            }
        }
        .sheet(isPresented: $showingModal, content: {
            AddNutrimentsAlert(isPresented: $showingModal, selected: $pageConfig.selectedNutrients, items: notSelected())
        })
    }
    
    private func notSelected() -> [OrderedNutrient] {
        return pageConfig.orderedNutrients?.nutrients.filter { !pageConfig.selectedNutrients.contains($0.id) } ?? []
    }
    
    private func displayed() -> [OrderedNutrient] {
        return pageConfig.orderedNutrients?.nutrients.filter { pageConfig.selectedNutrients.contains($0.id) } ?? []
    }
}
