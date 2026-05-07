//
//  OrderedNutriment.swift
//
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

let conversionFactorFromG: [Unit: Double] = [
    Unit.milliG: 1E3,
    Unit.microG: 1E6
]

let nextWeightUnits: [Unit: Unit] = [
   Unit.g: Unit.milliG,
   Unit.milliG: Unit.microG,
   Unit.microG: Unit.g,
]

public struct OrderedNutrients: Codable, Equatable {
    let nutrients: [OrderedNutrient]

    enum CodingKeys: String, CodingKey {
        case nutrients
    }
}

public class OrderedNutrient: ObservableObject, Codable, Equatable, Identifiable, CustomStringConvertible {
    public let id: String
    let name: String
    var important: Bool
    var displayInEditForm: Bool
    let subNutrients: [OrderedNutrient]?
    
    // user entered
    @Published var value: String = ""
    @Published var currentUnit: Unit = .g
    
    public static func == (lhs: OrderedNutrient, rhs: OrderedNutrient) -> Bool {
        return lhs.id == rhs.id  // or whatever properties you think define equality
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case important
        case displayInEditForm = "display_in_edit_form"
        case subNutrients = "nutrients"
    }
    
    func convertWeightToG(_ value: Double) -> Double {
        
        if let factor = conversionFactorFromG[self.currentUnit] {
            return value / factor
        }
        return value
    }
    
    func convertWeightFromG(_ value: Double) -> Double {
        
        if let factor = conversionFactorFromG[self.currentUnit] {
            return value * factor
        }
        return value
    }
    
    public var description: String {
        return "OrderedNutrient(id: \(id), name: \(name), important: \(important), displayInEditForm: \(displayInEditForm), currentUnit: \(currentUnit), value: \(value))"
    }
}

// MARK: - Sendable snapshot

/// Immutable, `Sendable` projection of an `OrderedNutrient` for
/// passing across actor boundaries (Swift 6 strict concurrency).
/// `OrderedNutrient` itself can't be `Sendable` because it's an
/// `ObservableObject` with `@Published` mutable state.
public struct OrderedNutrientSnapshot: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let important: Bool
    public let displayInEditForm: Bool
    public let subNutrients: [OrderedNutrientSnapshot]?

    public init(id: String, name: String, important: Bool,
                displayInEditForm: Bool, subNutrients: [OrderedNutrientSnapshot]? = nil) {
        self.id = id
        self.name = name
        self.important = important
        self.displayInEditForm = displayInEditForm
        self.subNutrients = subNutrients
    }
}

public extension OrderedNutrient {
    /// Build a `Sendable` snapshot of this nutrient (and its subtree).
    func snapshot() -> OrderedNutrientSnapshot {
        OrderedNutrientSnapshot(
            id: id,
            name: name,
            important: important,
            displayInEditForm: displayInEditForm,
            subNutrients: subNutrients?.map { $0.snapshot() }
        )
    }
}

public extension Array where Element: OrderedNutrient {
    /// Convenience: snapshot a whole array.
    func snapshots() -> [OrderedNutrientSnapshot] {
        self.map { $0.snapshot() }
    }
}
