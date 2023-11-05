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
            
            FloatingLabelTextField(title: "Serving size", placeholder: "Serving size, for e.g. 15g", text: $pageConfig.servingSize)
                .disableAutocorrection(true)
            PerWeightToggle(dataFor: $pageConfig.dataFor)
            
            ForEach(displayed(), id: \.id) { nutrient in
                NutrimentsEntryItem(deletable: !required.contains(nutrient), nutrient: nutrient) {
                    pageConfig.selectedNutrients.remove(nutrient.id)
                }
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
        .sheet(isPresented: $showingModal, content: {
            AddNutrimentsAlert(isPresented: $showingModal, selected: $pageConfig.selectedNutrients, items: notSelected())
        })
        .onAppear() {
            if pageConfig.isViewMode { return }
            
            self.required = pageConfig.orderedNutrients.filter({ $0.important && $0.displayInEditForm })
            pageConfig.selectedNutrients = Set(self.required.map { $0.id })
        }
    }
    
    private func notSelected() -> [OrderedNutrient] {
        return pageConfig.orderedNutrients.filter { !pageConfig.selectedNutrients.contains($0.id) }
    }
    
    private func displayed() -> [OrderedNutrient] {
        return pageConfig.orderedNutrients.filter { pageConfig.selectedNutrients.contains($0.id) }
    }
}
