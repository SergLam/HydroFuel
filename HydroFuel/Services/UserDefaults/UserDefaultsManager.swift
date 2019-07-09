//
//  DefaultsManager.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/6/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    var databasePath: String? {
        get {
            return defaults.string(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
    Array of date+time when local notification should triggers
    */
    var alarmArrayDateTime: [String]? {
        get {
            return defaults.stringArray(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
     Array of times when local notification should triggers
     */
    var alarmArrayAlarmTime: [String]? {
        get {
            return defaults.stringArray(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }

    /**
     Number of drinks that user performed at current day
    */
    var lastCountOfAttempt: Int {
        get {
            return defaults.integer(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
     Last alarm date
    */
    var previousDate: String? {
        get {
            return defaults.string(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
     Last water level. If not set - equal to zero
     */
    var prevWaterLevel: Double {
        get {
            return defaults.double(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
     Number of bottles that should be drinked
     */
    var bottleCount: Int {
        get {
            return defaults.integer(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
     Water portion that should be drink per time
     */
    var lastWaterConstraint: Int {
        get {
            return defaults.integer(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    /**
     Last displayed water level value
     */
    var lastDisplayedWaterLevel: Int {
        get {
            return defaults.integer(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    var isTutorialShown: Bool {
        get {
            return defaults.bool(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    var isFirstNotification: Bool {
        get {
            return defaults.bool(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
        
}

