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
        if addUserAgentParameters, let agent = OFFConfig.shared.userAgent {
            userAgentParams = agent.toMap(with: OFFConfig.shared.uuid)
        }
        let allQueryParams = queryParameters?.merging(userAgentParams) { (current, _) in current }
        
        var components = URLComponents()
        components.scheme = OFFApi.scheme
        components.host = OFFConfig.shared.api.host(for: .world)
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
        components.host = OFFConfig.shared.api.host(for: .robotoff)
        return components.url
    }
    
    static func getFolksonomyUri(path: String, queryParameters: [String: String]?) -> URL? {
        var components = UriHelper.baseComponents(path: path, from: queryParameters)
        components.host = OFFConfig.shared.api.host(for: .folksonomy)
        return components.url
    }
    
    static func getEventsUri(path: String, queryParameters: [String: String]?) -> URL? {
        var components = UriHelper.baseComponents(path: path, from: queryParameters)
        components.host = OFFConfig.shared.api.host(for: .events)
        return components.url
    }
    
    static func getTaxonomiesUri(path: String) -> URL? {
        var components = UriHelper.baseComponents(path: path, from: [:])
        components.host = OFFConfig.shared.api.host(for: .taxonomies)
        return components.url
    }
    
    private static func baseComponents(path: String, from queryParameters: [String: String]?) -> URLComponents {
        var components = URLComponents()
        components.scheme = OFFApi.scheme
        components.path = path
        components.queryItems = queryParameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components
    }
    
    // TODO: verify why this shit is needed
    static func replaceSubdomain(uri: URL) -> URL {
        return replaceSubdomainWithCodes(uri: uri,
                                         languageCode: OFFConfig.shared.productsLanguage.rawValue,
                                         countryCode: OFFConfig.shared.country.rawValue)
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
