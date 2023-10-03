//
//  UserAgent.swift
//
//    do {
//        // Encoding
//        let userAgent = UserAgent(name: "AgentName", version: "1.0", system: "iOS", url: "http://example.com", comment: "Some comment")
//        let jsonData = try JSONEncoder().encode(userAgent)
//        if let jsonString = String(data: jsonData, encoding: .utf8) {
//            print("JSON String : " + jsonString)
//        }
//
//        // Decoding
//        let decodedUserAgent = try JSONDecoder().decode(UserAgent.self, from: jsonData)
//        print(decodedUserAgent)
//    } catch let error {
//        print("Error: \(error)")
//    }
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

struct UserAgent: Codable {
    
    var name: String?
    var version: String?
    var system: String?
    var url: String?
    var comment: String?
    
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
        for child in mirror.children {
            if let value = child.value as? String {
                result += " - \(value)"
            }
        }
        
        return result
    }
}
