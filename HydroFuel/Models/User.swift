//
//  User.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/8/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var id = NSUUID().uuidString.lowercased()
    @objc dynamic var gender: String = ""
    @objc dynamic var activityLevel: String = ""
    @objc dynamic var weight: Int = 0
    @objc dynamic var suggestedWaterLevel: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(gender: String, activityLevel: String, weight: Int, suggestedWater: Int) {
        self.init()
        self.gender = gender
        self.activityLevel = activityLevel
        self.weight = weight
        self.suggestedWaterLevel = suggestedWater
    }
    
    static func defaultUserModel() -> User {
        
        let user = self.init()
        user.gender = Gender.male.rawValue
        user.activityLevel = Activity.undefined.rawValue
        user.weight = 50
        user.suggestedWaterLevel = 2500
        return user
    }
}

enum Gender: String {
    
    case male = "male"
    case female = "female"
}

enum Activity: String {
    
    case undefined = "undefined"
    case low = "low"
    case medium = "medium"
    case high = "high"
}
