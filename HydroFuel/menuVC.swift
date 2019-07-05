//
//  menuVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class menuVC: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tblview: UITableView!
    @objc var mainViewController: UIViewController!
    @objc var HomeVC: UIViewController!
     @objc var Hostory: UIViewController!
    @objc var AlertVCNew:UIViewController!
    @objc var MyStatisticVC:UIViewController!
    @objc var PersonalInfoVC:UIViewController!
    @objc var HistoryDetail:UIViewController!
    
    var arrayname = ["Home","History","Modify Alerts","My Statistics","Buy","Personal Info","Help & About Us","Rate & Review"]
    var arrayimg = ["homeimg","history","alarm","graph","shoppingcartblack","personal","help","rateandreview"]
     var arrayimgblue = ["homeblue","historyblue","alarm_selected","graphblue","shoppingcartblue","settingblue","help","rateandreview"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblview.separatorStyle = .none
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! menucell
        
        cell.lblname.text = arrayname[indexPath.row]
        cell.imgview.image = UIImage(named:arrayimg[indexPath.row])
        if indexPath.row == 3
        {
             cell.lineview.isHidden = false
        }else{
            cell.lineview.isHidden = true
        }
        
        if appDelegate.menuName ==  arrayname[indexPath.row] {
            cell.lblname.textColor = myColors.bgcolor
            cell.imgview.image = UIImage(named:arrayimgblue[indexPath.row])
        }else {
            cell.lblname.textColor = UIColor.black
            cell.imgview.image = UIImage(named:arrayimg[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! menucell
        appDelegate.menuName = arrayname[indexPath.row]
        tblview.reloadData()
        if indexPath.row == 0
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as!  HomeVC
            self.HomeVC = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.HomeVC, close: true)
        }
        if indexPath.row == 1
        {
             cell.lblname.textColor = UIColor.blue
            appDelegate.backvar = "static"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as!  HistoryVC
            self.Hostory = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.Hostory, close: true)
        }
        if indexPath.row == 2
        {
            
            appDelegate.backvar = "static"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "AlertVCNew") as!  AlertVCNew
            self.AlertVCNew = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.AlertVCNew, close: true)
        }
        if indexPath.row == 3
        {
            
            appDelegate.backvar = "graph"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "MyStatisticVC") as!  MyStatisticVC
            self.MyStatisticVC = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.MyStatisticVC, close: true)
        }
        if indexPath.row == 4
        {
            UIApplication.shared.openURL(NSURL(string: "http://www.fuelyourfuture.co.uk")! as URL)
            
        }
        if indexPath.row == 5
        {
             
            appDelegate.backvar = "static"
           appDelegate.menuvar = "show"
          //  UserDefaults.standard.set(nil, forKey: "fill")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "PersonalInfoVC") as!  PersonalInfoVC
            self.PersonalInfoVC = UINavigationController(rootViewController: HomeVC)
            self.slideMenuController()?.changeMainViewController(self.PersonalInfoVC, close: true)
        }
        if indexPath.row == 6
        {
              UIApplication.shared.openURL(NSURL(string: "https://www.hydro-fuel.co.uk/about")! as URL)
//            appDelegate.backvar = "static"
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HistoryDetail") as!  HistoryDetail
//            self.HistoryDetail = UINavigationController(rootViewController: HomeVC)
//            self.slideMenuController()?.changeMainViewController(self.HistoryDetail, close: true)
        }
        if indexPath.row == 7
        {
            UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/buddyball/id1432543329?ls=1&mt=8")! as URL)
            //            appDelegate.backvar = "static"
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HistoryDetail") as!  HistoryDetail
            //            self.HistoryDetail = UINavigationController(rootViewController: HomeVC)
            //            self.slideMenuController()?.changeMainViewController(self.HistoryDetail, close: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
   

}
