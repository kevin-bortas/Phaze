//
//  ViewController.swift
//  Phaze
//
//  Created by Kevin Bortas on 04/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        if (txtUsername.text! != "" && txtPassword.text! != ""){
            login()
        }
        else {
            print("Unsuccessful, please try again")
        }
    }
    
    func goToMainActivity(){
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "MainActivityDisplayController") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func login() {
        let newUrl = User.url + "login"
        
        let url = URL(string: newUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let username = txtUsername.text!
        let password = txtPassword.text!
        
        let parameters: [String: Any] = [
            "Username": txtUsername.text!,
            "Password": txtPassword.text!
        ]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            if (response.statusCode == 200){
                User.username = username
                User.password = password
                DispatchQueue.main.async {
                    User.getUserNutritionalInformation()
                    self.goToMainActivity()
                }
            }
        }

        task.resume()
        
      }

}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

