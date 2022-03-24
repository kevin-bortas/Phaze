//
//  ImageViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 19/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
//    @IBOutlet var mealLabel: UILabel!
//    @IBOutlet var addButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var stackView: UIStackView!
//    @IBOutlet var tableView: UITableView!
//    @IBOutlet var backButton: UIButton!
    
    var food: Food?
    
//    let meals = [
//        "Breakfast",
//        "Lunch",
//        "Dinner",
//        "Snacks"
//    ]
    
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
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        // Styling tableView
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator = false

        // Do any additional setup after loading the view.
        
        setUpAllStackViews()
    }
    
    
    //Add button to add to the food diary and progress to the next page.
//    @IBAction func didTapAddButton(sender: UIButton) {
//        goToMealView()
//    }
    
    func goToMealView(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    //Back button to go back to the previous page.
    @IBAction func BackButton(_ sender: Any) {
        goToMainActivity()
    }
    
    func goToMainActivity(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        
        print("hello")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpAllStackViews(){
        
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
        breaker.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker2: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker2.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker2.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker3: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker3.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker3.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker3.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker4: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker4.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker4.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker4.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        
        let breaker5: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
            return v
        }()
        breaker5.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        breaker5.heightAnchor.constraint(equalToConstant: 3).isActive = true
        breaker5.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        
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
        
        stackView.addArrangedSubview(breaker5)
        stackView.addArrangedSubview(breakfastStackView)
        stackView.addArrangedSubview(breaker)
        
        stackView.addArrangedSubview(lunchStackView)
        stackView.addArrangedSubview(breaker2)
        
        stackView.addArrangedSubview(dinnerStackView)
        stackView.addArrangedSubview(breaker3)
        
        stackView.addArrangedSubview(snacksStackView)
        stackView.addArrangedSubview(breaker4)
        stackView.distribution = .equalCentering
        stackView.spacing = 0
        stackView.isUserInteractionEnabled = true
        
    }
    
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
    
    @objc func breakfastTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            breakfastStackView.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            breakfastStackView.backgroundColor = .white
        }
        
        addMeal(meal: "breakfast")
    }
    
    @objc func lunchTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            lunchStackView.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            lunchStackView.backgroundColor = .white
        }
        
        addMeal(meal: "lunch")
    }
    
    @objc func dinnerTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            dinnerStackView.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            dinnerStackView.backgroundColor = .white
        }
        
        addMeal(meal: "dinner")
    }
    
    @objc func snacksTapFunction(gesture: UITapGestureRecognizer) {
        snacksStackView.backgroundColor = hexStringToUIColor(hex: "#F4F5F6")
        if gesture.state == .ended || gesture.state == .cancelled {
            snacksStackView.backgroundColor = .white
        }
        
        addMeal(meal: "snacks")
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
    
    func addMeal(meal: String) {
        switch(meal){
        case "breakfast":
            Breakfast.addMeal(food: food!)
        case "lunch":
            Lunch.addMeal(food: food!)
        case "dinner":
            Dinner.addMeal(food: food!)
        default:
            Snacks.addMeal(food: food!)
        }
        
        goToMainActivity()
    }
    
}
