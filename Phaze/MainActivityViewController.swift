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
        let image = UIImage(data: data)!
        
//        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        foodResultsLauncher.setImageView(image: imageView)
        
//        let scaledSize = CGSize(width: 224, height: 224)
//        let rotatedImage = image!.rotate(radians: .pi/5)
//        let croppedImage = cropImage(image: image!)
//        let newImage = resizeImage(image: image, targetSize: scaledSize)
//        print(newImage)
        
//        let imageView = UIImageView(image: newImage)
//        imageView.contentMode = .scaleAspectFill
//        imageView.frame = view.bounds
//        foodResultsLauncher.setImageView(image: imageView)
        
        
//        let pixelBuffer = buffer(from: image)
//        print(pixelBuffer)
        
        let inputImageSize: CGFloat = 224.0
        let minLen = min(image.size.width, image.size.height)
        let resizedImage = image.resize(to: CGSize(width: inputImageSize * image.size.width / minLen, height: inputImageSize * image.size.height / minLen))
        let cropedToSquareImage = resizedImage.cropToSquare()

        guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
            fatalError()
        }
        
//        let newImage = CreateCGImageFromCVPixelBuffer(pixelBuffer: pixelBuffer!)!
//        let img = UIImage(cgImage: newImage)
//        let imageView = UIImageView(image: img)
//        imageView.contentMode = .scaleAspectFill
//        imageView.frame = view.bounds
//        foodResultsLauncher.setImageView(image: imageView)
        
        let result1: Result?
        result = modelDataHandler?.runModel(onFrame: pixelBuffer)?.inferences[0]
        result1 = modelDataHandler?.runModel(onFrame: pixelBuffer)
        print(result1)
        ModelResultsHolder.modelResult = result
        print(result)

        activateFoodResultsLauncher()
    }
    
    func cropImage(image: UIImage) -> UIImage {
        let size = image.size

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height - (size.height / 4)) //    1536 x 2048 pixels

        let cgImage = image.cgImage!

        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
       let size = image.size
       
//       let widthRatio  = targetSize.width  / size.width
//       let heightRatio = targetSize.height / size.height
//
//        print(widthRatio)
//        print(heightRatio)
//
//       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
//       if(widthRatio > heightRatio) {
//           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//       } else {
//           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//       }
       newSize = CGSize(width: targetSize.width, height: targetSize.height)
       
       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
       
       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       
       return newImage!
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
                                       kCVPixelFormatType_32RGBA,
                                       attrs,
                                       &pixelBuffer)
        
//      let buffer = pixelBuffer

      guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
        return nil
      }
        
      print("status", kCVReturnSuccess)

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
        
        print("context")

      context.translateBy(x: 0, y: image.size.height)
      context.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()

      return pixelBuffer
    }
    
//    func DegreesToRadians(_ degrees: CGFloat) -> CGFloat { return CGFloat( (degrees * .pi) / 180 ) }
//
//    func CreateCGImageFromCVPixelBuffer(pixelBuffer: CVPixelBuffer) -> CGImage? {
//        let bitmapInfo: CGBitmapInfo
//        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
//        if kCVPixelFormatType_32ARGB == sourcePixelFormat {
//            bitmapInfo = [.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)]
//        } else
//        if kCVPixelFormatType_32BGRA == sourcePixelFormat {
//            bitmapInfo = [.byteOrder32Little, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)]
//        } else {
//            return nil
//        }
//
//        // only uncompressed pixel formats
//        let sourceRowBytes = CVPixelBufferGetBytesPerRow(pixelBuffer)
//        let width = CVPixelBufferGetWidth(pixelBuffer)
//        let height = CVPixelBufferGetHeight(pixelBuffer)
//        print("Buffer image size \(width) height \(height)")
//
//        let val: CVReturn = CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//        if  val == kCVReturnSuccess,
//            let sourceBaseAddr = CVPixelBufferGetBaseAddress(pixelBuffer),
//            let provider = CGDataProvider(dataInfo: nil, data: sourceBaseAddr, size: sourceRowBytes * height, releaseData: {_,_,_ in })
//        {
//            let colorspace = CGColorSpaceCreateDeviceRGB()
//            let image = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: sourceRowBytes,
//                            space: colorspace, bitmapInfo: bitmapInfo, provider: provider, decode: nil,
//                            shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
//            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//            return image
//        } else {
//            return nil
//        }
//    }
//    // utility used by newSquareOverlayedImageForFeatures for
//    func CreateCGBitmapContextForSize(_ size: CGSize) -> CGContext? {
//        let bitmapBytesPerRow = Int(size.width * 4)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//
//        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8,
//                        bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//        else { return nil }
//        context.setAllowsAntialiasing(false)
//        return context
//    }
    
}

extension UIImage {

    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return resizedImage
    }

    func cropToSquare() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        var imageHeight = self.size.height
        var imageWidth = self.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let x = ((CGFloat(cgImage.width) - size.width) / 2).rounded()
        let y = ((CGFloat(cgImage.height) - size.height) / 2).rounded()

        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let croppedCgImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCgImage, scale: 0, orientation: self.imageOrientation)
        }

        return nil
    }

    func pixelBuffer() -> CVPixelBuffer? {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)

        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }

        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return resultPixelBuffer
    }
}
