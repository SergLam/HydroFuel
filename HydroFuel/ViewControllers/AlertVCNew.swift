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

class AlertVCNew: UIViewController, iShowcaseDelegate {
    
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
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dateFormatter.dateFormat = "HH:mm"
        strTimes = dateFormatter.string(from: Date())
        print(strTimes)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        showcase.delegate = self
        if UserDefaultsManager.shared.previousDate == nil {
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
        
        if UserDefaultsManager.shared.alarmArrayAlarmTime != nil {
            let arrTime = UserDefaultsManager.shared.alarmArrayAlarmTime! as NSArray
            arraydate = arrTime.mutableCopy() as! NSMutableArray
        }else{
            arraydate = ["08:30 AM","09:30 AM","11:30 AM","01:00 PM","03:30 PM","05:30 PM","07:30 PM","08:30 PM","09:30 PM","11:00 PM"]
            UserDefaultsManager.shared.alarmArrayAlarmTime = (arraydate as! [String])
        }
        if UserDefaultsManager.shared.alarmArrayDateTime != nil {
            let arrTime = UserDefaultsManager.shared.alarmArrayDateTime! as NSArray
            arrSetFixAlarmTime = arrTime.mutableCopy() as! NSMutableArray
        }else{
            arrSetFixAlarmTime = ["2018-09-13 08:30:00 +0000","2018-09-13 09:30:00 +0000","2018-09-13 10:30:00 +0000","2018-09-13 11:30:00 +0000","2018-09-13 12:30:00 +0000","2018-09-13 13:30:00 +0000","2018-09-13 14:30:00 +0000","2018-09-13 15:30:00 +0000","2018-09-13 16:30:00 +0000","2018-09-13 17:30:00 +0000"]
            UserDefaultsManager.shared.alarmArrayDateTime = (arrSetFixAlarmTime as! [String])
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard appDelegate.isToolTipShown else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showcase.setupShowcaseForTableView(self.tblAlert, withIndexPath: [0,0])
            self.showcase.titleLabel.text = "Notifications tell you exactly how much to drink so pay attention! You can edit the notification times here."
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "\n\n      "
            self.showcase.show()
        }
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        datePickerView.datePickerMode = .time
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        print(sender.date.localiz)
        if timeTag != 0{
            print(arrSetFixAlarmTime[timeTag-1] as! String)
            
            let formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            formattor.timeZone = TimeZone(identifier: "UTC")
            if  appDelegate.resettime != "reset" {
                print(String(describing: formattor.date(from: arrSetFixAlarmTime[timeTag-1] as! String)))
                // datePickerView.minimumDate = (formattor.date(from: arrSetFixAlarmTime[timeTag-1] as! String))?.toGlobalTime()
                //datePickerView.minimumDate = Date()
            }
        }else{
            if  appDelegate.resettime != "reset" {
                //datePickerView.minimumDate = Date()
            }
        }
        
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
        for date in arrFixDates {
            let format1 = DateFormatter()
            format1.dateFormat = "HH:mm"
            format1.timeZone = TimeZone(identifier: "UTC")
            let strDate2 = format1.string(from: date)
            arrForSort.append(format1.date(from: strDate2)!)
        }
        
        let arrSortedDates = arrForSort.sorted(by: { $0.compare($1) == .orderedAscending })
        arrFixDates = ((arrSortedDates as NSArray).mutableCopy() as! NSMutableArray) as! [Date]
        
        for (index, fixDate) in arrFixDates.enumerated() {
       
            timeTag = index
            setAlarm(fixDate, tag: index)
            let dt = formattor.string(from: fixDate)
            arrSetFixAlarmTime.replaceObject(at: index, with: dt)
        }
        
        if UserDefaultsManager.shared.previousDate == nil {
            let today = Date().toLocalTime()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            dateFormattor.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormattor.string(from: today)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            
            UserDefaultsManager.shared.bottleCount = 1
            UserDefaultsManager.shared.previousDate = strDate
            UserDefaultsManager.shared.lastCountOfAttempt = 0
            UserDefaultsManager.shared.lastDisplayedWaterLevel = 1000
        }
        UserDefaultsManager.shared.alarmArrayDateTime = (arrSetFixAlarmTime as! [String])
        
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
        if UserDefaultsManager.shared.previousDate == nil {
            let today = Date().toLocalTime()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            dateFormattor.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormattor.string(from: today)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            
            UserDefaultsManager.shared.bottleCount = 1
            UserDefaultsManager.shared.previousDate = strDate
            UserDefaultsManager.shared.lastCountOfAttempt = 0
            UserDefaultsManager.shared.lastDisplayedWaterLevel = 1000
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
            UserDefaultsManager.shared.alarmArrayDateTime = (self.arrSetFixAlarmTime as! [String])
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.appDelegate.resettime = "change"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setAlarm(_ setDate: Date, tag: Int) {
        
        let info: [String : Any] = ["Name":"Parth","Badge":(timeTag + 1) as NSNumber]
        let body = calculateWaterPerAlert(alertNumber: tag + 1)//"Its time to drink water"
        LocalNotificationsService.enqueueLocalNotification(body: body, badge: tag + 1,
                                                           info: info, toDate: setDate)
    }
    
}

// MARK: - UITableViewDataSource
extension AlertVCNew: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFixDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as? alertCell else {
            preconditionFailure("Unable to dequeueReusableCell")
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: arrFixDates[indexPath.row])
        cell.lbltimeshow.text = strDate
        cell.lblwaterdescripation.text = calculateWaterPerAlert(alertNumber: indexPath.row + 1)
        cell.txttimer.tag = indexPath.row
        cell.txttimer.delegate = self
        
        cell.txttimer.isEnabled = true
        cell.btnEdit.isEnabled = true
        cell.imgEdit.image = UIImage(named: "edit")
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension AlertVCNew: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

// MARK: - UITextFieldDelegate
extension AlertVCNew: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        datePickerView.datePickerMode = .time
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        timeTag = textField.tag
        datePickerView.datePickerMode = .time
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        datePickerView.datePickerMode = .time
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        timeTag = textField.tag
        
        arrSetFixAlarmTime.replaceObject(at: timeTag, with: "\(datePickerView.date.localiz)")
        isTimeEdited = true
        arrFixDates.removeAll()
        
        for date in arrSetFixAlarmTime {
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            let fixDate = dateFormatter.date(from: date as! String)
            arrFixDates.append(fixDate!)
        }
        
        tblAlert.reloadData()
    }
    
}
