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
        
        let storyboard1: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let leftViewController = storyboard1.instantiateViewController(withIdentifier: "menuVC") as! menuVC
        let nvc: UINavigationController = UINavigationController(rootViewController: mainVC)
        
        leftViewController.mainViewController = nvc
        let slideMenuController = SlideMenuController(mainViewController: nvc,
                                                      leftMenuViewController: leftViewController)
        
        slideMenuController.delegate = mainVC as? SlideMenuControllerDelegate
        AppDelegate.shared.window?.backgroundColor = UIColor.appBackgroundColor
        AppDelegate.shared.window?.rootViewController = slideMenuController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
}
