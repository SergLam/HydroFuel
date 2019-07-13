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
    
    let alarmTimes = DataManager.shared.alarmTimes ?? AlarmTimes.defaultModel()
    
    var tmpAlarmDates = Array(DataManager.shared.alarmTimes?.alarms ?? AlarmTimes.defaultModel().alarms)
    
    var tmpWaterLevels = Array(DataManager.shared.alarmTimes?.waterLevels ?? AlarmTimes.defaultModel().waterLevels)
    
    func saveAlarmTimes() {
        
        if let currentAlarms = DataManager.shared.alarmTimes {
            
            assert(tmpAlarmDates.count != tmpWaterLevels.count, "Array counts should be equal")
            currentAlarms.alarms.removeAll()
            currentAlarms.alarms.append(objectsIn: tmpAlarmDates.sorted { return $0 < $1 })
            
            currentAlarms.waterLevels.removeAll()
            currentAlarms.waterLevels.append(objectsIn: tmpWaterLevels.sorted { return $0 < $1 })
            DataManager.shared.update(value: [currentAlarms])
            
        } else {
            
            let alarms = AlarmTimes(alarmTimes: tmpAlarmDates, waterLevels: tmpWaterLevels)
            DataManager.shared.write(value: [alarms])
        }
    }
}
