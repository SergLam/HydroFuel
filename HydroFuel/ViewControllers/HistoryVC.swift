//
//  HistoryVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import FSCalendar

final class HistoryVC: UIViewController {

    @IBOutlet var imgback: UIImageView!
    @IBOutlet var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
     
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if appDelegate.backvar == "static" {
            imgback.image = UIImage(named: "menu")
        } else{
            imgback.image = UIImage(named: "backk")
        }
    }

    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        if appDelegate.backvar == "static" {
             self.toggleLeft()
        } else {
            imgback.image = UIImage(named: "backk")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - FSCalendarDelegate
extension HistoryVC: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch appDelegate.backvar {
            
        case "static":
            let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryDetail") as! HistoryDetail
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "graph":
            let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryDetail") as! HistoryDetail
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            appDelegate.backvar = "abc"
            let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryDetail") as! HistoryDetail
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentMonth = calendar.currentPage
        debugPrint("this is the current Month \(currentMonth)")
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
}
