//
//  PersonalInfoVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import iShowcase
import CTShowcase

final class PersonalInfoVC: UIViewController {
    
    @IBOutlet private weak var btnMinus: UIButton!
    @IBOutlet private weak var btnPlus: UIButton!
    @IBOutlet private weak var imgmenu: UIImageView!
    @IBOutlet private weak var btnmenu: UIButton!
    
    @IBOutlet private weak var suggestedWatelVolumeLabel: UILabel!
    
    @IBOutlet private weak var imghigh: UIImageView!
    @IBOutlet private weak var imgmedium: UIImageView!
    @IBOutlet private weak var imglow: UIImageView!
    
    @IBOutlet private weak var btnfemale: UIButton!
    @IBOutlet private weak var btnmale: UIButton!
    
    @IBOutlet private weak var ImglineFemale: UIImageView!
    @IBOutlet private weak var Imgmalegrayline: UIImageView!
    
    @IBOutlet private weak var lblkg: UILabel!
    @IBOutlet private weak var slider: UISlider!
    
    private let activeFemaleImage = R.image.femalebuttonblue()
    private let inActiveFemaleImage = R.image.femalebuttonblack()
    
    private let activeMaleImage = R.image.malebuttonblue()
    private let inActiveMaleImage = R.image.malebuttonblack()
    
    private let selectedLowActImage = R.image.standingbuttonblue()
    private let unSelectedLowActImage = R.image.standingbuttonblack()
    private let selectedMediumActImage = R.image.walkingbuttonblue()
    private let unSelectedMediumActImage = R.image.walkingbuttonblue()
    private let selectedHighActImage = R.image.runningbuttonblue()
    private let unSelectedHighActImage = R.image.runningbuttonblack()
    
    private var user = DataManager.shared.currentUser ?? User.defaultUserModel()
    private var tmpUserModel = User.defaultUserModel()
    
    private var currentShowcase = 0
    private var showcase = iShowcase()
    
    private let dateFormatter = DateFormatter()
    
    // Default water level calculation formula (Int(Double(weightCurrentVAle) * Double(0.033) * 1000) )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showcase.delegate = self
        configureWeightSlider()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        btnmenu.isHidden = appDelegate.isMenuIconHidden
        imgmenu.isHidden = appDelegate.isMenuIconHidden
        updateDisplayedUserData()
        searchDataForUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !UserDefaultsManager.shared.isTutorialShown else {
            return
        }
        showFirstTutorialView()
    }
    
    private func configureWeightSlider() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        slider.addGestureRecognizer(panGesture)
        slider.isContinuous = true
        slider.setThumbImage(UIImage(named: "round1"), for: .normal)
    }
    
    private func updateDisplayedUserData() {
        
        lblkg.text = "\(user.weight) Kg"
        guard let gender = Gender(rawValue: user.gender),
            let activity = Activity(rawValue: user.activityLevel) else {
                assertionFailure("Unable to get user gender or activity")
            return
        }
        ImglineFemale.image = gender == .female ? activeFemaleImage : inActiveFemaleImage
        Imgmalegrayline.image = gender == .female ? inActiveMaleImage : activeMaleImage
        
        imglow.image = activity == .low ? selectedLowActImage : unSelectedLowActImage
        imgmedium.image = activity == .medium ? selectedMediumActImage : unSelectedMediumActImage
        imghigh.image = activity == .high ? selectedHighActImage : unSelectedHighActImage
        
        let genderRation: Double
        switch activity {
        case .low:
            genderRation = gender == .male ? 0.5 : 0.4
            
        case .medium:
            genderRation = gender == .male ? 0.6 : 0.5
            
        case .high:
            genderRation = gender == .male ? 0.7 : 0.6
        }
        
        guard let currentWaterLevel = Int(suggestedWatelVolumeLabel.text!) else {
            assertionFailure("Unable to get current water level")
            return
        }
        let newWaterLevel = Int(Double(slider.value) * Double(genderRation) * 100)
        guard abs(newWaterLevel - currentWaterLevel) > 500 else {
            return
        }
        suggestedWatelVolumeLabel.text = "\(newWaterLevel)"
    }
    
    @IBAction func didTapSuggestedWaterButton(_ sender: UIButton) {
        var currentAmount = Int(suggestedWatelVolumeLabel.text ?? "0") ?? 0
        if sender.tag == 1{
            //Plus
            currentAmount += 500
        }else{
            //Minus
            currentAmount = max(500, currentAmount-500)
        }
        suggestedWatelVolumeLabel.text = "\(currentAmount)"
        resetValues()
    }
    
    private func resetValues() {
        
        DataManager.shared.resetProgress(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
        appDelegate.badgeCount = 0
        appDelegate.resettime = "reset"
        
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        
        let currentPoint = gesture.location(in: slider)
        let percentage = currentPoint.x/slider.bounds.size.width;
        let delta = Float(percentage) * (slider.maximumValue - slider.minimumValue)
        let value = slider.minimumValue + delta
        slider.setValue(value, animated: true)
        user.weight = Int(value)
        updateDisplayedUserData()
    }
    
    private func validation() -> Bool {
        
        let inputData = [lblkg.text!, user.gender, user.activityLevel]
        let errorMessages = ["Please Choose Weight", "Please Choose Gender", "Please Choose Activity Level"]
        
        for (index, data) in inputData.enumerated() {
            if data.isEmpty {
                showMyAlert(messageIs: errorMessages[index])
                return false
            }
        }
        return true
    }
    
    @IBAction func btnFemale(_ sender: UIButton) {
        user.gender = Gender.female.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btnselectMale(_ sender: UIButton) {
        user.gender = Gender.male.rawValue
        updateDisplayedUserData()
    }
    @IBAction func btnHighClick(_ sender: UIButton) {
        user.activityLevel = Activity.high.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btnMediumClick(_ sender: UIButton) {
        user.activityLevel = Activity.medium.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        user.activityLevel = Activity.low.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btndone(_ sender: UIButton) {
        guard validation() else {
            return
        }
        let alertController = UIAlertController(title: nil, message: "Details Successfully Updated", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { [unowned self] (result) -> Void in
            
            let today = Date().toLocalTime()
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
            let strDate = self.dateFormatter.string(from: today)
            
            guard let waterLevel = Int(self.suggestedWatelVolumeLabel.text!) else {
                assertionFailure("Unable to get water level")
                return
            }
            let data = DataRecordModel(activity: self.user.activityLevel, date: strDate,
                                       gender: self.user.gender, remainingWater: waterLevel,
                                       totalDrink: 0, totalAttempt: 0, waterQuantity: waterLevel,
                                       waterPerAttempt: waterLevel / 10, weight: Int(self.slider.value))
            
                
//                self.insertData(data)
//
//                data.totalDrink = lblanss * self.dictPrevious.totalDrink
//                data.remainingWaterQuantity = self.num - (lblanss * self.dictPrevious.totalDrink)
//                self.updateData(data)
            
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        btnmenu.isHidden = appDelegate.isMenuIconHidden
        imgmenu.isHidden = appDelegate.isMenuIconHidden
        
        guard appDelegate.isMenuIconHidden else {
            appDelegate.isMenuIconHidden = false
            toggleLeft()
            return
        }
        toggleRight()
    }
    
    @IBAction func btnutctime(_ sender: UIButton) {
        self.appDelegate.timeselect = "yes"
    }
    
    private func insertData(_ data: DataRecordModel) -> Void {
        
        DataManager.shared.write(value: [data])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AlertVCNew") as? AlertVCNew else {
            assertionFailure("Unable to instantiateViewController")
            return
        }
        appDelegate.resettime = "reset"
        navigationController!.pushViewController(vc, animated: true)
        
    }
    
    private func updateData(_ data: DataRecordModel) {
        
        DataManager.shared.update(value: [data])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {
            assertionFailure("Unable to instantiateViewController")
            return
        }
        navigationController!.pushViewController(vc, animated: true)
    }
    
    private func searchDataForUpdate() {
        
        let today = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: today)
        let records = DataManager.shared.selectAllByDate(strDate)
        guard let lastRecord = records.first else {
            return
        }
    }
    
}

// MARK: - iShowcaseDelegate
extension PersonalInfoVC: iShowcaseDelegate {
    
    func iShowcaseShown(_ showcase: iShowcase) {
        currentShowcase += 1
    }
    
    private func showFirstTutorialView() {
        
        showcase.detailsLabel.text = " "
        showcase.titleLabel.font = UIFont.avenirMedium17
        
        showcase.setupShowcaseForView(self.lblkg)
        showcase.titleLabel.text = Localizable.personalInfoTutorialFirstStep()
        
        showcase.show()
    }
    
    func iShowcaseDismissed(_ showcase: iShowcase) {
        
        switch currentShowcase {
        case 1:
            self.showcase.setupShowcaseForView(self.btnmale)
            self.showcase.titleLabel.text = Localizable.personalInfoTutorialSecondStep()
            self.showcase.show()
            
        case 2:
            self.showcase.setupShowcaseForView(self.imgmedium)
            self.showcase.titleLabel.text = Localizable.personalInfoTutorialThirdStep()
            self.showcase.show()
            
        case 3:
            self.showcase.setupShowcaseForView(self.suggestedWatelVolumeLabel)
            self.showcase.titleLabel.text = Localizable.personalInfoTutorialFourthStep()
            self.showcase.show()
            
        default:
            break
        }
        
    }
    
}
