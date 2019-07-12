//
//  menuVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import StoreKit
import SVProgressHUD

final class MenuVC: UIViewController, AppStoreOpenable {
    
    @IBOutlet private weak var tblview: UITableView!
    
    @objc var mainViewController: UIViewController!
    @objc var HomeVC: UIViewController!
    @objc var Hostory: UIViewController!
    @objc var AlertVCNew: UIViewController!
    @objc var MyStatisticVC: UIViewController!
    @objc var PersonalInfoVC: UIViewController!
    @objc var HistoryDetail: UIViewController!
    
    var arrayname = ["Home", "History", "Modify Alerts", "My Statistics", "Buy",
                     "Personal Info", "Help & About Us", "Rate & Review"]
    var arrayimg = [R.image.homeimg(), R.image.history(), R.image.alarm(),
                    R.image.graph(), R.image.shoppingcartblack(), R.image.personal(),
                    R.image.help(), R.image.rateandreview()]
    
    var arrayimgblue = [R.image.homeblue(), R.image.historyblue(), R.image.alarm_selected(),
                        R.image.graphblue(), R.image.shoppingcartblue(), R.image.settingblue(),
                        R.image.help(), R.image.rateandreview()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblview.separatorStyle = .none
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}

// MARK: - UITableViewDataSource
extension MenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? menucell else {
            preconditionFailure("Unable to dequeueReusableCell")
        }
        
        cell.lblname.text = arrayname[indexPath.row]
        cell.imgview.image = arrayimg[indexPath.row]
        
        cell.lineview.isHidden = indexPath.row != 3
        
        if appDelegate.menuName == arrayname[indexPath.row] {
            cell.lblname.textColor = UIColor.bgcolor
            cell.imgview.image = arrayimgblue[indexPath.row]
        } else {
            cell.lblname.textColor = UIColor.black
            cell.imgview.image = arrayimg[indexPath.row]
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? menucell else {
            preconditionFailure("Unable to dequeueReusableCell")
        }
        
        appDelegate.menuName = arrayname[indexPath.row]
        tblview.reloadData()
        
        switch indexPath.row {
        case 0:
            self.HomeVC = UINavigationController(rootViewController: AppRouter.createHomeVC())
            self.slideMenuController()?.changeMainViewController(self.HomeVC, close: true)
            
        case 1:
            cell.lblname.textColor = UIColor.blue
            appDelegate.backvar = "static"
            self.Hostory = UINavigationController(rootViewController: AppRouter.createHistoryVC())
            self.slideMenuController()?.changeMainViewController(self.Hostory, close: true)
        
        case 2:
            appDelegate.backvar = "static"
            self.AlertVCNew = UINavigationController(rootViewController: AppRouter.createAlertVC())
            self.slideMenuController()?.changeMainViewController(self.AlertVCNew, close: true)
            
        case 3:
            appDelegate.backvar = "graph"
            self.MyStatisticVC = UINavigationController(rootViewController: AppRouter.createMyStatisticVC())
            self.slideMenuController()?.changeMainViewController(self.MyStatisticVC, close: true)
            
        case 4:
            guard let url = URL(string: "http://www.fuelyourfuture.co.uk") else {
                return
            }
            UIApplication.shared.open(url, options: [:]) { (_) in }
            
        case 5:
            appDelegate.backvar = "static"
            appDelegate.isMenuIconHidden = false
            self.PersonalInfoVC = UINavigationController(rootViewController: AppRouter.createPersonalInfoVC())
            self.slideMenuController()?.changeMainViewController(self.PersonalInfoVC, close: true)
            
        case 6:
            guard let url = URL(string: "https://www.hydro-fuel.co.uk/about") else {
                return
            }
            UIApplication.shared.open(url, options: [:]) { (_) in }
        case 7:
            let storeVC = SKStoreProductViewController()
            storeVC.delegate = self
            viewProductAtAppStore(storeVC: storeVC)
            
        default:
            assertionFailure("Unknown row value, plese update this method")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

// MARK: - SKStoreProductViewControllerDelegate
extension MenuVC: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
