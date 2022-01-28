//
//  MainActivityViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 13/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//
import AVFoundation
import UIKit

class MainActivityViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    
    var index: Int?
    
    var session: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    let foodResultsLauncher = FoodResultsLauncher()
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
            button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private var result: Inference?
    
    private var modelDataHandler: ModelDataHandler? =
      ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard modelDataHandler != nil else {
          fatalError("Model set up failed")
        }
        
        previewLayer.backgroundColor = UIColor.systemRed.cgColor

        // Do any additional setup after loading the view.
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermission()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - 100)
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch {
                print(error)
            }
        }
    }
    
    private func activateFoodResultsLauncher(){
        foodResultsLauncher.mainActivity = self
        foodResultsLauncher.displayResults()
    }
    
    func goToFoodView(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "foodview") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func reload(){
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        session?.startRunning()
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }
    
    @IBAction func didTapBackButton(sender: UIButton) {
        if (!backButton.isHidden){
            backButton.isHidden = true
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}

extension MainActivityViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        
//        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        foodResultsLauncher.setImageView(image: imageView)
        
        let pixelBuffer = buffer(from: image!)
        let result1: Result?
        result = modelDataHandler?.runModel(onFrame: pixelBuffer!)?.inferences[0]
        result1 = modelDataHandler?.runModel(onFrame: pixelBuffer!)
        print(result1)
        ModelResultsHolder.modelResult = result
        
        activateFoodResultsLauncher()
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
      ] as CFDictionary

      var pixelBuffer: CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                       Int(image.size.width),
                                       Int(image.size.height),
                                       kCVPixelFormatType_32BGRA,
                                       attrs,
                                       &pixelBuffer)

      guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
        return nil
      }

      CVPixelBufferLockBaseAddress(buffer, [])
      defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
      let pixelData = CVPixelBufferGetBaseAddress(buffer)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      guard let context = CGContext(data: pixelData,
                                    width: Int(image.size.width),
                                    height: Int(image.size.height),
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
        return nil
      }

      context.translateBy(x: 0, y: image.size.height)
      context.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()

      return pixelBuffer
    }
    
}
