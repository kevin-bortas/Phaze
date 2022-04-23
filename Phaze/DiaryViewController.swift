//
//  DiaryViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit
import Charts

// This is the view for the diary page
class DiaryViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    var stackView = UIStackView()
    
    var index: Int?
    var pieChart = PieChartView()
    
    var label = UILabel()
    let fontSize = 24
    
    var v = UIView()
    var edamam = Edamam()

    var cell = CustomTableViewCell()
    
    // Creates meal fields
    let meals = [
        "Breakfast",
        "Lunch",
        "Dinner",
        "Snacks"
    ]
    
    // Creates different ui elements
    let informationLegend: UIStackView = {
        let sv = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sv.backgroundColor = UIColor.white
        sv.layer.borderColor = UIColor.white.cgColor
        sv.layer.borderWidth = 0.5
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 45, bottom: 25, trailing: 45)
        return sv
    }()
    
    let carbLabel: UILabel = {
        let fontSize = 15
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "Carbs"
        label.textColor = UIColor.gray
        return label
    }()
    let carbValue: UILabel = {
        let fontSize = 30
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = String(User.getTotalCarbs()) + "g"
        return label
    }()
    let carbView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.layer.cornerRadius = 5
        return v
    }()
    let carbStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = UIColor.white
        return sv
    }()
    
    let proteinLabel: UILabel = {
        let fontSize = 15
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "Protein"
        label.textColor = UIColor.gray
        return label
    }()
    let proteinValue: UILabel = {
        let fontSize = 30
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = String(User.getTotalProtein()) + "g"
        return label
    }()
    let proteinView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        v.layer.cornerRadius = 5
        return v
    }()
    let proteinStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = UIColor.white
        return sv
    }()
    
    let fatLabel: UILabel = {
        let fontSize = 15
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = "Fat"
        label.textColor = UIColor.gray
        return label
    }()
    let fatValue: UILabel = {
        let fontSize = 30
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.text = String(User.getTotalFat()) + "g"
        return label
    }()
    let fatView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        v.layer.cornerRadius = 5
        return v
    }()
    let fatStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = UIColor.white
        return sv
    }()
    
    let mealLabel: UILabel = {
        let fontSize = 24
        let label = PaddingLabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: CGFloat(fontSize))
        label.heightAnchor.constraint(equalToConstant: 75).isActive = true
        label.paddingTop = 25
        label.paddingLeft = 15
        label.paddingBottom = 25
        label.text = "Meals"
        return label
    }()
    
    var breakfastButton = UILabel()
    var lunchButton = UILabel()
    var dinnerButton = UILabel()
    var snacksButton = UILabel()
    
    var breakfastStackView = UIStackView()
    var breakfastLabelStack = UIStackView()
    let breakfastIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.image = UIImage(named: "coffee")
        return image
    }()
    
    var lunchStackView = UIStackView()
    var lunchLabelStack = UIStackView()
    let lunchIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.image = UIImage(named: "sandwich")
        return image
    }()
    
    var dinnerStackView = UIStackView()
    var dinnerLabelStack = UIStackView()
    let dinnerIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.image = UIImage(named: "salad")
        return image
    }()
    
    var snacksStackView = UIStackView()
    var snacksLabelStack = UIStackView()
    let snacksIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.image = UIImage(named: "apple")
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        
        stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
        stackView.backgroundColor = UIColor.white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Sets up the different sections
        getCurrentDate()
        setUpPieChart()
        animateChart()
        
        setupStackView()
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
    
    // Gets the current date
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
    }
    
    // Sets up the pie chart
    private func setUpPieChart(){
        pieChart.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true

        pieChart.usePercentValuesEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawMarkers = false
        pieChart.rotationEnabled = false
        pieChart.legend.enabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.holeRadiusPercent = 0.8
        
        setUpChartText()
        setUpChartData()
    }
    
    // Sets up the center pie chart text
    private func setUpChartText(){
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let centerText = NSMutableAttributedString()
        
        let stringOne = "Total calories\n"
        let stringTwo = String(User.getCaloriesEaten()) + "\n"
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
    
    // Sets up the pie chart data
    private func setUpChartData(){
        var entries = [ChartDataEntry]()
        
        // Gets the data from the User class
        var nutritionalInfo = [["Protein", User.getTotalProtein()], ["Carbohydrates", User.getTotalCarbs()], ["Fat", User.getTotalFat()]]
        
        if (User.getCaloriesEaten() == 0){
            nutritionalInfo.append(["empty", 1.0])
        }
        
        for x in 0..<nutritionalInfo.count{
            entries.append(ChartDataEntry(x: nutritionalInfo[x][1] as! Double,
                                          y: nutritionalInfo[x][1] as! Double,
                                          data: nutritionalInfo[x][0]))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.drawValuesEnabled = false
        
        var  colors: [UIColor] = []
        colors.append(Helper.hexStringToUIColor(hex: "#F86285"))
        colors.append(Helper.hexStringToUIColor(hex: "#FFE570"))
        colors.append(Helper.hexStringToUIColor(hex: "#71D6CA"))
        colors.append(Helper.hexStringToUIColor(hex: "#F4F5F6"))
        set.colors = colors
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
    
    // This animates the pie chart
    private func animateChart(){
        pieChart.animate(xAxisDuration: 0.6, yAxisDuration: 0.6)
    }
    
    // Sets up the stack views for the page
    private func setupStackView() {
        setUpBreakfastButton()
        setUpLunchButton()
        setUpDinnerButton()
        setUpSnacksButton()
        
        
        let breaker: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        
        breaker.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker2: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker2.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker2.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker3: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker3.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker3.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker3.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker4: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker4.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker4.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker4.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker5: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker5.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker5.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker5.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        
        informationLegend.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        informationLegend.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        breakfastStackView.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breakfastStackView.heightAnchor.constraint(equalToConstant: stackView.frame.width * 0.20).isActive = true
        breakfastStackView.isLayoutMarginsRelativeArrangement = true
        breakfastStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25)
        breakfastStackView.isUserInteractionEnabled = true
        breakfastStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(breakfastTapFunction)))
        
        lunchStackView.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        lunchStackView.heightAnchor.constraint(equalToConstant: stackView.frame.width * 0.20).isActive = true
        lunchStackView.isLayoutMarginsRelativeArrangement = true
        lunchStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25)
        lunchStackView.isUserInteractionEnabled = true
        lunchStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lunchTapFunction)))
        
        dinnerStackView.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        dinnerStackView.heightAnchor.constraint(equalToConstant: stackView.frame.width * 0.20).isActive = true
        dinnerStackView.isLayoutMarginsRelativeArrangement = true
        dinnerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25)
        dinnerStackView.isUserInteractionEnabled = true
        dinnerStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dinnerTapFunction)))
        
        snacksStackView.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        snacksStackView.heightAnchor.constraint(equalToConstant: stackView.frame.width * 0.20).isActive = true
        snacksStackView.isLayoutMarginsRelativeArrangement = true
        snacksStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25)
        snacksStackView.isUserInteractionEnabled = true
        snacksStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(snacksTapFunction)))
        
        proteinView.backgroundColor = Helper.hexStringToUIColor(hex: "#F86285")
        carbView.backgroundColor = Helper.hexStringToUIColor(hex: "#FFE570")
        fatView.backgroundColor = Helper.hexStringToUIColor(hex: "#71D6CA")
        
        mealLabel.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        
        proteinStackView.addArrangedSubview(proteinLabel)
        proteinStackView.addArrangedSubview(proteinValue)
        proteinStackView.addArrangedSubview(proteinView)
        proteinStackView.axis = .vertical
        proteinStackView.distribution = .fill
        proteinStackView.spacing = 1
        
        carbStackView.addArrangedSubview(carbLabel)
        carbStackView.addArrangedSubview(carbValue)
        carbStackView.addArrangedSubview(carbView)
        carbStackView.axis = .vertical
        carbStackView.distribution = .fill
        carbStackView.spacing = 1
        
        fatStackView.addArrangedSubview(fatLabel)
        fatStackView.addArrangedSubview(fatValue)
        fatStackView.addArrangedSubview(fatView)
        fatStackView.axis = .vertical
        fatStackView.distribution = .fill
        fatStackView.spacing = 1
        
        informationLegend.addArrangedSubview(proteinStackView)
        informationLegend.addArrangedSubview(carbStackView)
        informationLegend.addArrangedSubview(fatStackView)
        
        informationLegend.axis = .horizontal
        informationLegend.distribution = .equalCentering
        informationLegend.spacing = 5
        informationLegend.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(breaker5)
        stackView.addArrangedSubview(pieChart)
        stackView.addArrangedSubview(informationLegend)
        stackView.addArrangedSubview(mealLabel)
        
        breakfastLabelStack.addArrangedSubview(breakfastButton)
        breakfastLabelStack.axis = .vertical
        
        breakfastStackView.addArrangedSubview(breakfastIcon)
        breakfastStackView.addArrangedSubview(breakfastLabelStack)
        breakfastStackView.axis = .horizontal
        breakfastStackView.distribution = .fill
        
        lunchLabelStack.addArrangedSubview(lunchButton)
        lunchLabelStack.axis = .vertical
        
        lunchStackView.addArrangedSubview(lunchIcon)
        lunchStackView.addArrangedSubview(lunchLabelStack)
        lunchStackView.axis = .horizontal
        lunchStackView.distribution = .fill
        
        dinnerLabelStack.addArrangedSubview(dinnerButton)
        dinnerLabelStack.axis = .vertical
        
        dinnerStackView.addArrangedSubview(dinnerIcon)
        dinnerStackView.addArrangedSubview(dinnerLabelStack)
        dinnerStackView.axis = .horizontal
        dinnerStackView.distribution = .fill
        
        snacksLabelStack.addArrangedSubview(snacksButton)
        snacksLabelStack.axis = .vertical
        
        snacksStackView.addArrangedSubview(snacksIcon)
        snacksStackView.addArrangedSubview(snacksLabelStack)
        snacksStackView.axis = .horizontal
        snacksStackView.distribution = .fill
        
        stackView.addArrangedSubview(breakfastStackView)
        stackView.addArrangedSubview(breaker)
        
        stackView.addArrangedSubview(lunchStackView)
        stackView.addArrangedSubview(breaker2)
        
        stackView.addArrangedSubview(dinnerStackView)
        stackView.addArrangedSubview(breaker3)
        
        stackView.addArrangedSubview(snacksStackView)
        stackView.addArrangedSubview(breaker4)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        scrollView.addSubview(stackView)
    }
    
    // Creates the breakfast button
    func setUpBreakfastButton(){
        let fontSize = 30
        let newLabel = PaddingLabel(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height))
        newLabel.textAlignment = .left
        newLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        newLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newLabel.widthAnchor.constraint(equalToConstant: stackView.frame.width * 0.80).isActive = true
        newLabel.text = "Breakfast"
        newLabel.isUserInteractionEnabled = true
        newLabel.backgroundColor = UIColor.white
        newLabel.paddingLeft = 15
        breakfastButton = newLabel
    }
    
    // Creates the lunch button
    func setUpLunchButton(){
        let fontSize = 30
        let newLabel = PaddingLabel(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height))
        newLabel.textAlignment = .left
        newLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        newLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newLabel.widthAnchor.constraint(equalToConstant: stackView.frame.width * 0.80).isActive = true
        newLabel.text = "Lunch"
        newLabel.isUserInteractionEnabled = true
        newLabel.backgroundColor = UIColor.white
        newLabel.paddingLeft = 15
        lunchButton = newLabel
    }
    
    // Creates the dinner button
    func setUpDinnerButton(){
        let fontSize = 30
        let newLabel = PaddingLabel(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height))
        newLabel.textAlignment = .left
        newLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        newLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newLabel.widthAnchor.constraint(equalToConstant: stackView.frame.width * 0.80).isActive = true
        newLabel.text = "Dinner"
        newLabel.isUserInteractionEnabled = true
        newLabel.backgroundColor = UIColor.white
        newLabel.paddingLeft = 15
        dinnerButton = newLabel
    }
    
    // Creates the snacks button
    func setUpSnacksButton(){
        let fontSize = 30
        let newLabel = PaddingLabel(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height))
        newLabel.textAlignment = .left
        newLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        newLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newLabel.widthAnchor.constraint(equalToConstant: stackView.frame.width * 0.80).isActive = true
        newLabel.text = "Snacks"
        newLabel.isUserInteractionEnabled = true
        newLabel.backgroundColor = UIColor.white
        newLabel.paddingLeft = 15
        snacksButton = newLabel
    }
    
    // When the breakfast button is tapped, display breakfast foods
    @objc func breakfastTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            breakfastStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            breakfastStackView.backgroundColor = .white
        }
        
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "BreakfastView") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // When the lunch button is tapped, display lunch foods
    @objc func lunchTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            lunchStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            lunchStackView.backgroundColor = .white
        }
        
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "LunchView") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // When the dinner button is tapped, display dinner foods
    @objc func dinnerTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            dinnerStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            dinnerStackView.backgroundColor = .white
        }
        
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "DinnerView") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // When the snacks button is tapped, display snack foods
    @objc func snacksTapFunction(gesture: UITapGestureRecognizer) {
        snacksStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        if gesture.state == .ended || gesture.state == .cancelled {
            snacksStackView.backgroundColor = .white
        }
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "SnackView") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
