//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Xing Du on 7/23/16.
//  Copyright © 2016 XingDu. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
   
    @IBOutlet weak var TOP:UITextField!
    
    @IBOutlet weak var BOTTOM:
    UITextField!
    
    var currentTextField : UITextField!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(), //TODO: Fill in appropriate UIColor,
        NSForegroundColorAttributeName : UIColor.whiteColor(),//TODO: Fill in UIColor,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0,//TODO: Fill in appropriate Float
        
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TOP.delegate = self
        self.BOTTOM.delegate = self
        
        TOP.text = "TOP"
        BOTTOM.text = "BOTTOM"
        
        TOP.defaultTextAttributes = memeTextAttributes
        BOTTOM.defaultTextAttributes = memeTextAttributes
        
        TOP.textAlignment = NSTextAlignment.Center
        BOTTOM.textAlignment = NSTextAlignment.Center
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.frame.origin.y = 0
    }
    
    //Sign up to be notified when the keyboard appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imagePickerView.image = image
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
        name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
        name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //When the keyboardWillShow notification is received, shift the view's frame up
    func keyboardWillShow(notification: NSNotification) -> Void {
        if BOTTOM.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void{
        
            self.view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion:nil)
    
    }
    

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

