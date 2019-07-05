//
//  Constants.swift
//  SNEAKERHEADTODAY
//
//  Created by stegowl on 06/01/18.
//  Copyright © 2018 NiteshMak's. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit



struct myColors
{
    //static let AppThemeColor: UIColor = UIColor.init(hex: "#eaa104")
    static let AppThemeColor: UIColor = UIColor(red: 33.0/255.0, green: 172.0/255.0, blue: 2.0/255.0, alpha: 1.0)
     static let bgcolor: UIColor = UIColor(red: 54.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    static let AppNotifColor: UIColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    static let highlite:UIColor = UIColor(red: 0.0/255.0, green: 154.0/255.0, blue: 216.0/255.0, alpha: 1.0)
}
var ImageViewGif = UIImageView()

func addAlert(_ msg:String) {
    let alert = UIAlertController(title: "WARNING", message: msg, preferredStyle: UIAlertControllerStyle.alert)
    
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

extension UIViewController {
   
    func showMyAlert(messageIs : String) -> Void {
      
        let alertController = UIAlertController(title: "", message: messageIs, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
           
        }
        alertController.addAction(okAction)
       
        self.present(alertController, animated: true, completion: nil)
    }
    
}
extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func isEmptyString(_ text : NSString) -> Bool
    {
        if text .isEqual(to: "") || text.trimmingCharacters(in: CharacterSet.whitespaces) .isEmpty
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
}

struct mykeys {
    static let KDBPATH = "KdbPath"
    static let KISDEFAULTALARMSET = "kIsDefaultAlarmSet"
    static let KARRALARMDATETIME = "KarrAlarmDateTime"
    static let KARRALARMTIME = "KarrAlarmTime"
    static let KLASTCOUNTOFATTEMPT = "KlastCountOfAttempt"
    static let KPREVIOUSDATE = "KpreviousDate"
    static let KPREVWATERLEVAL = "KprevWaterLeval"
    static let KBOTTLECOUNT = "KbottleCount"
    static let KPREVDETAILS = "KpreviousDetails"
    static let KLASTWATERCONSTRAINT = "KlastWaterConstraint"
    static let KLASTLBLWATERLEVAL = "KLastLblWaterLeval"
    static let KTOOLTIP = "KToolTip"
    static let KISFIRSTNOTIF = "KisFirstNotif"
}

