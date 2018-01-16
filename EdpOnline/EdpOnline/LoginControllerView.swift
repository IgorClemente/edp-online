//
//  LoginViewController.swift
//  EdpOnline
//  Autor : Igor Clemente dos Santos
//  Updare: 15/11/2017 - 23:20
//  Created by Igor Clemente dos Santos on 10/11/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit

class LoginControllerView : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var uiUsernameField: UITextField?
    @IBOutlet weak var uiPasswordField: UITextField?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
       let viewLeftUser   = UIView()
       viewLeftUser.frame = CGRect(x: 0, y: 0, width: 90, height: 25)
       let viewLeftPassword   = UIView()
       viewLeftPassword.frame = CGRect(x: 0, y: 0, width: 90, height: 25)
       
       let imageLeftViewUser   = UIImageView()
       imageLeftViewUser.frame = CGRect(x: 20, y: 0, width: 25, height: viewLeftUser.frame.height)
       imageLeftViewUser.image = UIImage(named: "user-login")
       viewLeftUser.addSubview(imageLeftViewUser)
        
       let imageLeftViewPassword   = UIImageView()
       imageLeftViewPassword.frame = CGRect(x: 20, y: 0, width: 25, height: viewLeftPassword.frame.height)
       imageLeftViewPassword.image = UIImage(named: "lock-password")
       viewLeftPassword.addSubview(imageLeftViewPassword)
        
       uiUsernameField?.leftViewMode  = .always
       uiUsernameField?.leftView      = viewLeftUser
       uiUsernameField?.textAlignment = .natural
       uiUsernameField?.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor:UIColor.black.withAlphaComponent(0.5)])
        
       uiPasswordField?.leftViewMode  = .always
       uiPasswordField?.leftView      = viewLeftPassword
       uiPasswordField?.textAlignment = .natural
       uiPasswordField?.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor:UIColor.black.withAlphaComponent(0.5)])
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let usernameField = self.uiUsernameField,
              let passwordField = self.uiPasswordField else {
              return true
        }
        
        let fieldsMap:[UITextField:UITextField?] = [
            usernameField : passwordField,
            passwordField : nil
        ]
        
        if let fieldSelected = fieldsMap[textField] ?? UITextField() {
           fieldSelected.becomeFirstResponder()
        }else{
             textField.resignFirstResponder()
        }
        return false
    }
}
