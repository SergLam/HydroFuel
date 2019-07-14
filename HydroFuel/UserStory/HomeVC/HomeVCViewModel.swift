//
//  HomeVCViewModel.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/12/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

class HomeVCViewModel {
    
    var previousModel: DataRecordModel!
    var currentModel = DataRecordModel.defaultModel()
    
    var lastCountOfAttempt = 0
    var waterPerAttempt = 0
    var prevWaterLeval = CGFloat()
    var bottleCount = 0
    var timer = Timer()
    var counter = 0
    var bottleNumberAsNotif = 0
    var tottleBottle = 0
    
    var arrFixDates: [Date] = []
    var arrSetFixAlarmTime = NSMutableArray()
    var strTimes = ""
    
    var differenceWater = 0.0
    
    let formatter = DateFormatter()
    
    init() {
        formatter.dateFormat = "HH:mm"
        strTimes = formatter.string(from: Date())
    }
}
