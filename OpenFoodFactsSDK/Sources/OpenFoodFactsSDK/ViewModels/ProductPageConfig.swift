//
//  EditProductPageViewModel.swift
//
//
//  Created by Henadzi Rabkin on 08/10/2023.
//
import SwiftUI

enum ProductPageState {
    case view
    case new
}

class ProductPageConfig: ObservableObject {
    
    static let requiredNutrients = ["energy-kcal", "proteins", "carbohydrates", "fat"]
    static let requiredImageFields = [ ImageField.front, ImageField.nutrition ]
    
    @Published var pageState = ProductPageState.new // TODO: workaround until editing will be implemented
    
    @Published var nutrientsMeta: NutrientMetadata?
    @Published var orderedNutrients: OrderedNutrients?
    
    @Published var isInitialised: Bool = false
    
    @Published var productName = ""
    @Published var brand = ""
    @Published var categories: [String] = []
    @Published var weight = ""
    @Published var servingSize = ""
    @Published var selectedNutrients: Set<String> = [] // ids
    @Published var dataFor = DataFor.hundredG
    @Published var packageLanguage = OFFConfig.shared.productsLanguage {
        didSet {
            OFFConfig.shared.productsLanguage = packageLanguage
            print("Package language update to \(OFFConfig.shared.productsLanguage)")
        }
    }
    @Published var images = Dictionary(uniqueKeysWithValues: ImageField.allCases.map { ($0, UIImage()) })
    
    
    @Published var errorMessage: NSError?
    
    func binding(for key: ImageField) -> Binding<UIImage> {
        return Binding<UIImage>(
            get: { self.images[key] ?? UIImage() },
            set: { newValue in self.images[key] = newValue }
        )
    }
    
    var isViewMode: Bool {
        return pageState == .view
    }
    var isNewMode: Bool {
        return pageState == .new
    }
    
    @MainActor
    func fetchData(barcode: String) async {
        await downloadEditorNutrients()
        await getProduct(barcode: barcode)
        if isNewMode {
            await fetchNutrientsMetada()
        }
        self.isInitialised = true
    }
    
    @MainActor
    private func fetchNutrientsMetada() async {
        
        do {
            self.nutrientsMeta = try await OpenFoodAPIClient.shared.fetchNutrientsMetadata()
        } catch {
            self.errorMessage = NSError(domain: "Error occurred: \(error.localizedDescription)", code: 409)
        }
    }
    
    @MainActor
    private func getProduct(barcode: String) async {
        do {
            let productResponse = try await OpenFoodAPIClient.shared.getProduct(
                config: ProductQueryConfiguration(barcode: barcode)
            )
            if productResponse.hasProduct(), let product = productResponse.product {
                self.pageState = .view
                await self.unwrapExistingProduct(product: product)
            } else {
                self.pageState = .new
            }
        } catch {
            self.errorMessage = NSError(domain: "Error occurred: \(error.localizedDescription)", code: 409)
        }
    }
    
    @MainActor
    func downloadEditorNutrients() async {
        do {
            let downloadedOrderedNutrients = try await OpenFoodAPIClient.shared.getOrderedNutrients(
                country: OFFConfig.shared.country,
                language: OFFConfig.shared.uiLanguage)
            self.orderedNutrients = downloadedOrderedNutrients
        } catch {
            self.errorMessage = NSError(domain: "Couldn't download nutrients", code: 409)
        }
    }
    
    /// Bare minimum marked with .required() view modifier
    func getMissingFields() -> [String] {
        var missingFields = [String]()
        
        if productName.isEmpty { missingFields.append("Name") }
        if weight.isEmpty { missingFields.append("Weight") }
        if servingSize.isEmpty { missingFields.append("Serving size") }
        if images[ImageField.front]!.isEmpty() { missingFields.append("Front image") }
        if images[ImageField.nutrition]!.isEmpty() { missingFields.append("Nutrients image") }
        
        let reqNutrientsSet = Set(ProductPageConfig.requiredNutrients)
        if let nutrients = orderedNutrients?.nutrients, !selectedNutrients.isSuperset(of: reqNutrientsSet) {
            let missingNutrients = reqNutrientsSet.subtracting(selectedNutrients)
            missingNutrients.forEach { id in
                missingFields.append("Nutrient \(String(describing: nutrients.filter({ $0.id == id }).first?.name))")
            }
        }
        
        return missingFields
    }
    
    @MainActor
    func unwrapExistingProduct(product: Product) async {
        
        self.productName = product.productName ?? ""
        self.brand = product.brands ?? ""
        // ?.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
        if let cats = product.categories {
            self.categories = [ cats ]
        }
        self.weight = product.quantity ?? ""
        self.servingSize = product.servingSize ?? ""
        
        self.dataFor = DataFor(rawValue: product.dataPer ?? "") ?? DataFor.hundredG
        self.packageLanguage = product.lang ?? OpenFoodFactsLanguage.UNDEFINED
        
        if let nutrients = orderedNutrients?.nutrients, let productNutrients = product.nutriments {
            for on in nutrients {
                let key = "\(on.id)_\(self.dataFor.rawValue)"
                let unitKey = "\(key)_unit"
                
                if productNutrients.keys.contains(unitKey), 
                    let unitStr = productNutrients[unitKey] as? String,
                    let unit = Unit(fromString: unitStr) {
                    on.currentUnit = unit
                }
                let hasKey = productNutrients.keys.contains(key)
                if hasKey, let value = productNutrients[key] as? Double {
                    on.value = String(describing: value)
                }
                on.displayInEditForm = hasKey
                on.important = hasKey
                if hasKey {
                    selectedNutrients.insert(on.id)
                }
            }
        }
        
        let imageUrls = [
            ImageField.front: product.imageFront,
            ImageField.ingredients: product.imageIngredients,
            ImageField.nutrition: product.imageNutrition
        ]
        do {
            self.images = try await OpenFoodAPIClient.shared.fetchProductImages(imageUrls: imageUrls)
        } catch {
            print("\(#function) failed to unwrap some images, \(error)")
        }
    }
    
    func composeSendProduct(barcode: String) -> [String: Any] {
        
        var productNutrients = orderedNutrients?.nutrients.filter { selectedNutrients.contains($0.id) } ?? []
        
        let nuntrients = productNutrients.reduce(into: [String: Double]()) { (result, element) in
            if let doubleValue = Double(element.value) {
                result["\(element.id)_\(dataFor.rawValue)"] = element.convertWeightToG(doubleValue)
            }
        }
        
        var product = [
            "code": barcode,
            "brands": brand,
            "lang": OFFConfig.shared.productsLanguage.rawValue,
            "quantity": self.weight,
            "serving_size": self.servingSize,
            "nutrition_data_per": self.dataFor.rawValue,
            "categories": categories.joined(separator: ","),
            "nutrients": nuntrients
        ] as [String: Any]
        
        // Debug
        print("\(#function): \(product)")
        
        return product
    }
}
