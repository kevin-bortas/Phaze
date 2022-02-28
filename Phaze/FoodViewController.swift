//
//  ImageViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 19/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
    @IBOutlet var mealLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var tableView: UITableView!
//    @IBOutlet var backButton: UIButton!
    
    let meals = [
        "Breakfast",
        "Lunch",
        "Dinner",
        "Snacks"
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Styling tableView
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        // Do any additional setup after loading the view.
    }
    
    
    //Add button to add to the food diary and progress to the next page.
    @IBAction func didTapAddButton(sender: UIButton) {
        goToMealView()
    }
    
    func goToMealView(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "mealview") else {
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
    
}

extension FoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me!")
    }
}

extension FoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        let mealValue = meals[indexPath.row]

        cell.mealLabel.text = mealValue
        cell.mealImage.image = UIImage(named: mealValue)
        
        //Make cell look rounded.
        cell.celllView.layer.cornerRadius = cell.celllView.frame.height / 2
        
        // Round images
        cell.mealImage.layer.cornerRadius = cell.mealImage.frame.height / 2
        
        return cell
    }

}
