//
//  SwiftUIView.swift
//  
//
//  Created by Henadzi Rabkin on 01/10/2023.
//

import SwiftUI
import BarcodeView

struct ProductCode: View {
    
    let barcode: Barcode?
    
    public init(barcodeString: String) {
        self.barcode = BarcodeFactory.barcode(from: barcodeString)
    }
    
    var body: some View {
        if let code = barcode {
            BarcodeView(code)
                .frame(height: 60) // You can adjust these dimensions
                .environment(\.barWidth, 1)
        } else {
            Text("Invalid barcode")
                .frame(width: 120, height: 60) // Same dimensions as the barcode view
        }
    }
}

#Preview {
    ProductCode(barcodeString: "5701377101134")
}
