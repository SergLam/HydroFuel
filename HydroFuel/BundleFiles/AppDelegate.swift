//
//  AppDelegate.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import IQKeyboardManagerSwift
import UserNotifications
import UserNotificationsUI
import Rswift

typealias VoidClosure = () -> ()
typealias Localizable = R.string.localizable

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    var backvar = "static"
    var menuName = ""
    var isMenuIconHidden: Bool = true
    var resettime = "change"
    
    var badgeCount = UIApplication.shared.applicationIconBadgeNumber
    
    var isAfterReset = false
    var timeselect = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate = self
        if UserDefaultsManager.shared.isFirstNotification == nil {
            UserDefaultsManager.shared.isFirstNotification = true
        }
        
        requestPermissionForAlerts()
        
        if DataManager.shared.currentUser == nil {
            
            isMenuIconHidden = true
            AppRouter.setupAppRootVC(mainVC: AppRouter.createPersonalInfoVC())
            
        } else if DataManager.shared.alarmTimes == nil {
            
            AppRouter.setupAppRootVC(mainVC: AppRouter.createAlertVC())
        } else {
            AppRouter.setupAppRootVC(mainVC: AppRouter.createHomeVC())
        }
        return true
    }
    
    func requestPermissionForAlerts() {
        
        let options: UNAuthorizationOptions = [.badge, .alert, .sound];
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            
        }
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        badgeCount = UIApplication.shared.applicationIconBadgeNumber
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Called when user cancel, open or select notification action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: update database values here
        
        completionHandler()
    }
    
    // The method will be called on the delegate only if the application is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let badgeCount = notification.request.content.userInfo["Badge"] as? Int else {
            assertionFailure("Unable to get badge count number")
            return
        }
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
        UserDefaultsManager.shared.isFirstNotification = false
        completionHandler([.alert, .badge, .sound])
        self.badgeCount = badgeCount
    }
    
    
}

