//
//  KeyboardContraint.swift
//  FaceFriends
//
//  Created by Nilo on 15/10/17.
//  Copyright © 2017 Nilo. All rights reserved.
//

import UIKit

class KeyboardContraint : NSLayoutConstraint {
    
    var originalConstant:CGFloat = 0
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        originalConstant = self.constant
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardDidHide(not:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardDidShow(not:)),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil)
    }
    
    @objc func keyboardDidHide(not:Notification) {
        self.constant = originalConstant
    }
    
    @objc func keyboardDidShow(not:Notification) {
        guard let aValue = not.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        
        let frame = aValue.cgRectValue
        self.constant = originalConstant + frame.size.height
    }
    
}
