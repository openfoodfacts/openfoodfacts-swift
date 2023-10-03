//
//  User.swift
//
//  Usage:
//    do {
//        // Encoding
//        let user = User(comment: "some comment", userId: "user123", password: "password123")
//        let jsonData = try JSONEncoder().encode(user)
//        if let jsonString = String(data: jsonData, encoding: .utf8) {
//            print("JSON String : " + jsonString)
//        }
//
//        // Decoding
//        let decodedUser = try JSONDecoder().decode(User.self, from: jsonData)
//        print(decodedUser)
//    } catch let error {
//        print("Error: \(error)")
//    }
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

struct User: Codable {
    var comment: String?
    var userId: String
    var password: String

    enum CodingKeys: String, CodingKey {
        case comment
        case userId = "user_id"
        case password
    }
    
    func toMap() -> [String: String] {
        var user = [String: String]()
        user["comment"] = self.comment ?? ""
        user["userId"] = self.userId
        user["password"] = self.password
        
        return user
    }
}


