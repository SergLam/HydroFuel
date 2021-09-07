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

    @IBOutlet private weak var imgback: UIImageView!
    @IBOutlet private weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
     
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgback.image = appDelegate.backvar == "static" ? R.image.menu() : R.image.backk()
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
        
        switch appDelegate.backvar {
            
        case "static", "graph":
            let vc = AppRouter.createHistoryDetail()
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            appDelegate.backvar = "abc"
            let vc = AppRouter.createHistoryDetail()
            vc.showDate = date.toLocalTime()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
}
