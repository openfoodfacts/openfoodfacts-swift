//
//  SwiftUIView.swift
//  
//
//  Created by Henadzi Rabkin on 01/10/2023.
//

import SwiftUI

struct CategoryInputWidget: View {
    
    @State private var newCategory: String = ""
    @Binding var categories: [String]
    
    func addCategory() {
        DispatchQueue.main.async {
            if !newCategory.isEmpty {
                categories.append(newCategory)
                newCategory = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            // Input field for category
            HStack {
                TextField("Enter new category", text: $newCategory, onCommit: {
                    addCategory()
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    addCategory()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }.padding(.vertical,5)
            ForEach(categories, id: \.self) { category in
                HStack {
                    Text(category).padding(5)
                    Spacer()
                    Button(action: {
                        if let index = categories.firstIndex(of: category) {
                            categories.remove(at: index)
                        }
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .padding(.horizontal,20).padding(.vertical,5)
                .background(Color(UIColor.secondarySystemBackground)).cornerRadius(10)
            }
        }.padding(.vertical,5)
    }
}

#Preview {
    CategoryInputWidget(categories: .constant([String]()))
}
