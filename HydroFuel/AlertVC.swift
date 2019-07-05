//
//  AlertVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import UserNotifications
import UserNotificationsUI
import IQKeyboardManagerSwift

class AlertVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet var lbltimetwo: UILabel!
    @IBOutlet var txtten: UITextField!
    @IBOutlet var lbldesten: UILabel!
    @IBOutlet var lbltimeten: UILabel!
    @IBOutlet var txtnine: UITextField!
    @IBOutlet var lbldesnine: UILabel!
    @IBOutlet var lbltimenine: UILabel!
    @IBOutlet var txteight: UITextField!
    @IBOutlet var lbldeseight: UILabel!
    @IBOutlet var lbltimeeight: UILabel!
    @IBOutlet var txtseven: UITextField!
    @IBOutlet var lbldesseven: UILabel!
    @IBOutlet var lbltimeseven: UILabel!
    @IBOutlet var txtsix: UITextField!
    @IBOutlet var lbldessix: UILabel!
    @IBOutlet var lbltimesix: UILabel!
    @IBOutlet var txtfive: UITextField!
    @IBOutlet var lbldesfive: UILabel!
    @IBOutlet var lbltimefive: UILabel!
    @IBOutlet var txtfour: UITextField!
    @IBOutlet var lbldesfour: UILabel!
    @IBOutlet var lbltimefour: UILabel!
    @IBOutlet var txtthree: UITextField!
    @IBOutlet var lbldesthree: UILabel!
    @IBOutlet var lbltimethree: UILabel!
    @IBOutlet var txttwo: UITextField!
    @IBOutlet var lbldestwo: UILabel!
    @IBOutlet var imgback: UIImageView!
    
    @IBOutlet var txttimer: UITextField!
    @IBOutlet var editone: UILabel!
    @IBOutlet var edittwo: UILabel!
    @IBOutlet var editthree: UILabel!
    @IBOutlet var editfour: UILabel!
    @IBOutlet var editfive: UILabel!
    @IBOutlet var editsix: UILabel!
    @IBOutlet var editseven: UILabel!
    @IBOutlet var editeight: UILabel!
    @IBOutlet var editnine: UILabel!
    @IBOutlet var editten: UILabel!
    
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet var lbldescription: UILabel!
    @IBOutlet var lbltime: UILabel!
    let dateFormatter = DateFormatter()
    let datePickerView = UIDatePicker()
    let datetime = Date()
    //var setDate = Date()
    //let center = UNUserNotificationCenter.current()
    var min = Date()
    var changevalue = ""
    var str = 0
    var timeTag = -1
    
    var arraydate = NSMutableArray()
    var arrSetFixAlarmTime = NSMutableArray()
    var value1 = Int()
    var value2 = Int()
    var value3 = Int()
    var value4 = Int()
    var value5 = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) == nil {
            imgback.isHidden = true
            btnMenu.isHidden = true
        }else{
            imgback.isHidden = false
            btnMenu.isHidden = false
        }
        if UserDefaults.standard.value(forKey: mykeys.KARRALARMDATETIME) != nil {
            
            let arrTime = UserDefaults.standard.value(forKey: mykeys.KARRALARMDATETIME) as! NSArray
            arrSetFixAlarmTime = arrTime.mutableCopy() as! NSMutableArray
        }else{
            
            arrSetFixAlarmTime = ["2018-09-13 03:00:00 +0000","2018-09-13 04:00:00 +0000","2018-09-13 06:00:00 +0000","2018-09-13 07:30:00 +0000","2018-09-13 10:00:00 +0000","2018-09-13 12:00:00 +0000","2018-09-13 14:00:00 +0000","2018-09-13 15:00:00 +0000","2018-09-13 16:00:00 +0000","2018-09-13 17:30:00 +0000"]
            UserDefaults.standard.set(arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
            
        }
        
        if UserDefaults.standard.value(forKey: mykeys.KARRALARMTIME) != nil {
            let arrTime = UserDefaults.standard.value(forKey: mykeys.KARRALARMTIME) as! NSArray
            arraydate = arrTime.mutableCopy() as! NSMutableArray
        }else{
            arraydate = ["08:30 AM","09:30 AM","11:30 AM","01:00 PM","03:30 PM","05:30 PM","07:30 PM","08:30 PM","09:30 PM","11:00 PM"]
            UserDefaults.standard.set(arraydate, forKey: mykeys.KARRALARMTIME)
        }
        
        // permissionForAlert()
        
        if UserDefaults.standard.value(forKey: "lblml") != nil
        {
            str = Int(truncating: UserDefaults.standard.value(forKey: "lblml") as! NSNumber)
            print(str)
        }
        txttimer.delegate = self
        for i in 1...10 {
            calculateWaterPerAlert(alertNumber: i)
        }
        
        
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        lbltime.text = arraydate[0] as? String//"08:30 am"
        lbltimetwo.text = arraydate[1] as? String//"09:30 am"
        lbltimethree.text = arraydate[2] as? String//"10:30 am"
        lbltimefour.text = arraydate[3] as? String//"11:30 am"
        lbltimefive.text = arraydate[4] as? String//"12:30 pm"
        lbltimesix.text = arraydate[5] as? String//"1:30 pm"
        lbltimeseven.text = arraydate[6] as? String//"2:30 pm"
        lbltimeeight.text = arraydate[7] as? String//"3:30 pm"
        lbltimenine.text = arraydate[8] as? String//"4:30 pm"
        lbltimeten.text = arraydate[9] as? String//"5:30 pm"
        //let ans = (1 * 350)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func calculateWaterPerAlert(alertNumber: Int){
        print(alertNumber)
        var lbl = ""
        if str * alertNumber < 1000{
            let text = "Its time to drink to " + "\(1000 - (str * alertNumber))" + " ml Water"
            print(text)
            lbl = text
        }else {
            let data = (str * alertNumber) % 1000
            print(data)
            
            if 1000 - data > str && (1000 - data) + str > 1000{
                let text = "Drink " + "\((str - data))" + " ml Refill the bottle and drink to " + "\(1000 - data)" + " ml"
                print(text)
                lbl = text
            }else{
                let text = "Its time to drink to " + "\(1000 - data)" + " ml Water"
                print(text)
                lbl = text
            }
            
            
        }
        
        switch alertNumber {
        case 1:
            lbldescription.text = lbl//calculateWaterPerAlert(alertNumber: 1)
            break
        case 2:
            lbldestwo.text = lbl
            break
        case 3:
            lbldesthree.text = lbl
            break
        case 4:
            lbldesfour.text = lbl
            break
        case 5:
            lbldesfive.text = lbl
            break
        case 6:
            lbldessix.text = lbl
            break
        case 7:
            lbldesseven.text = lbl
            break
        case 8:
            lbldeseight.text = lbl
            break
        case 9:
            lbldesnine.text = lbl
            break
        case 10:
            lbldesten.text = lbl
            break
        default:
            print("Default")
            break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.value(forKey: "lblml") != nil
        {
            str = Int(UserDefaults.standard.value(forKey: "lblml") as! NSNumber)
            print(str)
        }
        //setdata()
        if  appDelegate.resettime == "reset"
        {
            txttimer.isEnabled = true
            txttwo.isEnabled = true
            txtthree.isEnabled = true
            txtfour.isEnabled = true
            txtfive.isEnabled = true
            txtsix.isEnabled = true
            txtseven.isEnabled = true
            txteight.isEnabled = true
            txtnine.isEnabled = true
            txtten.isEnabled = true
            editone.isEnabled = true
            edittwo.isEnabled = true
            editthree.isEnabled = true
            editfour.isEnabled = true
            editfive.isEnabled = true
            editsix.isEnabled = true
            editseven.isEnabled = true
            editeight.isEnabled = true
            editnine.isEnabled = true
            editten.isEnabled = true
            
        }else{
            appDelegate.resettime = "change"
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormatter.string(from: Date())
            if   (dateFormatter.date(from: lbltime.text!))! < (dateFormatter.date(from: strDate))!
            {
                txttimer.isEnabled = false
                editone.isEnabled = false
                
            }
            if   (dateFormatter.date(from: lbltimetwo.text!))! < (dateFormatter.date(from: strDate))!
            {
                txttwo.isEnabled = false
                edittwo.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimethree.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtthree.isEnabled = false
                editthree.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimefour.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtfour.isEnabled = false
                editfour.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimefive.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtfive.isEnabled = false
                editfive.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimesix.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtsix.isEnabled = false
                editsix.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimeseven.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtseven.isEnabled = false
                editseven.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimeeight.text!))! < (dateFormatter.date(from: strDate))!
            {
                txteight.isEnabled = false
                editeight.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimenine.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtnine.isEnabled = false
                editnine.isEnabled = false
            }
            if   (dateFormatter.date(from: lbltimeten.text!))! < (dateFormatter.date(from: strDate))!
            {
                txtten.isEnabled = false
                editten.isEnabled = false
            }
            
        }
        
    }
    //    func setdata()
    //    {
    //        if appDelegate.resettime == "change"
    //        {
    //            //resettime = "change"
    //            dateFormatter.dateFormat = "hh:mm a"
    //            let strDate = dateFormatter.string(from: Date())
    //            for i in 0..<arraydate.count
    //            {
    //                if (dateFormatter.date(from: arraydate[i] as! String))! < (dateFormatter.date(from: strDate))!
    //                {
    //                    count += 1
    //                    badgeCount = count
    //                    UIApplication.shared.applicationIconBadgeNumber = badgeCount
    //                }
    //                print(count)
    //            }
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func permissionForAlert() {
        let options: UNAuthorizationOptions = [.badge, .alert, .sound];
        appDelegate.center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
            else{
                print("Premission Granted.!")
                self.setDefaultAlarm()
            }
        }
        appDelegate.center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
    }
    
    func setDefaultAlarm() {
        if UserDefaults.standard.value(forKey: mykeys.KISDEFAULTALARMSET) == nil{
            for i in 0..<arrSetFixAlarmTime.count {
                let formattor = DateFormatter()
                formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                formattor.timeZone = TimeZone(identifier: "UTC")
                let fixDate = formattor.date(from: arrSetFixAlarmTime[i] as! String)
                print(fixDate!)
                timeTag = i
                setAlarm(fixDate!)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //datePickerView.minimumDate = Date()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        timeTag = textField.tag
        datePickerView.datePickerMode = .time
        
        switch textField.tag {
        case 0:
            //txttimer.inputView = datePickerView
            // let mini = datePickerView.minimumDate as! String
            
            print(datePickerView.date)
            setAlarm(datePickerView.date)
            lbltime.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltime.text!)
            appDelegate.resettime = "change"
            //datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 1:
            //txttwo.inputView = datePickerView
            
            
            lbltimetwo.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimetwo.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            
            //datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 2:
            //txtthree.inputView = datePickerView
            lbltimethree.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimethree.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            //datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 3:
            // txtfour.inputView = datePickerView
            lbltimefour.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimefour.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            // datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 4:
            //txtfive.inputView = datePickerView
            lbltimefive.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimefive.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            //datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 5:
            //txtsix.inputView = datePickerView
            lbltimesix.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimesix.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            //datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 6:
            // txtseven.inputView = datePickerView
            lbltimeseven.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimeseven.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            //datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 7:
            // txteight.inputView = datePickerView
            lbltimeeight.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimeeight.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            // datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 8:
            // txtnine.inputView = datePickerView
            
            lbltimenine.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimenine.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            // datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 9:
            // txtten.inputView = datePickerView
            lbltimeten.text = dateFormatter.string(from: datePickerView.date)
            arraydate.replaceObject(at: textField.tag, with: lbltimeten.text!)
            setAlarm(datePickerView.date)
            appDelegate.resettime = "change"
            // datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        default:
            print("")
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //datePickerView.minimumDate = Date()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        timeTag = textField.tag
        datePickerView.datePickerMode = .time
        
        switch textField.tag {
        case 0:
            
            
            txttimer.inputView = datePickerView
            //print(datePickerView.date)
            //setAlarm(datePickerView.date)
            //lbltime.text = dateFormatter.string(from: datePickerView.date)
            //arraydate.replaceObject(at: textField.tag, with: lbltime.text!)
            // appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 1:
            txttwo.inputView = datePickerView
            //            lbltimetwo.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimetwo.text!)
            //            setAlarm(datePickerView.date)
            // appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 2:
            txtthree.inputView = datePickerView
            //            lbltimethree.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimethree.text!)
            //            setAlarm(datePickerView.date)
            //appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 3:
            txtfour.inputView = datePickerView
            //            lbltimefour.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimefour.text!)
            //            setAlarm(datePickerView.date)
            //appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 4:
            txtfive.inputView = datePickerView
            //            lbltimefive.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimefive.text!)
            //            setAlarm(datePickerView.date)
            //appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 5:
            txtsix.inputView = datePickerView
            //            lbltimesix.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimesix.text!)
            //            setAlarm(datePickerView.date)
            // appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 6:
            txtseven.inputView = datePickerView
            //appDelegate.resettime = "change"
            //            lbltimeseven.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimeseven.text!)
            //            setAlarm(datePickerView.date)
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 7:
            txteight.inputView = datePickerView
            //            lbltimeeight.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimeeight.text!)
            //            setAlarm(datePickerView.date)
            //appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 8:
            txtnine.inputView = datePickerView
            //            lbltimenine.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: lbltimenine.text!)
            //            setAlarm(datePickerView.date)
            // appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        case 9:
            txtten.inputView = datePickerView
            //            lbltimeten.text = dateFormatter.string(from: datePickerView.date)
            //            arraydate.replaceObject(at: textField.tag, with: txtten.text!)
            //            setAlarm(datePickerView.date)
            //appDelegate.resettime = "change"
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break
        default:
            print("")
            break
        }
    }
    
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateString4 = dateFormatter.string(from: datePickerView.date)
        arraydate.replaceObject(at: timeTag, with: dateString4)
        print(datePickerView.date)
        if timeTag != 0{
            let formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            datePickerView.minimumDate = formattor.date(from: arrSetFixAlarmTime[timeTag-1] as! String)
        }else{
            datePickerView.minimumDate = Date()
        }
        switch timeTag {
        case 0:
            
            lbltime.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 1:
            lbltimetwo.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 2:
            lbltimethree.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 3:
            lbltimefour.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 4:
            lbltimefive.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 5:
            lbltimesix.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 6:
            lbltimeseven.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 7:
            lbltimeeight.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 8:
            lbltimenine.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        case 9:
            lbltimeten.text = dateString4
            setAlarm(datePickerView.date)
            break
            
        default:
            print("")
            break
            
        }
        
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) == nil {
            let today = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormattor.string(from: today)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
        }
        
        
        
        UserDefaults.standard.set(arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
        UserDefaults.standard.set(arraydate, forKey: mykeys.KARRALARMTIME)
        if appDelegate.backvar == "static"
        {
            self.toggleLeft()
            appDelegate.resettime = "change"
            //setdata()
        }
        else
        {
            imgback.image = UIImage(named: "back2")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnHomeclick(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) == nil {
            let today = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormattor.string(from: today)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        appDelegate.resettime = "change"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setAlarm(_ setDate: Date) {
        arrSetFixAlarmTime.replaceObject(at: timeTag, with: "\(setDate)")
        
        let content = UNMutableNotificationContent()
        content.title = "Hydrofuel Reminder"
        content.body = "Its time to drink water"
        content.sound = UNNotificationSound.default()
        content.badge = (timeTag + 1) as NSNumber
        content.userInfo = ["Name":"Parth","Badge":(timeTag + 1) as NSNumber]
        let date = setDate
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "UYLLocalNotification\(timeTag)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
        
        UserDefaults.standard.set(arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
        UserDefaults.standard.set(arraydate, forKey: mykeys.KARRALARMTIME)
        print("Alarm set...!")
    }
}
