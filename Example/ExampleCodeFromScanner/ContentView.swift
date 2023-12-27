//
//  ContentView.swift
//  Example
//
//  Created by Henadzi Rabkin on 15/10/2023.
//

import SwiftUI
import OpenFoodFactsSDK

struct ContentView: View {
    
    @State private var isEditingProduct = false
    @State private var isScanning = true
    @State private var isValidBarcode = false
    @State private var barcode: String = ""
    
    var body: some View {
        BarcodeScannerScreen(barcode: $barcode, isCapturing: $isScanning)
        .onChange(of: barcode) { newValue in
            print("Found barcode \(barcode) which \(barcode.isAValidBarcode() ? "Valid" : "Invalid")")
            if newValue.isAValidBarcode() {
                isEditingProduct = true
            } else {
                isValidBarcode = true
            }
        }
        .fullScreenCover(isPresented: $isEditingProduct) {
            ProductPage(barcode: barcode) { uploadedProduct in
                print(uploadedProduct ?? "")
            }.onDisappear() {
                isScanning = true
            }
        }
        .alert("Invalid barcode", isPresented: $isValidBarcode) {
            Button("Dismiss") {
                isValidBarcode = false
                isScanning = true
            }
        } message: {
            Text("Barcode \(barcode) is invalid. Expected format should have 7,8,12 or 13 digits.")
        }
    }
}
