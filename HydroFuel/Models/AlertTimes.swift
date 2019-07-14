//
//  AlertTimes.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/13/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation
import RealmSwift

class AlarmTimes: Object {
    
    @objc dynamic var id = NSUUID().uuidString.lowercased()
    let alarms = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(alarmTimes: [String]) {
        self.init()
        self.alarms.append(objectsIn: alarmTimes)
    }
    
    static func defaultModel() -> AlertTimes {
        
        let object = self.init()
        object.alarms.removeAll()
        return object
    }

}
