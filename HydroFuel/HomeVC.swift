

//
//  HomeVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SafariServices
import iShowcase
import CTShowcase

class HomeVC: UIViewController, iShowcaseDelegate {
    
    var dictPrevious = NSMutableDictionary()
    var enableColour = UIColor(hexString: "#4187D2")
    var disableColour = UIColor(hexString: "#8FC1E5")
    @IBOutlet var conBottomWater: NSLayoutConstraint!
    @IBOutlet weak var demowaterlevel: UILabel!
    @IBOutlet weak var lblBottleCount: UILabel!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var conTopBlueBG: NSLayoutConstraint!
    
    @IBOutlet weak var conImgTrailing: NSLayoutConstraint!
    @IBOutlet weak var conHeightWaterLeval: NSLayoutConstraint!
    
    @IBOutlet weak var conImgLeading: NSLayoutConstraint!
    
    @IBOutlet weak var lblWaterToDrink: UILabel!
    @IBOutlet weak var fartuMarkerView: UIView!
    @IBOutlet weak var lblWaterLavel: UILabel!
    
    @IBOutlet weak var notifMarkerView: UIView!
    @IBOutlet weak var lblNotifWaterLavel: UILabel!
    @IBOutlet weak var conTopNotifMarker: NSLayoutConstraint!
    
    @IBOutlet weak var notificationvideDomo: UIView!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnHydrate: UIButton!
    @IBOutlet weak var conBottomTab: NSLayoutConstraint!
    
    @IBOutlet weak var conTopBottleCount: NSLayoutConstraint!
    
    @IBOutlet weak var imgBottle: UIImageView!
    
    @IBOutlet var conTopvideoMarker: NSLayoutConstraint!
    
    var DATE = ""
    var WEIGHT = 0
    var GENDER = ""
    var ACTIVITYLAVEL = ""
    var WATERQTY = 0
    var REMAININGWATERQTY = 0
    var TOTALDRINK = 0
    var TOTALATTEMPT = 0
    var WATERQTYPERATTEMPT = 0
    
    var lastCountOfAttempt = 0
    var waterPerAttempt = 0
    var prevWaterLeval = CGFloat()
    var bottleCount = 0
    var timer = Timer()
    var counter = 0
    var bottleNumberAsNotif = 0
    var tottleBottle = 0
    var currentShowcase = 0
    var showcase = iShowcase()
    var arrFixDates: [Date] = []
    var arrSetFixAlarmTime = NSMutableArray()
    var strTimes = ""
    
    var differenceWater = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showcase.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        strTimes = dateFormatter.string(from: Date())
        print(strTimes)
        
        //createDB()
        let arrTime = UserDefaults.standard.value(forKey: mykeys.KARRALARMDATETIME) as! NSArray
        arrSetFixAlarmTime = arrTime.mutableCopy() as! NSMutableArray
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                conImgLeading.constant = 0
                conImgTrailing.constant = 0
                conTopBlueBG.constant = 44
                conBottomTab.constant = 0
                conTopBottleCount.constant = 0
                self.conTopvideoMarker.constant = 5
                self.differenceWater = 0
                createDB()
            case 1334:
                print("iPhone 6/6S/7/8")
                conImgLeading.constant = 0
                conImgTrailing.constant = 0
                conTopBlueBG.constant = 62
                conBottomTab.constant = 0
                conTopBottleCount.constant = 13
                self.conTopvideoMarker.constant = 25
                self.differenceWater = 0
                createDB()
            case 1920://
                print("iPhone 6+/6S+/7+/8+1111")
                conImgLeading.constant = 0
                conImgTrailing.constant = 0
                conTopBlueBG.constant = 74
                conBottomTab.constant = 0
                conTopBottleCount.constant = 25
                self.conTopvideoMarker.constant = 38
                createDB()
                if WATERQTY>5500 {
                    self.differenceWater = 0.1
                }else if WATERQTY>4500 {
                    self.differenceWater = 0.2
                }
                else if WATERQTY>4000 {
                    self.differenceWater = 0.3
                }
                else if WATERQTY>3500 {
                    self.differenceWater = 0.4
                }else if WATERQTY==3500 {
                    self.differenceWater = 0.5
                }else if WATERQTY==3000 {
                    self.differenceWater = 0
                }else if WATERQTY==2500 {
                    self.differenceWater = 0.1
                }else{
                    self.differenceWater = 0.2
                }
            case 2208://1920
                print("iPhone 6+/6S+/7+/8+2222")
                conImgLeading.constant = 0
                conImgTrailing.constant = 0
                conTopBlueBG.constant = 74
                conBottomTab.constant = 0
                conTopBottleCount.constant = 25
                self.conTopvideoMarker.constant = 38
                createDB()
                if WATERQTY>5500 {
                    self.differenceWater = 0.1
                }else if WATERQTY>4500 {
                    self.differenceWater = 0.2
                }
                else if WATERQTY>4000 {
                    self.differenceWater = 0.3
                }
                else if WATERQTY>3500 {
                    self.differenceWater = 0.4
                }else if WATERQTY==3500 {
                    self.differenceWater = 0.5
                }else if WATERQTY==3000 {
                    self.differenceWater = 0
                }else if WATERQTY==2500 {
                    self.differenceWater = 0.1
                }else{
                    self.differenceWater = 0.2
                }
            case 2436:
                if UserDefaults.standard.value(forKey: "waterlevel") != nil
                {
                    let value1 =  (UserDefaults.standard.value(forKey: "waterlevel") as! String)
                    print(value1)
                    lblWaterLavel.text = value1
                }else{
                    
                }
                print("iPhone X")
                conImgLeading.constant = -70
                conImgTrailing.constant = 70
                conTopBlueBG.constant = 81
                conBottomTab.constant = 15
                conTopBottleCount.constant = 25
                createDB()
                if WATERQTY>5500 {
                    self.differenceWater = 0.1
                }
                else if WATERQTY>5000 {
                    self.differenceWater = 0.4
                }
                else if WATERQTY>4500 {
                    self.differenceWater = 0.2
                }
                else if WATERQTY>4000 {
                    self.differenceWater = 0
                }else if WATERQTY>3000 {
                    self.differenceWater = 0.2
                }else if WATERQTY==2500 {
                    self.differenceWater = 0.3
                }else if WATERQTY==2000 {
                    self.differenceWater = 0.2
                }else{
                    self.differenceWater = 0
                }
                self.conTopvideoMarker.constant = 45
            default:
                print("unknown")
            }
            
        }
        if appDelegate.badgeCount < 1 {
            notifMarkerView.isHidden = true
        }
        
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if appDelegate.isToolTipShown == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                self.notificationvideDomo.isHidden = false
                self.showcase.setupShowcaseForView(self.lblWaterLavel)
                self.showcase.titleLabel.text = "Water level 1: This shows you how full the bottle is."
                self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
                self.showcase.detailsLabel.text = "\n"
                self.showcase.show()
               
            }
        }else{
            self.notificationvideDomo.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
             self.notifMarkerView.isHidden = false
             self.fartuMarkerView.isHidden = false
           // self.notificationvideDomo.isHidden = false
            self.countWaterLevalAsNotif()
        }
    }
    
    func iShowcaseShown(_ showcase: iShowcase) {
        currentShowcase += 1
    }
    
    func iShowcaseDismissed(_ showcase: iShowcase) {
        switch currentShowcase {
        case 1:
            self.showcase.setupShowcaseForView(self.demowaterlevel)
            self.showcase.titleLabel.text = "Water level 2: This shows you where you need to drink to."
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "      "
            self.showcase.show()
           
            
            break
            
            
        case 2:
            self.notificationvideDomo.isHidden = true
            self.showcase.setupShowcaseForView(self.btnHydrate)
            self.showcase.titleLabel.text = "Once you’ve drank… Tap ‘Hydrate’ and the water level will update automatically."
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "     "
            self.showcase.show()
            
            break
        case 3:
            self.showcase.setupShowcaseForView(self.btnReset)
            self.showcase.titleLabel.text = "Click here to reset today’s intake."
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "      "
            self.showcase.show()
           
            break
        case 4:
            self.showcase.setupShowcaseForView(self.imgBottle)
            self.showcase.titleLabel.text = "You’re Done! Fill up your bottle and lets get started!"
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "      "
            self.showcase.show()
           
            
            break
        default:
            UserDefaults.standard.set(false, forKey: mykeys.KTOOLTIP)
            appDelegate.isToolTipShown = false
            print("Default")
            checkForAutoNotif()
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notifMarkerView.isHidden = true
        notificationvideDomo.isHidden = true
        fartuMarkerView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(NotifArrives), name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
    }
    
    
    
    @objc func NotifArrives() {
        if appDelegate.badgeCount != 0 {
             btnHydrate.backgroundColor = enableColour
            var waterAsPerNotif = appDelegate.badgeCount * self.WATERQTYPERATTEMPT
            if waterAsPerNotif == 0 {
                waterAsPerNotif = self.WATERQTYPERATTEMPT
            }
            
            let floatData = Double(waterAsPerNotif)/1000.0
            let intData = Double(waterAsPerNotif/1000)
            if intData < floatData {
                bottleNumberAsNotif = (waterAsPerNotif/1000) + 1
            }else{
                bottleNumberAsNotif = (waterAsPerNotif/1000)
            }
            
            if bottleNumberAsNotif == bottleCount {
                let totalWater = 1000 * (bottleNumberAsNotif - 1)
                print(totalWater)
                lblNotifWaterLavel.text = "\(1000 - (waterAsPerNotif - totalWater))"
            }
            else{
                if bottleNumberAsNotif == tottleBottle {
                    let outerViewHeight = Int(self.viewOuter.frame.size.height)
                    let leval1 = Double(self.WATERQTY).truncatingRemainder(dividingBy: 1000.0)
                    print(leval1)
                    if leval1 == 0 {
                        self.conHeightWaterLeval.constant = self.viewOuter.frame.size.height
                        self.lblWaterLavel.text = "1000"
                    }else{
                        let lastBottleWater = CGFloat((Double(outerViewHeight)*leval1)/1000)
                        self.conHeightWaterLeval.constant = lastBottleWater
                        self.lblWaterLavel.text = "\(Int(leval1))"
                    }
                    
                    
                }else{
                conHeightWaterLeval.constant = viewOuter.frame.size.height
                lblBottleCount.text = "Bottle \(bottleNumberAsNotif) of \(tottleBottle)"
                lblWaterLavel.text = "1000"
                let totalWater = 1000 * (bottleNumberAsNotif - 1)
                print(totalWater)
                lblNotifWaterLavel.text = "\(1000 - (waterAsPerNotif - totalWater))"
                }
            }
            
          
            let needWater = appDelegate.badgeCount * self.WATERQTYPERATTEMPT
            let leval = Double(needWater).truncatingRemainder(dividingBy: 1000.0)
            print(leval)
            let outerViewHeight = Int(self.viewOuter.frame.size.height)
            
            lblBottleCount.text = "Bottle \(bottleNumberAsNotif) of \(tottleBottle)"
            if bottleNumberAsNotif == tottleBottle {
                let leval1 = Double(self.WATERQTY).truncatingRemainder(dividingBy: 1000.0)
                print(leval1)
                let decreasingHeightPerAttempt = Double((Double(outerViewHeight) * leval)/1000) + self.differenceWater
                let diff = Double((Double(outerViewHeight) * leval1)/1000) + self.differenceWater
                var markerLeval = 0
                if CGFloat(diff) + CGFloat(decreasingHeightPerAttempt) - 15 < 15 {
                    markerLeval = Int(viewOuter.frame.size.height) - 15
                }else{
                    markerLeval = Int(CGFloat(diff) + CGFloat(decreasingHeightPerAttempt) - 15)
                }
                conTopNotifMarker.constant = CGFloat(markerLeval)//CGFloat(diff) + CGFloat(decreasingHeightPerAttempt) - 15
                let totalWater = 1000 * (bottleNumberAsNotif - 1)
                print(totalWater)
                lblNotifWaterLavel.text = "\(Int(1000-leval1) - (waterAsPerNotif - totalWater))"
                if lblNotifWaterLavel.text == "0" {
                    conTopNotifMarker.constant = CGFloat(Int(viewOuter.frame.size.height) - 15)
                }
                notifMarkerView.isHidden = false
            }else{
                //let decreasingHeightPerAttempt = Double((Double(outerViewHeight) * leval)/1000) + self.differenceWater
                
                let leval1 = Double(self.WATERQTY).truncatingRemainder(dividingBy: 1000.0)
                print(leval1)
                let decreasingHeightPerAttempt = Double((Double(outerViewHeight) * leval)/1000) + self.differenceWater
                let diff = Double((Double(outerViewHeight) * leval1)/1000) + self.differenceWater
                var markerLeval = 0
                if CGFloat(diff) + CGFloat(decreasingHeightPerAttempt) - 15 < 15 {
                    markerLeval = Int(viewOuter.frame.size.height) - 15
                }else{
                    markerLeval = Int(CGFloat(decreasingHeightPerAttempt) - 15)
                }
                
                conTopNotifMarker.constant = CGFloat(markerLeval)//CGFloat(decreasingHeightPerAttempt) - 15
                notifMarkerView.isHidden = false
                let totalWater = 1000 * (bottleNumberAsNotif - 1)
                print(totalWater)
                lblNotifWaterLavel.text = "\(1000 - (waterAsPerNotif - totalWater))"
                if lblNotifWaterLavel.text == "0" {
                    conTopNotifMarker.constant = CGFloat(Int(viewOuter.frame.size.height) - 15)
                }
            }
        }else{
            btnHydrate.backgroundColor =  disableColour
            notifMarkerView.isHidden = true
        }
    }
    
    func checkForAutoNotif() {
        var localNotifCount = 0
        for i in 0...9 {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            format.timeZone = TimeZone(identifier: "UTC")
            let checkDate = format.date(from: arrSetFixAlarmTime[i] as! String)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(identifier: "UTC")
            let strDate1 = formatter.string(from: Date())
            print(strDate1)
            
            
            let format1 = DateFormatter()
            format1.dateFormat = "HH:mm"
            format1.timeZone = TimeZone(identifier: "UTC")
            let strDate2 = format1.string(from: checkDate!)
            print(strDate2)
            if   (dateFormatter.date(from: strDate2))! <= (dateFormatter.date(from: strTimes))!
            {
                localNotifCount += 1
                appDelegate.badgeCount = localNotifCount
            }
            if i == 9 {
                if localNotifCount <= self.lastCountOfAttempt {
                    appDelegate.badgeCount = 0
                    localNotifCount = 0
                }
                self.NotifArrives()
            }
        }
        
    }
    
    func countWaterLevalAsNotif() {
        
        var waterAsPerNotif = appDelegate.badgeCount * self.WATERQTYPERATTEMPT
        if waterAsPerNotif == 0 {
            waterAsPerNotif = self.WATERQTYPERATTEMPT
        }
        let floatData = Double(waterAsPerNotif)/1000.0
        let intData = Double(waterAsPerNotif/1000)
        var bottleNumberAsNotif = 0
        if intData < floatData {
            bottleNumberAsNotif = (waterAsPerNotif/1000) + 1
        }else{
            bottleNumberAsNotif = (waterAsPerNotif/1000)
        }
        
        
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) != nil{
            let previousDate = UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) as? String
            if previousDate == strDate {
                lastCountOfAttempt = UserDefaults.standard.value(forKey: mykeys.KLASTCOUNTOFATTEMPT) as! Int
                if UserDefaults.standard.value(forKey: mykeys.KLASTWATERCONSTRAINT) == nil {
                    UserDefaults.standard.set(viewOuter.frame.size.height, forKey: mykeys.KLASTWATERCONSTRAINT)
                }
                
                if UserDefaults.standard.value(forKey: mykeys.KPREVWATERLEVAL) == nil {
                    prevWaterLeval = viewOuter.frame.size.height
                    UserDefaults.standard.set(Double(viewOuter.frame.size.height).rounded(toPlaces: 6), forKey: mykeys.KPREVWATERLEVAL)
                }else{
                    prevWaterLeval = UserDefaults.standard.value(forKey: mykeys.KPREVWATERLEVAL) as! CGFloat
                }
                print(prevWaterLeval)
                bottleCount = UserDefaults.standard.value(forKey: mykeys.KBOTTLECOUNT) as! Int
                if appDelegate.badgeCount == 0
                {
                    bottleNumberAsNotif = bottleCount
                }
                if bottleNumberAsNotif == bottleCount {
                    conHeightWaterLeval.constant = CGFloat(prevWaterLeval)
                    lblBottleCount.text = "Bottle \(bottleCount) of \(tottleBottle)"
                    lblNotifWaterLavel.text = "\((1000 * bottleCount) - waterAsPerNotif)"
                    
                    if UIDevice().userInterfaceIdiom == .phone {
                        switch UIScreen.main.nativeBounds.height {
                        case 1136:
                            print("iPhone 5 or 5S or 5C")
                            conBottomTab.constant = 0
                            if UserDefaults.standard.value(forKey: "waterlevel") != nil
                            {
                                let value1 =  (UserDefaults.standard.value(forKey: "waterlevel") as! String)
                                print(value1)
                                lblWaterLavel.text = value1
                            }else{
                                lblWaterLavel.text = "\(1000)"
                            }
                            
                        case 1334:
                            print("iPhone 6/6S/7/8")
                            conBottomTab.constant = 0
                            if UserDefaults.standard.value(forKey: "waterlevel") != nil
                            {
                                let value1 =  (UserDefaults.standard.value(forKey: "waterlevel") as! String)
                                print(value1)
                                lblWaterLavel.text = value1
                            }else{
                                lblWaterLavel.text = "\(1000)"
                            }
                        case 1920:
                            print("iPhone 6+/6S+/7+/8+")
                            conBottomTab.constant = 0
                            if UserDefaults.standard.value(forKey: "waterlevel") != nil
                            {
                                let value1 =  (UserDefaults.standard.value(forKey: "waterlevel") as! String)
                                print(value1)
                                lblWaterLavel.text = value1
                            }else{
                                lblWaterLavel.text = "\(1000)"
                                
                            }
                        case 2208:
                            print("iPhone 6+/6S+/7+/8+")
                            conBottomTab.constant = 0
                            if UserDefaults.standard.value(forKey: "waterlevel") != nil
                            {
                                let value1 =  (UserDefaults.standard.value(forKey: "waterlevel") as! String)
                                print(value1)
                                lblWaterLavel.text = value1
                            }else{
                                lblWaterLavel.text = "\(1000)"
                                
                            }
                            
                        case 2436:
                            print("iPhone X")
                            print(prevWaterLeval)
                            conBottomTab.constant = 15
                            if UserDefaults.standard.value(forKey: "waterlevel") != nil
                            {
                                let value1 =  (UserDefaults.standard.value(forKey: "waterlevel") as! String)
                                print(value1)
                                lblWaterLavel.text = value1
                            }else{
                                lblWaterLavel.text = "\(1000)"
                                
                            }
                            
                        default:
                            print("unknown")
                        }
                    }
                    
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        if self.TOTALATTEMPT == 0
                        {
                            self.conHeightWaterLeval.constant = self.viewOuter.frame.size.height
                            self.lblBottleCount.text = "Bottle \(bottleNumberAsNotif) of \(self.tottleBottle)"
                        }else{
                            self.conHeightWaterLeval.constant = CGFloat(self.prevWaterLeval)
                            self.lblBottleCount.text = "Bottle \(bottleNumberAsNotif) of \(self.tottleBottle)"
                        }
                        
                        let totalWater = 1000 * (bottleNumberAsNotif - 1)
                        print(totalWater)
                        self.lblNotifWaterLavel.text = "\(1000 - (waterAsPerNotif - totalWater))"
                    }
                }
                if appDelegate.badgeCount < 1 {
                    notifMarkerView.isHidden = true
                }
            /*   if appDelegate.badgeCount > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let needWater = self.appDelegate.badgeCount * self.WATERQTYPERATTEMPT
                        let leval = Double(needWater).truncatingRemainder(dividingBy: 1000.0)
                        print(leval)
                        let outerViewHeight = Int(self.viewOuter.frame.size.height)
                        let decreasingHeightPerAttempt = Double((Double(outerViewHeight) * leval)/1000)
                        UIView.animate(withDuration: 1.0) {
                            self.conTopNotifMarker.constant = CGFloat(decreasingHeightPerAttempt) - 15
                            self.view.layoutIfNeeded()
                            self.view.layer.removeAllAnimations()
                        }
                        self.notifMarkerView.isHidden = false
                    }
                }else{
                    notifMarkerView.isHidden = true
                }*/
            }else{
                for i in 0..<arrSetFixAlarmTime.count {
                    let formattor = DateFormatter()
                    formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                    formattor.timeZone = TimeZone(identifier: "UTC")
                    let fixDate = formattor.date(from: arrSetFixAlarmTime[i] as! String)
                    print(fixDate!)
                    arrFixDates.append(fixDate!)
                }
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm"
                dateFormatter1.timeZone = TimeZone(identifier: "UTC")
                let strDate1 = dateFormatter1.string(from: Date())
                
                let format1 = DateFormatter()
                format1.dateFormat = "HH:mm"
                format1.timeZone = TimeZone(identifier: "UTC")
                let strDate2 = format1.string(from: arrFixDates[0])
                
                if   (dateFormatter1.date(from: strDate2))! <= (dateFormatter1.date(from: strDate1))!
                {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    appDelegate.badgeCount = 0
                }
                lastCountOfAttempt = 0
                bottleCount = 1
                prevWaterLeval = viewOuter.frame.size.height
                conHeightWaterLeval.constant = viewOuter.frame.size.height
                UserDefaults.standard.set(conHeightWaterLeval.constant, forKey: mykeys.KLASTWATERCONSTRAINT)
                UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
                UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
                UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
                UserDefaults.standard.set(Double(viewOuter.frame.size.height).rounded(toPlaces: 6), forKey: mykeys.KPREVWATERLEVAL)
                UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
                lblBottleCount.text = "Bottle \(bottleCount) of \(tottleBottle)"
                notifMarkerView.isHidden = true
                lblNotifWaterLavel.text = ""
                conTopNotifMarker.constant = -15
                lblWaterLavel.text = "\(1000)"
            }
        }else{
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            lastCountOfAttempt = 0
            bottleCount = 1
            prevWaterLeval = viewOuter.frame.size.height
            conHeightWaterLeval.constant = viewOuter.frame.size.height
            UserDefaults.standard.set(conHeightWaterLeval.constant, forKey: mykeys.KLASTWATERCONSTRAINT)
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set(Double(viewOuter.frame.size.height).rounded(toPlaces: 6), forKey: mykeys.KPREVWATERLEVAL)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
            lblBottleCount.text = "Bottle \(bottleCount) of \(tottleBottle)"
            notifMarkerView.isHidden = true
            lblNotifWaterLavel.text = ""
            conTopNotifMarker.constant = -15
            lblWaterLavel.text = "\(1000)"
        }
        if appDelegate.isToolTipShown != true {
            checkForAutoNotif()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        self.toggleLeft()
    }
    
    
    @IBAction func btnstatisticclick(_ sender: UIButton) {
        appDelegate.backvar = "abc"
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyStatisticVC") as! MyStatisticVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHistoryclick(_ sender: UIButton) {
        appDelegate.backvar = "abc"
        let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHomeclick(_ sender: UIButton) {
        
        
    }
    
    @IBAction func btnHelpclick(_ sender: UIButton) { //"www.hydro-fuel.co.uk/support
        
        UIApplication.shared.openURL(NSURL(string: "https://www.hydro-fuel.co.uk/support")! as URL)
        
        
    }
    
    @IBAction func btnRateusclick(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/buddyball/id1432543329?ls=1&mt=8")! as URL)
    }
    
    
    @IBAction func btnReseatClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure to reset today log?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("yes")
            self.appDelegate.isAfterReset = true
            self.resetData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    
    @IBAction func btnHydrateClick(_ sender: UIButton) {
        if appDelegate.badgeCount != 0 {
            UIApplication.shared.beginIgnoringInteractionEvents()
            btnHydrate.isUserInteractionEnabled = false
            let totalDrink = appDelegate.badgeCount - lastCountOfAttempt
            print("totalDrink--",totalDrink)
            let remainingWaterQty = self.REMAININGWATERQTY - (totalDrink*WATERQTYPERATTEMPT)
            print("remainingWaterQty--",remainingWaterQty)
            self.lblWaterToDrink.text = "\(remainingWaterQty)ml"
            self.conHeightWaterLeval.constant = UserDefaults.standard.value(forKey: mykeys.KLASTWATERCONSTRAINT) as! CGFloat
            UserDefaults.standard.set(nil, forKey: "waterlevel")
            
            self.lblBottleCount.text = "Bottle \(self.bottleCount) of \(tottleBottle)"
            
            print(lblBottleCount.text)
            self.lblWaterLavel.text = UserDefaults.standard.value(forKey: mykeys.KLASTLBLWATERLEVAL) as? String
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.changeStatus()
            }
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector:#selector(changeStatus), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeStatus() {
        
        if bottleCount != bottleNumberAsNotif {
            notifMarkerView.isHidden = true
        }else{
            notifMarkerView.isHidden = false
        }
        let lastBottle = Int(self.WATERQTY/1000) + 1
        let totalDrink = appDelegate.badgeCount - lastCountOfAttempt
        counter += 1
        if counter <= totalDrink {
            
            let outerViewHeight = Int(self.viewOuter.frame.size.height)
            let leval1 = Double(self.WATERQTY).truncatingRemainder(dividingBy: 1000.0)
            print(leval1)
            let lastBottleWater = CGFloat((Double(outerViewHeight)*leval1)/1000)
            var heightConstant = CGFloat()
            let decreasingHeightPerAttempt = Double((outerViewHeight*self.WATERQTYPERATTEMPT)/1000) + self.differenceWater
            
            if CGFloat(decreasingHeightPerAttempt) > self.conHeightWaterLeval.constant {
                
                heightConstant = self.conHeightWaterLeval.constant
                var leval = 0
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.conHeightWaterLeval.constant = 0
                    
                    leval = self.WATERQTYPERATTEMPT - Int(self.lblWaterLavel.text!)!
                    self.lblWaterLavel.text = "0"
                    self.view.layoutIfNeeded()
                    self.view.layer.removeAllAnimations()
                }, completion: { (true) in
                    self.view.layer.removeAllAnimations()
                    if lastBottle == self.bottleCount + 1 {
                        
                        self.conHeightWaterLeval.constant = lastBottleWater
                        self.lblWaterLavel.text = "\(Int(leval1) - leval)"
                    }else{
                    self.lblWaterLavel.text = "1000"
                    self.conHeightWaterLeval.constant = self.viewOuter.frame.size.height
                    }
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    UIView.animate(withDuration: 1.0) {
                        if lastBottle == self.bottleCount + 1 {
                        self.conHeightWaterLeval.constant = CGFloat(Double(lastBottleWater - (CGFloat(decreasingHeightPerAttempt) - heightConstant)).rounded(toPlaces: 6)) - CGFloat(self.differenceWater)
                            let leval1 = Double(self.WATERQTY).truncatingRemainder(dividingBy: 1000.0)
                            print(leval1)
                            let valuelevel = "\((1000 - Int(leval1)) - leval)"
                            self.lblWaterLavel.text = valuelevel
                            if self.counter == 10 {
                                self.conHeightWaterLeval.constant = 0
                                self.lblWaterLavel.text = "0"
                            }
                            
                        }else{
                            self.conHeightWaterLeval.constant = CGFloat(Double(CGFloat(outerViewHeight) - (CGFloat(decreasingHeightPerAttempt) - heightConstant)).rounded(toPlaces: 6)) - CGFloat(self.differenceWater)
                            self.lblWaterLavel.text = "\(1000 - leval)"
                        }
                        self.view.layoutIfNeeded()
                        self.view.layer.removeAllAnimations()
                        UserDefaults.standard.set(self.conHeightWaterLeval.constant, forKey: mykeys.KPREVWATERLEVAL)
                        
                        self.bottleCount += 1
                        
                        if self.bottleCount == self.bottleNumberAsNotif {
                            self.notifMarkerView.isHidden = false
                        }else{
                            self.notifMarkerView.isHidden = true
                        }
                        
                        
                        self.lblBottleCount.text = "Bottle \(self.bottleCount) of \(self.tottleBottle)"
                        UserDefaults.standard.set(self.bottleCount, forKey: mykeys.KBOTTLECOUNT)
                    }
                }
            }else{
                
                UIView.animate(withDuration: 1.0) {

                        self.conHeightWaterLeval.constant = CGFloat(Double(self.conHeightWaterLeval.constant - CGFloat(decreasingHeightPerAttempt)).rounded(toPlaces: 6)) - CGFloat(self.differenceWater)
                    let valuelevel = "\(Int(self.lblWaterLavel.text!)! - self.WATERQTYPERATTEMPT)"
                    self.lblWaterLavel.text = valuelevel
                    if self.counter == 10 {
                        self.conHeightWaterLeval.constant = 0
                        self.lblWaterLavel.text = "0"
                    }
                        self.view.layoutIfNeeded()
                        self.view.layer.removeAllAnimations()
                    
                        UserDefaults.standard.set(self.conHeightWaterLeval.constant, forKey: mykeys.KPREVWATERLEVAL)
                }
            }
            
        }else{
            
            timer.invalidate()
            UserDefaults.standard.set(lblWaterLavel.text, forKey: "waterlevel")
            notifMarkerView.isHidden = true
            let remainingWaterQty = self.REMAININGWATERQTY - (totalDrink*WATERQTYPERATTEMPT)
            updateData(REMAININGWATERQTY: remainingWaterQty, TOTALATTEMPT: appDelegate.badgeCount)
            lastCountOfAttempt = appDelegate.badgeCount
            UserDefaults.standard.set(conHeightWaterLeval.constant, forKey: mykeys.KLASTWATERCONSTRAINT)
            UserDefaults.standard.set(lastCountOfAttempt, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set(self.lblWaterLavel.text!, forKey: mykeys.KLASTLBLWATERLEVAL)
            print("lastCountOfAttempt--",lastCountOfAttempt)
            appDelegate.badgeCount = 0
            UIApplication.shared.applicationIconBadgeNumber = 0
            counter = 0
            timer.invalidate()
            btnHydrate.isUserInteractionEnabled = true
            UIApplication.shared.endIgnoringInteractionEvents()
             btnHydrate.backgroundColor =  disableColour
        }
    }
    
    
    func searchDataForUpdate() {
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        let strURL = "SELECT * FROM HYDROFUELPERSINFO where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.selectIdDataTable(strURL)
        print(data)
        if data.Status == 1 {
            
            print(data.Success)
            let arrLocalData = data.arrData
            dictPrevious = (arrLocalData[0] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            self.DATE = dictPrevious.value(forKey: "DATE") as! String
            self.WEIGHT = dictPrevious.value(forKey: "WEIGHT") as! Int
            self.GENDER = dictPrevious.value(forKey: "GENDER") as! String
            self.ACTIVITYLAVEL = dictPrevious.value(forKey: "ACTIVITYLAVEL") as! String
            self.WATERQTY = dictPrevious.value(forKey: "WATERQTY") as! Int
           
            let floatData = Double(self.WATERQTY)/1000.0
            let intData = Double(self.WATERQTY/1000)
            if intData < floatData {
                self.tottleBottle = (self.WATERQTY/1000) + 1
            }else{
                self.tottleBottle = (self.WATERQTY/1000)
            }
            self.REMAININGWATERQTY = dictPrevious.value(forKey: "REMAININGWATERQTY") as! Int
            self.TOTALDRINK = dictPrevious.value(forKey: "TOTALDRINK") as! Int
            self.TOTALATTEMPT = dictPrevious.value(forKey: "TOTALATTEMPT") as! Int
            self.WATERQTYPERATTEMPT = dictPrevious.value(forKey: "WATERQTYPERATTEMPT") as! Int
            let remainingWaterQty = self.REMAININGWATERQTY - (TOTALDRINK*WATERQTYPERATTEMPT)
            self.lblWaterToDrink.text = "\(remainingWaterQty)ml"
            
            
            
        }else{
            print(data.Failure)
        }
        
    }
    
    func updateData(REMAININGWATERQTY: Int, TOTALATTEMPT: Int){
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        let strURL = "update HYDROFUELPERSINFO set REMAININGWATERQTY='\(REMAININGWATERQTY)', TOTALATTEMPT='\(TOTALATTEMPT)' where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.updateTable(strURL)
        print(data)
        if data.Status == 1 {
            searchDataForUpdate()
        }
    }
    
    
    func createDB() -> Void {
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        
        let strURL = "CREATE TABLE IF NOT EXISTS HYDROFUELPERSINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, WEIGHT INTEGER, GENDER TEXT, ACTIVITYLAVEL TEXT, WATERQTY INTEGER, REMAININGWATERQTY INTEGER, TOTALDRINK INTEGER, TOTALATTEMPT INTEGER, WATERQTYPERATTEMPT INTEGER)"
        print(strURL)
        
        let data = AFSQLWrapper.createTable(strURL)
        print(data)
        
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) != nil{
            let previousDate = UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) as? String
            if previousDate == strDate {
                searchDataForUpdate()
            }else{
                showData()
            }
        }else{
            searchDataForUpdate()
        }
    }
    
    func insertData(DATE: String, WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, TOTALATTEMPT: Int, WATERQTYPERATTEMPT: Int) -> Void {
        
        let strURL = "INSERT INTO HYDROFUELPERSINFO (DATE, WEIGHT, GENDER, ACTIVITYLAVEL, WATERQTY, REMAININGWATERQTY, TOTALDRINK, TOTALATTEMPT, WATERQTYPERATTEMPT) VALUES ('\(DATE)', '\(WEIGHT)', '\(GENDER)', '\(ACTIVITYLAVEL)', '\(WATERQTY)', '\(REMAININGWATERQTY)', '\(TOTALDRINK)', '\(TOTALATTEMPT)', '\(WATERQTYPERATTEMPT)')"
        
        print(strURL)
        
        let data = AFSQLWrapper.insertTable(strURL)
        print(data)
        if data.Status == 1{
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            lastCountOfAttempt = 0
            bottleCount = 1
            prevWaterLeval = viewOuter.frame.size.height
            conHeightWaterLeval.constant = viewOuter.frame.size.height
            UserDefaults.standard.set(DATE, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(conHeightWaterLeval.constant, forKey: mykeys.KLASTWATERCONSTRAINT)
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set(Double(viewOuter.frame.size.height).rounded(toPlaces: 6), forKey: mykeys.KPREVWATERLEVAL)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
            lblBottleCount.text = "Bottle \(bottleCount) of \(tottleBottle)"
            notifMarkerView.isHidden = true
            lblWaterLavel.text = "\(1000)"
            
            lblNotifWaterLavel.text = ""
            conTopNotifMarker.constant = -15
            appDelegate.resettime = "reset"
            UserDefaults.standard.set(lblWaterLavel.text, forKey: "waterlevel")
            searchDataForUpdate()
            
        }
    }
    
    func showData() {
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        
        let strURL = "SELECT * FROM HYDROFUELPERSINFO"
        print(strURL)
        let data = AFSQLWrapper.selectTable(strURL)
        print(data)
        if data.Status == 1 {
            let arrLocalData = data.arrData
            dictPrevious = (arrLocalData[arrLocalData.count-1] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            
            let WEIGHT1 = dictPrevious.value(forKey: "WEIGHT") as! Int
            let GENDER1 = dictPrevious.value(forKey: "GENDER") as! String
            let ACTIVITYLAVEL1 = dictPrevious.value(forKey: "ACTIVITYLAVEL") as! String
            let WATERQTY1 = dictPrevious.value(forKey: "WATERQTY") as! Int
            
            let floatData = Double(WATERQTY1)/1000.0
            let intData = Double(WATERQTY1/1000)
            if intData < floatData {
                self.tottleBottle = (WATERQTY1/1000) + 1
            }else{
                self.tottleBottle = (WATERQTY1/1000)
            }
            let WATERQTYPERATTEMPT1 = dictPrevious.value(forKey: "WATERQTYPERATTEMPT") as! Int
            
            
            self.insertData(DATE: strDate, WEIGHT: WEIGHT1, GENDER: GENDER1, ACTIVITYLAVEL: ACTIVITYLAVEL1, WATERQTY: WATERQTY1, REMAININGWATERQTY: WATERQTY1, TOTALDRINK: 0, TOTALATTEMPT: 0, WATERQTYPERATTEMPT: WATERQTYPERATTEMPT1)
            
        }
        
    }
    
    func resetData(){
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        let strURL = "update HYDROFUELPERSINFO set REMAININGWATERQTY='\(self.WATERQTY)', TOTALDRINK='\(0)',TOTALATTEMPT='\(0)' where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.updateTable(strURL)
        print(data)
         btnHydrate.backgroundColor =  disableColour
        if data.Status == 1 {
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            lastCountOfAttempt = 0
            bottleCount = 1
            prevWaterLeval = viewOuter.frame.size.height
            conHeightWaterLeval.constant = viewOuter.frame.size.height
            
            UserDefaults.standard.set(conHeightWaterLeval.constant, forKey: mykeys.KLASTWATERCONSTRAINT)
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set(Double(viewOuter.frame.size.height).rounded(toPlaces: 6), forKey: mykeys.KPREVWATERLEVAL)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
            lblBottleCount.text = "Bottle \(bottleCount) of \(tottleBottle)"
            notifMarkerView.isHidden = true
            lblWaterLavel.text = "\(1000)"
            
            lblNotifWaterLavel.text = ""
            conTopNotifMarker.constant = -15
            appDelegate.resettime = "reset"
            UserDefaults.standard.set(lblWaterLavel.text, forKey: "waterlevel")
            searchDataForUpdate()
            
        }
    }
    
    
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
