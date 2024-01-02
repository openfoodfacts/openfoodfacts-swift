//
//  ContentView.swift
//  Example
//
//  Created by Henadzi Rabkin on 15/10/2023.
//

import SwiftUI
import OpenFoodFactsSDK

struct ContentView: View {
    
    @State private var barcode: String = ""
    @State private var isEditing = false
    @State private var isInvalidCode = false
    @State private var isScanning = true
    
    private func resetState() {
        isInvalidCode = false
        barcode = ""
        isScanning = true
    }
    
    var body: some View {
        NavigationStack {
            BarcodeScannerScreen(barcode: $barcode, isCapturing: $isScanning).ignoresSafeArea(.all)
            .navigationDestination(isPresented: $isEditing, destination: {
                ProductPage(barcode: barcode) { uploadedProduct in
                    print(uploadedProduct?.json() ?? "returned product is nil")
                    resetState()
                }
            })
            .onChange(of: isEditing) { newValue in
                if newValue == false {
                    resetState()
                }
            }
            .onChange(of: barcode) { newValue in
                if newValue.isEmpty { return }
                print("Found barcode \(barcode) which \(barcode.isAValidBarcode() ? "Valid" : "Invalid")")
                if newValue.isAValidBarcode() {
                    isEditing = true
                } else {
                    isInvalidCode = true
                }
            }
            .alert("Invalid barcode", isPresented: $isInvalidCode) {
                Button("Dismiss") {
                    resetState()
                }
            } message: {
                Text("Barcode \(barcode) is invalid. Expected format should have 7,8,12 or 13 digits.")
            }
        }
    }
}
