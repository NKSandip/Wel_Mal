//
//  APLoginViewController.swift
//  E3mal
//  Created by Ekta Mahajan on 6/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//
import AVFoundation
import UIKit
import Google
import Crashlytics

// This class handles user's login via email/ google/ twitter/ linkedIn

open class APLoginViewController: BaseViewController, SwiftAlertViewDelegate, GIDSignInUIDelegate {
    
    // MARK: iVars
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var orConnectWithLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var heightConstraintOrConnectWith: NSLayoutConstraint!
    
    @IBOutlet weak var linnkdenTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var guestBtn: UIButton!
    
    // MARK: Life Cycle Methods
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setUpLocalization()
        
        prePopulateFormData()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isOpaque = true
        UIApplication.shared.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
        if UIScreen.main.bounds.size.width == 320 {
            
            heightConstraintOrConnectWith.constant = 10
        }
    }
    
    override open func updateViewConstraints() {
        super.updateViewConstraints()
        if(UIDevice.current.model.range(of: "iPad") != nil) {
            self.connectLblBottomConstraint.constant = 0
            self.linnkdenTopConstraint.constant = 0
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Helper Methods
    fileprivate func setupUI() {
        
        emailTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        passwordTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        
        self.loginButton.layer.cornerRadius = 20
        self.loginButton.layer.masksToBounds = true
        
        self.emailView.changeCornerAndColor(10, borderWidth: 1.0, color:Constants.cornerColorBlack)
        self.passwordView.changeCornerAndColor(10, borderWidth: 1.0 , color: Constants.cornerColorBlack)
        self.signUpButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
        
        let clearButton : UIButton =   self.emailTextField.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "cross-icon"), for: .normal)
    }
    
    func setUpLocalization(){
        titleLabel.text = Localization("LOGIN")
        rememberMeLabel.text = Localization("Remember me")
        orConnectWithLabel.text = Localization("or connect with")
        
        emailTextField.placeholder = Localization("E-mail")
        passwordTextField.placeholder = Localization("Password")
        
        self.guestBtn.addLocalization()
        
        loginButton.setTitle(Localization("SIGN IN"), for: .normal)
        
        loginButton.titleLabel?.addTextSpacing(spacing: 1.0)
        signUpButton.titleLabel?.addTextSpacing(spacing: 1.0)
        titleLabel.addTextSpacing(spacing: 1.0)
        
        forgotPasswordButton.setTitle(Localization("Forgot Password"), for: .normal)
        signUpButton.setTitle(Localization("SIGN UP"), for: .normal)
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            
            titleLabel.font = UIFont(name: "GeezaPro-Bold", size: titleLabel.font.pointSize)
            rememberMeLabel.font = UIFont(name: "Geeza Pro", size: rememberMeLabel.font.pointSize)
            orConnectWithLabel.font = UIFont(name: "Geeza Pro", size: orConnectWithLabel.font.pointSize)
            
            emailTextField.font = UIFont(name: "Geeza Pro", size: (emailTextField.font?.pointSize)!)
            passwordTextField.font = UIFont(name: "Geeza Pro", size: (passwordTextField.font?.pointSize)!)
            
            loginButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (loginButton.titleLabel?.font.pointSize)!)
            signUpButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (signUpButton.titleLabel?.font.pointSize)!)
            forgotPasswordButton.titleLabel?.font = UIFont(name: "Geeza Pro", size: (forgotPasswordButton.titleLabel?.font.pointSize)!)
            
        }
    }
    
    func prePopulateFormData() {
        
        // if remember me
        if let email = UserManager.sharedManager().lastLoggedUserEmail(UserManager.sharedManager().roleTypeString()) {
            self.emailTextField.text = email
        }
        
        if let password = UserManager.sharedManager().lastLoggedUserPassword(UserManager.sharedManager().roleTypeString()) {
            self.passwordTextField.text = password
        }
        
    }

    // MARK: Form Validations
    func validateTextFields() -> Bool {
        
        if self.emailTextField.isTextFieldEmpty() {
            showAlertViewWithMessageAndActionHandler("Error.", message: "E-mail field can not be empty.", actionHandler: {
                DispatchQueue.main.async {
                    self.emailTextField.becomeFirstResponder()
                }
            })
            return false
        }
        else if !self.emailTextField.text!.isValidEmail() {
            showAlertViewWithMessageAndActionHandler("Error.", message: NSLocalizedString("Enter valid email", comment: ""), actionHandler: {
                DispatchQueue.main.async {
                    self.emailTextField.becomeFirstResponder()
                }
            })
            return false
        }
        else if self.passwordTextField.isTextFieldEmpty() {
            showAlertViewWithMessageAndActionHandler("Error.", message: "Password field can not be empty.", actionHandler: {
                DispatchQueue.main.async {
                    self.passwordTextField.becomeFirstResponder()
                }
            })
            return false
        }
        else if !(self.passwordTextField.text?.isValidPassword())! {
            showAlertViewWithMessageAndActionHandler("Error.", message: "Password must be at least 8 characters, including a number, an uppercase letter and a lowercase letter.", actionHandler: {
                DispatchQueue.main.async {
                    self.passwordTextField.becomeFirstResponder()
                }
            })
            return false
        }
        else {
            return true
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func actionGuestBtn(_ sender: UIButton) {
        UserDefaults.setObject("true" as AnyObject, forKey: GUEST_USER_KEY)
        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        if(self.navigationController?.viewControllers.count == 1) {
            AppDelegate.presentRootViewController(false, rootViewIdentifier: .toShowLoginScreen)
        }
        else {
           let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func textFieldEditingChanged(_ sender: AnyObject) {
    }
    
    @IBAction func remembermeCheckboxButtonPressed(_ sender: UIButton) {
        if(self.checkboxButton.currentImage == UIImage(named: "ic_tick")) {
           self.checkboxButton.setImage(nil, for: .normal)
        }
        else {
            self.checkboxButton.setImage(UIImage(named:"ic_tick"), for: .normal)
        }
    }
    
    @IBAction func loginAction(_ sender : AnyObject?) {
        self.loginToServerViaEmail()
    }
    
    @IBAction func googlePlusLoginAction(_ sender: AnyObject?) {
        
        self.view.showLoader(mainTitle: Localization("please wait"), subTitle: "")
        
        APGoogleManager.sharedManager().loginFromController(self) { (userDict, error) in
            // hide loader
            DispatchQueue.main.async {
                self.view.hideLoader()

                if error == nil
                {
                    self.loginToServerViaGoogle(userDict)
                }
                else
                {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }
            }
        }
    }
    
    @IBAction func twitterLoginAction(_ sender: Any) {
        APTwitterManager.sharedManager.login { (userDict, error) in
            self.navigationController?.view.hideLoader()
            
            if(error != nil)
            {
                self.showAlertBannerWithMessage(error!.localizedDescription, bannerStyle: ALAlertBannerStyleFailure)
            }
            else
            {
                self.loginToServerViaTwitter(userDict)
            }
            
        }
    }
    
    @IBAction func linkedInLoginAction(_ sender: AnyObject) {
        APLinkedINManager.sharedManager.login { (userDict, error) in
            if(error != nil)
            {
                self.showAlertBannerWithMessage(error!.localizedDescription, bannerStyle: ALAlertBannerStyleFailure)
            }
            else
            {
                self.loginToServerViaLinkedIn(userDict)
            }
        }
    }
    
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "forgot-password" {
            
            let vc = segue.destination as! ForgotPasswordViewController
            vc.prefilledEmail = self.emailTextField.textByTrimmingWhiteSpacesAndNewline()
            
        }
        
    }
    
}

extension APLoginViewController: UITextFieldDelegate {
    
    // MARK: UITextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
//            loginAction(self.loginButton)
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        /*
        if textField == self.emailTextField {
            if (!self.emailTextField.isTextFieldEmpty()) {
                if (!self.emailTextField.text!.isValidEmail()) {
                    
                    let alert = UIAlertController(title: "Warning!", message: NSLocalizedString("Enter valid email", comment: ""), preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) -> Void in
                        textField.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
 */
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Do not allow spaces
        if string == " " {
            return false
        }
        
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

}
