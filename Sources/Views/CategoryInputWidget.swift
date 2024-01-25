//
//  SwiftUIView.swift
//
//
//.scrollTargetLayout()
//.scrollTargetBehavior(.viewAligned)
//.safeAreaPadding(.horizontal, 10)
//
//  Created by Henadzi Rabkin on 01/10/2023.
//

import SwiftUI
import Combine

struct CategoryInputWidget: View {
    
    @EnvironmentObject var pageConfig: ProductPageConfig
    @StateObject private var viewModel = CategoryInputWidgetModel()
    
    @Binding var categories: [String]
    
    func addCategory() {
        DispatchQueue.main.async {
            if !viewModel.newCategory.isEmpty {
                categories.append(viewModel.newCategory)
                viewModel.newCategory = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            // Input field for category
            if pageConfig.isNewMode {
                HStack {
                    // $viewModel.editing, $viewModel.newCategory, $viewModel.suggestions
                    TextField("Enter new category", text: $viewModel.newCategory, onEditingChanged: { isEditing in
                        viewModel.editing = isEditing
                    }, onCommit: {
                        addCategory()
                    })
                    .clearButton(text: $viewModel.newCategory, isActive: pageConfig.isNewMode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled()
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            if (viewModel.editing) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                            Button(action: {
                                                viewModel.newCategory = suggestion
                                            }) {
                                                Text(suggestion).padding(.vertical,3).padding(.horizontal,5)
                                            }
                                            .background(Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(6)
                                            .foregroundColor(Color(UIColor.secondaryLabel))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        addCategory()
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .padding(.vertical,5)
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
            } else if let categoriesStr = categories.first {
                Text(categoriesStr).padding(5)
            }
        }
        .padding(.vertical,5)
    }
}

#Preview {
    CategoryInputWidget(categories: .constant([String]()))
}
