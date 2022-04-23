//
//  SettingsViewController.swift
//  Phaze
//
//  Created by Kevin Cogan on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class DinnerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let elements = Dinner.getMeals()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    var index: Int?
    
    // Go back to main activity if back button pressed
    @IBAction func BackButton(_ sender: Any) {
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
    }
    
    // If a food item is tapped, delete it and update the user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(elements[indexPath.row]).")
        
        Dinner.removeMeal(position: indexPath.row)
        
        User.update()
        
        let types = ["calories", "protein", "carbs", "fat"]

        for type in types{
            User.updateServer(type: type)
        }
        User.updateMeals()

        // Refresh the page
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "DinnerView") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dinnerCell") as! CustomDinnerTableViewCell

        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 3.5

        cell.dinnerLabel.text = elements[indexPath.row].getName()
//        cell.breakfastImage.image = UIImage(named: elements[indexPath.row])
//        cell.settingsImage.layer.cornerRadius = cell.settingsImage.frame.height / 2

        return cell
    }
    
}


