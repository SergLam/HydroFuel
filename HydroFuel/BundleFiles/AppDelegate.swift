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

typealias VoidClosure = () -> ()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var entrySetArr = NSMutableArray()
    var window: UIWindow?
    var backvar = "static"
    var menuName = ""
    var menuvar = ""
    var resettime = "change"
    let dateFormatter = DateFormatter()
    var badgeCount = UIApplication.shared.applicationIconBadgeNumber
    var center = UNUserNotificationCenter.current()
    
    var changevalue = ""
    var str = 0
    
    var arraydate = NSMutableArray()
    var arrSetFixAlarmTime = NSMutableArray()
    var isAfterReset = false
    var isToolTipShown = false
    var isFirstNotif = false
    var timeselect = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        UNUserNotificationCenter.current().delegate = self
        
        if UserDefaultsManager.shared.shouldShowTutorial == false {
            isToolTipShown = UserDefaultsManager.shared.shouldShowTutorial
        }else{
            isToolTipShown = true
        }
        
        if UserDefaultsManager.shared.isFirstNotification == false {
            isFirstNotif = UserDefaultsManager.shared.isFirstNotification
        } else{
            isFirstNotif = true
        }
        
        permissionForAlert()
        let storyboard1: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.value(forKey: "fill") != nil{
            if UserDefaults.standard.value(forKey: "fill") as! Int == 2 {
                var mainViewController = UIViewController()
                mainViewController = storyboard1.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let leftViewController = storyboard1.instantiateViewController(withIdentifier: "menuVC") as! menuVC
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                
                leftViewController.mainViewController = nvc
                let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                
                slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
                self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
            }else{
                var mainViewController = UIViewController()
                mainViewController = storyboard1.instantiateViewController(withIdentifier: "AlertVCNew") as! AlertVCNew
                let leftViewController = storyboard1.instantiateViewController(withIdentifier: "menuVC") as! menuVC
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                
                leftViewController.mainViewController = nvc
                let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                
                slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
                self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
            }
            
        }
        else
        {
            // let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var mainViewController = UIViewController()
            menuvar = "hide"
            mainViewController = storyboard1.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
            let leftViewController = storyboard1.instantiateViewController(withIdentifier: "menuVC") as! menuVC
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            leftViewController.mainViewController = nvc
            let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
            
            slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
            self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    func permissionForAlert() {
        
        let options: UNAuthorizationOptions = [.badge, .alert, .sound];
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
            else{
                print("Premission Granted.!")
                //self.setDefaultAlarm()
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
            
        }
        UIApplication.shared.applicationIconBadgeNumber = 0 //new added
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        badgeCount = UIApplication.shared.applicationIconBadgeNumber
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0 //add new
        print(notification.request.content.userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber = notification.request.content.userInfo["Badge"] as! Int
        completionHandler([.alert, .badge, .sound])
        badgeCount = notification.request.content.userInfo["Badge"] as! Int
        UserDefaultsManager.shared.isFirstNotification = false
        isFirstNotif = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
    }
    
    
}

