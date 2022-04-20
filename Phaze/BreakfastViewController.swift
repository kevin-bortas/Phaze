//
//  SettingsViewController.swift
//  Phaze
//
//  Created by Kevin Cogan on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class BreakfastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let elements = Breakfast.getMeals()

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    var index: Int?
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(elements[indexPath.row]).")
        
        Breakfast.removeMeal(position: indexPath.row)
        
        User.update()
        
        let types = ["calories", "protein", "carbs", "fat"]

        for type in types{
            User.updateServer(type: type)
        }
        User.updateMeals()

        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "BreakfastView") else {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "breakfastCell") as! CustomBreakfastTableViewCell

        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 3.5

        cell.breakfastLabel.text = elements[indexPath.row].getName()
//        cell.breakfastImage.image = UIImage(named: elements[indexPath.row])
//        cell.settingsImage.layer.cornerRadius = cell.settingsImage.frame.height / 2

        return cell
    }
    
}


