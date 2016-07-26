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
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(), //TODO: Fill in appropriate UIColor,
        NSForegroundColorAttributeName : UIColor.whiteColor(),//TODO: Fill in UIColor,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 3.0//TODO: Fill in appropriate Float
    ]

    
    let topDelegate = TOPDelegate()
    let bottomDelegate = BOTTOMDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TOP.delegate = topDelegate
        self.BOTTOM.delegate = bottomDelegate
        TOP.textAlignment = NSTextAlignment.Center
        BOTTOM.textAlignment = NSTextAlignment.Center
        TOP.text = "TOP"
        BOTTOM.text = "BOTTOM"
        TOP.defaultTextAttributes = memeTextAttributes
        BOTTOM.defaultTextAttributes = memeTextAttributes
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    
}

