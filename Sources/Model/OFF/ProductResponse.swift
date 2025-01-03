//
//  ProductResponse.swift
//
//
//  Created by Henadzi Rabkin on 17/10/2023.
//

import Foundation

public struct ProductResponse: Decodable {
    
    /// Possible value for [status]: the operation failed.
    public static let statusFailure = "failure"

    /// Possible value for [status]: the operation succeeded with warnings.
    public static let statusWarning = "success_with_warnings"

    /// Possible value for [status]: the operation succeeded.
    public static let statusSuccess = "success"

    /// Possible value for [result.id]: product found
    public static let resultProductFound = "product_found"

    /// Possible value for [result.id]: product not found
    public static let resultProductNotFound = "product_not_found"
    
    public let barcode: String?
    public let status: Int?
    public let statusVerbose: String?
    public let product: Product?
    
    public enum CodingKeys: String, CodingKey {
        case barcode = "code"
        case status
        case product
        case statusVerbose = "status_verbose"
    }
    
    public func hasProduct() -> Bool {
        guard let status = self.statusVerbose else { return false }
        return status == ProductResponse.resultProductFound || status == ProductResponse.statusSuccess || status == ProductResponse.statusWarning
    }
}

public struct ProductResponseV3: Decodable {
    
    /// Possible value for [status]: the operation failed.
    public static let statusFailure = "failure"

    /// Possible value for [status]: the operation succeeded with warnings.
    public static let statusWarning = "success_with_warnings"

    /// Possible value for [status]: the operation succeeded.
    public static let statusSuccess = "success"

    /// Possible value for [result.id]: product found
    public static let resultProductFound = "product_found"

    /// Possible value for [result.id]: product not found
    public static let resultProductNotFound = "product_not_found"
    
    public let barcode: String?
    public let status: String?
    public let product: Product?
    
    public enum CodingKeys: String, CodingKey {
        case barcode = "code"
        case status
        case product
    }
    
    public func hasProduct() -> Bool {
        guard let status = self.status else { return false }
        return status == ProductResponse.resultProductFound || status == ProductResponse.statusSuccess || status == ProductResponse.statusWarning
    }
}
