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
    @IBOutlet weak var autoLayoutContainer: UIView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageViewContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewContainerHeight: NSLayoutConstraint!

    @IBOutlet weak var imagePickerView: UIImageView!
   
    @IBOutlet weak var top:UITextField!
    
    @IBOutlet weak var bottom:
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
        self.top.delegate = self
        self.bottom.delegate = self
        
        top.text = "TOP"
        bottom.text = "BOTTOM"
        
        top.defaultTextAttributes = memeTextAttributes
        bottom.defaultTextAttributes = memeTextAttributes
        
        top.textAlignment = NSTextAlignment.Center
        bottom.textAlignment = NSTextAlignment.Center
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.frame.origin.y = 0
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
        if bottom.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        } else {
            self.view.frame.origin.y = 0
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
    
    @IBAction func shareImage(sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        var completionWithItemsHandler: UIActivityViewControllerCompletionWithItemsHandler?
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (!completed) {
                return
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
        var meme = Meme(texts: (top: top.text!, bottom: bottom.text!), image: self.imagePickerView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        print(self.imageViewContainer.frame)
        var multiplier = CGFloat(0)
        
        if let image = self.imagePickerView.image {
            let oldImageSize = self.imageViewContainerWidth.constant;
            let temporarySize = (image.size.width > image.size.height) ? image.size.height : image.size.width;
            
            multiplier = (temporarySize / oldImageSize) * 2;
        }
        
        
        //self.imageViewContainerWidth.
        
        print(self.imageViewContainer.frame)
        
        UIGraphicsBeginImageContextWithOptions(self.imageViewContainer.bounds.size, false, multiplier)
        //UIGraphicsBeginImageContext(self.imageViewContainer.bounds.size)
        
        self.imageViewContainer.drawViewHierarchyInRect(self.imageViewContainer.bounds, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        //self.topTextFieldDelegate.applyFontSizeMultiplier(multiplier: 1)
        //self.bottomTextFieldDelegate.applyFontSizeMultiplier(multiplier: 1)
        //self.updateImageContainerSize()
        
        return memedImage;
    }
    
    
}

