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

extension Double {
    
    static var commonFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 18  // Or another maximum value as needed
        formatter.minimumFractionDigits = 0  // This will strip trailing zeros
        return formatter
    }()

    func toString() -> String {
        return Double.commonFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension String {
    
    func toDouble() -> Double? {
        return Double.commonFormatter.number(from: self)?.doubleValue
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
    
    func removingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
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

public extension [String: String]? {
    
    public func json() -> String {
        guard let dictionary = self else {
            return "Product is nil"
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return String(data: data, encoding: .utf8) ?? "Empty"
        } catch {
            return "Error serializing product: \(error)"
        }
    }
}

public extension [String: String] {
        
    public func json() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: data, encoding: .utf8) ?? "Empty"
        } catch {
            return "Error serializing product: \(error)"
        }
    }
    
    public func convertToProduct() -> Product? {
        do {
            var originalDictionary = self
            let prefix = "nutriment_"
            
            let modifiedDictionary = originalDictionary
                .filter { $0.key.hasPrefix(prefix) && !$0.key.hasSuffix("_unit") }
                .reduce(into: [String: String]()) { (result, keyValue) in
                    let newKey = keyValue.key.replacing(prefix, with: "")
                    result[newKey + "_\(self["nutrition_data_per"])"] = keyValue.value
                }
            
            let unmodifiedPart = originalDictionary.filter { !$0.key.hasPrefix(prefix) }
            let finalDictionary = unmodifiedPart.merging(modifiedDictionary) { (current, _) in current }
            
            let data = try JSONSerialization.data(withJSONObject: finalDictionary)
            let product = try JSONDecoder().decode(Product.self, from: data)
            return product
        } catch {
            print(error)
            return nil
        }
    }
}
