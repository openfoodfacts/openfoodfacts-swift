//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation
import UIKit

public enum OFFEnvironment {
    case production
    case staging
}

/// https://wiki.openfoodfacts.org/API/Write
final public class OFFConfig {
    
    var api = OFFApi()
    
    public var apiEnv = OFFEnvironment.production {
        didSet {
            api.currentEnvironment = apiEnv
            
            if apiEnv == .staging {
                self.globalUser = User(userId: "off", password: "off")
            }
        }
    }
    public var useRequired = true
    /// Required property
    public var globalUser: User?
    /// Auto-generated can be overriden
    public var userAgent: UserAgent?
    /// Metadata
    public var country: OpenFoodFactsCountry = OpenFoodFactsCountry.USA
    public var uiLanguage: OpenFoodFactsLanguage = OpenFoodFactsLanguage.ENGLISH
    public var productsLanguage: OpenFoodFactsLanguage = OpenFoodFactsLanguage.ENGLISH
    
    public static let shared: OFFConfig = {
        let instance = OFFConfig()
        return instance
    }()
    
    var uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    
    init() {
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
            comment: comment
        )
    }
}
