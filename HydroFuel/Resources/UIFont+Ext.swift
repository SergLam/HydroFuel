//
//  UIFont+Ext.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/6/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

extension UIFont {
    
    @nonobjc class var avenirMedium17: UIFont {
        return UIFont(name: "Avenir Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
}
