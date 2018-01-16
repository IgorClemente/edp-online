//
//  LateralMenuView.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 24/09/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit


class SideMenuView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let menuController = ControllerSideMenu.controller
        
        let modalBackground       = UIView()
            modalBackground.frame = CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height)
            modalBackground.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            modalBackground.tag = 10
        
        let mainMenu       = UIView()
            mainMenu.frame = CGRect(x:0,y:0,width:125,height:self.frame.height)
            mainMenu.backgroundColor = UIColor.white
        
        let profileImage       = UIImageView()
            profileImage.frame = CGRect(x:20,y:30,width:90,height:90)
            profileImage.clipsToBounds = true
            profileImage.image         = UIImage(named:"photo-perfil")
            profileImage.contentMode        = .scaleAspectFill
            profileImage.layer.cornerRadius = profileImage.frame.width/2
        
        let settingsButton               = UIButton()
            settingsButton.clipsToBounds = true
            settingsButton.setImage(UIImage(named:"settings"), for: .normal)
            settingsButton.contentMode   = .scaleAspectFill
            settingsButton.translatesAutoresizingMaskIntoConstraints = false
            settingsButton.addTarget(menuController, action: #selector(menuController.tapSettingsCreateControllerView), for: .touchUpInside)
        
        let homeReturnButton               = UIButton()
            homeReturnButton.clipsToBounds = true
            homeReturnButton.setImage(UIImage(named:"home"), for: .normal)
            homeReturnButton.layer.cornerRadius = homeReturnButton.frame.width/2
            homeReturnButton.translatesAutoresizingMaskIntoConstraints = false
            homeReturnButton.addTarget(menuController, action: #selector(menuController.tapReturnHome), for: .touchUpInside)
        
        let rankingButton               = UIButton()
            rankingButton.clipsToBounds = true
            rankingButton.setImage(UIImage(named:"ranking"), for: .normal)
            rankingButton.layer.cornerRadius = homeReturnButton.frame.width/2
            rankingButton.translatesAutoresizingMaskIntoConstraints = false
            rankingButton.addTarget(menuController, action: #selector(menuController.tapRankingCreateControllerView), for: .touchUpInside)
        
        let prizesButton               = UIButton()
            prizesButton.clipsToBounds = true
            prizesButton.setImage(UIImage(named:"favorite"), for: .normal)
            prizesButton.layer.cornerRadius = homeReturnButton.frame.width/2
            prizesButton.translatesAutoresizingMaskIntoConstraints = false
            prizesButton.addTarget(menuController,action:
            #selector(menuController.tapPremiosCreateControllerView),for:.touchUpInside)
        
        mainMenu.addSubview(homeReturnButton)
        mainMenu.addSubview(rankingButton)
        mainMenu.addSubview(prizesButton)
        mainMenu.addSubview(settingsButton)
        mainMenu.addSubview(profileImage)
        modalBackground.addSubview(mainMenu)
        self.addSubview(modalBackground)
        
        var limiters = [NSLayoutConstraint]()
        limiters.append(contentsOf:[NSLayoutConstraint(item: homeReturnButton, attribute: .bottom,relatedBy: .equal
            ,toItem: rankingButton,attribute: .top,multiplier: 1.0,constant: -55)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: homeReturnButton, attribute: .centerX,relatedBy: .equal,toItem: mainMenu,attribute: .centerX, multiplier: 1.0,constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: homeReturnButton, attribute: .width,relatedBy: .equal,toItem: mainMenu,attribute: .width, multiplier: 0.4,constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: homeReturnButton, attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute, multiplier: 1,constant:47)])
        
        limiters.append(contentsOf:
            [NSLayoutConstraint(item: rankingButton,attribute: .centerY, relatedBy: .equal,toItem:
            mainMenu,attribute:
                .centerY,multiplier: 1,constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: rankingButton,attribute: .centerX,relatedBy: .equal,toItem: mainMenu, attribute: .centerX, multiplier: 1.0, constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: rankingButton, attribute: .width,relatedBy: .equal,toItem: mainMenu,attribute: .width,multiplier: 0.4,constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: rankingButton, attribute: .height,relatedBy:.equal,toItem: nil,attribute: .notAnAttribute, multiplier: 1.0, constant: 50)])
        
        limiters.append(contentsOf:
            [NSLayoutConstraint(item: prizesButton,attribute: .top, relatedBy: .equal,toItem:
                rankingButton,attribute:
                .bottom,multiplier: 1,constant: 50)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: prizesButton,attribute: .centerX,relatedBy: .equal,toItem: mainMenu, attribute: .centerX, multiplier: 1.0, constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: prizesButton, attribute: .width,relatedBy: .equal,toItem: mainMenu,attribute: .width,multiplier: 0.4,constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: prizesButton, attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute, multiplier: 1.0, constant: 50)])
        
        limiters.append(contentsOf:
            [NSLayoutConstraint(item: settingsButton,attribute: .bottom, relatedBy: .equal,toItem:
                mainMenu,attribute:
                .bottom,multiplier: 1.0,constant: -50)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: settingsButton,attribute: .centerX,relatedBy: .equal,toItem: mainMenu, attribute: .centerX, multiplier: 1.0, constant: 0)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: settingsButton, attribute: .width,relatedBy: .equal,toItem: mainMenu,attribute: .width,multiplier: 0.4,constant: 3)])
        
        limiters.append(contentsOf:[NSLayoutConstraint(item: settingsButton, attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute, multiplier: 1.0, constant: 53)])
        
        NSLayoutConstraint.activate(limiters)
        
        self.alpha = 0.0
        let centerBefore = CGPoint(x: mainMenu.center.x - 125,y: mainMenu.center.y)
        let centerFinal = mainMenu.center
        
        mainMenu.alpha = 0.0
        mainMenu.center = centerBefore
        
        UIView.animate(withDuration: 0.4){
            mainMenu.center = centerFinal
            self.alpha = 1.0
            mainMenu.alpha = 1.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
           if t.view?.tag == 10 {
              UIView.animate(withDuration: 0.4, animations: {
                self.alpha = 0.0
              }){ _ in
                self.removeFromSuperview()
              }
           }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
