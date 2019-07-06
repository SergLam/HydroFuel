//
//  HistoryDetail.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import FSCalendar
import UICircularProgressRing

class HistoryDetail: UIViewController {

    @IBOutlet weak var lblWaterLevalPersentage: UILabel!
    @IBOutlet weak var lblWaterLeval: UILabel!
    @IBOutlet weak var progressRingView: UICircularProgressRingView!
    @IBOutlet var imgback: UIImageView!
    var showDate = Date()
    var counter = 0
    var arrDatesForGraph = NSMutableArray()
    
    @IBOutlet var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.select(showDate, scrollToDate: true)
        calendar.setScope(.week, animated: true)
        calendar.weekdayHeight = 30
        calendar.scrollEnabled = false
        
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: showDate)
        searchDataForProgress(strDate: strDate)
        
        let Day = Calendar.current.date(byAdding: .day, value: -1, to: showDate)
        let Yesterday = dateFormattor.string(from: Day!)
        arrDatesForGraph.add(Yesterday)
        arrDatesForGraph.add(strDate)
        
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }

    @IBAction func btngraphclick(_ sender: UIButton) {
        
         if appDelegate.backvar == "static"
        {
            appDelegate.backvar = "static"
            imgback.image = UIImage(named: "backk")
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyStatisticVC") as! MyStatisticVC
            vc.arrDates = arrDatesForGraph
            self.navigationController?.pushViewController(vc, animated: true)
         }else{
         appDelegate.backvar = "abc"
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyStatisticVC") as! MyStatisticVC
            vc.arrDates = arrDatesForGraph
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        
            if appDelegate.backvar == "static"
            {
                appDelegate.backvar = "static"
                imgback.image = UIImage(named: "menu")
                self.navigationController?.popViewController(animated: true)
              
            }

            else{
                 appDelegate.backvar = "abc"
                imgback.image = UIImage(named: "backk")
                self.navigationController?.popViewController(animated: true)
                
            }
       
    }
    
    func searchDataForProgress(strDate : String) {
        
        let strURL = "SELECT * FROM HYDROFUELPERSINFO where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.selectIdDataTable(strURL)
        print(data)
        if data.status == 1 {
            print(data.success)
            let arrLocalData = data.arrData
            let dictPrevious = (arrLocalData[0] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            //let DATE = dictPrevious.value(forKey: "DATE") as! String
            
           
            let WATERQTY = dictPrevious.value(forKey: "WATERQTY") as! Int
            //let REMAININGWATERQTY = dictPrevious.value(forKey: "REMAININGWATERQTY") as! Int
            //let TOTALDRINK = dictPrevious.value(forKey: "TOTALDRINK") as! Int
            let TOTALATTEMPT = dictPrevious.value(forKey: "TOTALATTEMPT") as! Int
            let WATERQTYPERATTEMPT = dictPrevious.value(forKey: "WATERQTYPERATTEMPT") as! Int
            
            let totalWater = TOTALATTEMPT * WATERQTYPERATTEMPT
            
            
            progressRingView.maxValue = CGFloat(WATERQTY)
            progressRingView.value = CGFloat(totalWater)
            
            self.lblWaterLeval.text = "\(totalWater)" + "/" + "\(WATERQTY)" + " " + "ml"
            let per = (totalWater * 100)/WATERQTY
            self.lblWaterLevalPersentage.text = "\(per)%"
            
            
        }else{
            progressRingView.maxValue = 0
            progressRingView.value = 0
            self.lblWaterLeval.text = "\(0)" + "/" + "\(0)ml"
            self.lblWaterLevalPersentage.text = "\(0)%"
            print(data.failure)
        }
        
    }
    
}


// MARK: - FSCalendarDelegate
extension HistoryDetail: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        arrDatesForGraph.removeAllObjects()
        let today = date.toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        print(strDate)
        let Day = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let Yesterday = dateFormattor.string(from: Day!)
        
        arrDatesForGraph.add(Yesterday)
        arrDatesForGraph.add(strDate)
        
        searchDataForProgress(strDate: strDate)
        
    }
    
}
