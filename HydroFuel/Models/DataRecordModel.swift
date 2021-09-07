//
//  DataRecordModel.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/7/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation
import RealmSwift

class DataRecordModel: Object {
    
    @objc dynamic var id: String = NSUUID().uuidString.lowercased()
    
    @objc dynamic var activityLevel: String = "" // low, medium, high
    @objc dynamic var date: String = "" // "2019-07-07"
    @objc dynamic var gender: String = ""// male - female
    
    @objc dynamic var remainingWaterQuantity: Int = 0
    @objc dynamic var totalDrink: Int = 0
    
    @objc dynamic var totalAttempt: Int = 0
    @objc dynamic var waterQuantity: Int = 0
    @objc dynamic var waterPerAttempt: Int = 0
    @objc dynamic var weight: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(activity: String, date: String, gender: String,
                              remainingWater: Int, totalDrink: Int, totalAttempt: Int,
                              waterQuantity: Int, waterPerAttempt: Int, weight: Int) {
        self.init()
        self.activityLevel = activity
        self.date = date
        self.gender = gender
        self.remainingWaterQuantity = remainingWater
        self.totalDrink = totalDrink
        self.totalAttempt = totalAttempt
        self.waterQuantity = waterQuantity
        self.waterPerAttempt = waterPerAttempt
        self.weight = weight
    }
    
    
    static func defaultModel() -> DataRecordModel {
        return DataRecordModel()
    }
}
