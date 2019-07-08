//
//  DataRecordModel.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/7/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation

struct DataRecordModel: Equatable {
    
    var activityLevel: String // low, medium, high
    var date: String // "2019-07-07"
    var gender: String // male - female
    var id: Int
    var remainingWaterQuantity: Int
    var totalDrink: Int
    
    var totalAttempt: Int
    var waterQuantity: Int
    var waterQuantityPerAttempt: Int
    var weight: Int
    
    static func defaultModel() -> DataRecordModel {
        return DataRecordModel(activityLevel: "", date: "", gender: "", id: 0, remainingWaterQuantity: 0, totalDrink: 0, totalAttempt: 0, waterQuantity: 0, waterQuantityPerAttempt: 0, weight: 0)
    }
}
