//
//  SettingsViewController.swift
//  Phaze
//
//  Created by Kevin Cogan on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // This is our Settings page
    let elements = ["Privacy & Security", "Help & Support", "About", "Logout"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    var index: Int?
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(elements[indexPath.row]).")
        
        // Goes to our privacy and security page
        if (elements[indexPath.row] == "Privacy & Security") {
            UIApplication.shared.open(URL(string: "https://www.privacypolicies.com/live/1262b0a2-1e18-4c19-81f2-49d6c51b9f46")!, options: [:], completionHandler: nil)
        }
        
        // Goes to help and support
        if (elements[indexPath.row] == "Help & Support") {
            UIApplication.shared.open(URL(string: "http://website-env-1.eba-3evzsc6b.eu-west-1.elasticbeanstalk.com/#contact")!, options: [:], completionHandler: nil)
        }
        
        // Goes to about
        if (elements[indexPath.row] == "About") {
            UIApplication.shared.open(URL(string: "http://website-env-1.eba-3evzsc6b.eu-west-1.elasticbeanstalk.com/#about")!, options: [:], completionHandler: nil)
        }
        
        // Logs the user out and resets the current user
        if (elements[indexPath.row] == "Logout") {
            User.resetUser()
            guard let vc =
                self.storyboard?.instantiateViewController(withIdentifier: "loginView") else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }

    // Sets up the table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSettingCell") as! CustomSettingTableViewCell

        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2

        cell.settingsLabel.text = elements[indexPath.row]
        cell.settingsImage.image = UIImage(named: elements[indexPath.row])

        return cell
    }
    
}


