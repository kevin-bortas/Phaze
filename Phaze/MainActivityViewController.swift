//
//  MainActivityViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 13/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//
import AVFoundation
import UIKit
import MLKit

class MainActivityViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    
    var index: Int?
    
    let foodIdentifier = ImagePredictor()
    var prediction: String = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        ImagePredictor.createImageClassifier()
        classifyImage(cropedToSquareImage!)
        let myResult = prediction.split(separator: "-")
        print(myResult[0])

        guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
            fatalError()
        }
        
        barcodeScanner(image: image, prediction: "ingr=" + myResult[0])
    }
    
    
    // MARK: Image prediction methods
    /// Sends a photo to the Image Predictor to get a prediction of its content.
    /// - Parameter image: A photo.
    func classifyImage(_ image: UIImage) {
        do {
            try self.foodIdentifier.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

    /// The method the Image Predictor calls when its image classifier model generates a prediction.
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            print("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
        prediction = predictionString
    }

    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(1).map { prediction in
            var name = prediction.classification

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
    
    func barcodeScanner(image: UIImage, prediction: String) {
        let barcodeOptions = BarcodeScannerOptions(formats: .all)
        
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        let barcodeScanner = BarcodeScanner.barcodeScanner()
        
        barcodeScanner.process(visionImage) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
              // Error handling
              self.requestFood(food: prediction)
              return
            }
            // Recognized barcodes
            for barcode in features{
                self.requestFood(food: "upc=" + barcode.displayValue!)
            }
        }
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

    func requestFood(food: String) {
        
        let store = Store()
        let edamam = Edamam()
        
        let task = Task {
            let response = await edamam.get(query: food)
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
            var labelFlag = false
            for char in split_string {
                let newChar = char.replacingOccurrences(of: "\"", with: "")
                switch(newChar){
                case "label":
                    var tmp_position = position + 2;
                    while (!labelFlag){
                        if (split_string[tmp_position].contains(";")){
                            let newString = split_string[tmp_position].dropLast()
                            name += newString
                            labelFlag = true
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
            
            print(name)
            
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
