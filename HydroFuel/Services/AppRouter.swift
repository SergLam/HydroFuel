//
//  AppRouter.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/7/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class AppRouter {
    
    static func setupAppRootVC(mainVC: UIViewController) {
        
        let leftViewController = Storyboard(.main).instantiateViewController(MenuVC.self)
        let nvc: UINavigationController = UINavigationController(rootViewController: mainVC)
        
        leftViewController.mainViewController = nvc
        let slideMenuController = SlideMenuController(mainViewController: nvc,
                                                      leftMenuViewController: leftViewController)
        
        slideMenuController.delegate = mainVC as? SlideMenuControllerDelegate
        AppDelegate.shared.window?.backgroundColor = UIColor.appBackgroundColor
        AppDelegate.shared.window?.rootViewController = slideMenuController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    static func createAlertVC() -> AlertVCNew {
        
        return Storyboard(.main).instantiateViewController(AlertVCNew.self)
    }
    
    static func createHomeVC() -> HomeVC {
        
        return Storyboard(.main).instantiateViewController(HomeVC.self)
    }
    
    static func createHistoryVC() -> HistoryVC {
        
        return Storyboard(.main).instantiateViewController(HistoryVC.self)
    }
    
    static func createHistoryDetail() -> HistoryDetail {
        
        return Storyboard(.main).instantiateViewController(HistoryDetail.self)
    }
    
    static func createMyStatisticVC() -> MyStatisticVC {
        
        return Storyboard(.main).instantiateViewController(MyStatisticVC.self)
    }
    
    static func createPersonalInfoVC() -> PersonalInfoVC {
        
        return Storyboard(.main).instantiateViewController(PersonalInfoVC.self)
    }
    
    
}
