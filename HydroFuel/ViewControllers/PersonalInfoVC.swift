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

class PersonalInfoVC: UIViewController, iShowcaseDelegate {
    
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
    var  num = Int()
    @IBOutlet var slider: UISlider!
    var dicdata = NSDictionary()
    var dictPrevious = NSMutableDictionary()
    var currentShowcase = 0
    var showcase = iShowcase()
    var caluculatedWaterLevelValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDB()
        showcase.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        self.slider.addGestureRecognizer(panGesture)
        lblkg.text = "50" + "Kg"
        weightCurrentVAle = 50
        ans = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000) )
        lblwaterml.text =  "\(ans)"
        num = checkForRoundValue()
        lblwaterml.text = "\(num)" + " " + "ml"
        
        self.navigationController?.navigationBar.isHidden = true
        slider.setThumbImage(UIImage(named: "round1"), for: .normal)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        slider.isContinuous = true
        btnPlus.layer.cornerRadius = btnPlus.frame.height / 2
        btnPlus.clipsToBounds = true
        btnMinus.layer.cornerRadius = btnMinus.frame.height / 2
        btnMinus.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard appDelegate.isToolTipShown else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.showcase.setupShowcaseForView(self.lblkg)
            self.showcase.titleLabel.text = "To work out your daily water intake goal please Select Your Weight"
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "      "
            self.showcase.show()
        }
        
    }
    
    @IBAction func btnClickedToChangeDailyTarget(_ sender: UIButton) {
        
        var currentAmount = Int((lblwaterml.text ?? "0").replacingOccurrences(of: " ml", with: "")) ?? 0
        if sender.tag == 1{
            //Plus
            currentAmount += 500
        }else{
            //Minus
            currentAmount = max(500,currentAmount-500)
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
        if data.Status == 1 {
            UIApplication.shared.applicationIconBadgeNumber = 0
            appDelegate.badgeCount = 0
            UserDefaults.standard.set(200, forKey: mykeys.KLASTWATERCONSTRAINT)
            UserDefaults.standard.set(1, forKey: mykeys.KBOTTLECOUNT)
            UserDefaults.standard.set(strDate, forKey: mykeys.KPREVIOUSDATE)
            UserDefaults.standard.set(0, forKey: mykeys.KLASTCOUNTOFATTEMPT)
            UserDefaults.standard.set("1000", forKey: mykeys.KLASTLBLWATERLEVAL)
            appDelegate.resettime = "reset"
            UserDefaults.standard.set("1000", forKey: "waterlevel")
        }
    }
    func caluculateTotalValue(){
        lblkg.text = "\(weightCurrentVAle) kg"
        caluculatedWaterLevelValue = (Int(Double(weightCurrentVAle) * Double(0.033) * 1000))
        lblwaterml.text = "\(caluculatedWaterLevelValue)"
        num = checkForRoundValue()
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
                num = checkForRoundValue()
                lblwaterml.text = "\(num)" + " " + "ml"
            }
            else
            {
                lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(1.5) * 1000))"
                num = checkForRoundValue()
                lblwaterml.text = "\(num)"  + " " + "ml"
            }
        }else if  activity == "medium"{
            imghigh.image = UIImage(named: "runningbuttonblack")
            imglow.image = UIImage(named: "standingbuttonblack")
            imgmedium.image = UIImage(named: "walkingbuttonblue")
            if gander == "female"
            {
                lblwaterml.text = "\(Int(Double(caluculatedWaterLevelValue) + Double(0.5) * 1000))"
                num = checkForRoundValue()
                lblwaterml.text = "\(num)" + " " + "ml"
            }
            else
            {
                // let num =  Int(Double(maleans) + Double(0.5) * 1000)
                lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(1) * 1000))"
                num = checkForRoundValue()
                lblwaterml.text = "\(num)" + " " + "ml"
            }
        }else if activity == "low"{
            imghigh.image = UIImage(named: "runningbuttonblack")
            imglow.image = UIImage(named: "standingbuttonblue")
            imgmedium.image = UIImage(named: "walkingbuttonblack")
            if gander == "female"
            {
                lblwaterml.text = "\(caluculatedWaterLevelValue)"
                num = checkForRoundValue()
                lblwaterml.text = "\(num)" + " " + "ml"
                
            }
            else
            {
                lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(0.5) * 1000))"
                num = checkForRoundValue()
                lblwaterml.text = "\(num)"  + " " + "ml"
                print(num)
            }
        }
    }
    
    func caluCulateGenderValue(genderText:String, genderRation:Double) {
        gander = genderText
        lblwaterml.text =  "\(Int(Double(caluculatedWaterLevelValue) + Double(genderRation) * 1000))"
        num = checkForRoundValue()
        lblwaterml.text = "\(num)"  + " " + "ml"
    }
    
    func iShowcaseShown(_ showcase: iShowcase) {
        currentShowcase += 1
    }
    
    func iShowcaseDismissed(_ showcase: iShowcase) {
        switch currentShowcase {
        case 1:
            self.showcase.setupShowcaseForView(self.btnmale)
            self.showcase.titleLabel.text = "Select your Gender"
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.titleLabel.setNeedsDisplay(CGRect(x: 50, y: 50, width: 0, height: 0))
            self.showcase.detailsLabel.text = "     "
            self.showcase.show()
            
        case 2:
            self.showcase.setupShowcaseForView(self.imgmedium)
            self.showcase.titleLabel.text = "Select your Activity level"
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "     "
            self.showcase.show()
            
        case 3:
            self.showcase.setupShowcaseForView(self.lblwaterml)
            self.showcase.titleLabel.text = "This is your suggested daily water intake"
            self.showcase.titleLabel.font = UIFont (name: "Avenir Medium", size: 17)
            self.showcase.detailsLabel.text = "      "
            self.showcase.show()
            
        default:
            assertionFailure("Default \(currentShowcase)")
        }
    }
    
    @objc func panGesture(gesture:UIPanGestureRecognizer){
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
            self.firstInsertData(DATE: tempDate, WEIGHT: 0, GENDER: "Male", ACTIVITYLAVEL: "Low", WATERQTY: 0, REMAININGWATERQTY: 0, TOTALDRINK: 0, TOTALATTEMPT: 0, WATERQTYPERATTEMPT: 0)
        }
        if UserDefaults.standard.value(forKey: "gander") != nil {
            
            let userObj = UserDefaults.standard.value(forKey: "gander") as! String
            gander = userObj
            print(userObj)
        }
        if UserDefaults.standard.value(forKey: "activity") != nil {
            
            let  userObj1 = UserDefaults.standard.value(forKey: "activity") as! String
            activity = userObj1
            print(userObj1)
        }
        
        if UserDefaults.standard.value(forKey: "kg") != nil {
            //value = "abcd"
            let  userObj2 = UserDefaults.standard.value(forKey: "kg") as! NSNumber
            //currentValue = Int(userObj2)
            lblkg.text = "\(userObj2)"
            slider.value = Float(truncating: userObj2)
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
    func validation() ->Bool
    {
        if lblkg.text == ""
        {
            showMyAlert(messageIs: "Please Choose Weight")
        }
        if gander == ""
        {
            showMyAlert(messageIs: "Please Choose Gender")
        }
        if activity == ""
        {
            showMyAlert(messageIs: "Please Choose Activity Level")
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
        if validation(){
            let alertController = UIAlertController(title: "", message: "Details Successfully Updated", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            {
                (result : UIAlertAction) -> Void in
                var lblanss = Int()
                lblanss = (self.num / 10)
                print(lblanss)
                UserDefaults.standard.set(lblanss, forKey: "lblml")
                UserDefaults.standard.set(self.gander, forKey: "gander")
                UserDefaults.standard.set(self.activity, forKey: "activity")
                UserDefaults.standard.set(self.weightCurrentVAle, forKey: "kg")
                UserDefaults.standard.set(1, forKey: "fill")
                UserDefaults.standard.set(self.num, forKey: "MainWaterQuantityKey")
                if self.dictPrevious.count == 0{
                    
                    let today = Date().toLocalTime()
                    let dateFormattor = DateFormatter()
                    dateFormattor.dateFormat = "yyyy-MM-dd"
                    dateFormattor.timeZone = TimeZone(identifier: "UTC")
                    let strDate = dateFormattor.string(from: today)
                    
                    self.insertData(DATE: strDate, WEIGHT: self.weightCurrentVAle, GENDER: self.gander, ACTIVITYLAVEL: self.activity, WATERQTY: self.num, REMAININGWATERQTY: self.num, TOTALDRINK: 0, TOTALATTEMPT: 0, WATERQTYPERATTEMPT: lblanss)
                }else{
                    
                    let totalDrinksCount = self.dictPrevious.value(forKey: "TOTALDRINK") as! Int
                    
                    let totalDrinkWater = lblanss*totalDrinksCount
                    let remainingWaterQty = self.num - totalDrinkWater
                    
                    self.updateData(WEIGHT: self.weightCurrentVAle, GENDER: self.gander, ACTIVITYLAVEL: self.activity, WATERQTY: self.num, REMAININGWATERQTY: remainingWaterQty, TOTALDRINK: totalDrinksCount, WATERQTYPERATTEMPT: lblanss)
                }
                
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        if appDelegate.menuvar == "hide"
        {
            btnmenu.isHidden = true
            imgmenu.isHidden = true
            self.toggleRight()
        }
        else{
            appDelegate.menuvar = "show"
            btnmenu.isHidden = false
            imgmenu.isHidden = false
            self.toggleLeft()
            
            
        }
    }
    
    //MARK:- SQL Database Handler
    
    func createDB() -> Void {
        //let strURL = "CREATE TABLE IF NOT EXISTS HYDROFUELPERSINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, CITY TEXT)"
        let strURL = "CREATE TABLE IF NOT EXISTS HYDROFUELPERSINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, WEIGHT INTEGER, GENDER TEXT, ACTIVITYLAVEL TEXT, WATERQTY INTEGER, REMAININGWATERQTY INTEGER, TOTALDRINK INTEGER, TOTALATTEMPT INTEGER, WATERQTYPERATTEMPT INTEGER)"
        print(strURL)
        
        let data = AFSQLWrapper.createTable(strURL)
        print(data)
    }
    
    
    
    func insertData(DATE: String, WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, TOTALATTEMPT: Int, WATERQTYPERATTEMPT: Int) -> Void {
        //let strURL = "INSERT INTO DEMOSQL (NAME, CITY) VALUES ('\(myName)', '\(myCity)')"
        let strURL = "INSERT INTO HYDROFUELPERSINFO (DATE, WEIGHT, GENDER, ACTIVITYLAVEL, WATERQTY, REMAININGWATERQTY, TOTALDRINK, TOTALATTEMPT, WATERQTYPERATTEMPT) VALUES ('\(DATE)', '\(WEIGHT)', '\(GENDER)', '\(ACTIVITYLAVEL)', '\(WATERQTY)', '\(REMAININGWATERQTY)', '\(TOTALDRINK)', '\(TOTALATTEMPT)', '\(WATERQTYPERATTEMPT)')"
        print(strURL)
        
        let data = AFSQLWrapper.insertTable(strURL)
        print(data)
        if data.Status == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlertVCNew") as? AlertVCNew
            self.appDelegate.resettime = "reset"
            self.navigationController!.pushViewController(vc!, animated: true)
        }
    }
    
    func firstInsertData(DATE: String, WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, TOTALATTEMPT: Int, WATERQTYPERATTEMPT: Int) -> Void {
        //let strURL = "INSERT INTO DEMOSQL (NAME, CITY) VALUES ('\(myName)', '\(myCity)')"
        let strURL = "INSERT INTO HYDROFUELPERSINFO (DATE, WEIGHT, GENDER, ACTIVITYLAVEL, WATERQTY, REMAININGWATERQTY, TOTALDRINK, TOTALATTEMPT, WATERQTYPERATTEMPT) VALUES ('\(DATE)', '\(WEIGHT)', '\(GENDER)', '\(ACTIVITYLAVEL)', '\(WATERQTY)', '\(REMAININGWATERQTY)', '\(TOTALDRINK)', '\(TOTALATTEMPT)', '\(WATERQTYPERATTEMPT)')"
        print(strURL)
        
        let data = AFSQLWrapper.insertTable(strURL)
        print(data)
        if data.Status == 1{
            print("Success")
            
        }
    }
    
    func updateData(WEIGHT: Int, GENDER: String, ACTIVITYLAVEL: String, WATERQTY: Int, REMAININGWATERQTY: Int, TOTALDRINK: Int, WATERQTYPERATTEMPT: Int){
        let today = Date()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        let strURL = "update HYDROFUELPERSINFO set WEIGHT='\(WEIGHT)', GENDER='\(GENDER)', ACTIVITYLAVEL='\(ACTIVITYLAVEL)', WATERQTY='\(WATERQTY)', REMAININGWATERQTY='\(REMAININGWATERQTY)', TOTALDRINK='\(TOTALDRINK)', WATERQTYPERATTEMPT='\(WATERQTYPERATTEMPT)' where DATE='\(strDate)'"
        //  print(strURL)id
        
        let data = AFSQLWrapper.updateTable(strURL)
        print(data)
        if data.Status == 1 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
            self.navigationController!.pushViewController(vc!, animated: true)
        }
    }
    
    func searchDataForUpdate() {
        let today = Date()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormattor.string(from: today)
        let strURL = "SELECT * FROM HYDROFUELPERSINFO where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.selectIdDataTable(strURL)
        print(data)
        if data.Status == 1 {
            print(data.Success)
            let arrLocalData = data.arrData
            dictPrevious = (arrLocalData[0] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
        }else{
            print(data.Failure)
        }
        
    }
    
    
    func checkForRoundValue() -> Int {
        var number = 0
        
        let value = Int(lblwaterml.text!)!
        if value < 500 {
            let num = 500 - value
            number = value + num
        }else if value > 500 {
            if value < 1000 {
                let num = 1000 - value
                number = value + num
            }else{
                let temp = value/1000
                let data = ("\(temp)000")
                let figureData = value - Int(data)!
                if figureData < 500 {
                    let num = 500 - figureData
                    number = value + num
                }else{
                    let num = 1000 - figureData
                    number = value + num
                }
            }
        }
        return number
    }
    
    @IBAction func btnutctime(_ sender: UIButton) {
        self.appDelegate.timeselect = "yes"
    }
    
}
