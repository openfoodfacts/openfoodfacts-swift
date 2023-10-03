//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation
import UIKit

class OpenFoodAPIConfiguration {
    
    static let instance = OpenFoodAPIConfiguration()
    
    static let scheme = "https"
    static let uriProdHost = "world.openfoodfacts.org"
    static let uriProdHostFolksonomy = "api.folksonomy.openfoodfacts.org"
    static let uriProdHostRobotoff = "robotoff.openfoodfacts.org"
    static let imageProdUrlBase = "https://static.openfoodfacts.org/images/products/"
    static let uriProdHostEvents = "events.openfoodfacts.org"
    
    var uuid = UUID().uuidString
    
    var globalUser: User?
    
    var userAgent: UserAgent?
    
    var country: OpenFoodFactsCountry = OpenFoodFactsCountry.USA
    var language: OpenFoodFactsLanguage = OpenFoodFactsLanguage.ENGLISH
    
    private init() {
        setupUserAgent()
    }
    
    private func getAppInfoComment(withName: Bool = true, name: String = "",
                           withVersion: Bool = true, version: String = "",
                           withSystem: Bool = true, system: String = "",
                           withId: Bool = true, id: String = "") -> String {
        var appInfo = ""
        let infoDelimiter = " - "
        
        if withName {
            appInfo += infoDelimiter + name
        }
        if withVersion {
            appInfo += infoDelimiter + version
        }
        if withSystem {
            appInfo += infoDelimiter + system
        }
        if withId {
            appInfo += infoDelimiter + id
        }
        
        return appInfo
    }

    private func setupUserAgent() {
        
        if self.userAgent != nil { return }
        
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        
        let version = "\(appVersion)+\(buildNumber)"
        let system = "\(UIDevice.current.systemName)+\(UIDevice.current.systemVersion)"
        let comment = getAppInfoComment(name: appName, version: version, system: system, id: uuid)
        
        self.userAgent = UserAgent(
            name: appName,
            version: version,
            system: system,
            url: "https://world.openfoodfacts.org/",
            comment: comment
        )
    }
}
