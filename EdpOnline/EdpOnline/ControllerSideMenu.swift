//
//  ControllerLateralMenu.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 27/09/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit


class ControllerSideMenu {
    
    init() {}
    static let controller = ControllerSideMenu()
    
    var activeControllerView:UIViewController?
    var transitonControllerView:UIViewController?  = nil
    var menu:UIView?
    
    func createMainMenu(_ viewEndPoint:UIViewController) -> Void {
        self.menu = SideMenuView(frame: viewEndPoint.view.frame)
        self.activeControllerView = viewEndPoint
        viewEndPoint.view.addSubview(self.menu ?? UIView())
    }
    
    @objc func tapReturnHome() {
        if let view = activeControllerView {
           view.dismiss(animated: true, completion: nil)
           self.closeMainMenu()
        }
    }
    
    @objc func tapSettingsCreateControllerView() {
        self.closeMainMenu()
        
        let settingsControllerView = SettingsControllerView(nibName: "SettingsControllerView",bundle: nil)
        settingsControllerView.modalTransitionStyle   = .crossDissolve
        settingsControllerView.modalPresentationStyle = .currentContext
        
        self.transitonControllerView?.dismiss(animated: false, completion: nil)
        
        let tela = UIApplication.shared.keyWindow?.rootViewController
        tela?.present(settingsControllerView,animated: true, completion: nil)
        self.transitonControllerView = settingsControllerView
    }
    
    @objc func tapRankingCreateControllerView() {
        self.closeMainMenu()
        
        let rankingControllerView = RankingControllerView(nibName: "RankingControllerView", bundle: nil)
        rankingControllerView.modalTransitionStyle   = .crossDissolve
        rankingControllerView.modalPresentationStyle = .currentContext
        
        self.transitonControllerView?.dismiss(animated: false, completion: nil)
        
        let tela = UIApplication.shared.keyWindow?.rootViewController
        tela?.present(rankingControllerView, animated: true, completion:nil)
        self.transitonControllerView = rankingControllerView
    }
    
    @objc func tapPremiosCreateControllerView() {
        self.closeMainMenu()
        
        let prizesControllerView = PrizesControllerView(nibName: "PrizesControllerView", bundle: nil)
        prizesControllerView.modalTransitionStyle   = .crossDissolve
        prizesControllerView.modalPresentationStyle = .currentContext
        
        self.transitonControllerView?.dismiss(animated: false, completion: nil)
        
        let tela = UIApplication.shared.keyWindow?.rootViewController
        tela?.present(prizesControllerView,animated:true,completion:nil)
        self.transitonControllerView = prizesControllerView
    }
    
    @objc func closeMainMenu() {
        guard let m = menu else {
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            m.alpha = 0.0
        }){ _ in
            m.removeFromSuperview()
        }
    }
}
