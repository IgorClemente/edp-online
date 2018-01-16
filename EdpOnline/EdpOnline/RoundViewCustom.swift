//
//  RoundViewsCustom.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 24/09/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit

@IBDesignable
class RoundViewCustom : NSObject {

    @IBInspectable var radii:Int = 10
    
    @IBOutlet var viewsRoundMedi:[UIView]? {
        didSet {
           guard let views = viewsRoundMedi else {
               return
           }
          
           views.forEach { view in
                view.layer.cornerRadius = CGFloat(radii)
                view.clipsToBounds      = true
           }
        }
    }
    
    @IBOutlet var imageRoundCircle:[UIView]? {
        didSet {
           guard let views =  imageRoundCircle else {
               return
           }
           
           views.forEach { view in
                let large               = view.frame.size.width
                view.clipsToBounds      = true
                view.layer.cornerRadius = CGFloat(0.5 * large)
           }
        }
    }
}

