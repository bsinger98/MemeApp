//
//  memeSwipeController.swift
//  MemeApp
//
//  Created by Brian Singer on 12/17/16.
//  Copyright © 2016 Brian Singer. All rights reserved.
//

import UIKit
import Alamofire

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
    
    private var currentImageId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = memeImg.bounds
        originalCenter = memeImg.center
        
        let defaults = UserDefaults.standard;
        let sessionToken = defaults.string(forKey: "sessionToken");
        
        let serverUrl = URL(string: "https://www.memetinder.com/api/vote/getImage")!
        
        self.setImageFromAPI(serverUrl: serverUrl, sessionToken: sessionToken!)
    }
    
    // First gets an image url from the server, then uses that url to set the UIImage
    func setImageFromAPI(serverUrl: URL, sessionToken: String) {
        var request = URLRequest(url: serverUrl)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionToken, forHTTPHeaderField: "x-access-token")
        
        Alamofire.request(request)
            .responseJSON {response in
                
                if let result = response.result.value {
                    let JSON = result as! [String: Any]
                    
                    if JSON["error"] != nil {
                        // TODO display error to user
                        print(JSON["error"]!);
                    } else {
                        
                        // Gets image url and sets the current image id for voting
                        let imageArray = JSON["image"] as! [Any]
                        let imageDat = imageArray[0] as! [String: Any]
                        let imageUrl = URL(string: imageDat["url"] as! String)
                        
                        self.currentImageId = imageDat["id"] as! String
                        
                        self.setMemeImageFromUrl(imageUrl: imageUrl!, sessionToken: sessionToken)
                    }
                    
                    
                } else {
                    // TODO display error: trouble connecting to server
                }
                
        }

    }
    
    // Gets the image info from the CDN and replaces the image on the screen
    func setMemeImageFromUrl(imageUrl: URL, sessionToken: String) {
        var imgRequest = URLRequest(url: imageUrl)
        
        imgRequest.httpMethod = "GET"
        imgRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        imgRequest.setValue(sessionToken, forHTTPHeaderField: "x-access-token")
        
        Alamofire.request(imgRequest)
            .response { response in
                self.memeImg.image = UIImage(data: response.data!, scale:1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Unused function that may be useful for fade animations
    func fade() {
        UIView.animate(withDuration: 1, animations: {
            self.memeImg.alpha = 0.0;
        })
        
    }
    
    // Used tutorial from: https://www.raywenderlich.com/94719/uikit-dynamics-swift-tutorial-tossing-views
    @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.memeImg)
        
        switch sender.state {
        case .began:
            // Remove any previous animations
            animator.removeAllBehaviors()
            
            // Offset from different location of finger on image
            let centerOffset = UIOffset(horizontal: boxLocation.x - memeImg.bounds.midX, vertical: boxLocation.y - memeImg.bounds.midY)
            
            // Attaches anchor to image
            attachmentBehavior = UIAttachmentBehavior(item: memeImg, offsetFromCenter: centerOffset, attachedToAnchor: location)
            
            // DEBUG Squares: Blue is image anchor, Green is anchor location
            greenSquare.center = attachmentBehavior.anchorPoint
            blueSquare.center = location
            
            animator.addBehavior(attachmentBehavior)
            
        case .ended:
            
            // Check if anchor is passed left or right swipe zones
            if(location.x > self.view.bounds.width/2 + 105) {
                // If passed zone, vote and get new image from api
                let defaults = UserDefaults.standard;
                let sessionToken = defaults.string(forKey: "sessionToken");
                
                let serverUrl = URL(string: "https://www.memetinder.com/api/vote/voteUp/" + self.currentImageId)!
                
                self.setImageFromAPI(serverUrl: serverUrl, sessionToken: sessionToken!)
                
            } else if(location.x < self.view.bounds.width/2 - 105) {
                let defaults = UserDefaults.standard;
                let sessionToken = defaults.string(forKey: "sessionToken");
                
                let serverUrl = URL(string: "https://www.memetinder.com/api/vote/voteDown/" + self.currentImageId)!
                
                self.setImageFromAPI(serverUrl: serverUrl, sessionToken: sessionToken!)
            }
           
            resetAnimation()
            
        default:
            // Anchor follows finger lcoation
            attachmentBehavior.anchorPoint = sender.location(in: view)
            greenSquare.center = attachmentBehavior.anchorPoint
        }
    }
    
    // This returns everything to original position
    func resetAnimation() {
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.45) {
            self.memeImg.bounds = self.originalBounds
            self.memeImg.center = self.originalCenter
            self.memeImg.transform = CGAffineTransform.identity
        }
    }

    
}

