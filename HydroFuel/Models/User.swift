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
    
    var id = NSUUID().uuidString.lowercased()
    var gender: String = ""
    var activityLevel: String = ""
    var weight: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(gender: String, activityLevel: String, weight: Int) {
        self.init()
        self.gender = gender
        self.activityLevel = activityLevel
        self.weight = weight
    }
}

enum Gender: String {
    
    case male = "male"
    case female = "female"
}

enum Activity: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
}
