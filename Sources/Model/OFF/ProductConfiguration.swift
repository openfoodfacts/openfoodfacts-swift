//
//  ProductConfiguration.swift
//
//
//  Created by Henadzi Rabkin on 17/10/2023.
//

import Foundation

public struct ProductQueryConfiguration {
    let barcode: String
    var languages: [OpenFoodFactsLanguage]
    var fields: [ProductField]?
    
    public init(barcode: String,
         languages: [OpenFoodFactsLanguage] = [],
         country: OpenFoodFactsCountry? = nil,
         fields: [ProductField]? = nil) {
        self.barcode = barcode
        self.languages = languages
        self.fields = fields
    }
    
    func getParametersMap() -> [String: String] {
        var result = [String: String]()
        
        let queryLanguages = [OpenFoodFactsLanguage]()
        if !queryLanguages.isEmpty {
            result["lc"] = queryLanguages.map { $0.info.code }.joined(separator: ",")
            result["tags_lc"] = queryLanguages.first?.info.code ?? ""
        }
        
        result["cc"] = OFFConfig.shared.country.rawValue
        
        if let flds = fields {
            let ignoreFieldsFilter = flds.contains { $0 == ProductField.all }
            if !ignoreFieldsFilter {
                let fieldsStrings = convertFieldsToStrings(fields: flds, languages: queryLanguages)
                result["fields"] = fieldsStrings.joined(separator: ",")
            }
        }
        
//        var filterTagCount = 0
//        for p in additionalParameters {
//            if let tf = p as? TagFilter {
//                result["tagtype_\(filterTagCount)"] = tf.getTagType()
//                result["tag_contains_\(filterTagCount)"] = tf.getContains()
//                result["tag_\(filterTagCount)"] = tf.getTagName()
//                filterTagCount += 1
//            } else {
//                result[p.getName()] = p.getValue()
//            }
//        }
        
        return result
    }
    
    private func convertFieldsToStrings(fields: [ProductField], languages: [OpenFoodFactsLanguage]) -> [String] {
        var fieldsStrings: [String] = []
        
        let fieldsInLanguages: [ProductField] = [
            .categoriesTagsInLanguages,
            .labelsTagsInLanguages,
            .nameInLanguages,
            .countriesTagsInLanguages,
            .ingredientsTextInLanguages,
            .packagingTextInLanguages,
            .ingredientsTagsInLanguages,
            .imagesFreshnessInLanguages
        ]
        
        for field in fields {
            if fieldsInLanguages.contains(field) {
                for language in languages {
                    fieldsStrings.append("\(field.rawValue)\(language.info.code)")
                }
            } else {
                fieldsStrings.append(field.rawValue)
            }
        }
        
        return fieldsStrings
    }
}
