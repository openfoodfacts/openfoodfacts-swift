//
//  ProductResponse.swift
//
//
//  Created by Henadzi Rabkin on 17/10/2023.
//

import Foundation

public struct ProductResponse: Decodable {
    
    /// Possible value for [status]: the operation failed.
    static let statusFailure = "failure"

    /// Possible value for [status]: the operation succeeded with warnings.
    static let statusWarning = "success_with_warnings"

    /// Possible value for [status]: the operation succeeded.
    static let statusSuccess = "success"

    /// Possible value for [result.id]: product found
    static let resultProductFound = "product_found"

    /// Possible value for [result.id]: product not found
    static let resultProductNotFound = "product_not_found"
    
    public let barcode: String?
    public let status: String?
    public let product: Product?
    
    enum CodingKeys: String, CodingKey {
        case barcode = "code"
        case status
        case product
    }
    
    func hasProduct() -> Bool {
        guard let status = self.status else { return false }
        return status == ProductResponse.resultProductFound || status == ProductResponse.statusSuccess || status == ProductResponse.statusWarning
    }
}
