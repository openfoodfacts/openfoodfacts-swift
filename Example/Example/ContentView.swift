//
//  ContentView.swift
//  Example
//
//  Created by Henadzi Rabkin on 30/09/2023.
//
import SwiftUI
import OpenFoodFactsSDK

struct ContentView: View {
    var body: some View {
        EditProductPage(barcodeString: "5701377101134")
    }
}

#Preview {
    ContentView()
}
