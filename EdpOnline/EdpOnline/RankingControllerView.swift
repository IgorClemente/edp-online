//
//  TelaPremioController.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 01/10/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit

class RankingControllerView : UIViewController {
    
    @IBOutlet weak var uiViewFundoRanking: UIView?
    @IBOutlet var posicoesDoRanking: [UIView]?
    @IBOutlet weak var uiSpinnerActivity: UIActivityIndicatorView?
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        uiViewFundoRanking?.backgroundColor = UIColor.white
        guard let posicoes = posicoesDoRanking else {
            return
        }
        
        posicoes.forEach { posicao in
            posicao.isHidden = true
        }
        
        uiSpinnerActivity?.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let posicoes = posicoesDoRanking,
              let usuarios = RankingInfo() else {
              uiSpinnerActivity?.stopAnimating()
              return
        }
        
        uiViewFundoRanking?.backgroundColor = UIColor.lightGray
        
        for (index,posicao) in posicoes.enumerated() {
            
            posicao.isHidden = false
            posicao.layer.borderColor = UIColor.black.cgColor
            var count = 0
            
            posicao.subviews.enumerated().forEach { (i,p) in
             if let identificador = p.restorationIdentifier,
                let campo = p as? UILabel {
                
                switch identificador {
                  case "\(index+1)_nome":
                    campo.text  = usuarios[index].nome
                  case "\(index+1)_pontos":
                    campo.text = "\(usuarios[index].pontos) pontos"
                  default:
                    break
                }
                count += 1
             }
              
             if let image = p as? WebImageView ,
                let identificador = p.restorationIdentifier{
                if identificador == "\(index+1)_image" {
                   let idUser = usuarios[index].id
                   image.url = URL(string: "https://inovatend.mybluemix.net/usuarios/pictures/\(idUser)")
                }
             }
           }
         }
         uiSpinnerActivity?.stopAnimating()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func tapCriarMenuPrincipal() {
        ControllerSideMenu.controller.createMainMenu(self)
    }
}
