//
//  DataViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    var displayText: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = displayText

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
