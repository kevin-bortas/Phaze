//
//  DiaryViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit
import Charts

class DiaryViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var index: Int?
    var pieChart = PieChartView()
    
    var label = UILabel()
    let fontSize = 24
    
    var v = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        
        getCurrentDate()
        setUpPieChart()
        animateChart()
        
        
        setupStackView()
    }
    
    override func viewDidLayoutSubviews() {
//        getCurrentDate()
//        setUpPieChart()
//        animateChart()
        
//        setupStackView()
        
//        setUpMealTableView()
    }
    
    private func getCurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "M"
        let monthNum = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)
        
        let currentDay = day + ", " + monthNum + " " + month + " " + year
        
        label.text = currentDay
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        label.backgroundColor = .systemYellow
    }
    
    private func setUpPieChart(){
//        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
//        pieChart.center = view.center
        
//        pieChart.backgroundColor = .systemBlue
        
        pieChart.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        pieChart.usePercentValuesEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawMarkers = false
        pieChart.rotationEnabled = false
        pieChart.legend.enabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.holeRadiusPercent = 0.8
        
        setUpChartText()
        setUpChartData()
        
//        view.addSubview(pieChart)
    }
    
    private func setUpChartText(){
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let centerText = NSMutableAttributedString()
        
        let stringOne = "Total calories\n"
        let stringTwo = "0\n"
        let stringThree = "of 2000"
        let attributes = [ NSAttributedString.Key.paragraphStyle: style,
                           NSAttributedString.Key.foregroundColor: UIColor.gray,
                           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size:25.0)!]
        
        let zeroAttributes = [ NSAttributedString.Key.paragraphStyle: style,
                               NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size:40.0)!]
        
        let centerTextPartOne = NSAttributedString(string: stringOne, attributes: attributes)
        let centerTextPartTwo = NSAttributedString(string: stringTwo, attributes: zeroAttributes)
        let centerTextPartThree = NSAttributedString(string: stringThree, attributes: attributes)
        
        centerText.append(centerTextPartOne)
        centerText.append(centerTextPartTwo)
        centerText.append(centerTextPartThree)

        pieChart.centerAttributedText = centerText
    }
    
    private func setUpChartData(){
        var entries = [ChartDataEntry]()
        
        var protein = Double(10)
        var carbs = Double(50)
        var fat = Double(20)
        
        var nutritionalInfo = [["Protein", protein], ["Carbohydrates", carbs], ["Fat", fat]]
        
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
    
    private func animateChart(){
        pieChart.animate(xAxisDuration: 0.6, yAxisDuration: 0.6)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
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
    
    private func setupStackView(){
        v.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        v.heightAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(pieChart)
        stackView.addArrangedSubview(v)
//        stackView.backgroundColor = .systemRed
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
    }
}
