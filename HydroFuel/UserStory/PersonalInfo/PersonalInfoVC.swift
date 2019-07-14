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
    private let unSelectedMediumActImage = R.image.walkingbuttonblack()
    private let selectedHighActImage = R.image.runningbuttonblue()
    private let unSelectedHighActImage = R.image.runningbuttonblack()
    
    private let viewModel = PersonalInfoVM()
    
    private var currentShowcase = 0
    private var showcase = iShowcase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
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
        
        lblkg.text = "\(viewModel.tmpUserModel.weight) Kg"
        guard let gender = Gender(rawValue: viewModel.tmpUserModel.gender),
            let activity = Activity(rawValue: viewModel.tmpUserModel.activityLevel) else {
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
            
        case .undefined:
            genderRation = 0.33
            
        }
        
        let newWaterLevel = Int(Double(slider.value) * Double(genderRation) * 100)
        if newWaterLevel < 500 {
            suggestedWatelVolumeLabel.text = "\(500)"
            viewModel.tmpUserModel.suggestedWaterLevel = 500
        } else {
            let roundValue = Int(newWaterLevel / 500) * 500
            viewModel.tmpUserModel.suggestedWaterLevel = roundValue
            suggestedWatelVolumeLabel.text = "\(roundValue)"
        }
        
    }
    
    @IBAction func didTapSuggestedWaterButton(_ sender: UIButton) {
        var currentAmount = Int(suggestedWatelVolumeLabel.text ?? "0") ?? 0
        if sender.tag == 1 {
            //Plus
            currentAmount += 500
        } else {
            //Minus
            currentAmount = max(500, currentAmount - 500)
        }
        viewModel.tmpUserModel.suggestedWaterLevel = currentAmount
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
        let percentage = currentPoint.x / slider.bounds.size.width
        let delta = Float(percentage) * (slider.maximumValue - slider.minimumValue)
        
        var value = slider.minimumValue + delta
        
        if value < slider.minimumValue {
            
           value = slider.minimumValue
            
        } else if value > slider.maximumValue {
            value = slider.maximumValue
        }
        slider.setValue(value, animated: true)
        viewModel.tmpUserModel.weight = Int(value)
        updateDisplayedUserData()
    }
    
    @IBAction func btnFemale(_ sender: UIButton) {
        viewModel.tmpUserModel.gender = Gender.female.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btnselectMale(_ sender: UIButton) {
        viewModel.tmpUserModel.gender = Gender.male.rawValue
        updateDisplayedUserData()
    }
    @IBAction func btnHighClick(_ sender: UIButton) {
        viewModel.tmpUserModel.activityLevel = Activity.high.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btnMediumClick(_ sender: UIButton) {
        viewModel.tmpUserModel.activityLevel = Activity.medium.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        viewModel.tmpUserModel.activityLevel = Activity.low.rawValue
        updateDisplayedUserData()
    }
    
    @IBAction func btndone(_ sender: UIButton) {
        
        do {
            try viewModel.validateInputData()
        } catch {
            AlertPresenter.showMyAlert(at: self, message: error.localizedDescription)
            return
        }
        viewModel.updateData()
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
    
}

// MARK: - PersonalInfoVMDelegate
extension PersonalInfoVC: PersonalInfoVMDelegate {
    
    func shouldPushController(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
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
