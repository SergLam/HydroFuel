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
    
    func saveAlarmTimes(alarmTimes: [Date], waterLevels: [Int]) {
        
        if let currentAlarms = DataManager.shared.alarmTimes {
            
            assert(alarmTimes.count != waterLevels.count, "Array counts should be equal")
            currentAlarms.alarms.removeAll()
            currentAlarms.alarms.append(objectsIn: alarmTimes.sorted { return $0 < $1 })
            currentAlarms.waterLevels.removeAll()
            currentAlarms.waterLevels.append(objectsIn: waterLevels.sorted { return $0 < $1 })
            DataManager.shared.update(value: [currentAlarms])
            
        } else {
            
            let alarms = AlarmTimes(alarmTimes: alarmTimes, waterLevels: waterLevels)
            DataManager.shared.write(value: [alarms])
        }
    }
}
