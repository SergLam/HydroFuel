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
        return User(gender: Gender.male.rawValue, activityLevel: Activity.undefined.rawValue, weight: 50, suggestedWater: 2500)
    }
    
    func update(user: User) {
        
        if user.gender != Gender.undefined.rawValue {
            gender = user.gender
        }
        if user.activityLevel != Activity.undefined.rawValue {
            activityLevel = user.activityLevel
        }
        weight = user.weight
        suggestedWaterLevel = user.suggestedWaterLevel
    }
    
}

enum Gender: String {
    
    case undefined = "undefined"
    case male = "male"
    case female = "female"
}

enum Activity: String {
    
    case undefined = "undefined"
    case low = "low"
    case medium = "medium"
    case high = "high"
}
