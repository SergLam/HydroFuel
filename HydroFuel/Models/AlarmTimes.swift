//
//  AlertTimes.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/13/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation
import RealmSwift

// NOTE: formatter.timeZone = TimeZone(identifier: "UTC") - cause timer should trigger exactly in the specified time, independently of user current timezone
class AlarmTimes: Object {
    
    @objc dynamic var id = NSUUID().uuidString.lowercased()
    var alarms = List<Date>()
    var waterLevels = List<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(alarmTimes: [Date], waterLevels: [Int]) {
        self.init()
        self.alarms.append(objectsIn: alarmTimes)
        self.waterLevels.append(objectsIn: waterLevels)
    }
    
    static func defaultModel() -> AlarmTimes {
        
        let hours: [Int] = [8, 9, 11, 13, 15, 17, 19, 20, 21, 23]
        let minutes: [Int] = [30, 30, 30, 0, 30, 30, 30, 30, 30, 0]
        let user = DataManager.shared.currentUser ?? User.defaultUserModel()
        let waterPerAttempt = user.suggestedWaterLevel / 10
        
        var defaultDates: [Date] = []
        var defaultWaterLevels: [Int] = []
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        for i in 0...9 {
            
            let date = calendar.date(bySettingHour: hours[i], minute: minutes[i], second: 0, of: Date())!
            defaultWaterLevels.append(waterPerAttempt * (10 - i))
            defaultDates.append(date)
        }
        
        return AlarmTimes(alarmTimes: defaultDates, waterLevels: defaultWaterLevels)
    }

}
