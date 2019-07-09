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
    
    @IBOutlet weak var suggestedWatelVolumeLabel: UILabel!
    
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
    
    var weightCurrentVAle: Int = 0
    
    var maleans = 0
    var ans1 = 0
    
    var user = User()
    
    var value = ""
    var ans = 0
    var num = Int()
    
    var dicdata = NSDictionary()
    var dictPrevious = DataRecordModel.defaultModel()
    var currentShowcase = 0
    var showcase = iShowcase()
    var caluculatedWaterLevelValue = 0
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showcase.delegate = self
        configureWeightSlider()
        
        lblkg.text = "50" + "Kg"
        weightCurrentVAle = 50
        ans = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000) )
        suggestedWatelVolumeLabel.text =  "\(ans)"
        num = getSuggestedWaterLevel()
        suggestedWatelVolumeLabel.text = "\(num)"
        Imgmalegrayline.image = activeMaleImage
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard !UserDefaultsManager.shared.isTutorialShown else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            
            self?.showFirstTutorialView()
        }
    }
    
    private func configureWeightSlider() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        slider.addGestureRecognizer(panGesture)
        slider.isContinuous = true
        slider.setThumbImage(UIImage(named: "round1"), for: .normal)
    }
    
    @IBAction func btnClickedToChangeDailyTarget(_ sender: UIButton) {
        
        var currentAmount = Int(suggestedWatelVolumeLabel.text ?? "0") ?? 0
        if sender.tag == 1{
            //Plus
            currentAmount += 500
        }else{
            //Minus
            currentAmount = max(500, currentAmount-500)
        }
        suggestedWatelVolumeLabel.text = "\(currentAmount)"
        num = currentAmount
        caluculatedWaterLevelValue = currentAmount
        resetValues()
    }
    
    func resetValues() {
        let today = Date().toLocalTime()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: today)
        
        DataManager.shared.resetProgress(self.num)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        appDelegate.badgeCount = 0
        UserDefaultsManager.shared.lastWaterConstraint = 200
        UserDefaultsManager.shared.bottleCount = 1
        UserDefaultsManager.shared.previousDate = strDate
        UserDefaultsManager.shared.lastCountOfAttempt = 0
        UserDefaultsManager.shared.lastDisplayedWaterLevel = 1000
        appDelegate.resettime = "reset"
        
    }
    
    private func caluculateTotalValue() {
        
        lblkg.text = "\(weightCurrentVAle) kg"
        caluculatedWaterLevelValue = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000))
        suggestedWatelVolumeLabel.text = "\(caluculatedWaterLevelValue)"
        
        caluCulateGenderValue(genderText: Gender.male.rawValue, genderRation: 0.5)
        
        guard let activity = Activity(rawValue: user.activityLevel) else {
            assertionFailure("Invalid activity raw value")
            return
        }
        
        guard let gender = Gender(rawValue: user.gender) else {
            assertionFailure("Invalid gender raw value")
            return
        }
        
        ImglineFemale.image = gender == .female ? activeFemaleImage : inActiveFemaleImage
        Imgmalegrayline.image = gender == .female ? inActiveMaleImage : activeMaleImage
        num = getSuggestedWaterLevel()
        
        imglow.image = activity == .low ? selectedLowActImage : unSelectedLowActImage
        imgmedium.image = activity == .medium ? selectedMediumActImage : unSelectedMediumActImage
        imghigh.image = activity == .high ? selectedHighActImage : unSelectedHighActImage
        
        let genderRation: Double
        switch activity {
        case .low:
            genderRation = gender == .male ? 0.5 : 0
            
        case .medium:
            genderRation = gender == .male ? 1 : 0.5
            
        case .high:
            genderRation = gender == .male ? 1.5 : 1
            
        }
        caluCulateGenderValue(genderText: gender.rawValue, genderRation: genderRation)
    }
    
    private func caluCulateGenderValue(genderText: String, genderRation: Double) {
        user.gender = genderText
        suggestedWatelVolumeLabel.text = "\(Int(Double(caluculatedWaterLevelValue) + Double(genderRation) * 1000))"
        num = getSuggestedWaterLevel()
        suggestedWatelVolumeLabel.text = "\(num)"
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        
        let currentPoint = gesture.location(in: slider)
        let percentage = currentPoint.x/slider.bounds.size.width;
        let delta = Float(percentage) * (slider.maximumValue - slider.minimumValue)
        let value1 = slider.minimumValue + delta
        slider.setValue(value1, animated: true)
        if value == "abcd"{
            slider.value = Float(Int(weightCurrentVAle))
            weightCurrentVAle = Int(lblkg.text ?? "0") ?? 0
        }
        else{
            weightCurrentVAle = Int(slider.value)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if UserDefaults.standard.value(forKey: "fill") != nil{
            searchDataForUpdate()
        } else {
            DataManager.shared.write(value: [DataRecordModel.defaultModel()])
        }
        
        
        if user.weight != 0 {
            
            lblkg.text = "\(user.weight)"
            slider.value = Float(user.weight)
            weightCurrentVAle = Int(lblkg.text!)!
            slider.value = Float(weightCurrentVAle)
        }
        //caluculateTotalValue()
        btnmenu.isHidden = appDelegate.isMenuIconHidden
        imgmenu.isHidden = appDelegate.isMenuIconHidden
        
        if appDelegate.isMenuIconHidden == true {
            
        } else {
            appDelegate.isMenuIconHidden = false
        }
        if let WATERQTY = UserDefaults.standard.value(forKey:"MainWaterQuantityKey") as? Int {
            caluculatedWaterLevelValue = (WATERQTY)
            num = WATERQTY
            print(caluculatedWaterLevelValue)
            print(caluculatedWaterLevelValue)
            suggestedWatelVolumeLabel.text = "\(caluculatedWaterLevelValue)"
        }
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
        user.gender = Gender.male.rawValue
        caluculateTotalValue()
    }
    @IBAction func btnselectMale(_ sender: UIButton) {
        user.gender = Gender.male.rawValue
        caluculateTotalValue()
    }
    @IBAction func btnHighClick(_ sender: UIButton) {
        user.activityLevel = Activity.high.rawValue
        caluculateTotalValue()
    }
    
    @IBAction func btnMediumClick(_ sender: UIButton) {
        user.activityLevel = Activity.medium.rawValue
        caluculateTotalValue()
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        user.activityLevel = Activity.low.rawValue
        caluculateTotalValue()
    }
    
    @IBAction func btndone(_ sender: UIButton) {
        guard validation() else {
            return
        }
        let alertController = UIAlertController(title: nil, message: "Details Successfully Updated", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { [unowned self] (result) -> Void in
            
            let lblanss: Int = self.num / 10
            
            UserDefaults.standard.set(lblanss, forKey: "lblml")
            UserDefaults.standard.set(1, forKey: "fill")
            UserDefaults.standard.set(self.num, forKey: "MainWaterQuantityKey")
            
            let today = Date().toLocalTime()
            
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
            let strDate = self.dateFormatter.string(from: today)
            let data = DataRecordModel(activity: self.user.activityLevel, date: strDate,
                                       gender: self.user.gender, remainingWater: self.num,
                                       totalDrink: 0, totalAttempt: 0, waterQuantity: self.num,
                                       waterPerAttempt: lblanss, weight: self.weightCurrentVAle)
            
            if self.dictPrevious == DataRecordModel.defaultModel() {
                
                self.insertData(data)
            }else{
                
                data.totalDrink = lblanss * self.dictPrevious.totalDrink
                data.remainingWaterQuantity = self.num - (lblanss * self.dictPrevious.totalDrink)
                self.updateData(data)
            }
            
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
    
    // MARK: - SQL Database Handler
    
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
        dictPrevious = lastRecord
    }
    
    
    private func getSuggestedWaterLevel() -> Int {
        
        return Int(suggestedWatelVolumeLabel.text!)!
    }
    
    @IBAction func btnutctime(_ sender: UIButton) {
        self.appDelegate.timeselect = "yes"
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
