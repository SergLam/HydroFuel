//
//  Global.swift
//  iBabelClient
//
//  Created by Raxit on 06/10/16.
//  Copyright © 2016 Crest-Infotech. All rights reserved.
//

import UIKit
import Foundation

class Global: NSObject
{
    static let sharedInstance = Global()
    
    // Variable Declaration
    var userDataPath = String()
    
    class func setDataPath(setDataPath : String) -> Void {
        sharedInstance.userDataPath = setDataPath as String
    }
    class func getDataPath() -> String {
        return sharedInstance.userDataPath as String
    }
    
    
}
