

//
//  HomeVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import iShowcase
import CTShowcase
import StoreKit

final class HomeVC: UIViewController, AppStoreOpenable {
    
    @IBOutlet private weak var conBottomWater: NSLayoutConstraint!
    @IBOutlet private weak var demowaterlevel: UILabel!
    @IBOutlet private weak var lblBottleCount: UILabel!
    @IBOutlet private weak var viewOuter: UIView!
    @IBOutlet private weak var conTopBlueBG: NSLayoutConstraint!
    
    @IBOutlet private weak var conImgTrailing: NSLayoutConstraint!
    @IBOutlet private weak var conHeightWaterLeval: NSLayoutConstraint!
    
    @IBOutlet private weak var conImgLeading: NSLayoutConstraint!
    
    @IBOutlet private weak var lblWaterToDrink: UILabel!
    @IBOutlet private weak var fartuMarkerView: UIView!
    @IBOutlet private weak var lblWaterLavel: UILabel!
    
    @IBOutlet private weak var notifMarkerView: UIView!
    @IBOutlet private weak var lblNotifWaterLavel: UILabel!
    @IBOutlet private weak var conTopNotifMarker: NSLayoutConstraint!
    
    @IBOutlet private weak var notificationvideDomo: UIView!
    @IBOutlet private weak var btnReset: UIButton!
    @IBOutlet private weak var btnHydrate: UIButton!
    @IBOutlet private weak var conBottomTab: NSLayoutConstraint!
    
    @IBOutlet private weak var conTopBottleCount: NSLayoutConstraint!
    @IBOutlet private weak var imgBottle: UIImageView!
    @IBOutlet private weak var conTopvideoMarker: NSLayoutConstraint!
    
    var currentShowcase = 0
    var showcase = iShowcase()
    
    let viewModel = HomeVCViewModel()
    
    // MARK: Life-cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showcase.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(NotifArrives), name: NSNotification.Name(rawValue: "NotifArrives"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard !UserDefaultsManager.shared.isTutorialShown else {
            notificationvideDomo.isHidden = true
            notifMarkerView.isHidden = false
            fartuMarkerView.isHidden = false
            return
        }
        showFirstTutorialView()
        searchDataForUpdate()
        showData()
    }
    
    @objc func NotifArrives() {

    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        self.toggleLeft()
    }
    
    
    @IBAction func btnstatisticclick(_ sender: UIButton) {
        appDelegate.backvar = "abc"
        self.navigationController?.pushViewController(AppRouter.createMyStatisticVC(), animated: true)
    }
    
    @IBAction func btnHistoryclick(_ sender: UIButton) {
        appDelegate.backvar = "abc"
        self.navigationController?.pushViewController(AppRouter.createHistoryVC(), animated: true)
    }
    
    @IBAction func btnHelpclick(_ sender: UIButton) {
        
        guard let url = URL(string: "https://www.hydro-fuel.co.uk/support") else {
            return
        }
        UIApplication.shared.open(url, options: [:]) { (_) in
            
        }
    }
    
    @IBAction func btnRateusclick(_ sender: UIButton) {
        
        let storeVC = SKStoreProductViewController()
        storeVC.delegate = self
        viewProductAtAppStore(storeVC: storeVC)
    }
    
    
    @IBAction func btnReseatClick(_ sender: UIButton) {
        
        AlertPresenter.showResetAlert(at: self) { [weak self] in
            self?.resetData()
        }        
    }
    
    
    @IBAction func btnHydrateClick(_ sender: UIButton) {
        guard appDelegate.badgeCount > 0 else {
            return
        }
        UIApplication.shared.beginIgnoringInteractionEvents()
        btnHydrate.isUserInteractionEnabled = false
        let totalDrink = appDelegate.badgeCount - viewModel.lastCountOfAttempt
        
        let remainingWaterQty = viewModel.currentModel.remainingWaterQuantity - (totalDrink * viewModel.currentModel.waterPerAttempt)
        
        self.lblWaterToDrink.text = "\(remainingWaterQty)ml"
        
        self.lblBottleCount.text = "Bottle \(viewModel.bottleCount) of \(viewModel.tottleBottle)"
        
        self.lblWaterLavel.text = "\(0)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.changeStatus()
        }
        viewModel.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeStatus), userInfo: nil, repeats: true)
    }
    
    @objc func changeStatus() {
        // TODO: water level animation should be here
    }
    
    
    func searchDataForUpdate() {
        
        let strDate = Date.currentDateToString()
        
        let data = DataManager.shared.selectAllByDate(strDate)
        viewModel.previousModel = data.first
        
        let floatData = Double(viewModel.currentModel.waterQuantity)/1000.0
        let intData = Double(viewModel.currentModel.waterQuantity/1000)
        if intData < floatData {
            viewModel.tottleBottle = (viewModel.currentModel.waterQuantity/1000) + 1
        }else{
            viewModel.tottleBottle = (viewModel.currentModel.waterQuantity/1000)
        }
        
        viewModel.currentModel.remainingWaterQuantity = viewModel.previousModel.remainingWaterQuantity
        viewModel.currentModel.totalDrink = viewModel.previousModel.totalDrink
        viewModel.currentModel.totalAttempt = viewModel.previousModel.totalAttempt
        viewModel.currentModel.waterPerAttempt = viewModel.previousModel.waterPerAttempt
        let remainingWaterQty = viewModel.currentModel.remainingWaterQuantity - (viewModel.currentModel.totalDrink * viewModel.currentModel.waterPerAttempt)
        self.lblWaterToDrink.text = "\(remainingWaterQty)ml"
    }
    
    func updateData(remainingWaterQty: Int, totalAttempt: Int) {
        
        let strDate = Date.currentDateToString()

        DataManager.shared.updateAllByDate(strDate: strDate,
                                           remainingWaterQuantity: remainingWaterQty, totalAttepmt: totalAttempt)
        searchDataForUpdate()
    }
    
    func insertData(_ data: DataRecordModel) -> Void {
        
        DataManager.shared.write(value: [data])
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        appDelegate.badgeCount = 0
        viewModel.lastCountOfAttempt = 0
        viewModel.bottleCount = 1
        viewModel.prevWaterLeval = viewOuter.frame.size.height
        conHeightWaterLeval.constant = viewOuter.frame.size.height
        
        lblBottleCount.text = "Bottle \(viewModel.bottleCount) of \(viewModel.tottleBottle)"
        notifMarkerView.isHidden = true
        lblWaterLavel.text = "\(1000)"
        
        lblNotifWaterLavel.text = ""
        conTopNotifMarker.constant = -15
        appDelegate.resettime = "reset"
        
        searchDataForUpdate()
    }
    
    func showData() {
        
        let strDate = Date.currentDateToString()
        let data = DataManager.shared.readAll(object: DataRecordModel.self)
        
        viewModel.previousModel = data.last
    
        let floatData = Double(viewModel.previousModel.waterQuantity)/1000.0
        let intData = Double(viewModel.previousModel.waterQuantity/1000)
        if intData < floatData {
            viewModel.tottleBottle = (viewModel.previousModel.waterQuantity/1000) + 1
        } else {
            viewModel.tottleBottle = (viewModel.previousModel.waterQuantity/1000)
        }

        let dataModel = DataRecordModel(activity: viewModel.previousModel.activityLevel, date: strDate,
                                        gender: viewModel.previousModel.gender, remainingWater: viewModel.previousModel.waterQuantity, totalDrink: 0, totalAttempt: 0, waterQuantity: viewModel.previousModel.waterQuantity, waterPerAttempt: viewModel.previousModel.waterPerAttempt, weight: viewModel.previousModel.weight)
        self.insertData(dataModel)
    }
    
    func resetData() {
        
        DataManager.shared.resetProgress(viewModel.currentModel.waterQuantity)
        
        btnHydrate.backgroundColor = UIColor.disableColour
        
        appDelegate.badgeCount = 0
        viewModel.lastCountOfAttempt = 0
        viewModel.bottleCount = 1
        viewModel.prevWaterLeval = viewOuter.frame.size.height
        
        conHeightWaterLeval.constant = viewOuter.frame.size.height
        
        lblBottleCount.text = "Bottle \(viewModel.bottleCount) of \(viewModel.tottleBottle)"
        notifMarkerView.isHidden = true
        lblWaterLavel.text = "\(1000)"
        
        lblNotifWaterLavel.text = ""
        conTopNotifMarker.constant = -15
        appDelegate.resettime = "reset"
        searchDataForUpdate()
    }
    
}

// MARK: - iShowcaseDelegate
extension HomeVC: iShowcaseDelegate {
    
    func iShowcaseShown(_ showcase: iShowcase) {
        currentShowcase += 1
    }
    
    private func showFirstTutorialView() {
        
        notificationvideDomo.isHidden = false
        showcase.setupShowcaseForView(lblWaterLavel)
        showcase.titleLabel.text = Localizable.homeTutorialFirstStep()
        showcase.titleLabel.font = UIFont.avenirMedium17
        showcase.detailsLabel.text = "\n"
        showcase.show()
    }
    
    func iShowcaseDismissed(_ showcase: iShowcase) {
        
        switch currentShowcase {
        case 1:
            self.showcase.setupShowcaseForView(self.demowaterlevel)
            self.showcase.titleLabel.text = Localizable.homeTutorialSecondStep()
            self.showcase.show()
            
        case 2:
            self.notificationvideDomo.isHidden = true
            self.showcase.setupShowcaseForView(self.btnHydrate)
            self.showcase.titleLabel.text = Localizable.homeTutorialThirdStep()
            self.showcase.show()
            
        case 3:
            self.showcase.setupShowcaseForView(self.btnReset)
            self.showcase.titleLabel.text = Localizable.homeTutorialFourthStep()
            self.showcase.show()
            
        case 4:
            self.showcase.setupShowcaseForView(self.imgBottle)
            self.showcase.titleLabel.text = Localizable.homeTutorialFifthStep()
            self.showcase.show()
            
        default:
            UserDefaultsManager.shared.isTutorialShown = true
            print("Default")
            //checkForAutoNotif()
            
        }
    }
    
}

// MARK: - SKStoreProductViewControllerDelegate
extension HomeVC: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
