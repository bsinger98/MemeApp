//
//  memeSwipeController.swift
//  MemeApp
//
//  Created by Brian Singer on 12/17/16.
//  Copyright © 2016 Brian Singer. All rights reserved.
//

import UIKit

class memeSwipeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeRight(_ swipe:UISwipeGestureRecognizer) {
        print("Swipe Right")
        
    }
    
    @IBAction func swipeLeft(_ swipe:UISwipeGestureRecognizer) {
        print("Swipe Left")
        
    }

    
}

