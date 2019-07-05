//
//  HistoryVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import FSCalendar
class HistoryVC: UIViewController,FSCalendarDelegate{

    @IBOutlet var imgback: UIImageView!
    
    @IBOutlet var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
       calendar.delegate = self
     
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.backvar == "static"
        {
            imgback.image = UIImage(named: "menu")
        }
        else{
            imgback.image = UIImage(named: "backk")
        }
    }
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//
//        }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Date--->",date.toLocalTime())
        print("monthPosition---->", monthPosition)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if appDelegate.backvar == "static"
        {
            appDelegate.backvar = "static"
            let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryDetail") as! HistoryDetail
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)

        }
       else if appDelegate.backvar == "graph"{
            
                    let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryDetail") as! HistoryDetail
                    vc.showDate = date.toLocalTime()
                    self.navigationController?.pushViewController(vc, animated: true)
        }
//
        else{
            appDelegate.backvar = "abc"
            let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryDetail") as! HistoryDetail
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
      //  let currentMonth = calendar.currentPage.month
       
      //  print("this is the current Month \(currentMonth)")
    }
  //  - (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date FSCalendarDeprecated(-calendar:shouldDeselectDate:atMonthPosition:)
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
       
        return true
    }
    @IBAction func btnmenuclick(_ sender: UIButton) {
        if appDelegate.backvar == "static"
        {
             self.toggleLeft()
        }
        else{
            imgback.image = UIImage(named: "backk")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
