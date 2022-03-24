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
    
    private func activateFoodResultsLauncher(food: Food){
        foodResultsLauncher.mainActivity = self
        foodResultsLauncher.displayResults(food: food)
    }
    
    func goToFoodView(food: Food){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "foodview") as! FoodViewController
        vc.food = food
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
        
        let inputImageSize: CGFloat = 224.0
        let minLen = min(image.size.width, image.size.height)
        let resizedImage = image.resize(to: CGSize(width: inputImageSize * image.size.width / minLen, height: inputImageSize * image.size.height / minLen))
        let cropedToSquareImage = resizedImage.cropToSquare()

        guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
            fatalError()
        }
        
        result = modelDataHandler?.runModel(onFrame: pixelBuffer)?.inferences[0]
        ModelResultsHolder.modelResult = result
        
        requestFood()

//        activateFoodResultsLauncher()
    }
    
    func cropImage(image: UIImage) -> UIImage {
        let size = image.size

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height - (size.height / 4)) //    1536 x 2048 pixels

        let cgImage = image.cgImage!

        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
    
    actor Store {
        var foodJson: [String:AnyObject] = [:]
        func append(response: [String:AnyObject]) {
            foodJson = response
        }
    }

    func requestFood() {
        
        let store = Store()
        let edamam = Edamam()
        
        let task = Task {
            let response = await edamam.get(query: ModelResultsHolder.modelResult!.label)
            await store.append(response: response)
            
            let food_array = await store.foodJson
            let hints = food_array["hints"]
            let s = String(describing: hints!)
            let split_string = s.split(whereSeparator: \.isWhitespace)
            
            var name: String = ""
            var cals: Double = 0.0
            var protein: Double = 0.0
            var fat: Double = 0.0
            var carbs: Double = 0.0
            
            var position = 0;
            var setFinishFlag = false
            for char in split_string {
                let newChar = char.replacingOccurrences(of: "\"", with: "")
                switch(newChar){
                case "label":
                    var tmp_position = position + 2;
                    while (true){
                        if (split_string[tmp_position].contains(";")){
                            let newString = split_string[tmp_position].dropLast()
                            name += newString
                            break
                        }
                        else {
                            name += split_string[tmp_position] + " "
                        }
                        tmp_position += 1;
                    }
                case "ENERC_KCAL":
                    let myString = split_string[position + 2].dropLast().replacingOccurrences(of: "\"", with: "")
                    cals = (myString as NSString).doubleValue
                case "PROCNT":
                    let myString = split_string[position + 2].dropLast().replacingOccurrences(of: "\"", with: "")
                    protein = (myString as NSString).doubleValue
                case "FAT":
                    let myString = split_string[position + 2].dropLast().replacingOccurrences(of: "\"", with: "")
                    fat = (myString as NSString).doubleValue
                case "CHOCDF":
                    let myString = split_string[position + 2].dropLast().replacingOccurrences(of: "\"", with: "")
                    carbs = (myString as NSString).doubleValue
                default:
                    if (name != "" && cals != 0.0 && protein != 0.0 && fat != 0.0 && carbs != 0.0){
                        setFinishFlag = true
                        break
                    }
                }
                if (setFinishFlag == true){
                    break
                }
                position += 1
            }
            
            let food = Food(n: name.capitalized, measure: "", c: cals, p: protein, cb: carbs, f: fat)
            activateFoodResultsLauncher(food: food)
        }
    }
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
