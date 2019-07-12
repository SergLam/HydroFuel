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

protocol PersonalInfoVMDelegate: class {
    
    func shouldPushController(vc: UIViewController)
}

class PersonalInfoVM {
    
    weak var delegate: PersonalInfoVMDelegate?
    
    var user = DataManager.shared.currentUser ?? User.defaultUserModel()
    var tmpUserModel = User.defaultUserModel()
    
    private let dateFormatter = DateFormatter()
    
    func validateInputData() throws {
        
        if user.weight == 0 {
            throw UserDataError.emptyWeight
        } else if user.gender == Gender.undefined.rawValue {
            throw UserDataError.emptyGender
        } else if user.activityLevel == Activity.undefined.rawValue {
            throw UserDataError.emptyActivity
        }
    }
    
    func insertData(_ data: DataRecordModel) -> Void {
        
        DataManager.shared.write(value: [data])
        let vc = AppRouter.createAlertVC()
        delegate?.shouldPushController(vc: vc)
    }
    
    func updateData(_ suggestedWaterLevel: Int) {
        
        let strDate = Date.currentDateToString()
        
        let data = DataRecordModel(activity: user.activityLevel, date: strDate,
                                   gender: user.gender, remainingWater: suggestedWaterLevel,
                                   totalDrink: 0, totalAttempt: 0, waterQuantity: suggestedWaterLevel,
                                   waterPerAttempt: suggestedWaterLevel / 10, weight: user.weight)
        
        DataManager.shared.update(value: [data])
        let vc = AppRouter.createHomeVC()
        delegate?.shouldPushController(vc: vc)
    }
    
    func searchDataForUpdate() {
        
//        let strDate = Date.currentDateToString()
//        let records = DataManager.shared.selectAllByDate(strDate)
//        guard let lastRecord = records.first else {
//            return
//        }
    }
    
}
