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
    @State var isValidBarcode: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Text("Expected format should have 7,8,12 or 13 digits.")
                HStack {
                    TextField("Enter barcode for e.g. 5900102025473", text: $barcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: barcode) { newValue in
                        isValidBarcode = newValue.isAValidBarcode()
                        print("\(barcode) and \(isValidBarcode)")
                    }
                    Image(systemName: isValidBarcode ? "checkmark" : "exclamationmark.octagon.fill")
                        .renderingMode(.template).foregroundColor(isValidBarcode ? .green : .red)
                }.padding()
                // Added for testing that editor is loaded with NavigatorView
                NavigationLink("Check") {
                    ProductPage(barcode: self.barcode) { product in
                        print(product ?? "")
                    }.disabled(!isValidBarcode)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
