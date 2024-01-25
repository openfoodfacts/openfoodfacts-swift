//
//  ExampleApp.swift
//  Example
//
//  Created by Henadzi Rabkin on 30/09/2023.
//

import SwiftUI
import OpenFoodFactsSDK

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
