//
//  APOTPVerifyViewController.swift
//  OnDemandApp
//  Created by Saurabh Verma on 23/02/16.
//  Copyright © 2016 Appster. All rights reserved.
//

enum OTPTextFieldTag: Int {
    case otpTextFieldTagFirst = 100
    case otpTextFieldTagSecond = 101
    case otpTextFieldTagThird = 102
    case otpTextFieldTagFourth = 103
    case otpTextFieldTagFifth = 104
    case otpTextFieldTagSixth = 105
    case otpTextFieldTagSeventh = 106
    case otpTextFieldTagEighth = 107
}

import Foundation
import UIKit

open class APOTPVerifyViewController: BaseViewController {
    
    // MARK: iVars
    @IBOutlet weak var secondTextField: OTPTextField!
    @IBOutlet weak var thirdTextField: OTPTextField!
    @IBOutlet weak var fourthTextField: OTPTextField!
    @IBOutlet weak var fifthTextField: OTPTextField!
    
    @IBOutlet weak var sixthTextField: OTPTextField!
    @IBOutlet weak var seventhTextField: OTPTextField!
    
    var phoneNumber: String!
    
    // MARK: View Life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
        self.setupScreenUI()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async(execute: {
            self.showAlertViewWithMessage("OTP", message: NSLocalizedString("Your OTP for is ", comment: "") + UserManager.sharedManager().activeUser.otp!)
        });
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove all Observers here
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func initialize() {
        
        self.secondTextField.otpDelegate = self
        self.thirdTextField.otpDelegate = self
        self.fourthTextField.otpDelegate = self
        self.fifthTextField.otpDelegate = self
        self.sixthTextField.otpDelegate = self
        self.seventhTextField.otpDelegate = self
        
        // enable first textfield
        enableTextField(self.secondTextField)
        
        // Set Phone Number
        
        // Add notification when textfield content changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(APOTPVerifyViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: self.secondTextField
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(APOTPVerifyViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: self.thirdTextField
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(APOTPVerifyViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: self.fourthTextField
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(APOTPVerifyViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: self.fifthTextField
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(APOTPVerifyViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: self.sixthTextField
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(APOTPVerifyViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: self.seventhTextField
        )
    }
    
    
    // MARK: - HELPER METHODS
    fileprivate func setupScreenUI() {
        
        self.secondTextField.layer.borderWidth = 1
        self.thirdTextField.layer.borderWidth = 1
        self.fourthTextField.layer.borderWidth = 1
        self.fifthTextField.layer.borderWidth = 1
        self.sixthTextField.layer.borderWidth = 1
        self.seventhTextField.layer.borderWidth = 1
        
        self.secondTextField.layer.borderColor = UIColor(hexColorCode: "#A5A698", alpha: 1.0).cgColor
        self.thirdTextField.layer.borderColor = UIColor(hexColorCode: "#A5A698", alpha: 1.0).cgColor
        self.fourthTextField.layer.borderColor = UIColor(hexColorCode: "#A5A698", alpha: 1.0).cgColor
        self.fifthTextField.layer.borderColor = UIColor(hexColorCode: "#A5A698", alpha: 1.0).cgColor
        self.sixthTextField.layer.borderColor = UIColor(hexColorCode: "#A5A698", alpha: 1.0).cgColor
        self.seventhTextField.layer.borderColor = UIColor(hexColorCode: "#A5A698", alpha: 1.0).cgColor
    }
    
    func textFieldBackspacePressed(_ sender : UITextField) {
        
    }
    
    func textFieldTextChanged(_ sender : AnyObject) {
        
        let notification = sender as? Foundation.Notification
        let textField = notification?.object as? UITextField
        let tag = OTPTextFieldTag(rawValue: textField!.tag)!
        
        switch tag {
        case .otpTextFieldTagFirst:
            
            enableTextField(secondTextField)
            
        case .otpTextFieldTagSecond:
            
            enableTextField(thirdTextField)
            
        case .otpTextFieldTagThird:
            
            enableTextField(fourthTextField)
            
        case .otpTextFieldTagFourth:
            
            enableTextField(fifthTextField)
            
        case .otpTextFieldTagFifth:
            enableTextField(sixthTextField)
            
            
        case .otpTextFieldTagSixth:
            enableTextField(seventhTextField)
            
        case .otpTextFieldTagSeventh: break
            
        case .otpTextFieldTagEighth: break
            
        }
        
    }
    
    fileprivate func enableTextField(_ candidate: UITextField) {
        
        // disable all
        self.secondTextField.isUserInteractionEnabled = false
        self.thirdTextField.isUserInteractionEnabled = false
        self.fourthTextField.isUserInteractionEnabled = false
        self.fifthTextField.isUserInteractionEnabled = false
        self.sixthTextField.isUserInteractionEnabled = false
        self.seventhTextField.isUserInteractionEnabled = false
        
        // now enable the candidate
        candidate.isUserInteractionEnabled = true
        candidate.becomeFirstResponder()
    }
    
    fileprivate func disableAllTextField(_ candidate: UITextField) {
        
        // disable all
        self.secondTextField.isUserInteractionEnabled = false
        self.thirdTextField.isUserInteractionEnabled = false
        self.fourthTextField.isUserInteractionEnabled = false
        self.fifthTextField.isUserInteractionEnabled = false
        self.sixthTextField.isUserInteractionEnabled = false
        self.seventhTextField.isUserInteractionEnabled = false
        
        // now enable the candidate
        candidate.isUserInteractionEnabled = true
        candidate.becomeFirstResponder()
    }
    
    fileprivate func getCleanPhoneNumber(_ candidate: String) -> String {
        
        var cleanPhoneNumber = candidate.replacingOccurrences(of: "(", with: "")
        cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: ")", with: "")
        cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: " ", with: "")
        cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: "-", with: "")
        
        return cleanPhoneNumber
    }
    
    
    // MARK: Control Actions
    @IBAction fileprivate func cancelButtonAction(_ sender : AnyObject?) {
        if navigationController != nil {
            navigationController!.popViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: {
                
            })
        }
    }
    
    @IBAction fileprivate func changePhone(_ sender: UIButton) {
        
        // put down the keyboard
        self.secondTextField.resignFirstResponder()
        self.thirdTextField.resignFirstResponder()
        self.fourthTextField.resignFirstResponder()
        self.fifthTextField.resignFirstResponder()
        
        // go back
        self.dismiss(animated: true, completion: nil)
    }
}

extension APOTPVerifyViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        LogManager.logDebug("range.length = \(range.length)")
        LogManager.logDebug("range.location = \(range.location)")
        LogManager.logDebug("string = \(string)")
        LogManager.logDebug("textField.text = \(textField.text)")
        
        if range.length == 0 && range.location > 0 {
            return false
        }
        return true
    }
}

extension APOTPVerifyViewController: OTPTextFieldDelegate {
    
    func backspaceInEmptyFieldPressed(_ textField: UITextField) {
        let tag = OTPTextFieldTag(rawValue: textField.tag)!
        LogManager.logDebug("backspaceInEmptyFieldPressed->textField.text = \(textField.text)")
        LogManager.logDebug("backspaceInEmptyFieldPressed->tag = \(tag)")
        
        switch tag {
        case .otpTextFieldTagFirst: break
            
        case .otpTextFieldTagSecond: break
            
        case .otpTextFieldTagThird:
            
            enableTextField(secondTextField)
            self.secondTextField.text = ""
            self.secondTextField.becomeFirstResponder()
            
        case .otpTextFieldTagFourth:
            
            enableTextField(thirdTextField)
            self.thirdTextField.text = ""
            self.thirdTextField.becomeFirstResponder()
            
        case .otpTextFieldTagFifth:
            
            enableTextField(fourthTextField)
            self.fourthTextField.text = ""
            self.fourthTextField.becomeFirstResponder()
            
        case .otpTextFieldTagSixth:
            enableTextField(fifthTextField)
            self.fifthTextField.text = ""
            self.fifthTextField.becomeFirstResponder()
            
        case .otpTextFieldTagSeventh:
            enableTextField(sixthTextField)
            self.sixthTextField.text = ""
            self.sixthTextField.becomeFirstResponder()
            
        case .otpTextFieldTagEighth: break
            
        }
    }
}

// MARK: extension for web service
extension APOTPVerifyViewController {
    
    @IBAction fileprivate func reSendOTP(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        self.view.isUserInteractionEnabled = false
        
        // show loader
        AppDelegate.delegate().window?.rootViewController!.view.showLoader(mainTitle: NSLocalizedString("Sending Otp", comment: ""), subTitle: Localization("please wait"))
        UserManager.sharedManager().performPhoneLogin(phoneNumber) { (success, error) -> (Void) in
            
            // hide loader
            DispatchQueue.main.async {
                
                self.view.isUserInteractionEnabled = true
                AppDelegate.delegate().window?.rootViewController!.view.hideLoader()
            
            if let _ = error {
                
                self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
            }
            else
            {
                self.showAlertViewWithMessage("OTP", message: NSLocalizedString("Your OTP for is ", comment: "") + UserManager.sharedManager().activeUser.otp!)
            }
                }
        }
    }
    
    @IBAction fileprivate func verifyOtp(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        let otp = self.secondTextField.text! + self.thirdTextField.text! + self.fourthTextField.text! + self.fifthTextField.text! + self.sixthTextField.text! + self.seventhTextField.text!
        
        
        // show loader
        AppDelegate.delegate().window?.rootViewController!.view.showLoader(mainTitle: NSLocalizedString("Sending Otp", comment: ""), subTitle: Localization("please wait"))
        
        
        UserManager.sharedManager().performOtpVerify(self.phoneNumber ?? "", otp: otp) { (success, error) -> (Void) in
            
            DispatchQueue.main.async {
                // hide loader
                AppDelegate.delegate().window?.rootViewController!.view.hideLoader()
                
                
                self.view.isUserInteractionEnabled = true
                
                
                if success {
                    
                    UserManager.sharedManager().activeUser.isPhoneVerified = 1
                    UserManager.sharedManager().updateActiveUser()
                    
                    AppDelegate.delegate().window?.rootViewController?.dismiss(animated: true, completion: {
                        
                    })
                    
                    if(UserManager.sharedManager().userType == .userTypeProvider)
                    {
                        
                        if ConfigurationManager.sharedManager().isMultiService() == true
                        {
                            // push category viewcontroller
                            let categoryStoryboard = UIStoryboard.init(storyboard: "Category")
                            let categoryVC = categoryStoryboard.instantiateInitialViewController()
                            AppDelegate.delegate().window?.rootViewController = categoryVC
                        }
                        else if !UserManager.sharedManager().activeUser.isServicesSaved!.boolValue
                        {
                            let categoryStoryboard = UIStoryboard.init(storyboard: "Category")
                            let servicesVC = categoryStoryboard.instantiateViewController(withIdentifier: "APServicesViewControllerContainer")
                            AppDelegate.delegate().window?.rootViewController = servicesVC
                        }
                        
                    }
                    
                }
                if let _ = error {
                    
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }

            }
            
            
        }
        
    }
}

