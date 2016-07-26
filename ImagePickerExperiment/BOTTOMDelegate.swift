//
//  BOTTOMDelegate.swift
//  ImagePickerExperiment
//
//  Created by Xing Du on 7/25/16.
//  Copyright © 2016 XingDu. All rights reserved.
//

import Foundation
import UIKit

class BOTTOMDelegate: NSObject, UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textViewDidEndEditing(textField: UITextField) {
        if (textField.text=="")  {
            textField.text = "BOTTOM"
            textField.textColor = UIColor.whiteColor()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    
}