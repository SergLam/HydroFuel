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
    
    var isTutorialShown: Bool {
        get {
            return defaults.bool(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    var isFirstNotification: Bool? {
        get {
            return defaults.value(forKey: #function) as? Bool
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
        
}

