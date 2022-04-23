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
        
        setUpAllStackViews()
    }
    
//    func goToMealView(){
//        guard let vc =
//            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
//            return
//        }
//        self.navigationController?.pushViewController(vc, animated: false)
//    }
    
    
    //Back button to go back to the previous page.
    @IBAction func BackButton(_ sender: Any) {
        goToMainActivity()
    }
    
    // Goes to the main activity after user selected a meal to add the food to
    func goToMainActivity(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Sets up the page view using the stack views
    func setUpAllStackViews(){
        
        // Sets up the buttons for the different meals
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
    
    // This is the tap gesture recogniser for the breakfast button
    @objc func breakfastTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            breakfastStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            breakfastStackView.backgroundColor = .white
        }
        
        // Adds food to breakfast
        addMeal(meal: "breakfast")
    }
    
    // This is the tap gesture recogniser for the lunch button
    @objc func lunchTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            lunchStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            lunchStackView.backgroundColor = .white
        }
        
        // Adds food to lunch
        addMeal(meal: "lunch")
    }
    
    // This is the tap gesture recogniser for the dinner button
    @objc func dinnerTapFunction(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            dinnerStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        } else if gesture.state == .ended || gesture.state == .cancelled {
            dinnerStackView.backgroundColor = .white
        }
        
        // Adds food to dinner
        addMeal(meal: "dinner")
    }
    
    // This is the tap gesture recogniser for the snacks button
    @objc func snacksTapFunction(gesture: UITapGestureRecognizer) {
        snacksStackView.backgroundColor = Helper.hexStringToUIColor(hex: "#F4F5F6")
        if gesture.state == .ended || gesture.state == .cancelled {
            snacksStackView.backgroundColor = .white
        }
        
        // Adds the food to snacks
        addMeal(meal: "snacks")
    }
    
    // Adds the food to the corresponding meal selected
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
        
        // Updates the user locally
        User.update()
        
        // Updates the database corresponding to the current user for each of the fields
        let types = ["calories", "protein", "carbs", "fat"]
        for type in types{
            User.updateServer(type: type)
        }
        
        // Updates the meals for this user on the database
        User.updateMeals()
        
        // Goes to the main pages
        goToMainActivity()
    }
    
}
