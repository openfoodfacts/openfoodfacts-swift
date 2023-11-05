//
//  AddNutrimentsAlert.swift
//
//
//  Created by Henadzi Rabkin on 06/10/2023.
//

import Foundation
import SwiftUI

struct AddNutrimentsAlert: View {
    
    @Binding var isPresented: Bool
    
    @Binding var selected: Set<String>
    @State private var localSelected = Set<String>()
    
    var items: [OrderedNutrient]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(items.filter { searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) }, selection: $localSelected) {
                Text($0.name)
            }
            .environment(\.editMode, .constant(EditMode.active))
            .navigationTitle("Add a nutrient")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isPresented = false
                        selected.formUnion(localSelected)
                        print("Selected IDs: \(selected)")
                    }
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search...") // TODO: verify warnings 
        Text("\(localSelected.count) selections")
    }
}
