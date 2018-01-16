//
//  InfoRankingForacaster.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 03/10/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import Foundation

typealias Usuario = (nome:String,pontos:Int,id:Int)

func RankingInfo() -> [Usuario]? {
    var usuariosRanking:[Usuario] = []
    let address = "https://inovatend.mybluemix.net/usuarios"
    
    guard let url  = URL(string: address) else {
        return nil
    }
    
    do {
       let data = try Data(contentsOf: url)
       let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
       guard let info = json as? [String:Any],
             let usuarios = info["resultado"] as? [[String:Any]] else {
           return nil
       }
        
       for (_,u) in usuarios.enumerated() {
           guard let nome   = u["nome"] as? String,
                 let pontos = u["pontos"] as? Int,
                 let id     = u["id"] as? Int else {
               return nil
           }
           usuariosRanking.append((nome:nome,pontos:pontos,id:id))
        }
    }catch{
       print("ERROR",error.localizedDescription)
       return nil
    }
    
    return usuariosRanking
}
