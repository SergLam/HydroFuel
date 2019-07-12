//
//  PersonalInfoVM.swift
//  HydroFuel
//
//  Created by Andrii Mazepa on 7/12/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation

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

class PersonalInfoVM {
    
    var user = DataManager.shared.currentUser ?? User.defaultUserModel()
    var tmpUserModel = User.defaultUserModel()
    
    func validateInputData() throws {
        
        if user.weight == 0 {
            throw UserDataError.emptyWeight
        } else if user.gender
    }
    
}
