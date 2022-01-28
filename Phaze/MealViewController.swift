//
//  MealViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 23/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class MealViewController: UIViewController {

    @IBOutlet var addButton: UIButton!
//    @IBOutlet var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAddButton(sender: UIButton) {
        goToMainActivity()
    }
    
    func goToMainActivity(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
