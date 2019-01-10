//
//  SignUpVCViewController.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 09/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import FRHyperLabel
import Google

import UIKit

class SignUpVC: BaseViewController, EULAControllerDelegate, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termAndConditionText: UILabel!
    @IBOutlet weak var orConnectWithLabel: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    
    @IBOutlet weak var termsConditionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOrConnectWith: NSLayoutConstraint!
    
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var termsConditionTopConstraint: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeLanguageText()
        setupScreenUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
        
        if UIScreen.main.bounds.size.width == 320 {
            heightConstraintOrConnectWith.constant = 10
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if (UIDevice.current.model.range(of: "iPad") != nil){
            self.termsConditionBottomConstraint.constant = 0
            self.buttonTopConstraint.constant = 0
            self.loginBottomConstraint.constant = 0
            self.termsConditionTopConstraint.constant = 0
        }
    }
    
    func setupScreenUI() {
        
        self.navigationController?.navigationBar.isHidden = true
        emailTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        passwordTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        confirmPasswordTextField.textAlignment = Localisator.sharedInstance.currentTextDirection

        self.emailView.backgroundColor = UIColor.clear
        self.passwordView.backgroundColor = UIColor.clear
        self.confirmPasswordView.backgroundColor = UIColor.clear
        
        self.emailView.changeCornerAndColor(10, borderWidth: 1.0, color: Constants.cornerColorBlack)
        self.passwordView.changeCornerAndColor(10, borderWidth: 1.0 , color: Constants.cornerColorBlack)
        self.confirmPasswordView.changeCornerAndColor(10, borderWidth: 1.0 , color: Constants.cornerColorBlack)
        self.loginButton.changeCornerAndColor(20, borderWidth: 1.0 , color: Constants.cornerColor)
    
        loginButton.titleLabel?.addTextSpacing(spacing: 1.0)
        signUpButton.titleLabel?.addTextSpacing(spacing: 1.0)
        titleLabel?.addTextSpacing(spacing: 1.4)
        
        let clearButton : UIButton =   self.emailTextField.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "cross-icon"), for: .normal)
  

    }
    
    @IBAction func termsAndConditionsTapped(_ sender: AnyObject) {
        let eulaVC:EULAWebController = EULAWebController(nibName: "EULAWebController", bundle: Bundle.main)
        eulaVC.title = Localization("Terms & Conditions")
        eulaVC.titleText = Localization("Terms & Conditions")
        self.navigationController?.pushViewController(eulaVC, animated: true)
    }
    
    func changeLanguageText(){
        
        let main_string = Localization("By signing up you agree to all Terms & Conditions")
        let string_to_color = Localization("Terms & Conditions")
        
        let range = (main_string as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:main_string)
        let cornerColor = UIColor().colorWithRedValue(39, greenValue: 193, blueValue: 221, alpha: 1.0)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: cornerColor , range: range)
        
        titleLabel.attributedText = NSAttributedString(string: Localization("SIGN UP") )
        termAndConditionText.attributedText = attributedString
        orConnectWithLabel.text = Localization("or connect with")
        
        emailTextField.placeholder = Localization("E-mail")
        passwordTextField.placeholder = Localization("Password")
        confirmPasswordTextField.placeholder = Localization("Confirm Password")
        
        loginButton.setTitle(Localization("SIGN IN"), for: .normal)
        signUpButton.setTitle(Localization("SIGN UP"), for: .normal)
        
        if Localisator.sharedInstance.currentLanguage == "ar" {
            titleLabel.font = UIFont(name: "GeezaPro-Bold", size: titleLabel.font.pointSize)
            termAndConditionText.font = UIFont(name: "Geeza Pro", size: termAndConditionText.font.pointSize)
            orConnectWithLabel.font = UIFont(name: "Geeza Pro", size: orConnectWithLabel.font.pointSize)
            emailTextField.font = UIFont(name: "Geeza Pro", size: 12.0)
            passwordTextField.font = UIFont(name: "Geeza Pro", size: 12.0)
            confirmPasswordTextField.font = UIFont(name: "Geeza Pro", size: 12.0)
            loginButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (loginButton.titleLabel?.font.pointSize)!)
            signUpButton.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (signUpButton.titleLabel?.font.pointSize)!)
            
        }
    }
    
    fileprivate func setupScreenLayoutDependentUI() {
        self.signUpButton.layer.cornerRadius = 10
        self.signUpButton.layer.masksToBounds = true
    }
    
    // MARK: - EULAControllerDelegate
    func eulaControllerOptionDidSelect(_ isAccepted: Bool) {
        
    }
    
    // MARK: - IBActions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: AnyObject) {
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        if (validateTextFields()) {
            
            let postSignUpProfile  = UIStoryboard(name: "PostSignUpProfile", bundle: nil)
            let postSignUpProfileVC = postSignUpProfile.instantiateViewController(withIdentifier: "PostSignUpProfile")
            self.navigationController?.pushViewController(postSignUpProfileVC, animated: false)
        }
    }
    
    // MARK: Form Validations
    func validateTextFields() -> Bool {
        
        if self.emailTextField.isTextFieldEmpty() {
            self.showAlertViewWithMessage("Error.", message: "E-mail field can not be empty.")
            return false
        }
        else if !self.emailTextField.text!.isValidEmail() {
            self.showAlertViewWithMessage("Error.", message: NSLocalizedString("Enter valid email", comment: ""))
            return false
        }
        else if self.passwordTextField.isTextFieldEmpty() {
            self.showAlertViewWithMessage("Error.", message: "Password field can not be empty.")
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
        else if self.confirmPasswordTextField.isTextFieldEmpty() {
            self.showAlertViewWithMessage("Error.", message: "Confirm Password field can not be empty.")
            return false
        }
        else if self.confirmPasswordTextField.text != self.passwordTextField.text {
            self.showAlertViewWithMessage("Error.", message: "Password and confirm password must be same.")
            return false
        }
        else {
            return true
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            self.confirmPasswordView.becomeFirstResponder()
        }
        return true
    }
    
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        super.removeTapGesture()
    }
    
}



// MARK: extension for web service

extension SignUpVC {
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if validateTextFields() {
            
            // show loader
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
            UserManager.sharedManager().registerWithEmail(self.emailTextField.textByTrimmingWhiteSpacesAndNewline(), password:self.passwordTextField.textByTrimmingWhiteSpacesAndNewline(), roleType: UserManager.sharedManager().roleTypeString(), deviceInfo:deviceInfo(), completion: { (success, error) -> (Void) in
                
                DispatchQueue.main.async {
                    self.navigationController!.view.hideLoader()
                    if success {
                        
                        LogManager.logDebug("login success")
                        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                    
                    }
                    else {
                        // hide loader
                        self.navigationController!.view.hideLoader()
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
            })
        }
    }
    
    
    
    // MARK: Social Login Google
    @IBAction func googlePlusLoginAction(_ sender: AnyObject?) {
        
        self.view.showLoader(mainTitle: Localization("please wait"), subTitle: "")
        
        APGoogleManager.sharedManager().loginFromController(self) { (userDict, error) in
            // hide loader
            DispatchQueue.main.async {
                self.view.hideLoader()
                
                
                if error == nil {
                    
                    self.loginToServerViaGoogle(userDict)
                    
                }
                else
                {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }
            }
        }
    }
    
    
    func loginToServerViaGoogle(_ userDict: [String : String]?) {
        
        if let _ = userDict {
            
            //show loader
            self.view.showLoader(mainTitle: Localization("please wait"), subTitle: "")
            
            
            UserManager.sharedManager().performGoogleLogin(userDict!["name"]!, email: userDict!["email"]! , googleId: userDict!["googleID"]!, roleType: UserManager.sharedManager().roleTypeString(), profileImage: userDict!["profilePicture"]!, googleIdToken: userDict!["google_IdToken"]!, deviceInfo: deviceInfo(), completion: { (success, error) -> (Void) in
                // hide loader
                DispatchQueue.main.async {
                    self.view.hideLoader()
                    
                    
                    
                    if success {
                        
                        LogManager.logDebug("login success")
                        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                        
                    } else {
                        
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
                
            })
            
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
                // hit login api
                //self.showAlertBannerWithMessage("Login Sucessful", bannerStyle: ALAlertBannerStyleNotify)
                self.loginToServerViaLinkedIn(userDict)
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
                // hit login api
                //                self.showAlertBannerWithMessage("Login Sucessful", bannerStyle: ALAlertBannerStyleNotify)
                self.loginToServerViaTwitter(userDict)
            }
            
        }
    }
    
    func loginToServerViaLinkedIn(_ userDict: [String : String]?) {
        
        if let _ = userDict {
            
            //show loader
            self.view.showLoader(mainTitle: Localization("please wait"), subTitle: "")
            
            UserManager.sharedManager().performLinkedInLogin(userDict!["name"]!, email: userDict!["email"]! , linkedId: userDict!["accountID"]!, roleType: UserManager.sharedManager().roleTypeString(), profileImage: userDict!["profilePicture"]!, authToken: userDict!["authToken"]!, deviceInfo: deviceInfo(), completion: { (success, error) -> (Void) in
                // hide loader
                DispatchQueue.main.async {
                    self.view.hideLoader()
                    
                    if success {
                        
                        // show home view controller
                        
                        LogManager.logDebug("login success")
                        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                        
                    } else {
                        
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
                
            })
            
        }
    }
    
    func loginToServerViaTwitter(_ userDict: [String : String]?) {
        
        if let _ = userDict {
            
            //show loader
            self.view.showLoader(mainTitle: Localization("please wait"), subTitle: "")
            
            UserManager.sharedManager().performTwitterLogin(userDict!["name"]!, email: userDict!["email"]! , twitterId: userDict!["accountID"]!, roleType: UserManager.sharedManager().roleTypeString(), profileImage: userDict!["profilePicture"]!, twitterIdToken: userDict!["authToken"]!, deviceInfo: deviceInfo(), completion: { (success, error) -> (Void) in
                // hide loader
                DispatchQueue.main.async {
                    self.view.hideLoader()
                    
                    if success {
                        
                        // show home view controller
                        
                        LogManager.logDebug("login success")
                        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                        
                    } else {
                        
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
                
            })
            
        }
    }

    
    
    
    
    
}
