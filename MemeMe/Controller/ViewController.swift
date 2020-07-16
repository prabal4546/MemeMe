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
    
    @IBOutlet weak var memeView: UIView!
    
    //MARK:- VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    //MARK:- textField attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black /* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.foregroundColor: UIColor.white/* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5.0 /* TODO: fill in appropriate Float */
    ]
    func textFieldSetUp(){
        textTop.defaultTextAttributes = memeTextAttributes
        textBottom.defaultTextAttributes = memeTextAttributes
    }
    
    func setupTextFields(){
           for textfield : UITextField in [textBottom,textTop] {
               textfield.defaultTextAttributes = memeTextAttributes
        }
        
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
        func getKeyboardHeight(_ notification: Notification)->CGFloat{

            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let height = keyboardSize.cgRectValue.height
            return height

        }

        @objc func keyboardWillShow(_ notification:Notification){

            view.frame.origin.y = -getKeyboardHeight(notification)
        }

        func subscribeToKeyboardNotification(){

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        }

        func unsubscribeFromKeyboardNotifications() {

            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }

    
    //MARK: Move view up /down only for bottomTextField
   
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if textBottom.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
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


//MARK:- UITextField Delegate Methods
extension ViewController : UITextFieldDelegate {
    
    //MARK: Textfield empties first time
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "BOTTOM" || textField.text == "TOP" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
