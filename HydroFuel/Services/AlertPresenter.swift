//
//  AlertPresenter.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/6/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

final class AlertPresenter {
    
    static func showResetAlert(at vc: UIViewController, yesAction: @escaping VoidClosure) {
        
        let alert = UIAlertController(title: "Are you sure to reset today log?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            vc.appDelegate.isAfterReset = true
            yesAction()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
}
