//
//  PersonalInfoVM.swift
//  HydroFuel
//
//  Created by Andrii Mazepa on 7/12/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

enum UserDataError: Error, LocalizedError {
    
    case emptyWeight
    case emptyGender
    case emptyActivity
    
    var description: String {
        switch self {
            
        case .emptyWeight:
            return "Please Choose Weight"
            
        case .emptyGender:
            return "Please Choose Gender"
            
        case .emptyActivity:
            return "Please Choose Activity Level"
        }
    }
    
    var errorDescription: String? {
        get {
            return self.description
        }
    }
    
}

protocol PersonalInfoVMDelegate: AnyObject {
    
    func shouldPushController(vc: UIViewController)
}

class PersonalInfoVM {
    
    weak var delegate: PersonalInfoVMDelegate?
    
    var user = DataManager.shared.currentUser ?? User.defaultUserModel()
    var tmpUserModel = DataManager.shared.currentUser ?? User.defaultUserModel()
    
    private let dateFormatter = DateFormatter()
    
    func validateInputData() throws {
        
        if tmpUserModel.weight == 0 {
            throw UserDataError.emptyWeight
        } else if tmpUserModel.gender == Gender.undefined.rawValue {
            throw UserDataError.emptyGender
        } else if tmpUserModel.activityLevel == Activity.undefined.rawValue {
            throw UserDataError.emptyActivity
        }
    }
    
    func updateData() {
        
        user.update(user: tmpUserModel)
        DataManager.shared.write(value: [user])
        let strDate = Date.currentDateToString()
        
        let data = DataRecordModel(activity: user.activityLevel, date: strDate,
                                   gender: user.gender, remainingWater: user.suggestedWaterLevel,
                                   totalDrink: 0, totalAttempt: 0, waterQuantity: user.suggestedWaterLevel,
                                   waterPerAttempt: user.suggestedWaterLevel / 10, weight: user.weight)
        
        DataManager.shared.update(value: [data])
        
        let vc: UIViewController
        if DataManager.shared.alarmTimes == nil {
            vc = AppRouter.createAlertVC()
        } else {
            vc = AppRouter.createHomeVC()
        }
        delegate?.shouldPushController(vc: vc)
    }
    
}
