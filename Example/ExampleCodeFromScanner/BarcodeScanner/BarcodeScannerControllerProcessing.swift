//
//  BarcodeScannerControllerProcessing.swift
//
//  Created by Henadzi Ryabkin on 08/06/2023.
//

import UIKit
import AVFoundation
import Vision

extension BarcodeScannerController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func handleDetectedBarcode(request: VNRequest, error: Error?) {
        if let nsError = error as NSError? {
            print(nsError.localizedDescription)
            return
        }
        
        guard let results = request.results as? [VNBarcodeObservation] else { return }
        if let result = results.first,
            let barcode = result.payloadStringValue {
            self.pauseCapturing()
            self.delegate?.stoppedCapturing()
            DispatchQueue.main.async {
                self.overlayView.animateMatch(isMatch: true) {
                    self.delegate?.didFindCode(code: barcode)
                }
            }
        }
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation.init(rawValue: 6) ?? .up, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
