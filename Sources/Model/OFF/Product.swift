//
//  Product.swift
//
//
//  Created by Henadzi Rabkin on 17/10/2023.
//

import Foundation

public enum DataFor: String {
    case serving = "serving"
    case hundredG = "100g"
    
    func label() -> String {
        switch self {
        case .hundredG:
            return "per 100 g/ml"
        case .serving:
            return "per serving"
        }
    }
}

public struct Product: Codable, Equatable, Sendable {
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return  lhs.code == rhs.code &&
                lhs.productName == rhs.productName &&
                lhs.productNameEn == rhs.productNameEn &&
                lhs.brands == rhs.brands &&
                lhs.servingSize == rhs.servingSize &&
                lhs.servingQuantity == rhs.servingQuantity &&
                lhs.quantity == rhs.quantity &&
                lhs.packagingQuantity == rhs.packagingQuantity &&
                lhs.dataPer == rhs.dataPer &&
                lhs.categories == rhs.categories &&
                lhs.imageFront == rhs.imageFront &&
                lhs.imageIngredients == rhs.imageIngredients &&
                lhs.imageNutrition == rhs.imageNutrition &&
                lhs.nutriments?.count == rhs.nutriments?.count
    }
    
    public let code: String
    public let productName: String?
    public let productNameEn: String?
    public let brands: String?
    public let lang: OpenFoodFactsLanguage?
    public let quantity: String?
    public let packagingQuantity: Double
    public let packagingQuantityUnit: String
    public let servingSize: String?
    public let servingQuantity: Double
    public let servingQuantityUnit: String
    public let dataPer: String?
    public let categories: String?
    public var nutriments: [String: Any]?
    public let imageFront: String?
    public let imageIngredients: String?
    public let imageNutrition: String?
    public let keywords: [String]?
    public let novaGroup: Double?
    public let nutriScore: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case lang
        case brands
        case quantity
        case packagingQuantity = "product_quantity"
        case packagingQuantityUnit = "product_quantity_unit"
        case categories
        case images
        case productName = "product_name"
        case productNameEn = "product_name_en"
        case servingSize = "serving_size"
        case servingQuantity = "serving_quantity"
        case servingQuantityUnit = "serving_quantity_unit"
        case dataPer = "nutrition_data_per"
        case nutriments = "nutriments"
        case imageFront = "image_front_url"
        case imageIngredients = "image_ingredients_url"
        case imageNutrition = "image_nutrition_url"
        case novaGroup = "nova_group"
        case nutriScore = "nutriscore_grade"
        case keywords = "_keywords"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        brands = try container.decodeIfPresent(String.self, forKey: .brands)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        productNameEn = try container.decodeIfPresent(String.self, forKey: .productNameEn)
        quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
        servingSize = try container.decodeIfPresent(String.self, forKey: .servingSize)
        dataPer = try container.decodeIfPresent(String.self, forKey: .dataPer)
        categories = try container.decodeIfPresent(String.self, forKey: .categories)
        imageFront = try container.decodeIfPresent(String.self, forKey: .imageFront)
        imageIngredients = try container.decodeIfPresent(String.self, forKey: .imageIngredients)
        imageNutrition = try container.decodeIfPresent(String.self, forKey: .imageNutrition)
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords)
        nutriScore = try container.decodeIfPresent(String.self, forKey: .nutriScore)
        novaGroup = try container.decodeIfPresent(Double.self, forKey: .novaGroup)
        servingQuantityUnit = try container.decodeIfPresent(String.self, forKey: .servingQuantityUnit) ?? "g"
        packagingQuantityUnit = try container.decodeIfPresent(String.self, forKey: .packagingQuantityUnit) ?? "g"
        
        if let packagingQuantityValue = try? container.decode(Double.self, forKey: .packagingQuantity) {
            packagingQuantity = packagingQuantityValue
        } else if let packagingQuantityString = try? container.decode(String.self, forKey: .packagingQuantity) {
            let cleanedString = packagingQuantityString.filter { $0.isNumber || $0 == "." || $0 == "," }
            packagingQuantity = Double(cleanedString) ?? 0.0
            
        } else {
            packagingQuantity = 100
        }
        
        if let servingQuantityValue = try? container.decode(Double.self, forKey: .servingQuantity) {
            servingQuantity = servingQuantityValue
        } else if let servingQuantityString = try? container.decode(String.self, forKey: .servingQuantity) {
            let cleanedString = servingQuantityString.filter { $0.isNumber || $0 == "." || $0 == "," }
            servingQuantity = Double(cleanedString) ?? 0.0
        } else {
            servingQuantity = 100
        }
        
        if let nutrimentsContainer = try? container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .nutriments) {
            var nutriments: [String: Any] = [:]
            for key in nutrimentsContainer.allKeys {
                if let doubleValue = try? nutrimentsContainer.decode(Double.self, forKey: key) {
                    nutriments[key.stringValue] = doubleValue
                } else if let stringValue = try? nutrimentsContainer.decode(String.self, forKey: key) {
                    nutriments[key.stringValue] = stringValue
                }
            }
            self.nutriments = nutriments
        }
        if let langCode = try container.decodeIfPresent(String.self, forKey: .lang) {
            self.lang = OpenFoodFactsLanguage.allCases.first { $0.info.code == langCode }
        } else {
            self.lang = OpenFoodFactsLanguage.UNDEFINED
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encodeIfPresent(brands, forKey: .brands)
        try container.encodeIfPresent(productName, forKey: .productName)
        try container.encodeIfPresent(productNameEn, forKey: .productNameEn)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(packagingQuantity, forKey: .packagingQuantity)
        try container.encodeIfPresent(packagingQuantityUnit, forKey: .packagingQuantityUnit)
        try container.encodeIfPresent(servingSize, forKey: .servingSize)
        try container.encodeIfPresent(servingQuantity, forKey: .servingQuantity)
        try container.encodeIfPresent(servingQuantityUnit, forKey: .servingQuantityUnit)
        try container.encodeIfPresent(dataPer, forKey: .dataPer)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encodeIfPresent(imageFront, forKey: .imageFront)
        try container.encodeIfPresent(imageIngredients, forKey: .imageIngredients)
        try container.encodeIfPresent(imageNutrition, forKey: .imageNutrition)
        try container.encodeIfPresent(keywords, forKey: .keywords)
        try container.encodeIfPresent(lang?.rawValue, forKey: .lang)
        try container.encodeIfPresent(nutriScore, forKey: .nutriScore)
        try container.encodeIfPresent(novaGroup, forKey: .novaGroup)
        
        if let nutriments = self.nutriments {
            var nutrimentsContainer = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .nutriments)
            for (key, value) in nutriments {
                let key = AnyCodingKey(stringValue: key)!
                switch value {
                case let doubleValue as Double:
                    try nutrimentsContainer.encode(doubleValue, forKey: key)
                case let stringValue as String:
                    try nutrimentsContainer.encode(stringValue, forKey: key)
                default:
                    break
                }
            }
        }
        
        try container.encodeIfPresent(lang?.info.code, forKey: .lang)
    }
}

private struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
    
    init(_ key: CodingKey) {
        self.stringValue = key.stringValue
        self.intValue = key.intValue
    }
}
