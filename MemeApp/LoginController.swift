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
    
    // Always return false, sign in request will segue screen if there is a success or failure
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        makeSignInRequest(userEmail: emailField.text!, userPassword: passwordField.text!, sender: sender);
        
        return false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeSignInRequest(userEmail:String, userPassword:String, sender:Any?) {
        // Create HTTPS request with login info
        let postBody = ["email": userEmail, "password": userPassword]
        let loginURL = URL(string: "https://www.memetinder.com/auth")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request)
        .responseJSON {response in
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                
                if JSON["error"] != nil {
                    // TODO display error to user
                    print(JSON["error"]!);
                } else {
                    
                    // Save session token for later api usage
                    let defaults = UserDefaults.standard;
                    let sessionToken = JSON["sessionToken"] as! String
                    defaults.setValue(sessionToken, forKey: "sessionToken")
                    defaults.synchronize()
                    
                    // Login good, segue to next screen
                    self.performSegue(withIdentifier: "loginSegue", sender: sender);
                }
                
                
            } else {
                // TODO display error: trouble connecting to server
            }
            
        }
    }

}

