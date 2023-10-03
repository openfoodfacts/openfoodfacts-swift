//
//  Status.swift
//
//
//  Created by Henadzi Rabkin on 03/10/2023.
//

import Foundation

struct Status: Codable {
    static let wrongUserOrPasswordErrorMessage = "Incorrect user name or password"

    let status: Int?
    let statusVerbose: String?
    let body: String?
    let error: String?
    let imageId: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusVerbose = "status_verbose"
        case body
        case error
        case imageId = "imgid"
    }
    
    init(status: Int? = nil, statusVerbose: String? = nil, body: String? = nil, error: String? = nil, imageId: Int? = nil) {
        self.status = status
        self.statusVerbose = statusVerbose
        self.body = body
        self.error = error
        self.imageId = imageId
    }
    
    static func fromApiResponse(_ responseBody: String) -> Status {
        do {
            let jsonData = Data(responseBody.utf8)
            let status = try JSONDecoder().decode(Status.self, from: jsonData)
            return status
        } catch {
            return Status(
                status: 400,
                statusVerbose: createStatusVerbose(responseBody: responseBody, exception: error),
                body: responseBody,
                error: nil,
                imageId: nil
            )
        }
    }

    static func createStatusVerbose(responseBody: String, exception: Error) -> String {
        if responseBody.contains(wrongUserOrPasswordErrorMessage) {
            return wrongUserOrPasswordErrorMessage
        } else {
            return exception.localizedDescription
        }
    }
    
    func isWrongUsernameOrPassword() -> Bool {
        return statusVerbose == Status.wrongUserOrPasswordErrorMessage
    }
}
