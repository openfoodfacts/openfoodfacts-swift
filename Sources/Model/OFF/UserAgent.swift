//
//  UserAgent.swift
//
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

public struct UserAgent: Codable {
    
    var name: String?
    var version: String?
    var system: String?
    var comment: String?
    
    public init(name: String? = nil, version: String? = nil, system: String? = nil, comment: String? = nil) {
        self.name = name
        self.version = version
        self.system = system
        self.comment = comment
    }
    
    func toMap(with uuid: String) -> [String: String] {
        var userAgent = [String: String]()
        userAgent["app_name"] = self.name ?? ""
        userAgent["app_version"] = self.version ?? ""
        userAgent["app_uuid"] = uuid
        userAgent["app_platform"] = self.system ?? ""
        userAgent["comment"] = self.comment ?? ""
        
        return userAgent
    }
    
    func toString() -> String {
        var result = ""
        
        let mirror = Mirror(reflecting: self)
        for (index, child) in mirror.children.enumerated() {
            if let value = child.value as? String {
                result += "\(value)"
                if index < mirror.children.count - 1 {
                    result += "-"
                }
            }
        }
        
        return result
    }
}
