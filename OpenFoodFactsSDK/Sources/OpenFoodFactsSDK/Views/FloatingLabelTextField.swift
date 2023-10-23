//
//  FloatingLabelTextField.swift
//
//
//  Created by Henadzi Rabkin on 08/10/2023.
//

import Foundation
import SwiftUI

struct FloatingLabelTextField: View {
    
    var title: String?
    var placeholder: String
    
    @Binding var text: String
    
    var isRequired: Bool = false
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Text(placeholder)
                .foregroundColor(isFocused ? .blue : .gray)
                .offset(y: (isFocused || !text.isEmpty) ? -26 : 0)
                .font(.system(size: (isFocused || !text.isEmpty) ? 13 : 16))
                .required(isActive: isRequired && !isFocused && text.isEmpty)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                withAnimation {
                    isFocused = isEditing
                }
            })
            .clearButton(text: $text, isActive: pageConfig.isNewMode)
            .autocorrectionDisabled()
            .textFieldStyle(PlainTextFieldStyle())
            .focused($isFocused)
        }
        .padding([.top], 17)
    }
}
