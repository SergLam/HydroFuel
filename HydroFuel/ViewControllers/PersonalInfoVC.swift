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
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet var imgmenu: UIImageView!
    @IBOutlet var btnmenu: UIButton!
    @IBOutlet var lblwaterml: UILabel!
    @IBOutlet var imghigh: UIImageView!
    @IBOutlet var imgmedium: UIImageView!
    @IBOutlet var imglow: UIImageView!
    @IBOutlet var btnfemale: UIButton!
    @IBOutlet var btnmale: UIButton!
    @IBOutlet var ImglineFemale: UIImageView!
    @IBOutlet var Imgmalegrayline: UIImageView!
    @IBOutlet var lblkg: UILabel!
    
    var maleans = 0
    var ans1 = 0
    var gander = ""
    var activity = ""
    var value = ""
    var ans = 0
    var lblvalue = Int()
    var num = Int()
    
    @IBOutlet var slider: UISlider!
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
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        self.slider.addGestureRecognizer(panGesture)
        lblkg.text = "50" + "Kg"
        weightCurrentVAle = 50
        ans = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000) )
        lblwaterml.text =  "\(ans)"
        num = getSuggestedWaterLevel()
        lblwaterml.text = "\(num)" + " " + "ml"
        
        self.navigationController?.navigationBar.isHidden = true
        slider.setThumbImage(UIImage(named: "round1"), for: .normal)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        slider.isContinuous = true
        btnPlus.layer.cornerRadius = btnPlus.frame.height / 2
        btnPlus.clipsToBounds = true
        btnMinus.layer.cornerRadius = btnMinus.frame.height / 2
        btnMinus.clipsToBounds = true
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
    
    func caluculateTotalValue(){
        lblkg.text = "\(weightCurrentVAle) kg"
        caluculatedWaterLevelValue = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000))
        lblwaterml.text = "\(caluculatedWaterLevelValue)"
        num = getSuggestedWaterLevel()
        lblwaterml.text = "\(num)" + " " + "ml"
        if gander == "female"{
            ImglineFemale.image = UIImage(named: "femalebuttonblue")
            Imgmalegrayline.image = UIImage(named: "malebuttonblack")
        }else{
            ImglineFemale.image = UIImage(named: "femalebuttonblack")
            Imgmalegrayline.image = UIImage(named: "malebuttonblue")
        }
        lblwaterml.text = "\(caluculatedWaterLevelValue)"  + " " + "ml"
        if activity == "low"
        {
            if gander == "female"
            {
                caluCulateGenderValue(genderText: "female", genderRation: 0)
            }
            else
            {
                caluCulateGenderValue(genderText: "male", genderRation: 0.5)
            }
        }
        else if activity == "medium"
        {
            if gander == "female"
            {
                caluCulateGenderValue(genderText: "female", genderRation: 0.5)
            }
            else
            {
                caluCulateGenderValue(genderText: "male", genderRation: 1)
            }
        }
        else if activity == "high"{
            if gander == "female"
            {
                caluCulateGenderValue(genderText: "female", genderRation: 1)
            }
            else
            {
                caluCulateGenderValue(genderText: "male", genderRation: 1.5)
            }
        }else{
            caluCulateGenderValue(genderText: "male", genderRation: 0.5)
        }
        if activity == "high"{
            imghigh.image = UIImage(named: "runningbuttonblue")
            imglow.image = UIImage(named: "standingbuttonblack")
            imgmedium.image = UIImage(named: "walkingbuttonblack")
            if gander == "female"
            {
                lblwaterml.text = "\(Int(Double(caluculatedWaterLevelValue) + Double(1) * 1000))"
                num = getSuggestedWaterLevel()
                lblwaterml.text = "\(num)" + " " + "ml"
            }
            else
            {
                lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(1.5) * 1000))"
                num = getSuggestedWaterLevel()
                lblwaterml.text = "\(num)"  + " " + "ml"
            }
        }else if  activity == "medium"{
            imghigh.image = UIImage(named: "runningbuttonblack")
            imglow.image = UIImage(named: "standingbuttonblack")
            imgmedium.image = UIImage(named: "walkingbuttonblue")
            if gander == "female"
            {
                lblwaterml.text = "\(Int(Double(caluculatedWaterLevelValue) + Double(0.5) * 1000))"
                num = getSuggestedWaterLevel()
                lblwaterml.text = "\(num)" + " " + "ml"
            }
            else
            {
                // let num =  Int(Double(maleans) + Double(0.5) * 1000)
                lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(1) * 1000))"
                num = getSuggestedWaterLevel()
                lblwaterml.text = "\(num)" + " " + "ml"
            }
        }else if activity == "low"{
            imghigh.image = UIImage(named: "runningbuttonblack")
            imglow.image = UIImage(named: "standingbuttonblue")
            imgmedium.image = UIImage(named: "walkingbuttonblack")
            if gander == "female"
            {
                lblwaterml.text = "\(caluculatedWaterLevelValue)"
                num = getSuggestedWaterLevel()
                lblwaterml.text = "\(num)" + " " + "ml"
                
            }
            else
            {
                lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(0.5) * 1000))"
                num = getSuggestedWaterLevel()
                lblwaterml.text = "\(num)"  + " " + "ml"
                print(num)
            }
        }
    }
    
    private func caluCulateGenderValue(genderText: String, genderRation: Double) {
        gander = genderText
        lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(genderRation) * 1000))"
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
        if UserDefaultsManager.shared.userGender != nil {
            
            let userObj = UserDefaultsManager.shared.userGender!
            gander = userObj
        }
        if UserDefaultsManager.shared.userActivityLevel != nil {
            
            let  userObj1 = UserDefaultsManager.shared.userActivityLevel!
            activity = userObj1
        }
        
        if UserDefaultsManager.shared.userWeight == 0 {
            
            let userObj2 = UserDefaultsManager.shared.userWeight
            
            lblkg.text = "\(userObj2)"
            slider.value = Float(truncating: NSNumber(value: userObj2))
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
    
    @IBAction func SliderClick(_ sender: UISlider) {
        
    }
    
    private func validation() -> Bool {
        
        let inputData = [lblkg.text!, gander, activity]
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
        gander = "female"
        caluculateTotalValue()
    }
    @IBAction func btnselectMale(_ sender: UIButton) {
        gander = "male"
        caluculateTotalValue()
    }
    @IBAction func btnHighClick(_ sender: UIButton) {
        activity = "high"
        caluculateTotalValue()
    }
    
    @IBAction func btnMediumClick(_ sender: UIButton) {
        activity = "medium"
        caluculateTotalValue()
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        activity = "low"
        caluculateTotalValue()
    }
    
    @IBAction func btndone(_ sender: UIButton) {
        guard validation() else {
            return
        }
        let alertController = UIAlertController(title: "", message: "Details Successfully Updated", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { [unowned self] (result) -> Void in
            
            let lblanss: Int = self.num / 10
            
            UserDefaults.standard.set(lblanss, forKey: "lblml")
            UserDefaults.standard.set(self.gander, forKey: "gander")
            UserDefaults.standard.set(self.activity, forKey: "activity")
            UserDefaults.standard.set(self.weightCurrentVAle, forKey: "kg")
            UserDefaults.standard.set(1, forKey: "fill")
            UserDefaults.standard.set(self.num, forKey: "MainWaterQuantityKey")
            if self.dictPrevious == DataRecordModel.defaultModel() {
                
                let today = Date().toLocalTime()
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
                let strDate = self.dateFormatter.string(from: today)
                
                self.insertData(DATE: strDate, WEIGHT: self.weightCurrentVAle, GENDER: self.gander, ACTIVITYLAVEL: self.activity, WATERQTY: self.num, REMAININGWATERQTY: self.num, TOTALDRINK: 0, TOTALATTEMPT: 0, WATERQTYPERATTEMPT: lblanss)
            }else{
                
                let totalDrinksCount = self.dictPrevious.totalDrink
                
                let totalDrinkWater = lblanss*totalDrinksCount
                let remainingWaterQty = self.num - totalDrinkWater
                
                self.updateData(WEIGHT: self.weightCurrentVAle, GENDER: self.gander, ACTIVITYLAVEL: self.activity, WATERQTY: self.num, REMAININGWATERQTY: remainingWaterQty, TOTALDRINK: totalDrinksCount, WATERQTYPERATTEMPT: lblanss)
            }
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        if appDelegate.menuvar == "hide" {
            btnmenu.isHidden = true
            imgmenu.isHidden = true
            self.toggleRight()
        } else {
            appDelegate.menuvar = "show"
            btnmenu.isHidden = false
            imgmenu.isHidden = false
            self.toggleLeft()
        }
    }
    
    // MARK: - SQL Database Handler
    
    func insertData(DATE: String, WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, TOTALATTEMPT: Int, WATERQTYPERATTEMPT: Int) -> Void {
        
        let result = DBManager.shared.insertData(date: DATE, weight: WEIGHT, gender: GENDER, activityLevel: ACTIVITYLAVEL, waterQty: WATERQTY, remainingWaterQty: REMAININGWATERQTY, totalDrink: TOTALDRINK, totalAttempt: TOTALATTEMPT, waterQtyPerAttempt: WATERQTYPERATTEMPT)
        
        guard result.status == 1 else {
            assertionFailure("\(result.failure)")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlertVCNew") as? AlertVCNew
        self.appDelegate.resettime = "reset"
        self.navigationController!.pushViewController(vc!, animated: true)
        
    }
    
    func updateData(WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, WATERQTYPERATTEMPT: Int){
        
        let result = DBManager.shared.updateData(weight: WEIGHT, gender: GENDER, activityLevel: ACTIVITYLAVEL, waterQty: WATERQTY, remainingWaterQty: REMAININGWATERQTY, totalDrink: TOTALDRINK, waterQtyPerAttempt: WATERQTYPERATTEMPT)
        
        guard result.status == 1 else {
            assertionFailure("\(result.failure)")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        self.navigationController!.pushViewController(vc!, animated: true)
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
