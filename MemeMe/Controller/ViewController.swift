//
//  ViewController.swift
//  MemeMe
//
//  Created by PRABALJIT WALIA     on 11/07/20.
//  Copyright © 2020 PRABALJIT WALIA    . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:-
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    
    //MARK:- VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //            subscribeToKeyboardNotification()
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //            unsubscribeFromKeyboardNotifications()
        
    }
    
    
    //MARK:-Image Picker Functionality
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:-adjusting keyboard
//        func getKeyboardHeight(_ notification: Notification)->CGFloat{
//
//            let userInfo = notification.userInfo
//            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey]
//            return keyboardSize.cgRectValue.height
//
//        }
//
//        @objc func keyboardWillShow(_ notification:Notification){
//
//            view.frame.origin.y = -getKeyboardHeight(notification)
//        }
//
//        func subscribeToKeyboardNotification(){
//
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
//        }
//
//        func unsubscribeFromKeyboardNotifications() {
//
//            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        }
    
    func save() {
            // Create the meme
            let meme = MemeModel(topText: textTop.text!, bottomText: textBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
    
    
}
