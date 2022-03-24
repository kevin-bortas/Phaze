//
//  FoodResultsLauncher.swift
//  Phaze
//
//  Created by Kevin Bortas on 23/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation
import UIKit
import Charts

class FoodResults: NSObject{
    let name: String
    let imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

class FoodResultsLauncher: NSObject, ChartViewDelegate {
    
    let blackview = UIView()
    
    // This section modifies the popup card.
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.layer.cornerRadius = 42
        cv.layer.borderColor = UIColor.white.cgColor
        cv.layer.borderWidth = 0.5
        
        return cv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sv.backgroundColor = UIColor.white
        sv.layer.cornerRadius = 42
        sv.layer.borderColor = UIColor.white.cgColor
        sv.layer.borderWidth = 0.5
        sv.translatesAutoresizingMaskIntoConstraints = true
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
        return sv
    }()
    
    let nutritionalInformationView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.backgroundColor = UIColor.white
        sv.layer.borderColor = UIColor.white.cgColor
        sv.layer.borderWidth = 0.5
        
        return sv
    }()
    
    let informationLegend: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.backgroundColor = UIColor.white
        sv.layer.borderColor = UIColor.white.cgColor
        sv.layer.borderWidth = 0.5
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 45, bottom: 0, trailing: 45)
        return sv
    }()
    
    let carbLabel: UILabel = {
        let fontSize = 15
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "Carbs"
        label.textColor = UIColor.gray
        return label
    }()
    let carbValue: UILabel = {
        let fontSize = 30
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "0.0g"
        return label
    }()
    let carbView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.layer.cornerRadius = 5
        return v
    }()
    let carbStackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.backgroundColor = UIColor.white
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 35, trailing: 0)
        return sv
    }()
    
    let proteinLabel: UILabel = {
        let fontSize = 15
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "Protein"
        label.textColor = UIColor.gray
        return label
    }()
    let proteinValue: UILabel = {
        let fontSize = 30
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "0.0g"
        return label
    }()
    let proteinView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        v.layer.cornerRadius = 5
        return v
    }()
    let proteinStackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.backgroundColor = UIColor.white
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 35, trailing: 0)
        return sv
    }()
    
    let fatLabel: UILabel = {
        let fontSize = 15
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "Fat"
        label.textColor = UIColor.gray
        return label
    }()
    let fatValue: UILabel = {
        let fontSize = 30
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "0.0g"
        return label
    }()
    let fatView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        v.layer.cornerRadius = 5
        return v
    }()
    let fatStackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.backgroundColor = UIColor.white
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 35, trailing: 0)
        return sv
    }()
    
    let paddingView: UIView = {
        let pv = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        pv.backgroundColor = UIColor.white
        return pv
    }()
    
    let foodLabel: UILabel = {
        let fontSize = 24
        let label = PaddingLabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.paddingLeft = 15
        return label
    }()
    
    let addFood: UILabel = {
        let fontSize = 30
        let label = PaddingLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.text = "Add food"
        label.isUserInteractionEnabled = true
        label.backgroundColor = UIColor.systemBlue
        return label
    }()
    
//    let foodViewController = FoodViewController()
    
    var pieChart = PieChartView()
    
    var mainActivity: MainActivityViewController?
    
    var globalFood: Food?
    
    var imageView = UIImageView()
    
    func setImageView(image: UIImageView){
        self.imageView = image
    }
    
    func displayResults(food: Food){
        
        globalFood = food
        
        if let window = UIApplication.shared.keyWindow {
            
            //After the photo is taken this sets the background colour.
            blackview.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //This closes the screen when an area of the screen is tapped.
            blackview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            // This saves the image taken as the background.
            window.addSubview(imageView)
            
            // This darkens the taken image.
            window.addSubview(blackview)
            
            // This shows the pop-up menu with the information.
            window.addSubview(stackView)
            
            let height: CGFloat = CGFloat(6) * 100
            let y = window.frame.height - height
            stackView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            foodLabel.text = ModelResultsHolder.modelResult!.label
            foodLabel.widthAnchor.constraint(equalToConstant: window.frame.width).isActive = true
            
            informationLegend.heightAnchor.constraint(equalToConstant: window.frame.width).isActive = true
            informationLegend.widthAnchor.constraint(equalToConstant: window.frame.width).isActive = true
            
            setUpPieChart(width: window.frame.width / 2, food: food)
            
            setupStackView()
            
            blackview.frame = window.frame
            blackview.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackview.alpha = 1
                self.stackView.frame = CGRect(x: 0, y: y, width: self.stackView.frame.width, height: self.stackView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.stackView.frame = CGRect(x: 0, y: window.frame.height, width: self.stackView.frame.width, height: self.stackView.frame.height)
                self.imageView.image = nil
            }
        })
    }
    
    private func setupStackView() {
        proteinView.backgroundColor = hexStringToUIColor(hex: "#F86285")
        carbView.backgroundColor = hexStringToUIColor(hex: "#FFE570")
        fatView.backgroundColor = hexStringToUIColor(hex: "#71D6CA")
        
        proteinStackView.addArrangedSubview(proteinLabel)
        proteinStackView.addArrangedSubview(proteinValue)
        proteinStackView.addArrangedSubview(proteinView)
        proteinStackView.axis = .vertical
        proteinStackView.distribution = .fill
        proteinStackView.spacing = 0
        
        carbStackView.addArrangedSubview(carbLabel)
        carbStackView.addArrangedSubview(carbValue)
        carbStackView.addArrangedSubview(carbView)
        carbStackView.axis = .vertical
        carbStackView.distribution = .fill
        carbStackView.spacing = 0
        
        fatStackView.addArrangedSubview(fatLabel)
        fatStackView.addArrangedSubview(fatValue)
        fatStackView.addArrangedSubview(fatView)
        fatStackView.axis = .vertical
        fatStackView.distribution = .fill
        fatStackView.spacing = 0
        
        informationLegend.addArrangedSubview(proteinStackView)
        informationLegend.addArrangedSubview(carbStackView)
        informationLegend.addArrangedSubview(fatStackView)
        
        addFood.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))
        
        informationLegend.axis = .vertical
        informationLegend.distribution = .fillEqually
        informationLegend.spacing = 5
        
        nutritionalInformationView.addArrangedSubview(pieChart)
        nutritionalInformationView.addArrangedSubview(informationLegend)
        nutritionalInformationView.axis = .horizontal
        nutritionalInformationView.distribution = .equalSpacing
        nutritionalInformationView.spacing = 5
        
        stackView.addArrangedSubview(foodLabel)
        stackView.addArrangedSubview(nutritionalInformationView)
        stackView.addArrangedSubview(addFood)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.isUserInteractionEnabled = true
    }

    private func setUpPieChart(width: CGFloat, food: Food){
        pieChart.widthAnchor.constraint(equalToConstant: width).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: width).isActive = true

        pieChart.setExtraOffsets(left: 0, top: 0, right:0, bottom: 0)
        pieChart.usePercentValuesEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawMarkers = false
        pieChart.rotationEnabled = false
        pieChart.legend.enabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.holeRadiusPercent = 0.8

        setUpChartText(food: food)
        setUpChartData(food: food)
    }

    private func setUpChartText(food: Food){
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let centerText = NSMutableAttributedString()

        let stringOne = String(food.getCaloriesInt())
        let stringTwo = "cals"
//        let stringThree = "of 2000"
        let attributes = [ NSAttributedString.Key.paragraphStyle: style,
                           NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size:35.0)!]

        let zeroAttributes = [ NSAttributedString.Key.paragraphStyle: style,
                               NSAttributedString.Key.foregroundColor: UIColor.gray,
                               NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size:20.0)!]

        let centerTextPartOne = NSAttributedString(string: stringOne, attributes: attributes)
        let centerTextPartTwo = NSAttributedString(string: stringTwo, attributes: zeroAttributes)

        centerText.append(centerTextPartOne)
        centerText.append(centerTextPartTwo)

        pieChart.centerAttributedText = centerText
    }

    private func setUpChartData(food: Food){
        var entries = [ChartDataEntry]()

        let protein = food.getProtein()
        proteinValue.text = String(round(10 * protein) / 10) + "g"
        
        let carbs = food.getCarbs()
        carbValue.text = String(round(10 * carbs) / 10) + "g"
        
        let fat = food.getFat()
        fatValue.text = String(round(10 * fat) / 10) + "g"

        let nutritionalInfo = [["Protein", protein], ["Carbohydrates", carbs], ["Fat", fat]]

        for x in 0..<3{
            entries.append(ChartDataEntry(x: nutritionalInfo[x][1] as! Double,
                                          y: nutritionalInfo[x][1] as! Double,
                                          data: nutritionalInfo[x][0]))
        }

        let set = PieChartDataSet(entries: entries)
        set.drawValuesEnabled = false

        var  colors: [UIColor] = []
        colors.append(hexStringToUIColor(hex: "#F86285"))
        colors.append(hexStringToUIColor(hex: "#FFE570"))
        colors.append(hexStringToUIColor(hex: "#71D6CA"))
        set.colors = colors

        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }

    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc func tapFunction() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackview.alpha = 0

            if let window = UIApplication.shared.keyWindow {
                self.stackView.frame = CGRect(x: 0, y: window.frame.height, width: self.stackView.frame.width, height: self.stackView.frame.height)
                self.imageView.image = nil
            }
        }) { (completion: Bool) in
            self.mainActivity?.goToFoodView(food: self.globalFood!)
        }
    }
    
    override init(){
        super.init()

        pieChart.delegate = self
    }
}

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}
