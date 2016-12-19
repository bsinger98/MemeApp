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
    
    @IBAction func swipeRight(_ swipe:UISwipeGestureRecognizer) {
        self.fadeRight()
        
    }
    
    @IBAction func swipeLeft(_ swipe:UISwipeGestureRecognizer) {
        self.fadeLeft()
        
    }
    
    func fadeRight() {
        UIView.animate(withDuration: 1, animations: {
            self.memeImg.alpha = 0.0;
            self.memeImg.frame.origin.x = 100;
        })
        
    }
    
    func fadeLeft() {
        UIView.animate(withDuration: 1.5, animations: {
            self.memeImg.alpha = 0.0;
            self.memeImg.frame.origin.y = -100;
        })
        
    }
    
    @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.memeImg)
        
        switch sender.state {
        case .began:
            print("Your touch start position is \(location)")
            print("Start location in image is \(boxLocation)")
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
            print("Your touch end position is \(location)")
            print("End location in image is \(boxLocation)")
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

