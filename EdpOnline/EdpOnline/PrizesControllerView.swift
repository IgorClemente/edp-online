//
//  TelaPremiosController.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 01/10/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit


class PrizesControllerView : UIViewController {
    
    @IBOutlet var viewsPremios: [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let views = viewsPremios else {
            return
        }
        views.forEach { v in
            v.layer.borderColor = UIColor.darkGray.cgColor
            v.layer.borderWidth = 0.8
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func tapAbrirMenuPrincipal() {
        ControllerSideMenu.controller.createMainMenu(self)
    }
}
