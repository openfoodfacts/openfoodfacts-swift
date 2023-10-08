//
//  BarcodeScanner.swift
//  
//
//  Created by Henadzi Ryabkin on 05/04/2023.
//

import SwiftUI
import UIKit

struct BarcodeScannerScreen: UIViewControllerRepresentable {
    @Binding var barcode: String
    @Binding var isCapturing: Bool
    
    func makeUIViewController(context: Context) -> BarcodeScannerController {
        let viewController = BarcodeScannerController()
        let coordinator = BarcodeScannerCoordinator(barcode: $barcode, isCapturing: $isCapturing)
        viewController.delegate = coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: BarcodeScannerController, context: Context) {
        if !uiViewController.initialised { return }
        if isCapturing {
            uiViewController.resumeCapturing()
        } else {
            uiViewController.pauseCapturing()
        }
    }
}

class BarcodeScannerCoordinator: NSObject, BarcodeScannerDelegate {
    
    @Binding var barcode: String
    @Binding var isCapturing: Bool
    
    init(barcode: Binding<String>, isCapturing: Binding<Bool>) {
        _barcode = barcode
        _isCapturing = isCapturing
    }
    
    func didFindCode(code: String) {
        print("\(#function) \(code)")
        self.barcode = code
    }
    
    func stoppedCapturing() {
        self.isCapturing = false
    }
}
