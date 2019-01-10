//
//  APLoginViewController+Services.swift
//  OnDemandApp
//
//  Created by Anish Kumar on 27/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: extension for web service
extension APLoginViewController {
    
    
    func checkValidation(){
        
            if (!self.emailTextField.isTextFieldEmpty()) {
                if (!self.emailTextField.text!.isValidEmail()) {
                    
                    let alert = UIAlertController(title: "Warning.", message: NSLocalizedString("Enter valid email", comment: ""), preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) -> Void in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
    }
    // MARK: Login
    
    func loginToServerViaEmail() {
        
        self.view.endEditing(true)
        
        if validateTextFields() {
            
            // show loader
            self.navigationController!.view.showLoader(mainTitle: NSLocalizedString("Signing In", comment: ""), subTitle: Localization("please wait"))
            UserManager.sharedManager().performLogin(self.emailTextField.textByTrimmingWhiteSpacesAndNewline(), password: self.passwordTextField.textByTrimmingWhiteSpacesAndNewline(), roleType: UserManager.sharedManager().roleTypeString(), deviceInfo: deviceInfo(), completion: { (success, error) -> (Void) in
                // hide loader
                DispatchQueue.main.async {
                    self.navigationController!.view.hideLoader()
                    
                    if (success) {
                        
                        if(self.checkboxButton.currentImage == UIImage(named: "ic_tick")) {
                           
                            if UserManager.sharedManager().roleTypeString() == "2"{
                            
                                UserDefaults.setObject(self.emailTextField.text as AnyObject?, forKey: LOGGED_USER_EMAIL_KEY_HIRE)
                                UserDefaults.setObject(self.passwordTextField.text as AnyObject?, forKey: LOGGED_USER_PASSWORD_KEY_HIRE)
                            }else{
                            
                                UserDefaults.setObject(self.emailTextField.text as AnyObject?, forKey: LOGGED_USER_EMAIL_KEY_WORK)
                                UserDefaults.setObject(self.passwordTextField.text as AnyObject?, forKey: LOGGED_USER_PASSWORD_KEY_WORK)
                                
                            }
                            
                        }
                        else {
                            
                            if UserManager.sharedManager().roleTypeString() == "2"{
                            
                                UserDefaults.removeObjectForKey(LOGGED_USER_EMAIL_KEY_HIRE)
                                UserDefaults.removeObjectForKey(LOGGED_USER_PASSWORD_KEY_HIRE)
                            
                            }else{
                            
                                UserDefaults.removeObjectForKey(LOGGED_USER_EMAIL_KEY_WORK)
                                UserDefaults.removeObjectForKey(LOGGED_USER_PASSWORD_KEY_WORK)
                            
                            }
                            
                        }
                        
                        LogManager.logDebug("login success")
                        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                        
                    } else {
                        
                        LogManager.logError("login failure = \(error)")
                        self.showError(error!)
                    }

                }
                
             })
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
                    
                    // show home view controller
                    AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                } else {
                    
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }
                    }
                
            })

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
                        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                    } else {
                        
                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
                
            })
            
        }
    }
    
    // MARK: Helper
    fileprivate func showError(_ error: NSError) {
        self.showAlertBannerWithMessage((error.localizedDescription), bannerStyle: ALAlertBannerStyleFailure)
    }
    

}
