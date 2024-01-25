//
//  BarcodeScannerController.swift
//
//  Created by Henadzi Ryabkin on 05/04/2023.
//

// TODO: handle errors to top view

import UIKit
import AVFoundation

import Vision

protocol BarcodeScannerDelegate: AnyObject {
    func didFindCode(code: String)
    func stoppedCapturing()
}

class BarcodeScannerController: UIViewController {

    var delegate: BarcodeScannerDelegate?
    
    // Processing extension variables
    
    /// Barcode scanner for results
    var requests: [VNRequest] = []
    
    internal let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    var overlayView: ScannerOverlayView!
    
    var initialised = false
    
    internal let sessionQueue = DispatchQueue(label: "captureQueue", qos: .background)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up the AVCaptureSession.
        self.checkPermissions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        let barcodeDetectRequest = VNDetectBarcodesRequest(completionHandler: self.handleDetectedBarcode)
        requests = [barcodeDetectRequest]
        
        self.overlayView = ScannerOverlayView(frame: self.view.layer.bounds)
        self.overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.overlayView.flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        
        view.addSubview(overlayView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.overlayView.resetStroke()
    }
    
    private func checkPermissions() {
        let viewBounds = self.view.bounds
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                DispatchQueue.main.async {
                    self.showCameraAccessDeniedAlert()
                }
                return
            } else {
                self.sessionQueue.async {
                    self.setUpCaptureSession(using: viewBounds)
                }
            }
        }
    }
    
    private func getCaptureDevice() -> AVCaptureDevice? {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTripleCamera, .builtInDualWideCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices.first ?? AVCaptureDevice.default(for: .video)
    }
    
    private func setUpCaptureSession(using bounds: CGRect) {
        
        guard let videoCaptureDevice = getCaptureDevice() else {
            print("Error: No video capture device available.")
            return
        }
        
        do {
            try videoCaptureDevice.lockForConfiguration()
            if videoCaptureDevice.isFocusModeSupported(.continuousAutoFocus) {
                videoCaptureDevice.focusMode = .continuousAutoFocus
            }
            if #available(iOS 15.4, *) , videoCaptureDevice.isFocusModeSupported(.autoFocus) {
                videoCaptureDevice.automaticallyAdjustsFaceDrivenAutoFocusEnabled = false
            }
            videoCaptureDevice.unlockForConfiguration()
        } catch {}
        
        do {
            if let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    self.captureSession.removeInput(input)
                }
            }
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            self.captureSession.addInput(input)
        } catch {
            print("Could not create device input: \(error)")
        }
        
        self.captureSession.beginConfiguration()
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720;
        // Add video output.
        let videoOutput = AVCaptureVideoDataOutput()

        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        // calls captureOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "processing"))
        
        self.captureSession.addOutput(videoOutput)
        for connection in videoOutput.connections {
            connection.videoOrientation = .portrait
        }
        self.captureSession.commitConfiguration()
        self.initialised = true
        self.resumeCapturing()
        
        DispatchQueue.main.async {
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = self.view.layer.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            self.view.bringSubviewToFront(self.overlayView)
        }
    }
    
    func resumeCapturing() {
        DispatchQueue.main.async {
            self.overlayView.resetStroke()
        }
        self.sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    func pauseCapturing() {
        self.sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    func showCameraAccessDeniedAlert() {
        let alertController = UIAlertController(title: "Camera Access Denied", message: "Please grant camera access in Settings to scan barcodes.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _
            in
            self.closeButtonTapped()
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func toggleFlash() {
        guard let device = getCaptureDevice(), device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.torchMode == .on {
                device.torchMode = .off
                overlayView.flashButton.setImage(UIImage(systemName: "bolt.slash.circle"), for: .normal)
            } else {
                device.torchMode = .on
                overlayView.flashButton.setImage(UIImage(systemName: "bolt.circle"), for: .normal)
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Error toggling flash: \(error)")
        }
    }
}
