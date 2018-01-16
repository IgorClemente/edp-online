//
//  WebImageView.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 20/11/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit

@IBDesignable
class WebImageView : UIImageView {
    
    static private var imageCached:[URL:UIImage] = [:]
    
    var url:URL? {
       didSet{
         guard let url = self.url else {
               return
         }
         if let image = WebImageView.imageCached[url] {
            self.image = image
         }else{
            DispatchQueue.global().async {
              do{
                let pictureData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: pictureData)
                    WebImageView.imageCached[url] = self.image
                }
              }catch{
                print("ERROR",error.localizedDescription)
              }
            }
         }
       }
    }
    
    @IBInspectable var rounded:Bool = true {
        didSet{
          if rounded {
             self.layer.cornerRadius = min(self.frame.width,self.frame.height)/2.0
             self.clipsToBounds = true
          }else{
             self.layer.cornerRadius = 0
          }
        }
    }
}
