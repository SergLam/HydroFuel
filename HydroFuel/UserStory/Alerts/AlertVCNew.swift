//
//  AlertVCNew.swift
//  HydroFuel
//
//  Created by Stegowl on 9/26/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import iShowcase
import CTShowcase

final class AlertVCNew: UIViewController {
    
    @IBOutlet private weak var highlightview: UIView!
    @IBOutlet private weak var btnMenu: UIButton!
    @IBOutlet private weak var tblAlert: UITableView!
    @IBOutlet private weak var imgback: UIImageView!
    
    private let datePickerView = UIDatePicker()
    
    private let dateFormatter = DateFormatter()
    private var timeTag = 0 // Determine selected cell
    private var lastSelectedDate = Date()
    
    private var showcase = iShowcase()
    private let viewModel = AlertVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showcase.delegate = self
        imgback.isHidden = !appDelegate.isAfterReset
        btnMenu.isHidden = !appDelegate.isAfterReset
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard !UserDefaultsManager.shared.isTutorialShown else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.showFirstTutorialView()
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        lastSelectedDate = sender.date
    }
    
    func calculateWaterPerAlert(alertNumber: Int) -> String {
        return ""
//        if str * alertNumber < 1000{
//            if UserDefaultsManager.shared.isFirstNotification == true {
//                let text = "Drink down to the " + "\(1000 - (str * alertNumber))" + "ml mark, Open the App and Tap “Hydrate”"
//                return text
//            } else{
//                if alertNumber == 10
//                {
//                    let text = "Finish the bottle. Congratulations you’re done for the day!"
//                    return text
//
//                }else{
//                    let data = (str * alertNumber) % 1000
//                    let totalWater = str * 10
//                    if (str * alertNumber) > totalWater - ((totalWater % 1000)){
//                        let bottleToRefil = ((10 - alertNumber) * str) + data
//                        let text = "Drink down to the " + "\(bottleToRefil - data)" + "ml mark right now!"
//                        return text
//                    }else{
//                        let text = "Drink down to the " + "\(1000 - (str * alertNumber))" + "ml mark right now!"
//                        return text
//                    }
//                }
//
//            }
//        }else {
//            let data = (str * alertNumber) % 1000
//            if 1000 - data > str && (1000 - data) + str > 1000{
//
//                if alertNumber == 10
//                {
//                    let text = "Finish the bottle. Congratulations you’re done for the day!"
//                    return text
//
//                }else{
//                    let totalWater = str * 10
//                    if (str * alertNumber) > totalWater - ((totalWater % 1000)){
//                        let bottleToRefil = ((10 - alertNumber) * str) + data
//                        let text = "Finish the bottle, refill to the " + "\(bottleToRefil) ml mark! " + "and drink to the " + "\(bottleToRefil - data)" + "ml mark!"
//                        return text
//                    }
//                    let text = "Finish the bottle, refill and drink to the " + "\(1000 - data)" + "ml mark!"
//                    return text
//                }
//
//            }
//
//            else{
//                if alertNumber == 10
//                {
//                    let text = "Finish the bottle. Congratulations you’re done for the day!"
//                    return text
//
//                }else{
//                    let data = (str * alertNumber) % 1000
//                    let totalWater = str * 10
//                    if (str * alertNumber) > totalWater - ((totalWater % 1000)){
//                        let bottleToRefil = ((10 - alertNumber) * str) + data
//                        let text = "Drink down to the " + "\(bottleToRefil - data)" + "ml mark right now!"
//                        return text
//                    }else{
//                        let text = "Drink down to the " + "\(1000 - data)" + "ml mark right now!"
//                        return text
//                    }
//                }
//
//            }
//        }
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        
        appDelegate.isAfterReset = false
        viewModel.saveAlarmTimes()
        
        if appDelegate.backvar == "static" {
            self.toggleLeft()
            appDelegate.resettime = "change"
            //setdata()
        } else {
            imgback.image = UIImage(named: "back2")
            self.navigationController?.popViewController(animated: true)
        }
        self.appDelegate.resettime = "change"
    }
    
    @IBAction func btnHomeclick(_ sender: UIButton) {
        
        appDelegate.isAfterReset = false
        
        viewModel.saveAlarmTimes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.appDelegate.resettime = "change"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setAlarm(_ setDate: Date, tag: Int) {
        
        let info: [String : Any] = ["Name" : "Parth", "Badge": timeTag + 1]
        let body = calculateWaterPerAlert(alertNumber: tag + 1)
        LocalNotificationsService.enqueueLocalNotification(body: body, badge: tag + 1,
                                                           info: info, toDate: setDate)
    }
    
}

// MARK: - UITableViewDataSource
extension AlertVCNew: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tmpAlarmDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as? alertCell else {
            preconditionFailure("Unable to dequeueReusableCell")
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: viewModel.tmpAlarmDates[indexPath.row])
        cell.lbltimeshow.text = strDate
        cell.lblwaterdescripation.text = calculateWaterPerAlert(alertNumber: indexPath.row + 1)
        
        cell.txttimer.tag = indexPath.row
        
        cell.txttimer.delegate = self
        
        cell.txttimer.isEnabled = true
        cell.btnEdit.isEnabled = true
        cell.imgEdit.image = R.image.edit()
        
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
        textField.inputView = datePickerView
        timeTag = textField.tag
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        viewModel.tmpAlarmDates[timeTag] = datePickerView.date
        tblAlert.reloadData()
    }
    
}

// MARK: - iShowcaseDelegate
extension AlertVCNew: iShowcaseDelegate {
    
    private func showFirstTutorialView() {
        
        showcase.setupShowcaseForTableView(tblAlert, withIndexPath: [0,0])
        showcase.titleLabel.text = "Notifications tell you exactly how much to drink so pay attention! You can edit the notification times here."
        showcase.titleLabel.font = UIFont.avenirMedium17
        showcase.detailsLabel.text = "\n\n\n"
        showcase.show()
    }
    
}
