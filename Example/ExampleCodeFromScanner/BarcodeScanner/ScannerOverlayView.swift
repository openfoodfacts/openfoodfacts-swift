//
//  ScannerOverlayView.swift
//
//  Created by Henadzi Ryabkin on 05/04/2023.
//
import UIKit

class ScannerOverlayView: UIView, CAAnimationDelegate {
    
    static let FOCUS_SQR_MINSIZE_FRACTION = 0.7
    
    let flashButton = UIButton(type: .system)
    let overlayView = UIView()

    let cutoutLayer = CAShapeLayer()
    let strokeLayer = CAShapeLayer()
    let textLayer = CATextLayer()
    
    let animationGroupKey = "matchAnimation"
    
    private var animationCompletion: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupSubLayers()
        setupOverlayView()
        setupFlashButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubLayers()
        setupOverlayView()
        setupFlashButton()
    }

    private func setupFlashButton() {
       flashButton.translatesAutoresizingMaskIntoConstraints = false
       flashButton.setImage(UIImage(systemName: "bolt.slash.circle"), for: .normal)
       flashButton.tintColor = .white
       flashButton.contentMode = .scaleAspectFit
       flashButton.contentVerticalAlignment = .fill
       flashButton.contentHorizontalAlignment = .fill
       addSubview(flashButton)
       
       NSLayoutConstraint.activate([
           flashButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
           flashButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80),
           flashButton.widthAnchor.constraint(equalToConstant: 40),
           flashButton.heightAnchor.constraint(equalToConstant: 40)
       ])
   }

    private func setupOverlayView() {
        self.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func setupSubLayers() {
        
        let overlayPath = UIBezierPath(rect: self.bounds)
        let squareSize: CGFloat = min(self.bounds.width, self.bounds.height) * ScannerOverlayView.FOCUS_SQR_MINSIZE_FRACTION
        let squareFrame = CGRect(x: (self.bounds.width - squareSize) / 2, y: (self.bounds.height - squareSize) / 2, width: squareSize, height: squareSize)
        let squarePath = UIBezierPath(roundedRect: squareFrame, cornerRadius: 10.0)

        overlayPath.append(squarePath)
        overlayPath.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor

        overlayView.layer.addSublayer(fillLayer)

        strokeLayer.path = squarePath.cgPath
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.lineWidth = 4

        overlayView.layer.addSublayer(strokeLayer)

        textLayer.string = "Scan barcode here"
        textLayer.font = UIFont.systemFont(ofSize: 16)
        textLayer.fontSize = 16
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.frame = CGRect(x: 0, y: squareFrame.maxY - 20 - 40, width: self.bounds.width, height: 20)

        // This line was missing
        overlayView.layer.addSublayer(textLayer)
    }
    
    func animateMatch(isMatch: Bool, completion: @escaping () -> Void) {
        
        if strokeLayer.animation(forKey: animationGroupKey) == nil {
            self.animationCompletion = completion
            let finalColor = isMatch ? UIColor.green.cgColor : UIColor.red.cgColor
            
            let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
            colorAnimation.toValue = finalColor
            colorAnimation.duration = 0.5
            
            let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
            widthAnimation.toValue = strokeLayer.lineWidth * 3
            widthAnimation.duration = 0.5
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.5
            animationGroup.animations = [colorAnimation, widthAnimation]
            animationGroup.delegate = self
            
            strokeLayer.add(animationGroup, forKey: animationGroupKey)
            
            strokeLayer.strokeColor = finalColor
            strokeLayer.lineWidth = strokeLayer.lineWidth * 3
        } else {
            print("\(animationGroupKey) animation group is already running!")
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.animationCompletion?()
            self.animationCompletion = nil
        }
    }

    func resetStroke() {
        
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.lineWidth = 4
        strokeLayer.removeAllAnimations()
    }
}
