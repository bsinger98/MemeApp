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
        
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = memeImg.bounds
        originalCenter = memeImg.center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fade() {
        UIView.animate(withDuration: 1, animations: {
            self.memeImg.alpha = 0.0;
        })
        
    }
    
    @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.memeImg)
        
        switch sender.state {
        case .began:
            // 1
            animator.removeAllBehaviors()
            
            // 2
            let centerOffset = UIOffset(horizontal: boxLocation.x - memeImg.bounds.midX,
                                        vertical: boxLocation.y - memeImg.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: memeImg,
                                                      offsetFromCenter: centerOffset, attachedToAnchor: location)
            
            // 3
            greenSquare.center = attachmentBehavior.anchorPoint
            blueSquare.center = location
            
            // 4
            animator.addBehavior(attachmentBehavior)
            
        case .ended:
            
            // Check if anchor is passed left or right swipe zones
            print(self.view.bounds.width/2)
            if(location.x > self.view.bounds.width/2 + 105) {
                print("swipe right")
            } else if(location.x < self.view.bounds.width/2 - 105) {
                print("swipe left")
            }
            print(location.x)
           
            resetDemo()
            
        default:
            attachmentBehavior.anchorPoint = sender.location(in: view)
            greenSquare.center = attachmentBehavior.anchorPoint
        }
    }
    
    //this returns the meme back to the starting place
    func resetDemo() {
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.45) {
            self.memeImg.bounds = self.originalBounds
            self.memeImg.center = self.originalCenter
            self.memeImg.transform = CGAffineTransform.identity
        }
    }

    
}

