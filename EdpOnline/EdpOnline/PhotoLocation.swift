//
//  PhotoLocation.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 07/01/2018.
//  Copyright © 2018 MACBOOK AIR. All rights reserved.
//

import Foundation

struct PhotoLocation {
    
    let street:String
    let state:String
    let city:String
    let subLocality:String
    
    init?(forInformation i:[AnyHashable:Any]) {
        guard let information = i as? [String:Any],
              let state = information["State"] as? String else {
            return nil
        }
        self.state = state
        
        guard let street = information["Street"] as? String,
              let streetFinaly = street.components(separatedBy: ",").first else {
            return nil
        }
        self.street = streetFinaly
        
        guard let city = information["City"] as? String else {
            return nil
        }
        self.city = city
        
        guard let subLocality = information["SubLocality"] as? String else {
            return nil
        }
        self.subLocality = subLocality
        
        print("Iniciado!")
    }
}
