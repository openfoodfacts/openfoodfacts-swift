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
