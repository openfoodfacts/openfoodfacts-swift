//
//  OrderedNutriment.swift
//
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

struct OrderedNutrients: Codable {
    let nutrients: [OrderedNutrient] = []

    enum CodingKeys: String, CodingKey {
        case nutrients
    }
}

struct OrderedNutrient: Codable {
    let id: String
    let name: String?
    let important: Bool
    let displayInEditForm: Bool
    let subNutrients: [OrderedNutrient]?
    
    func nname() -> String {
        return self.name ?? "Unknown"
    }
    
    func nunit() -> String {
        return (nutrientToUnit[self.id] ?? Unit.unknown).rawValue
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case important
        case displayInEditForm = "display_in_edit_form"
        case subNutrients = "nutrients"
    }
}
