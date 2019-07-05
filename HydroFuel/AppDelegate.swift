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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.sharedManager().enable = true
        
        UNUserNotificationCenter.current().delegate = self
        
        if UserDefaults.standard.value(forKey: mykeys.KTOOLTIP) != nil {
            isToolTipShown = UserDefaults.standard.value(forKey: mykeys.KTOOLTIP) as! Bool
        }else{
            isToolTipShown = true
        }
        
        if UserDefaults.standard.value(forKey: mykeys.KISFIRSTNOTIF) != nil {
            isFirstNotif = UserDefaults.standard.value(forKey: mykeys.KISFIRSTNOTIF) as! Bool
        }else{
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
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
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
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
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
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
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
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("ForeGround")
        badgeCount = UIApplication.shared.applicationIconBadgeNumber
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
}
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
        UserDefaults.standard.set(false, forKey: mykeys.KISFIRSTNOTIF)
        isFirstNotif = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
    }
    
    
    
    
}
extension UIViewController {
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
