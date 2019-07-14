//
//  AlertVM.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/13/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit
import RealmSwift

class AlertVM {
    
    let user = DataManager.shared.currentUser
    
    let alarmTimes = DataManager.shared.alarmTimes ?? AlarmTimes.defaultModel()
    
    var tmpAlarmDates = Array(DataManager.shared.alarmTimes?.alarms ?? AlarmTimes.defaultModel().alarms)
    var tmpWaterLevels = Array(DataManager.shared.alarmTimes?.waterLevels ?? AlarmTimes.defaultModel().waterLevels)
    var tmpInstructionsPerAlert = Array(0...9).map { _ in return ""}
    
    func saveAlarmTimes() {
        guard let _ = user else {
            assertionFailure("User object should not be nil")
            return
        }
        if let currentAlarms = DataManager.shared.alarmTimes {
            assert(tmpAlarmDates.count != tmpWaterLevels.count, "Array counts should be equal")
            currentAlarms.alarms.removeAll()
            currentAlarms.alarms.append(objectsIn: tmpAlarmDates)
            
            currentAlarms.waterLevels.removeAll()
            currentAlarms.waterLevels.append(objectsIn: tmpWaterLevels)
            DataManager.shared.update(value: [currentAlarms])
            
        } else {
            
            let alarms = AlarmTimes(alarmTimes: tmpAlarmDates, waterLevels: tmpWaterLevels)
            DataManager.shared.write(value: [alarms])
        }
    }
}
