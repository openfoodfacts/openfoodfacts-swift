//
//  HttpHelper.swift
//
//  General functions for sending http requests (post, get, multipart, ...)
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

class HttpHelper {
    
    static let shared = HttpHelper()
    static let userAgent = "iOS API"
    static let from = "anonymous"
    
    private init() {}
    
/// Send a http PATCH request to the specified uri.
///
/// The data / body of the request has to be provided as map. (key, value)
/// The result of the request will be returned as string.
    func doPatchRequest(uri: URL, body: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        
        var allQueryParams = body
        mergeWithUserAgent(baseDict: &allQueryParams)
        
        let requestBody = try? JSONSerialization.data(withJSONObject: allQueryParams, options: [])
        
        var request = URLRequest(url: uri)
        request.httpMethod = "PATCH"
        request.httpBody = requestBody
        request.allHTTPHeaderFields = buildHeaders(contentType: "application/json")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
/// Send a multipart post request to the specified uri.
/// The data / body of the request has to be provided as map. (key, value)
/// The files to send have to be provided as map containing the source file uri.
/// As result a json object of the "type" Status is expected.
    func doMultipartRequest(uri: URL, body: [String: String], sendImage: SendImage) async throws -> Data {
        
        var allQueryParams = body
        mergeWithGlobalUser(baseDict: &allQueryParams)
        mergeWithUserAgent(baseDict: &allQueryParams)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: uri)
        request.httpMethod = "POST"
        
        var data = Data()
        
        // Fields
        for (key, value) in allQueryParams {
            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            data.append("\(value)\r\n")
        }
        
        // Files
        if let fileData = sendImage.image.pngData() {
            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"\(sendImage.getImageDataKey())\"; filename=\"\(fileData.hashValue)\"\r\n")
            data.append("Content-Type: application/octet-stream\r\n\r\n")
            data.append(fileData)
            data.append("\r\n")
        }
        
        data.append("--\(boundary)--\r\n")
        
        request.httpBody = data
        request.allHTTPHeaderFields = buildHeaders(contentType: "multipart/form-data; boundary=\(boundary)")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            throw error
        }
    }
    
/// Send a http get request to the specified uri.
/// The data of the request (if any) has to be provided as parameter within the uri.
/// The result of the request will be returned as string.
/// By default the query will hit the PROD DB
    func doGetRequest(uri: URL, addCredentialsToHeader: Bool = false) async throws -> Data {
        var request = URLRequest(url: uri)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = buildHeaders(addCredentialsToHeader: addCredentialsToHeader)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            // Re-throw the error to be caught by the caller
            throw error
        }
    }
    
/// Send a http post request to the specified uri.
/// The data / body of the request has to be provided as map. (key, value)
/// The result of the request will be returned as string.
///
/// [addCredentialsToBody] should be only use for Robotoff,
/// See: https://github.com/openfoodfacts/openfoodfacts-dart/issues/553#issuecomment-1269810032
    func doPostRequest(uri: URL, body: [String: String], addCredentialsToBody: Bool, addCredentialsToHeader: Bool = false) async throws -> Data {
        
        var allQueryParams = body
        if addCredentialsToBody {
            mergeWithGlobalUser(baseDict: &allQueryParams)
        }
        mergeWithUserAgent(baseDict: &allQueryParams)
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = allQueryParams.map({ key, val in URLQueryItem(name: key, value: val) })
        
        var request = URLRequest(url: uri)
        request.httpMethod = "POST"
        request.httpBody = requestBodyComponents.percentEncodedQuery?.data(using: .utf8)
        request.allHTTPHeaderFields = buildHeaders(addCredentialsToHeader: addCredentialsToHeader)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            // Re-throw the error to be caught by the caller
            throw error
        }
    }
    
    private func buildHeaders(addCredentialsToHeader: Bool = false, contentType: String = "application/x-www-form-urlencoded") -> [String: String]? {
        var headers = [
            "Accept": "application/json",
            "Content-Type": contentType,
            "User-Agent": OFFConfig.shared.userAgent?.toString() ?? HttpHelper.userAgent,
            "From": OFFConfig.shared.globalUser?.userId ?? HttpHelper.from
        ]
        
        if addCredentialsToHeader, let myUser = OFFConfig.shared.globalUser {
            let userId = myUser.userId
            let password = myUser.password
            let credentialData = "\(userId):\(password)".data(using: .utf8)
            if let credentialData = credentialData {
                let token = credentialData.base64EncodedString(options: [])
                headers["Authorization"] = "Basic \(token)"
            }
        }
        return headers;
    }
    
    private func mergeWithUserAgent(baseDict: inout [String: String]) {
        var userAgentParams = [String: String]()

        if let agent = OFFConfig.shared.userAgent {
            userAgentParams = agent.toMap(with: OFFConfig.shared.uuid)
        }

        baseDict.merge(userAgentParams) { (current, _) in current }
    }
    
    private func mergeWithGlobalUser(baseDict: inout [String: String]) {
        var userParams = [String: String]()
        if let user = OFFConfig.shared.globalUser {
            userParams = user.toMap()
        }
        baseDict.merge(userParams) { (current, _) in current }
    }
}
