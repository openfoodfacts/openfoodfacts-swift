//
//  OrderedNutrientsCache.swift
//
//
//  Created by Henadzi Rabkin on 03/10/2023.
//

import Foundation

struct OrderedNutrientsCacheError: LocalizedError {
    
    let description: String?
    
    init(description: String? = nil) {
        self.description = description
    }
    
    var errorDescription: String? {
        return self.description ?? "An unknown error occurred."
    }
}

class OrderedNutrientsCache: ObservableObject {
    
    @Published var orderedNutrients: OrderedNutrients?
    @Published var error: OrderedNutrientsCacheError?
    
    private var api = OpenFoodAPIClient()
    private static let cacheKey = "OrderedNutrientsCacheKey"
    
    // Save data to UserDefaults
    private func save(orderedNutrients: OrderedNutrients) {
        if let dataToCache = try? JSONEncoder().encode(orderedNutrients) {
            UserDefaults.standard.set(dataToCache, forKey: Self.cacheKey)
        }
    }
    
    @MainActor
    private func download() async {
        do {
            let downloadedOrderedNutrients = try await api.getOrderedNutrients(
                country: OpenFoodAPIConfiguration.instance.country,
                language: OpenFoodAPIConfiguration.instance.language)
            self.save(orderedNutrients: downloadedOrderedNutrients)
            self.orderedNutrients = downloadedOrderedNutrients
        } catch {
            self.error = OrderedNutrientsCacheError(description: error.localizedDescription)
        }
    }
    
    @MainActor
    func getCache() async -> Void {
        self.error = nil
        
        if let cachedData = UserDefaults.standard.data(forKey: Self.cacheKey),
           let cachedNutrients = try? JSONDecoder().decode(OrderedNutrients.self, from: cachedData) {
            self.orderedNutrients = cachedNutrients
        } else {
            await download()
        }
    }
    
    // Generate the key to save to UserDefaults
    private func getKey() -> String {
        let country = OpenFoodAPIConfiguration.instance.country.rawValue
        let language = OpenFoodAPIConfiguration.instance.language.rawValue
        return "nutrients.pl/\(country)/\(language)/PROD"
    }
}
