//
//  User.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/8/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation

struct User {
    
    var gender: Gender? = Gender(rawValue: UserDefaultsManager.shared.userGender ?? "")
    var activityLevel: Activity? = Activity(rawValue: UserDefaultsManager.shared.userActivityLevel ?? "")
    var weight: Int? = UserDefaultsManager.shared.userWeight
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
