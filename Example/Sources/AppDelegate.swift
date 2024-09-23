//
//  AppDelegate.swift
//  Example
//
//  Created by Henadzi Rabkin on 04/10/2023.
//

import Foundation
import UIKit
import OpenFoodFactsSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        OFFConfig.shared.apiEnv = .production
        OFFConfig.shared.country = OpenFoodFactsCountry.POLAND
        OFFConfig.shared.productsLanguage = .FRENCH
        return true
    }
}
