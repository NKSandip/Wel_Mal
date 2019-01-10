//
//  ForgotPasswordViewController.swift
//  OnDemandApp
//
//  Created by Pawan Joshi on 26/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weWillSendYouLabel: UILabel!
    
    var prefilledEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sendButton.isEnabled = true
        self.title = NSLocalizedString("Forgot Password", comment: "")
        
        if prefilledEmail != "" {
            self.emailTextField.text = prefilledEmail
        }
        
        
        self.setupScreenUI()
        self.changeLanguageText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScreenUI() {
        
        emailTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        sendButton.titleLabel?.addTextSpacing(spacing: 1.0)
        titleLabel?.addTextSpacing(spacing: 1.0)
        weWillSendYouLabel.addTextSpacing(spacing: 1.0)
        
//        let clearButton : UIButton =   self.emailTextField.value(forKey: "_clearButton") as! UIButton
//        clearButton.setImage(UIImage(named: "cross-icon"), for: .normal)
    }
    

    
    func changeLanguageText(){

        titleLabel.text = Localization("FORGOT PASSWORD")
        weWillSendYouLabel.text = Localization("We will send you an e-mail with instruction\nhow to change password")
        emailTextField.placeholder = Localization("Enter registered e-mail address")
        sendButton.setTitle(Localization("SUBMIT"), for: .normal)
        
        if Localisator.sharedInstance.currentLanguage == "ar"{
            
            titleLabel.font = UIFont(name: "GeezaPro-Bold", size: titleLabel.font.pointSize)
            weWillSendYouLabel.font = UIFont(name: "Geeza Pro", size: weWillSendYouLabel.font.pointSize)
            emailTextField.font = UIFont(name: "Geeza Pro", size: (emailTextField.font?.pointSize)!)
            emailTextField.addTextSpacing(spacing: 2.0)
            sendButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (sendButton.titleLabel?.font.pointSize)!)
            
        }
    }
    
    
    func validateTextFields() -> Bool {
        if self.emailTextField.text == nil || self.emailTextField.text == "" {
            showAlertViewWithMessageAndActionHandler("Error.", message: "E-mail field can not be empty.", actionHandler: {
                self.emailTextField.becomeFirstResponder()
            })
            return false
        }
        else if !self.emailTextField.text!.isValidEmail() {
            showAlertViewWithMessageAndActionHandler("Error.", message: NSLocalizedString("Enter valid email", comment: ""), actionHandler: {
                self.emailTextField.becomeFirstResponder()
            })
            return false
        }
        else {
            return true
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChanged(_ sender: AnyObject) {
        
        if !((self.emailTextField.text?.isEmpty)!) {
            self.sendButton.isEnabled = true
        }
        else {
//            self.sendButton.isEnabled = false
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


extension ForgotPasswordViewController: UITextFieldDelegate {
    
    // MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Do not allow spaces
        if string == " " {
            return false
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        self.sendButton.isEnabled = false
        return true
    }
}


// MARK: extension for web service
extension ForgotPasswordViewController {
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if !validateTextFields() {
            return
        }
        
        // show loader
        self.navigationController!.view.showLoader(mainTitle: NSLocalizedString("Sending email", comment: ""), subTitle: Localization("please wait"))
        
        
        UserManager.sharedManager().resetPassword(self.emailTextField.textByTrimmingWhiteSpacesAndNewline(), roleType: UserManager.sharedManager().roleTypeString()) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.navigationController!.view.hideLoader()
            
            
            if success {
                
                self.showAlertViewWithMessageAndActionHandler("Success!", message: NSLocalizedString("An email with the reset password link has been sent to your email id.", comment: ""), actionHandler: {
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }
            else {
                // hide loader
                DispatchQueue.main.async {
                    self.navigationController!.view.hideLoader()
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
            }
            
            }

        }
    }
}
