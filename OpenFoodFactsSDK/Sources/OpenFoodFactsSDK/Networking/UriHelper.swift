//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

class UriHelper {
    
    private init() {}
    
    static func getUri(
        path: String,
        queryParameters: [String: String]? = nil,
        addUserAgentParameters: Bool = true
    ) -> URL? {
        
        var userAgentParams = [String: String]()
        if addUserAgentParameters, let agent = OpenFoodAPIConfiguration.instance.userAgent {
            userAgentParams = agent.toMap(with: OpenFoodAPIConfiguration.instance.uuid)
        }
        let allQueryParams = queryParameters?.merging(userAgentParams) { (current, _) in current }
        
        var components = URLComponents()
        components.scheme = OpenFoodAPIConfiguration.scheme
        components.host = OpenFoodAPIConfiguration.uriProdHost
        components.path = path
        components.queryItems = allQueryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    }
    
    static func getPostUri(path: String) -> URL? {
        return UriHelper.getUri(path: path, addUserAgentParameters: false)
    }
    
    static func getPatchUri(path: String) -> URL? {
        return getUri(path: path, addUserAgentParameters: false)
    }
    
    static func getRobotoffUri(path: String, queryParameters: [String: String]?) -> URL? {
        var components = UriHelper.baseComponents(path: path, from: queryParameters)
        components.host = OpenFoodAPIConfiguration.uriProdHostRobotoff
        return components.url
    }
    
    static func getFolksonomyUri(path: String, queryParameters: [String: String]?) -> URL? {
        var components = UriHelper.baseComponents(path: path, from: queryParameters)
        components.host = OpenFoodAPIConfiguration.uriProdHostFolksonomy
        return components.url
    }
    
    static func getEventsUri(path: String, queryParameters: [String: String]?) -> URL? {
        var components = UriHelper.baseComponents(path: path, from: queryParameters)
        components.host = OpenFoodAPIConfiguration.uriProdHostEvents
        return components.url
    }
    
    private static func baseComponents(path: String, from queryParameters: [String: String]?) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenFoodAPIConfiguration.scheme
        components.path = path
        components.queryItems = queryParameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components
    }
    
    // TODO: verify why this shit is needed
    static func replaceSubdomain(uri: URL) -> URL {
        return replaceSubdomainWithCodes(uri: uri,
                                         languageCode: OpenFoodAPIConfiguration.instance.language.rawValue,
                                         countryCode: OpenFoodAPIConfiguration.instance.country.rawValue)
    }
    
    static func replaceSubdomainWithCodes(uri: URL, languageCode: String?, countryCode: String?) -> URL {
        guard var components = URLComponents(url: uri, resolvingAgainstBaseURL: false) else { return uri }
        
        let initialSubdomain = components.host?.split(separator: ".").first ?? ""
        var subdomain = countryCode ?? String(initialSubdomain)
        
        if let languageCode = languageCode {
            subdomain = "\(countryCode ?? "")-\(languageCode)"
        }
        
        components.host = components.host?.replacingOccurrences(of: "\(initialSubdomain).", with: "\(subdomain).")
        return components.url ?? uri
    }
}
