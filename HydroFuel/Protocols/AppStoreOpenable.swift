//
//  AppStoreOpenable.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/8/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD

protocol AppStoreOpenable {
    
    func viewProductAtAppStore(storeVC: SKStoreProductViewController)
}

extension AppStoreOpenable where Self: UIViewController {
    
    func viewProductAtAppStore(storeVC: SKStoreProductViewController) {
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier : 1432543329]
        SVProgressHUD.show(withStatus: "Opening AppStore...")
        
        storeVC.loadProduct(withParameters: parameters) { [unowned self] (loaded, error) -> Void in
            SVProgressHUD.dismiss()
            if loaded {
                self.present(storeVC, animated: true, completion: nil)
            } else if let error = error {
                AlertPresenter.showErrorAlert(at: self, message: error.localizedDescription)
            }
        }
    }
    
}
