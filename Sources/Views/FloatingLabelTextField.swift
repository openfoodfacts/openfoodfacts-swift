//
//  FloatingLabelTextField.swift
//
//
//  Created by Henadzi Rabkin on 08/10/2023.
//

import Foundation
import SwiftUI

enum FloatingLabelTextFieldMode {
    case onlyDigits, alpha
}

struct FloatingLabelTextField: View {
    
    var title: String?
    var placeholder: String
    
    @Binding var text: String
    
    var isRequired: Bool = false
    var mode = FloatingLabelTextFieldMode.alpha
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    
    var widget: some View {
        TextField("", text: $text, onEditingChanged: { isEditing in
            withAnimation {
                isFocused = isEditing
            }
        })
        .clearButton(text: $text, isActive: pageConfig.isNewMode)
        .autocorrectionDisabled()
        .disableAutocorrection(true)
        .textFieldStyle(PlainTextFieldStyle())
        .focused($isFocused)
        .disabled(pageConfig.isViewMode)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Text(placeholder)
                .foregroundColor(isFocused ? .blue : .gray)
                .offset(y: (isFocused || !text.isEmpty) ? -26 : 0)
                .font(.system(size: (isFocused || !text.isEmpty) ? 13 : 16))
                .required(isActive: isRequired && !isFocused && text.isEmpty)
            
            if mode == .onlyDigits {
                widget.numbersOnly($text, includeDecimal: true)
            } else {
                widget
            }
        }
        .padding([.top], 17)
    }
}
