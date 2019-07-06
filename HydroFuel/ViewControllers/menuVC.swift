//
//  menuVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class menuVC: UIViewController {
    
    @IBOutlet var tblview: UITableView!
    
    @objc var mainViewController: UIViewController!
    @objc var HomeVC: UIViewController!
    @objc var Hostory: UIViewController!
    @objc var AlertVCNew: UIViewController!
    @objc var MyStatisticVC: UIViewController!
    @objc var PersonalInfoVC: UIViewController!
    @objc var HistoryDetail: UIViewController!
    
    var arrayname = ["Home", "History", "Modify Alerts", "My Statistics", "Buy",
                     "Personal Info", "Help & About Us", "Rate & Review"]
    var arrayimg = ["homeimg", "history", "alarm", "graph", "shoppingcartblack",
                    "personal", "help", "rateandreview"]
    var arrayimgblue = ["homeblue", "historyblue", "alarm_selected", "graphblue",
                        "shoppingcartblue", "settingblue", "help", "rateandreview"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblview.separatorStyle = .none
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}

// MARK: - UITableViewDataSource
extension menuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? menucell else {
            preconditionFailure("Unable to dequeueReusableCell")
        }
        
        cell.lblname.text = arrayname[indexPath.row]
        cell.imgview.image = UIImage(named:arrayimg[indexPath.row])
        
        cell.lineview.isHidden = indexPath.row != 3
        
        if appDelegate.menuName == arrayname[indexPath.row] {
            cell.lblname.textColor = UIColor.bgcolor
            cell.imgview.image = UIImage(named: arrayimgblue[indexPath.row])
        } else {
            cell.lblname.textColor = UIColor.black
            cell.imgview.image = UIImage(named: arrayimg[indexPath.row])
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension menuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? menucell else {
            preconditionFailure("Unable to dequeueReusableCell")
        }
        
        appDelegate.menuName = arrayname[indexPath.row]
        tblview.reloadData()
        
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as!  HomeVC
            self.HomeVC = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.HomeVC, close: true)
            
        case 1:
            cell.lblname.textColor = UIColor.blue
            appDelegate.backvar = "static"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as!  HistoryVC
            self.Hostory = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.Hostory, close: true)
        
        case 2:
            appDelegate.backvar = "static"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "AlertVCNew") as!  AlertVCNew
            self.AlertVCNew = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.AlertVCNew, close: true)
            
        case 3:
            appDelegate.backvar = "graph"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "MyStatisticVC") as!  MyStatisticVC
            self.MyStatisticVC = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.MyStatisticVC, close: true)
            
        case 4:
            guard let url = URL(string: "http://www.fuelyourfuture.co.uk") else {
                return
            }
            UIApplication.shared.open(url, options: [:]) { (_) in }
            
        case 5:
            appDelegate.backvar = "static"
            appDelegate.menuvar = "show"
            //  UserDefaults.standard.set(nil, forKey: "fill")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "PersonalInfoVC") as!  PersonalInfoVC
            self.PersonalInfoVC = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.PersonalInfoVC, close: true)
            
        case 6:
            guard let url = URL(string: "https://www.hydro-fuel.co.uk/about") else {
                return
            }
            UIApplication.shared.open(url, options: [:]) { (_) in }
        case 7:
            guard let url = URL(string: "https://itunes.apple.com/us/app/buddyball/id1432543329?ls=1&mt=8") else {
                return
            }
            UIApplication.shared.open(url, options: [:]) { (_) in }
            
        default:
            assertionFailure("Unknown row value, plese update this method")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
