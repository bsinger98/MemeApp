//
//  memeSwipeController.swift
//  MemeApp
//
//  Created by Brian Singer on 12/17/16.
//  Copyright © 2016 Brian Singer. All rights reserved.
//

import UIKit

class memeSwipeController: UIViewController {
    
    @IBOutlet weak var memeImg: UIImageView!
    @IBOutlet weak var greenSquare: UIView!
    @IBOutlet weak var blueSquare: UIView!
    
    private var originalBounds = CGRect.zero
    private var originalCenter = CGPoint.zero
    
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
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
    
    @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.memeImg)
        
        switch sender.state {
        case .began:
            print("Your touch start position is \(location)")
            print("Start location in image is \(boxLocation)")
            
        case .ended:
            print("Your touch end position is \(location)")
            print("End location in image is \(boxLocation)")
            
        default:
            break
        }
    }

    
}

