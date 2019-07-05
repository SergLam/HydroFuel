//
//  AlertVCNew.swift
//  HydroFuel
//
//  Created by Stegowl on 9/26/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import UserNotifications
import UserNotificationsUI
import IQKeyboardManagerSwift
import iShowcase
import CTShowcase

class AlertVCNew: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, iShowcaseDelegate {
    
    
    @IBOutlet weak var highlightview: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tblAlert: UITableView!
    @IBOutlet var imgback: UIImageView!
    //let dateFormatter = DateFormatter()
    let datePickerView = UIDatePicker()
    let datetime = Date()
    var timeTag = -1
    var arraydate = NSMutableArray()
    var arrSetFixAlarmTime = NSMutableArray()
    var arrFixDates: [Date] = []
    var str = 0
    var isTimeEdited = false
    var showcase = iShowcase()
    var strTimes = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // "a" prints "pm" or "am"
        strTimes = dateFormatter.string(from: Date()) // "12 AM"
        print(strTimes)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        showcase.delegate = self
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) == nil {
            if  appDelegate.isAfterReset == true{
                
                imgback.isHidden = false
                btnMenu.isHidden = false
            }else{
                imgback.isHidden = true
                btnMenu.isHidden = true
            }
        }else{
            imgback.isHidden = false
            btnMenu.isHidden = false
        }
        if UserDefaults.standard.value(forKey: mykeys.KARRALARMTIME) != nil {
            let arrTime = UserDefaults.standard.value(forKey: mykeys.KARRALARMTIME) as! NSArray
            arraydate = arrTime.mutableCopy() as! NSMutableArray
        }else{
            arraydate = ["08:30 AM","09:30 AM","11:30 AM","01:00 PM","03:30 PM","05:30 PM","07:30 PM","08:30 PM","09:30 PM","11:00 PM"]
            UserDefaults.standard.set(arraydate, forKey: mykeys.KARRALARMTIME)
        }
        if UserDefaults.standard.value(forKey: mykeys.KARRALARMDATETIME) != nil {
            let arrTime = UserDefaults.standard.value(forKey: mykeys.KARRALARMDATETIME) as! NSArray
            arrSetFixAlarmTime = arrTime.mutableCopy() as! NSMutableArray
        }else{
            arrSetFixAlarmTime = ["2018-09-13 08:30:00 +0000","2018-09-13 09:30:00 +0000","2018-09-13 10:30:00 +0000","2018-09-13 11:30:00 +0000","2018-09-13 12:30:00 +0000","2018-09-13 13:30:00 +0000","2018-09-13 14:30:00 +0000","2018-09-13 15:30:00 +0000","2018-09-13 16:30:00 +0000","2018-09-13 17:30:00 +0000"]
            UserDefaults.standard.set(arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
            
        }
        
        if UserDefaults.standard.value(forKey: "lblml") != nil
        {
            str = Int(truncating: UserDefaults.standard.value(forKey: "lblml") as! NSNumber)
            print(str)
        }
        
        for i in 0..<arrSetFixAlarmTime.count {
            let formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            formattor.timeZone = TimeZone(identifier: "UTC")
            let fixDate = formattor.date(from: arrSetFixAlarmTime[i] as! String)
            print(fixDate!)
            arrFixDates.append(fixDate!)
        }
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if appDelegate.isToolTipShown == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showcase.setupShowcaseForTableView(self.tblAlert, withIndexPath: [0,0])
                self.showcase.titleLabel.text = "Notifications tell you exactly how much to drink so pay attention! You can edit the notification times here."
                self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
                self.showcase.detailsLabel.text = "\n\n      "
                self.showcase.show()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFixDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! alertCell
        
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        format.timeZone = TimeZone(identifier: "UTC")
        let strDate = format.string(from: arrFixDates[indexPath.row])
        cell.lbltimeshow.text = strDate//arraydate[indexPath.row] as? String
        cell.lblwaterdescripation.text = calculateWaterPerAlert(alertNumber: indexPath.row + 1)
        cell.txttimer.tag = indexPath.row
        cell.txttimer.delegate = self
        if  appDelegate.resettime == "reset"
        {
            cell.txttimer.isEnabled = true
            cell.btnEdit.isEnabled = true
            cell.imgEdit.image = #imageLiteral(resourceName: "edit")
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
//            let strDate1 = dateFormatter.string(from: Date())
//            print(strDate1)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm" // "a" prints "pm" or "am"
            formatter.timeZone = TimeZone(identifier: "UTC")
            let strDate1 = formatter.string(from: Date()) // "12 AM"
            print(strDate1)
            
            
            let format1 = DateFormatter()
            format1.dateFormat = "HH:mm"
            format1.timeZone = TimeZone(identifier: "UTC")
            let strDate2 = format1.string(from: arrFixDates[indexPath.row])
            print(strDate2)
//            if   (dateFormatter.date(from: strDate2))! <= (dateFormatter.date(from: strTimes))!
//            {
//                cell.txttimer.isEnabled = false
//                cell.btnEdit.isEnabled = false
//                cell.imgEdit.image = #imageLiteral(resourceName: "editdisable")
//            }else{
//                cell.txttimer.isEnabled = true
//                cell.btnEdit.isEnabled = true
//                cell.imgEdit.image = #imageLiteral(resourceName: "edit")
//            }
            cell.txttimer.isEnabled = true
            cell.btnEdit.isEnabled = true
            cell.imgEdit.image = #imageLiteral(resourceName: "edit")
        }
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        datePickerView.datePickerMode = .time
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        timeTag = textField.tag
        
        
        print(datePickerView.date.localiz)
        //let text = dateFormatter.string(from: datePickerView.date)
        arrSetFixAlarmTime.replaceObject(at: timeTag, with: "\(datePickerView.date.localiz)")
        //appDelegate.resettime = "change"
        isTimeEdited = true
        arrFixDates.removeAll()
        for i in 0..<arrSetFixAlarmTime.count {
            let formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            //formattor.timeZone = TimeZone(identifier: "UTC")
            let fixDate = formattor.date(from: arrSetFixAlarmTime[i] as! String)
            print(fixDate!)
            arrFixDates.append(fixDate!)
        }
        tblAlert.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePickerView.datePickerMode = .time
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        timeTag = textField.tag
        datePickerView.datePickerMode = .time
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        datePickerView.datePickerMode = .time
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        //dateFormatter.dateFormat = "hh:mm a"
        //let dateString4 = dateFormatter.string(from: datePickerView.date)
        //arraydate.replaceObject(at: timeTag, with: dateString4)
        
        print(sender.date.localiz)
        if timeTag != 0{
            print(arrSetFixAlarmTime[timeTag-1] as! String)
            
            let formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            formattor.timeZone = TimeZone(identifier: "UTC")
            if  appDelegate.resettime != "reset" {
                print(formattor.date(from: arrSetFixAlarmTime[timeTag-1] as! String))
               // datePickerView.minimumDate = (formattor.date(from: arrSetFixAlarmTime[timeTag-1] as! String))?.toGlobalTime()
                 //datePickerView.minimumDate = Date()
            }
        }else{
            if  appDelegate.resettime != "reset" {
                //datePickerView.minimumDate = Date()
            }
        }
        
        //arrSetFixAlarmTime.replaceObject(at: timeTag, with: "\(datePickerView.date)")
        
        
        //appDelegate.resettime = "change"
        //self.tblAlert.reloadData()
    }
    func calculateWaterPerAlert(alertNumber: Int) -> String{
        if str * alertNumber < 1000{
            if appDelegate.isFirstNotif == true {
                let text = "Drink down to the " + "\(1000 - (str * alertNumber))" + "ml mark, Open the App and Tap “Hydrate”"
                return text
            }else{
                if alertNumber == 10
                {
                    let text = "Finish the bottle. Congratulations you’re done for the day!"
                    return text
                    
                }else{
                    let data = (str * alertNumber) % 1000
                    let totalWater = str * 10
                    if (str * alertNumber) > totalWater - ((totalWater % 1000)){
                        let bottleToRefil = ((10 - alertNumber) * str) + data
                        let text = "Drink down to the " + "\(bottleToRefil - data)" + "ml mark right now!"
                        return text
                    }else{
                    let text = "Drink down to the " + "\(1000 - (str * alertNumber))" + "ml mark right now!"
                    return text
                    }
                }
                
            }
        }else {
            let data = (str * alertNumber) % 1000
            if 1000 - data > str && (1000 - data) + str > 1000{
                //let text = "Drink " + "\((str - data))" + " ml Refill the bottle and drink to " + "\(1000 - data)" + " ml"
               if alertNumber == 10
               {
                let text = "Finish the bottle. Congratulations you’re done for the day!"
                return text
                
               }else{
                let totalWater = str * 10
                if (str * alertNumber) > totalWater - ((totalWater % 1000)){
                    let bottleToRefil = ((10 - alertNumber) * str) + data
                    let text = "Finish the bottle, refill to the " + "\(bottleToRefil) ml mark! " + "and drink to the " + "\(bottleToRefil - data)" + "ml mark!"
                    return text
                }
                    let text = "Finish the bottle, refill and drink to the " + "\(1000 - data)" + "ml mark!"
                    return text
                }
                
            }
    
            else{
                if alertNumber == 10
                {
                    let text = "Finish the bottle. Congratulations you’re done for the day!"
                    return text
                    
                }else{
                    let data = (str * alertNumber) % 1000
                    let totalWater = str * 10
                    if (str * alertNumber) > totalWater - ((totalWater % 1000)){
                        let bottleToRefil = ((10 - alertNumber) * str) + data
                        let text = "Drink down to the " + "\(bottleToRefil - data)" + "ml mark right now!"
                        return text
                    }else{
                    let text = "Drink down to the " + "\(1000 - data)" + "ml mark right now!"
                    return text
                    }
                }
                
            }
        }
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        appDelegate.isAfterReset = false
        let formattor = DateFormatter()
        formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        formattor.timeZone = TimeZone(identifier: "UTC")
        var arrForSort:[Date] = []
        for j in 0..<arrFixDates.count {
            let format1 = DateFormatter()
            format1.dateFormat = "HH:mm"
            format1.timeZone = TimeZone(identifier: "UTC")
            let strDate2 = format1.string(from: arrFixDates[j])
            arrForSort.append(format1.date(from: strDate2)!)
        }
        
        
        let arrSortedDates = arrForSort.sorted(by: { $0.compare($1) == .orderedAscending })
        arrFixDates = ((arrSortedDates as NSArray).mutableCopy() as! NSMutableArray) as! [Date]
        
        for i in 0..<arrFixDates.count {
            let fixDate = arrFixDates[i]
            print(fixDate)
            timeTag = i
            setAlarm(fixDate, tag: i)
            let dt = formattor.string(from: fixDate)
            arrSetFixAlarmTime.replaceObject(at: i, with: dt)
        }
        
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) == nil {
            let today = Date().toLocalTime()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            dateFormattor.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormattor.string(from: today)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
        }
        UserDefaults.standard.set(arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
        //UserDefaults.standard.set(arraydate, forKey: mykeys.KARRALARMTIME)
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
        self.appDelegate.resettime = "change"
    }
    
    @IBAction func btnHomeclick(_ sender: UIButton) {
        UserDefaults.standard.set(2, forKey: "fill")
        appDelegate.isAfterReset = false
        if UserDefaults.standard.value(forKey: mykeys.KPREVIOUSDATE) == nil {
            let today = Date().toLocalTime()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            dateFormattor.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormattor.string(from: today)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
        }
        let formattor = DateFormatter()
        formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        formattor.timeZone = TimeZone(identifier: "UTC")
        var arrForSort:[Date] = []
        for j in 0..<arrFixDates.count {
            let format1 = DateFormatter()
            format1.dateFormat = "HH:mm"
            format1.timeZone = TimeZone(identifier: "UTC")
            let strDate2 = format1.string(from: arrFixDates[j])
            arrForSort.append(format1.date(from: strDate2)!)
        }
        
        
        let arrSortedDates = arrForSort.sorted(by: { $0.compare($1) == .orderedAscending })
        arrFixDates = ((arrSortedDates as NSArray).mutableCopy() as! NSMutableArray) as! [Date]
        
        for i in 0..<arrFixDates.count {
            let fixDate = arrFixDates[i]
            print(fixDate)
            timeTag = i
            setAlarm(fixDate, tag: i)
            let dt = formattor.string(from: fixDate)
            arrSetFixAlarmTime.replaceObject(at: i, with: dt)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UserDefaults.standard.set(self.arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.appDelegate.resettime = "change"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setAlarm(_ setDate: Date, tag: Int) {
        //arrSetFixAlarmTime.replaceObject(at: timeTag, with: "\(setDate)")
        print(tag+1)
        let content = UNMutableNotificationContent()
        content.title = "Hydrofuel Reminder"
        content.body = calculateWaterPerAlert(alertNumber: tag + 1)//"Its time to drink water"
        content.sound = UNNotificationSound.default()
        content.badge = (tag + 1) as NSNumber
        content.userInfo = ["Name":"Parth","Badge":(timeTag + 1) as NSNumber]
        let date = setDate.toGlobalTime()
        let triggerDaily = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute, .second], from: date)
        //let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "UYLLocalNotification\(timeTag)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
        
        //UserDefaults.standard.set(arrSetFixAlarmTime, forKey: mykeys.KARRALARMDATETIME)
        //UserDefaults.standard.set(arraydate, forKey: mykeys.KARRALARMTIME)
        print("Alarm set...!")
    }
    
   
}
extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Date {
    var localiz: Date {
        return toLocalTime()
        //return description(with: .current)
    }
}
