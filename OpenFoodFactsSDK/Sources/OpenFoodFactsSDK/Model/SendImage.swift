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

enum ImageField: String {
    case front = "front"
    case ingredients = "ingredients"
    case nutrition = "nutrition"
    case packaging = "packaging"
    case other = "other"
}

class SendImage {
    
    var lang: OpenFoodFactsLanguage?
    var barcode: String
    var imageUri: URL
    var imageField: ImageField
    
    init(lang: OpenFoodFactsLanguage?, barcode: String, imageUri: URL, imageField: ImageField = .other) {
        self.lang = lang
        self.barcode = barcode
        self.imageUri = imageUri
        self.imageField = imageField
    }
    
    func getImageDataKey() -> String {
        return "imgupload_\(imageField.rawValue)_\(self.lang?.rawValue ?? "")"
    }
    
    private func getImageFieldWithLang() -> String {
        return "\(imageField.rawValue)_\(self.lang?.rawValue ?? "")"
    }
    
    func toJson() -> [String: String] {
        return [
            "lc": lang?.rawValue ?? "",
            "code": barcode,
            "imagefield": getImageFieldWithLang()
        ]
    }
}
