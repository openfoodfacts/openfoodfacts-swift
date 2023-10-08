//
//  SendImage.swift
//   SendImage image = SendImage(
//     lang: OpenFoodFactsLanguage.FRENCH,
//     barcode: barcode,
//     imageField: ImageField.FRONT,
//     imageUri: Uri.parse("path_to_my_image"),
//   );
//  Created by Henadzi Rabkin on 03/10/2023.
//

import Foundation
import UIKit

enum ImageField: String, CaseIterable, Decodable {
   case front = "front"
   case nutrition = "nutrition"
   case ingredients = "ingredients"
//   case packaging = "packaging"
//   case other = "other"
   
   init(from decoder: Decoder) throws {
       let container = try decoder.singleValueContainer()
       let size = try container.decode(String.self)
       self = ImageField(rawValue: size) ?? .front
   }
}

struct SendImage {
    
    var barcode: String
    var image: UIImage?
    var imageUri: String?
    var imageField: ImageField
    
    init(barcode: String, image: UIImage, imageUri: String, imageField: ImageField = .front) {
        self.barcode = barcode
        self.image = image
        self.imageField = imageField
        self.imageUri = imageUri
    }
    
    func getImageDataKey() -> String {
        return "imgupload_\(imageField.rawValue)_\(OFFConfig.shared.productsLanguage.info.code)"
    }
    
    func getImageName() -> String {
        return "\(barcode)_\(imageField.rawValue)_\(OFFConfig.shared.productsLanguage.info.code)"
    }
    
    private func getImageFieldWithLang() -> String {
        return "\(imageField.rawValue)_\(OFFConfig.shared.productsLanguage.info.code)"
    }
    
    func toJson() -> [String: String] {
        return [
            "lc": OFFConfig.shared.productsLanguage.info.code,
            "code": barcode,
            "imagefield": getImageFieldWithLang()
        ]
    }
}
