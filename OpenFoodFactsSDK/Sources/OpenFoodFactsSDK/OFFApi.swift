//
//  OFFApi.swift
//
/// Example usage
/// OFFApi.currentEnvironment = .production
/// let prodWorldURL = OFFApi.host(for: .world)
/// print("Production World URL: \(prodWorldURL)")
///
/// OFFApi.currentEnvironment = .staging
/// let stagingWorldURL = OFFApi.host(for: .world)
/// print("Staging World URL: \(stagingWorldURL)")
///
//  Created by Henadzi Rabkin on 04/10/2023.
//
// /cgi/product_image_upload.pl

//
//let path: String
//
//switch endpoint {
//case .taxonomies:
//    path = "/data/taxonomies"
//case .images:
//    path = "/images/products/"
//default:
//    path = ""
//}


import Foundation

public struct OFFApi {
    
    public static let scheme = "https"
    var currentEnvironment: OFFEnvironment = .production
    
    enum Endpoint: String {
        case world
        case folksonomy
        case robotoff
        case images
        case events
        case taxonomies
    }
    
    func host(for endpoint: Endpoint) -> String {
        let domain: String
        switch currentEnvironment {
        case .production:
            domain = "openfoodfacts.org"
        case .staging:
            domain = "openfoodfacts.net"
        }
        
        let subdomain: String
        switch endpoint {
        case .world,.taxonomies:
            subdomain = "world"
        case .folksonomy:
            subdomain = "api.folksonomy"
        case .robotoff:
            subdomain = "robotoff"
        case .images:
            subdomain = "static"
        case .events:
            subdomain = "events"
        }
        var host = "\(subdomain).\(domain)"
        
        return host
    }
}
