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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
   
    @IBOutlet weak var camera: UIBarButtonItem!
    

    @IBOutlet weak var imagePickerView: UIImageView!
   
    @IBOutlet weak var topTextField:UITextField!
    
    @IBOutlet weak var bottomTextField:
    UITextField!
    
    var currentTextField : UITextField!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(), //TODO: Fill in appropriate UIColor,
        NSForegroundColorAttributeName : UIColor.whiteColor(),//TODO: Fill in UIColor,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0,//TODO: Fill in appropriate Float
        
    ]
    
    func configureTextField(textField: UITextField){
        textField.text = textField==topTextField ? "TOP" : "BOTTOM"
        // assign delegate
        textField.delegate = self
        // assign attributes
        textField.defaultTextAttributes = memeTextAttributes
        // center
        textField.textAlignment = NSTextAlignment.Center
        // anything else if needed
    }
    
    //hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(topTextField)
        configureTextField(bottomTextField)
        // Do any additional setup after loading the view, typically from a nib.
        view.frame.origin.y = 0
        //camera button disabled when ruuning on simulator
        camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
            }
    
    //Sign up to be notified when the keyboard appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        //share button disabled before image is chosen
        if let imageViewHasImage = self.imagePickerView.image {
            shareButton.enabled = true
        }else {
            shareButton.enabled = false
        }
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
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void{
        
            view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion:nil)
    }

    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        presentImagePickerWith(.PhotoLibrary)
    
    }
    

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
    
        presentImagePickerWith(.Camera)
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        var completionWithItemsHandler: UIActivityViewControllerCompletionWithItemsHandler?
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (completed) {
                self.saveMeme()
            }
            
            //activity complete
            //some code here
            
            
        }
        
        self.presentViewController(activityController, animated: true, completion: nil)
        
        
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func saveMeme() {
        let memedImage = self.generateMemedImage()
        var meme = Meme(texts: (top: topTextField.text!, bottom: bottomTextField.text!), image: self.imagePickerView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
            
            // TODO: Hide toolbar and navbar
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: true)
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawViewHierarchyInRect(self.view.frame,
                                         afterScreenUpdates: true)
            let memedImage : UIImage =
                UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // TODO:  Show toolbar and navbar       
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(false, animated: true)
            return memedImage
        }
}

