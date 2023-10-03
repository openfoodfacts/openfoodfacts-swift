//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

enum OpenFoodAPIClientError: Error {
    case httpError
    case unknown
}

class OpenFoodAPIClient {
    
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
        
        guard let uri = UriHelper.getPostUri(path: "cgi/nutrients.pl") else {
            throw NSError(domain: "Couldn't compose uri for \(#function) call", code: 400)
        }
        
        let queryParameters: [String: String] = [
            "cc": country.rawValue,
            "lc": language.rawValue
        ]
        
        do {
            let data = try await HttpHelper.instance.doPostRequest(uri: uri, body: queryParameters, addCredentialsToBody: false)
                    
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
    func addProductImage(image: SendImage, completion: @escaping (Result<Status, Error>) -> Void) {
        var dataMap = [String: String]()
        var fileMap = [String: URL]()
        
        dataMap.merge(image.toJson()) { (current, _) in current }
        fileMap[image.getImageDataKey()] = image.imageUri
        
        guard let imageUri = UriHelper.getUri(path: "/cgi/product_image_upload.pl", addUserAgentParameters: false) else {
            print("Couldn't compose uri for \(#function) call")
            return
        }
        
        HttpHelper.instance.doMultipartRequest(uri: imageUri, body: dataMap, files: fileMap) { result in
            switch result {
            case .success(let status):
                completion(.success(status))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
