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

final class HistoryDetail: UIViewController {
    
    @IBOutlet private weak var lblWaterLevalPersentage: UILabel!
    @IBOutlet private weak var lblWaterLeval: UILabel!
    @IBOutlet private weak var progressRingView: UICircularProgressRing!
    @IBOutlet private var imgback: UIImageView!
    @IBOutlet private var calendar: FSCalendar!
    
    var showDate = Date()
    var counter = 0
    var arrDatesForGraph = NSMutableArray()
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendar()
        configureDateFormatter()
        
        let strDate = dateFormatter.string(from: showDate)
        searchDataForProgress(strDate: strDate)
        
        let Day = Calendar.current.date(byAdding: .day, value: -1, to: showDate)
        let Yesterday = dateFormatter.string(from: Day!)
        arrDatesForGraph.add(Yesterday)
        arrDatesForGraph.add(strDate)
        
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func btngraphclick(_ sender: UIButton) {
        
        if appDelegate.backvar == "static" {
            imgback.image = UIImage(named: "backk")
        } else{
            appDelegate.backvar = "abc"
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyStatisticVC") as! MyStatisticVC
        vc.arrDates = arrDatesForGraph
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        if appDelegate.backvar == "static" {
            appDelegate.backvar = "static"
            imgback.image = R.image.menu()
        } else {
            appDelegate.backvar = "abc"
            imgback.image = R.image.backk()
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureCalendar() {
        
        calendar.delegate = self
        calendar.select(showDate, scrollToDate: true)
        calendar.setScope(.week, animated: true)
        calendar.weekdayHeight = 30
        calendar.scrollEnabled = false
    }
    
    private func configureDateFormatter() {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
    }
    
    private func searchDataForProgress(strDate: String) {
        
        let data = DBManager.shared.selectAllByDate(strDate)
        
        guard data.status == 1 else {
            displayProgressData(totalWater: 0, waterQty: 0)
            return
        }
        let arrLocalData = data.arrData
        let dictPrevious = arrLocalData[0]
        
        let warerQty = dictPrevious.waterQuantity
        let totalAttempt = dictPrevious.totalAttempt
        let waterQtyPerAttempt = dictPrevious.waterQuantityPerAttempt
        
        let totalWater = totalAttempt * waterQtyPerAttempt
        
        displayProgressData(totalWater: totalWater, waterQty: warerQty)
    }
    
    private func displayProgressData(totalWater: Int, waterQty: Int) {
        
        progressRingView.maxValue = CGFloat(waterQty)
        progressRingView.value = CGFloat(totalWater)
        
        lblWaterLeval.text = "\(totalWater)" + "/" + "\(waterQty)" + " " + "ml"
        guard waterQty == 0 else {
            let percent = (totalWater / waterQty) * 100
            self.lblWaterLevalPersentage.text = "\(percent)%"
            return
        }
        lblWaterLevalPersentage.text = "\(0)%"
    }
    
}

// MARK: - FSCalendarDelegate
extension HistoryDetail: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        arrDatesForGraph.removeAllObjects()
        let today = date.toLocalTime()
        
        let strDate = dateFormatter.string(from: today)
        
        let Day = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let Yesterday = dateFormatter.string(from: Day!)
        
        arrDatesForGraph.add(Yesterday)
        arrDatesForGraph.add(strDate)
        
        searchDataForProgress(strDate: strDate)
    }
    
}
