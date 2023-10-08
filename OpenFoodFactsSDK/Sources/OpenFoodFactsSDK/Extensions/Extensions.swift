//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 01/10/2023.
//

import Foundation
import UIKit
import SwiftUI

extension Binding where Value: Equatable {
    func isEqualTo(_ value: Value) -> Binding<Bool> {
        return Binding<Bool>(
            get: { self.wrappedValue == value },
            set: { if $0 { self.wrappedValue = value } }
        )
    }
}

extension View {
    
    func hidden(_ isActive: Bool) -> some View {
        opacity(isActive ? 0 : 1)
    }
    
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
    
    func clearButton(text: Binding<String>, isActive: Bool = true) -> some View {
        self.modifier(ClearButton(text: text, isActive: isActive))
    }
    
    func required(isActive: Bool = true) -> some View {
        self.modifier(RequiredField(isActive: isActive))
    }
}

public extension String {
    
    func isAValidBarcode() -> Bool {
        return [7, 8, 12, 13].contains(self.count)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

// To dismiss keyboard on tap outside TextField
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = (connectedScenes.first as? UIWindowScene)?.windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

extension UIImage {
    
    func isEmpty() -> Bool {
        return self.size == CGSize.zero
    }
    
    static let minimumWidth = 640.0
    static let minimumHeight = 160.0
    
    func isPictureBigEnough() -> Bool {
        return self.size.width >= UIImage.minimumWidth || self.size.height >= UIImage.minimumHeight
    }
}
