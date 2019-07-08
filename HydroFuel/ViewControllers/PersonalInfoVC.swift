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
    
    var weightCurrentVAle = Int(){
        didSet{
            caluculateTotalValue()
        }
    }
    
    @IBOutlet private weak var btnMinus: UIButton!
    @IBOutlet private weak var btnPlus: UIButton!
    @IBOutlet private weak var imgmenu: UIImageView!
    @IBOutlet private weak var btnmenu: UIButton!
    
    @IBOutlet private weak var lblwaterml: UILabel!
    
    @IBOutlet private weak var imghigh: UIImageView!
    @IBOutlet private weak var imgmedium: UIImageView!
    @IBOutlet private weak var imglow: UIImageView!
    
    @IBOutlet private weak var btnfemale: UIButton!
    @IBOutlet private weak var btnmale: UIButton!
    
    @IBOutlet private weak var ImglineFemale: UIImageView!
    @IBOutlet private weak var Imgmalegrayline: UIImageView!
    
    @IBOutlet private weak var lblkg: UILabel!
    @IBOutlet private weak var slider: UISlider!
    
    private let activeFemaleImage = UIImage(named: "femalebuttonblue")
    private let inActiveFemaleImage = UIImage(named: "femalebuttonblack")
    
    private let activeMaleImage = UIImage(named: "malebuttonblue")
    private let inActiveMaleImage = UIImage(named: "malebuttonblack")

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
        DBManager.shared.createDB()
        
        showcase.delegate = self
        configureWeightSlider()

        lblkg.text = "50" + "Kg"
        weightCurrentVAle = 50
        ans = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000) )
        lblwaterml.text =  "\(ans)"
        num = getSuggestedWaterLevel()
        lblwaterml.text = "\(num)" + " " + "ml"
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
        
        var currentAmount = Int((lblwaterml.text ?? "0").replacingOccurrences(of: " ml", with: "")) ?? 0
        if sender.tag == 1{
            //Plus
            currentAmount += 500
        }else{
            //Minus
            currentAmount = max(500, currentAmount-500)
        }
        lblwaterml.text = "\(currentAmount)"
        num = currentAmount
        lblwaterml.text = "\(currentAmount)" + " ml"
        caluculatedWaterLevelValue = currentAmount
        resetValues()
    }
    
    func resetValues() {
        let today = Date().toLocalTime()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        let strURL = "update HYDROFUELPERSINFO set REMAININGWATERQTY='\(self.num)', TOTALDRINK='\(0)',TOTALATTEMPT='\(0)' where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.updateTable(strURL)
        print(data)
        if data.status == 1 {
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            UserDefaultsManager.shared.lastWaterConstraint = 200
            UserDefaultsManager.shared.bottleCount = 1
            UserDefaultsManager.shared.previousDate = strDate
            UserDefaultsManager.shared.lastCountOfAttempt = 0
            UserDefaultsManager.shared.lastDisplayedWaterLevel = 1000
            appDelegate.resettime = "reset"
        }
    }
    
    private func caluculateTotalValue() {
        
        lblkg.text = "\(weightCurrentVAle) kg"
        caluculatedWaterLevelValue = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000))
        lblwaterml.text = "\(caluculatedWaterLevelValue)"
        num = getSuggestedWaterLevel()
        lblwaterml.text = "\(num)" + " " + "ml"
        lblwaterml.text = "\(caluculatedWaterLevelValue)"  + " " + "ml"
        
        switch user.activityLevel {
      
        case .some(let activity):
            
            switch user.gender {
            case .some(let gender):
                
                ImglineFemale.image = gender == .female ? activeFemaleImage : inActiveFemaleImage
                Imgmalegrayline.image = gender == .female ? inActiveMaleImage : activeMaleImage
                num = getSuggestedWaterLevel()
                
                imglow.image = activity == .low ? UIImage(named: "standingbuttonblue") : UIImage(named: "standingbuttonblack")
                imgmedium.image = activity == .medium ? UIImage(named: "walkingbuttonblue") : UIImage(named: "walkingbuttonblack")
                imghigh.image = activity == .high ? UIImage(named: "runningbuttonblue") : UIImage(named: "runningbuttonblack")
                
                switch activity {
                    
                case .low:

                    let genderRation = gender == .male ? 0.5 : 0
                    caluCulateGenderValue(genderText: gender.rawValue, genderRation: genderRation)
                    
                case .medium:
                    
                    let genderRation = gender == .male ? 1 : 0.5
                    caluCulateGenderValue(genderText: gender.rawValue, genderRation: genderRation)
                    
                case .high:
                    
                    let genderRation = gender == .male ? 1.5 : 1
                    caluCulateGenderValue(genderText: gender.rawValue, genderRation: genderRation)
                }
                
            case .none:
                caluCulateGenderValue(genderText: Gender.male.rawValue, genderRation: 0.5)
            }
            
        case .none:
            caluCulateGenderValue(genderText: Gender.male.rawValue, genderRation: 0.5)
        }
    }
    
    private func caluCulateGenderValue(genderText: String, genderRation: Double) {
        user.gender = Gender(rawValue: genderText)
        lblwaterml.text = "\(Int(Double(caluculatedWaterLevelValue) + Double(genderRation) * 1000))"
        num = getSuggestedWaterLevel()
        lblwaterml.text = "\(num)"  + " " + "ml"
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        let currentPoint = gesture.location(in: slider)
        let percentage = currentPoint.x/slider.bounds.size.width;
        let delta = Float(percentage) *  (slider.maximumValue - slider.minimumValue)
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
        if UserDefaults.standard.value(forKey: "fill") != nil{
            searchDataForUpdate()
        }else{
            let tempDate = "2000-12-31"
            DBManager.shared.firstInsertData(date: tempDate, weight: 0, gender: "Male", activityLevel: "Low", waterQty: 0, remainingWaterQty: 0, totalDrink: 0, totalAttempt: 0, waterQtyPerAttempt: 0)
        }

        
        if let userObj2 = UserDefaultsManager.shared.userWeight {
            
            lblkg.text = String(describing: userObj2)
            slider.value = Float(userObj2)
            weightCurrentVAle = Int(lblkg.text!)!
            slider.value = Float(weightCurrentVAle)
        }
        caluculateTotalValue()
        if appDelegate.menuvar == "hide"
        {
            btnmenu.isHidden = true
            imgmenu.isHidden = true
        }
        else{
            appDelegate.menuvar = "show"
            btnmenu.isHidden = false
            imgmenu.isHidden = false
        }
        if let WATERQTY = UserDefaults.standard.value(forKey:"MainWaterQuantityKey") as? Int {
            caluculatedWaterLevelValue = (WATERQTY)
            num = WATERQTY
            print(caluculatedWaterLevelValue)
            print(caluculatedWaterLevelValue)
            lblwaterml.text = "\(caluculatedWaterLevelValue)"  + " " + "ml"
        }
    }
    
    private func validation() -> Bool {
        
        let inputData = [lblkg.text!, user.gender?.rawValue ?? "", user.activityLevel?.rawValue ?? ""]
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
        user.gender = .female
        caluculateTotalValue()
    }
    @IBAction func btnselectMale(_ sender: UIButton) {
        user.gender = .male
        caluculateTotalValue()
    }
    @IBAction func btnHighClick(_ sender: UIButton) {
        user.activityLevel = .high
        caluculateTotalValue()
    }
    
    @IBAction func btnMediumClick(_ sender: UIButton) {
        user.activityLevel = .medium
        caluculateTotalValue()
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        user.activityLevel = .low
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
            UserDefaultsManager.shared.userGender = self.user.gender?.rawValue ?? ""
            UserDefaultsManager.shared.userActivityLevel = self.user.activityLevel?.rawValue ?? ""
            UserDefaultsManager.shared.userWeight = self.user.weight
            UserDefaults.standard.set(1, forKey: "fill")
            UserDefaults.standard.set(self.num, forKey: "MainWaterQuantityKey")
            if self.dictPrevious == DataRecordModel.defaultModel() {
                
                let today = Date().toLocalTime()
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
                let strDate = self.dateFormatter.string(from: today)
                
                self.insertData(DATE: strDate, WEIGHT: self.weightCurrentVAle, GENDER: self.user.gender?.rawValue ?? "", ACTIVITYLAVEL: self.user.activityLevel?.rawValue ?? "", WATERQTY: self.num, REMAININGWATERQTY: self.num, TOTALDRINK: 0, TOTALATTEMPT: 0, WATERQTYPERATTEMPT: lblanss)
            }else{
                
                let totalDrinksCount = self.dictPrevious.totalDrink
                
                let totalDrinkWater = lblanss*totalDrinksCount
                let remainingWaterQty = self.num - totalDrinkWater
                
                self.updateData(WEIGHT: self.weightCurrentVAle, GENDER: self.user.gender?.rawValue ?? "", ACTIVITYLAVEL: self.user.activityLevel?.rawValue ?? "", WATERQTY: self.num, REMAININGWATERQTY: remainingWaterQty, TOTALDRINK: totalDrinksCount, WATERQTYPERATTEMPT: lblanss)
            }
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        let isButtonsHidden = appDelegate.menuvar == "hide"
        btnmenu.isHidden = isButtonsHidden
        imgmenu.isHidden = isButtonsHidden
        
        if appDelegate.menuvar == "hide" {
            self.toggleRight()
        } else {
            appDelegate.menuvar = "show"
            self.toggleLeft()
        }
    }
    
    // MARK: - SQL Database Handler
    
    private func insertData(DATE: String, WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, TOTALATTEMPT: Int, WATERQTYPERATTEMPT: Int) -> Void {
        
        let result = DBManager.shared.insertData(date: DATE, weight: WEIGHT, gender: GENDER, activityLevel: ACTIVITYLAVEL, waterQty: WATERQTY, remainingWaterQty: REMAININGWATERQTY, totalDrink: TOTALDRINK, totalAttempt: TOTALATTEMPT, waterQtyPerAttempt: WATERQTYPERATTEMPT)
        
        guard result.status == 1 else {
            assertionFailure("\(result.failure)")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlertVCNew") as? AlertVCNew
        appDelegate.resettime = "reset"
        navigationController!.pushViewController(vc!, animated: true)
        
    }
    
    private func updateData(WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, WATERQTYPERATTEMPT: Int){
        
        let result = DBManager.shared.updateData(weight: WEIGHT, gender: GENDER, activityLevel: ACTIVITYLAVEL, waterQty: WATERQTY, remainingWaterQty: REMAININGWATERQTY, totalDrink: TOTALDRINK, waterQtyPerAttempt: WATERQTYPERATTEMPT)
        
        guard result.status == 1 else {
            assertionFailure("\(result.failure)")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        navigationController!.pushViewController(vc!, animated: true)
    }
    
    private func searchDataForUpdate() {
        
        let today = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: today)
        let data = DBManager.shared.selectAllByDate(strDate)
        
        guard data.status == 1  else {
            assertionFailure("\(data.failure)")
            return
        }
        let arrLocalData = data.arrData
        dictPrevious = arrLocalData[0]
    }
    
    
    private func getSuggestedWaterLevel() -> Int {
        
        return Int(lblwaterml.text!)!
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
        showcase.titleLabel.text = "To work out your daily water intake goal please Select Your Weight"
        
        showcase.show()
    }
    
    func iShowcaseDismissed(_ showcase: iShowcase) {
        
        switch currentShowcase {
        case 1:
            self.showcase.setupShowcaseForView(self.btnmale)
            self.showcase.titleLabel.text = "Select your Gender"
            self.showcase.show()
            
        case 2:
            self.showcase.setupShowcaseForView(self.imgmedium)
            self.showcase.titleLabel.text = "Select your Activity level"
            self.showcase.show()
            
        case 3:
            self.showcase.setupShowcaseForView(self.lblwaterml)
            self.showcase.titleLabel.text = "This is your suggested daily water intake"
            self.showcase.show()
            
        default:
            break
        }
        
    }
    
}
