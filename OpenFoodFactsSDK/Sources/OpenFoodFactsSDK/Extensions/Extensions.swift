//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 01/10/2023.
//

import Foundation
import UIKit

extension String? {
    
    func isAValidBarcode() -> Bool {
        guard let strLen = self?.count else {
            return false
        }
        return [7, 8, 12, 13].contains(strLen);
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
