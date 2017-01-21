//
//  UploadImageController.swift
//  MemeApp
//
//  Created by Brian Singer on 12/17/16.
//  Copyright © 2016 Brian Singer. All rights reserved.
//

import UIKit
import Alamofire

class UploadImageController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var memeSelectImg: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBAction func uploadImage(_ sender: Any) {
        /* let imageData = UIPNGRepresentation(memeSelectImg.image)!
        
        Alamofire.upload(imageData, to: "https://memetinder/upload").responseJSON { response in
            debugPrint(response)
        } */
    }
    
    @IBAction func selectImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set image picker to use photolibrary and set delegate to controller
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self;
        
        // Initially disable upload button until user fills out all forms
        uploadButton.isEnabled = false;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Image Picker Callback
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Cast info as an image and try to put image in the selected image picture
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeSelectImg.contentMode = .scaleAspectFit
            memeSelectImg.image = pickedImage
            
            // Allow user to upload
            uploadButton.isEnabled = true;
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

