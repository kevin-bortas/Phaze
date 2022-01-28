//
//  ViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 04/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        if (txtUsername.text! == "kevin" && txtPassword.text! == "123"){
            goToMainActivity()
        }
        else {
            print("Unsuccessful, please try again")
        }
        
        print("LOGIN")
    }
    
    func goToMainActivity(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

