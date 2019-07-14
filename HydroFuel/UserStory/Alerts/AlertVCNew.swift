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
    
    func calculateWaterPerAlert(rowIndex: Int) -> String {
        
        let alertTimeForIndex = viewModel.tmpAlarmDates[rowIndex]
        
        let sortedTimes = viewModel.tmpAlarmDates.sorted { return $0 < $1 }
        let sortedWaterLevels = viewModel.tmpAlarmDates.sorted { return $0 < $1 }
        var sortedInstructions = Array<String>()
        
        guard let totalDrink = viewModel.user?.suggestedWaterLevel else {
            preconditionFailure("User object should not be nil")
        }
        let waterPerAttempt = Int(totalDrink / 10)
        
        var drinkedBottles: Int = 0
        var currentBottleWaterLevel: Int = 1000
        var bottleVolume: Int = 1000
        
        // Sub-function to reduce code duplicates
        func createInstructionForNonFirstNotification(index: Int) -> String {
            let value = currentBottleWaterLevel - waterPerAttempt
            
            if value > 0 {
                currentBottleWaterLevel = value
                
                if drinkedBottles * bottleVolume >= totalDrink || index == 9 {
                    return "Drink down to the " + "\(value)" + "ml mark right now.\nCongratulations you’re done for the day!"
                } else {
                    return "Drink down to the " + "\(value)" + "ml mark right now!"
                }
            } else {
                currentBottleWaterLevel = bottleVolume - abs(value)
                drinkedBottles += 1
                
                if drinkedBottles * bottleVolume >= totalDrink || index == 9 {
                    return "Finish the bottle. Congratulations you’re done for the day!"
                } else {
                    return "Finish the bottle, refill and drink to the \(currentBottleWaterLevel) ml mark!"
                }
            }
        }
        
        for index in 0...9 {
            if UserDefaultsManager.shared.isFirstNotification == true {
                
                if drinkedBottles == 0 {
                    let value = currentBottleWaterLevel - waterPerAttempt
                    
                    if value > 0 {
                        sortedInstructions.append("Drink down to the " + "\(value)" + "ml mark, Open the App and Tap “Hydrate”")
                        currentBottleWaterLevel = value
                        continue
                    } else {
                        currentBottleWaterLevel = bottleVolume - abs(value)
                        drinkedBottles += 1
                        sortedInstructions.append("Finish the bottle, refill and drink to the \(currentBottleWaterLevel) ml mark!")
                        continue
                    }
                    
                } else {
                    
                    sortedInstructions.append(createInstructionForNonFirstNotification(index: index))
                    continue
                }
              
            } else {
                sortedInstructions.append(createInstructionForNonFirstNotification(index: index))
                continue
            }
        }
        // Search in sorted dates array and return some value
        for (index, date) in sortedTimes.enumerated() {
            if date == alertTimeForIndex {
                return sortedInstructions[index]
            }
        }
        preconditionFailure("Cannot find record for requested index")
        
       
        
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        
        appDelegate.isAfterReset = false
        viewModel.saveAlarmTimes()
        
        if appDelegate.backvar == "static" {
            self.toggleLeft()
            appDelegate.resettime = "change"
            viewModel.saveAlarmTimes()
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
            let vc = AppRouter.createHomeVC()
            self.appDelegate.resettime = "change"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setAlarm(_ setDate: Date, tag: Int) {
        
        let info: [String : Any] = ["Name" : "Parth", "Badge": timeTag + 1]
        let body = calculateWaterPerAlert(rowIndex: tag)
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
        cell.lblwaterdescripation.text = calculateWaterPerAlert(rowIndex: indexPath.row)
        
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
