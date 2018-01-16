//
//  Scratch.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 12/12/2017.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit

class Scratch : NSObject {
    
    @IBInspectable var width:CGFloat = 0
    @IBInspectable var color:UIColor = UIColor.black
    
    @IBOutlet var targets:[UIView]? {
        didSet{
           guard let views = targets else {
             return
           }
        
           for view in views {
               view.layer.borderWidth = width
               view.layer.borderColor = color.cgColor
           }
        }
    }
}
