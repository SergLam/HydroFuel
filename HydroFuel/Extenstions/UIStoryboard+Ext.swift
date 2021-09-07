//
//  UIStoryboard+Ext.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/11/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

public enum StroyboadType: String, CaseIterable {
    
    case main = "Main"
    case launch = "LaunchScreen"
    
    var filename: String { return rawValue }
}

typealias Storyboard = UIStoryboard

extension Storyboard {
    convenience init(_ storyboard: StroyboadType) {
        self.init(name: storyboard.filename, bundle: nil)
    }
    
    /// Instantiates and returns the view controller with the specified identifier.
    ///
    /// - Parameter identifier: uniquely identifies equals to Class name
    /// - Returns: The view controller corresponding to the specified identifier string. If no view controller is associated with the string, this method throws an exception.
    public func instantiateViewController<T>(_ identifier: T.Type) -> T where T: UIViewController {
        let className = String(describing: identifier)
        guard let vc =  self.instantiateViewController(withIdentifier: className) as? T else {
            fatalError("Cannot find controller with identifier \(className)")
        }
        return vc
    }
}
