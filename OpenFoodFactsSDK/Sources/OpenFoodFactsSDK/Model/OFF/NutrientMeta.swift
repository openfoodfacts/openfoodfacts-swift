//
//  NutrientMeta.swift
//
//
//  Created by Henadzi Rabkin on 08/10/2023.
//

import Foundation

public enum Unit: String {
    case g, kcal, kj
    case milliG = "mg", microG = "µg", percentVol = "% vol"
    case percent = "%", mmol = "mmol/l", l = "l", milliL = "ml"
    case missing
    
    func isWeightUnit() -> Bool {
        return nextWeightUnits.keys.contains(self)
    }
    
    init?(fromString string: String) {
        let unitVariations: [String: Unit] = [
            "kcal": .kcal, "kCal": .kcal, "KCal": .kcal,
            "kj": .kj, "Kj": .kj, "kJ": .kj, "KJ": .kj,
            "g": .g, "G": .g,
            "mg": .milliG, "milli-gram": .milliG, "mG": .milliG,
            "mcg": .microG, "µg": .microG, "&#181;g": .microG,
            "&micro;g": .microG, "&#xb5;g": .microG,
            "ml": .milliL, "mL": .milliL, "Ml": .milliL, "ML": .milliL, "milli-liter": .milliL,
            "liter": .l, "L": .l, "l": .l,
            "%": .percent, "per cent": .percent, "percent": .percent,
            "μg": .microG
        ]
        
        if let unit = unitVariations[string] {
            self = unit
        } else {
            self = .missing
            print("Missing unit '\(string)'")
        }
    }
}

public struct UnitType: Codable {
    var en: Unit

    enum CodingKeys: String, CodingKey {
        case en = "en"
    }

    init(en: Unit) {
        self.en = en
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let enString = try container.decode(String.self, forKey: .en)
        
        guard let enValue = Unit(rawValue: enString) else {
            throw DecodingError.dataCorruptedError(forKey: .en, in: container, debugDescription: "Invalid unit value")
        }
        
        self.en = enValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(en.rawValue, forKey: .en)
    }
}

public struct NutrientMeta: Codable {
    
    public var unit: UnitType? // make it optional
    public var name: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case unit
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode 'name'
        self.name = try container.decode([String: String].self, forKey: .name)
        // Try decoding 'unit'; if it fails, set it to .missing
        if let unitDecoded = try? container.decode(UnitType.self, forKey: .unit) {
            self.unit = unitDecoded
        } else {
            self.unit = UnitType(en: .missing)
            print("Missing unit for \(String(describing: name["en"] ?? ""))")
        }
        
    }
}

public struct NutrientMetadata: Codable {
    public var nutrients: [String: NutrientMeta]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Decode the nutrients
        if let nutrientsDict = try? container.decode([String: NutrientMeta].self) {
            var cleanedDict: [String: NutrientMeta] = [:]
            
            // Remove "zz:" from each key
            for (key, value) in nutrientsDict {
                let cleanedKey = key.replacingOccurrences(of: "zz:", with: "")
                cleanedDict[cleanedKey] = value
            }
            
            self.nutrients = cleanedDict
        } else {
            self.nutrients = nil
        }
    }
}



