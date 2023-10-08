//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation
import UIKit

class OpenFoodAPIClient {
    
    public static let shared: OpenFoodAPIClient = {
        let instance = OpenFoodAPIClient()
        return instance
    }()

/// Returns the nutrient hierarchy specific to a country, localized.
/// ```dart
///   OrderedNutrients orderedNutrients =
///       await OpenFoodAPIClient.getOrderedNutrients(
///     country: OpenFoodFactsCountry.GERMANY,
///     language: OpenFoodFactsLanguage.ENGLISH,
///   );
///
///   print(orderedNutrients.nutrients[0].name);  // Energy (kJ)
///   print(orderedNutrients.nutrients[5].name);  // Fiber
///   print(orderedNutrients.nutrients[10].name); // Vitamin A
/// ```
    func getOrderedNutrients(country: OpenFoodFactsCountry, language: OpenFoodFactsLanguage) async throws -> OrderedNutrients {
        
        guard let uri = UriHelper.getPostUri(path: "/cgi/nutrients.pl") else {
            throw NSError(domain: "Couldn't compose uri for \(#function) call", code: 400)
        }
        
        let queryParameters: [String: String] = [
            "cc": country.rawValue,
            "lc": language.info.code
        ]
        
        do {
            let data = try await HttpHelper.shared.doPostRequest(uri: uri, body: queryParameters, addCredentialsToBody: false)
                    
            guard let jsonString = String(data: data, encoding: .utf8),
                  let jsonData = jsonString.data(using: .utf8) else {
                throw NSError(domain: "Couldn't convert JSON string to Data", code: 422)
            }
            let downloadedOrderedNutrients = try JSONDecoder().decode(OrderedNutrients.self, from: jsonData)
            return downloadedOrderedNutrients
        } catch {
            throw error
        }
    }
    
    /// cf. https://openfoodfacts.github.io/openfoodfacts-server/reference/api-v3/#get-/api/v3/taxonomy_suggestions
    /// //TODO: 1. extend with TagType taxonomyType, 2. use language / country
    /// Consider using [SuggestionManager].
    func getSuggestions(query: String = "", country: OpenFoodFactsCountry, language: OpenFoodFactsLanguage, limit: Int = 15) async throws -> [String] {
        
        let queryParameters: [String: String] = [
            "tagtype": "categories",
            "cc": country.rawValue,
            "lc": language.info.code,
            "string": query,
            "limit": "\(limit)",
        ]
        
        guard let uri = UriHelper.getUri(path: "/api/v3/taxonomy_suggestions", queryParameters: queryParameters) else {
            throw NSError(domain: "Couldn't compose uri for \(#function) call", code: 400)
        }
        
        do {
            let data = try await HttpHelper.shared.doGetRequest(uri: uri)
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw NSError(domain: "Couldn't convert JSON data to dictionary", code: 422)
            }
            
            var result: [String] = []
            
            if let suggestions = jsonObject["suggestions"] as? [Any] {
                for value in suggestions {
                    if let stringValue = value as? String {
                        result.append(stringValue)
                    }
                }
            }
            return result
        } catch {
            throw error
        }
    }
    
    func fetchProductImages(imageUrls: [ImageField: String?]) async throws -> [ImageField: UIImage] {
        var downloadedImages: [ImageField: UIImage] = [:]
        
        try await withThrowingTaskGroup(of: (ImageField, UIImage).self) { group in
            imageUrls.forEach { (key: ImageField, url: String?) in
                group.addTask {
                    return (key, try await self.fetchProductImage(withUrl: url))
                }
            }
            for try await (key, image) in group {
                downloadedImages[key] = image
            }
        }
        return downloadedImages
    }
    
    func fetchProductImage(withUrl url: String?) async throws -> UIImage 
    {
        guard let unwrappedUrl = url, let imgUrl = URL(string: unwrappedUrl) else { return UIImage() }
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: imgUrl))
            guard let downloadedImage = UIImage(data: data) else {
                return UIImage()
            }
            return downloadedImage
        } catch {
            throw NSError(domain: error.localizedDescription, code: 409)
        }
    }
    
    func fetchNutrientsMetadata() async throws -> NutrientMetadata 
    {
        guard let uri = UriHelper.getTaxonomiesUri(path: "/data/taxonomies/nutrients.json") else {
            throw NSError(domain: "Couldn't compose uri for \(#function) call", code: 400)
        }
        do {
            let data  = try await HttpHelper.shared.doGetRequest(uri: uri, addCredentialsToHeader: true)
            let nutrientsData = try JSONDecoder().decode(NutrientMetadata.self, from: data)
            return nutrientsData
        } catch {
            throw error
        }
    }
    
    func getProduct(config: ProductQueryConfiguration) async throws -> ProductResponse {
        
        let queryParameters = config.getParametersMap()
        
        guard let uriPath = UriHelper.getUri(path: "/api/v3/product/\(config.barcode)", queryParameters: queryParameters) else {
            throw NSError(domain: "Couldn't compose uri for \(#function) call", code: 400)
        }
        do {
            let data  = try await HttpHelper.shared.doGetRequest(uri: uriPath)
            let response = try JSONDecoder().decode(ProductResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    /// Add the given product to the database.
    ///
    /// Please read the language mechanics explanation if you intend to display
    /// or update data in specific language: https://github.com/openfoodfacts/openfoodfacts-dart/blob/master/DOCUMENTATION.md#about-languages-mechanics
    func saveProduct(product: [String: String]) async throws -> Status {
        
        var queryComponents = [String: String]()
        queryComponents.merge(OFFConfig.shared.globalUser?.toMap() ?? [:]) { (current, _) in current }
        queryComponents.merge(product) { (current, _) in current }
        
        queryComponents["lc"] = OFFConfig.shared.productsLanguage.rawValue
        queryComponents["cc"] = OFFConfig.shared.country.rawValue
        
        guard let saveProductUri = UriHelper.getPostUri(path: "/cgi/product_jqm2.pl") else {
            throw NSError(domain: "\(#function) couldn't construct uri", code: 409)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: saveProductUri))
            guard let dataStr = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "\(#function) missing data", code: 422)
            }
            return Status.fromApiResponse(dataStr)
        } catch {
            throw NSError(domain: error.localizedDescription, code: 409)
        }
    }
    
/// Send one image to the server.
/// The image will be added to the product specified in the SendImage
/// Returns a Status object as result.
///
/// ```dart
///   User myUser = User(userId: "username", password: "secret_password");
///
///   String barcode = "0000000000000";
///
///   SendImage image = SendImage(
///     lang: OpenFoodFactsLanguage.FRENCH,
///     barcode: barcode,
///     imageField: ImageField.FRONT,
///     imageUri: Uri.parse("path_to_my_image"),
///   );
///
///   Status status = await OpenFoodAPIClient.addProductImage(myUser, image);
///
///   if (status.status != 1) {
///     print(
///         "An error occured while sending the picture : ${status.statusVerbose}");
///     return;
///   }
///
///   print("Upload was successful");
/// ```
    func addProductImage(imageData: SendImage) async throws {
        
        guard let imageUri = UriHelper.getUri(path: "/cgi/product_image_upload.pl", addUserAgentParameters: false) else {
            throw NSError(domain: "Couldn't compose uri for \(#function) call", code: 400)
        }
        
        do {
            var response = try await HttpHelper.shared.doMultipartRequest(uri: imageUri, body: imageData.toJson(), sendImage: imageData)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    throw NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: ["Reason": httpResponse.statusCode.description])
                }
            }
        } catch {
            throw error
        }
    }
}
