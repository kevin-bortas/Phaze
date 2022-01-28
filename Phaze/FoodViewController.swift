//
//  ImageViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 19/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
    @IBOutlet var addButton: UIButton!
//    @IBOutlet var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAddButton(sender: UIButton) {
        goToMealView()
    }
    
    func goToMealView(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "mealview") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
