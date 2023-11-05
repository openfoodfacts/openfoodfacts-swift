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
            return "per 100 g"
        case .serving:
            return "per serving"
        }
    }
}

public struct Product: Decodable {
    
    let code: String
    let productName: String?
    let brands: String?
    let lang: OpenFoodFactsLanguage?
    let quantity: String?
    let servingSize: String?
    let dataPer: String?
    let categories: String?
    var nutriments: [String: Any]?
    let imageFront: String?
    let imageIngredients: String?
    let imageNutrition: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case lang
        case brands
        case quantity
        case categories
        case images
        case productName = "product_name"
        case servingSize = "serving_size"
        case dataPer = "nutrition_data_per"
        case nutriments = "nutriments"
        case imageFront = "image_front_url"
        case imageIngredients = "image_ingredients_url"
        case imageNutrition = "image_nutrition_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        brands = try container.decodeIfPresent(String.self, forKey: .brands)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
        servingSize = try container.decodeIfPresent(String.self, forKey: .servingSize)
        dataPer = try container.decodeIfPresent(String.self, forKey: .dataPer)
        categories = try container.decodeIfPresent(String.self, forKey: .categories)
        imageFront = try container.decodeIfPresent(String.self, forKey: .imageFront)
        imageIngredients = try container.decodeIfPresent(String.self, forKey: .imageIngredients)
        imageNutrition = try container.decodeIfPresent(String.self, forKey: .imageNutrition)
        
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
}
