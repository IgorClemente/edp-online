//
//  User.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 18/12/2017.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import Foundation

struct User {
    
    let user_id:Int
    let first_name:String
    let last_name:String
    let locality:String
    let uf:String
    let number_phone:String
    let email_account:String
    let points:Int
    
    init?(forInformation i:[String:Any]) {
        guard let user_id = i["id_user"] as? Int else {
           return nil
        }
        self.user_id = user_id
        
        guard let first_name = i["nome"] as? String else {
           return nil
        }
        self.first_name = first_name
        
        guard let last_name = i["sobrenome"] as? String else {
           return nil
        }
        self.last_name = last_name
        
        guard let locality = i["localidade"] as? String else {
           return nil
        }
        self.locality = locality
        
        guard let uf = i["uf"] as? String else {
           return nil
        }
        self.uf = uf
        
        guard let number_phone = i["numero_telefone"] as? String else {
           return nil
        }
        self.number_phone = number_phone
        
        guard let email_account = i["email"] as? String else {
            return nil
        }
        self.email_account = email_account
        
        guard let points = i["pontos"] as? Int else {
            return nil
        }
        self.points = points
    }
}
