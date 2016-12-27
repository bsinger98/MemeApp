//
//  ViewController.swift
//  MemeApp
//
//  Created by Brian Singer on 12/17/16.
//  Copyright © 2016 Brian Singer. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        print("hello");
        makeSignInRequest(userEmail: emailField.text!, userPassword: passwordField.text!);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeSignInRequest(userEmail:String, userPassword:String) {
        let postBody = ["email": userEmail, "password": userPassword]
        let loginURL = URL(string: "https://www.memetinder.com/auth")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
       Alamofire.request(request)
        .responseJSON {response in
            // do whatever you want here
            print(response);
        }
    }

}

