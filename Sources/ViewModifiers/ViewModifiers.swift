//
//  SwiftUIView.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import SwiftUI
import Combine

struct RoundedBackgroundCard: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(10).background(Color(UIColor.secondarySystemBackground)).cornerRadius(10)
    }
}

// Created for NumericTextFields
// by Stewart Lynch on 2022-12-18
// Using Swift 5.0
struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    var includeDecimal: Bool
    
    let separators = {
        var separators = [".", ","]
        if let local = Locale.current.decimalSeparator {
            separators.append(local)
        }
        return separators.joined()
    }()
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                if includeDecimal {
                    numbers += separators
                }
                if newValue.components(separatedBy: CharacterSet(charactersIn: separators)).count - 1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    var isActive: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty && isActive {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct RequiredField: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        HStack(alignment: .top) {
            if isActive && OFFConfig.shared.useRequired {
                Text("*").alignmentGuide(.top, computeValue: { dimension in
                    0
                })
            }
            content
        }.padding(0)
    }
}
