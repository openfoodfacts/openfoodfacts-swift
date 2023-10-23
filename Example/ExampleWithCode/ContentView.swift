//
//  ContentView.swift
//  ContentView
//
//  Sample codes:
//  existing 5900102025473 [pl] / 8711258029584 [nl], missing 5701377101134 [pl]
//
//  Created by Henadzi Rabkin on 16/10/2023.
//
import SwiftUI
import OpenFoodFactsSDK

struct ContentView: View {
    
    @State var barcode: String = ""
    @State var isProductEditorPresent: Bool = false
    @State var isInvalidBarcode: Bool = false
    
    @State var submitProduct: [String: String]? = nil {
        didSet {
            print(submitProduct ?? "")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                TextField("Enter barcode for e.g. 5900102025473", text: $barcode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Start") {
                    if barcode.isAValidBarcode() {
                        isProductEditorPresent = true
                    } else {
                        isInvalidBarcode = true
                    }
                }
                Spacer()
                // added for testing that editor is loaded with NavigatorView
                NavigationLink("", destination: ProductPage(barcode: self.$barcode, isPresented: self.$isProductEditorPresent, submitProduct: $submitProduct), isActive: $isProductEditorPresent).opacity(0)
            }
        }
        .alert("Invalid barcode", isPresented: $isInvalidBarcode) {
            Button("OK") {
                self.isInvalidBarcode = false
            }
        } message: {
            Text("Barcode \(barcode) is invalid. Expected format should have 7,8,12 or 13 digits.")
        }
    }
}

