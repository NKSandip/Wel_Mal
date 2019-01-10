//
//  test.swift
//  E3malApp
//
//  Created by Rishav Tomar on 11/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

extension APPostSignupProfileViewController {
    
    
    /* getCountryList method is called to get Country List */
    
    func getCountryList(){
        
        // show loader
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        
        Country.getCountryList({ (countryList, success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                if let _ = error {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    
                } else {
                    self.countryList = countryList as! [GulfCountry]?
                    self.profileTableView.reloadData()
                }
            }
            
        })
    }
    
    func updateProfileImage() {
        
        if self.navigationController == nil {
             self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
         self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        }
        
       
        
        UserManager.sharedManager().activeUser.uploadUserPhoto(self.profileImage!, completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                
                if self.navigationController == nil{
                self.view.hideLoader()
                }else{
                self.navigationController!.view.hideLoader()
                }
                
                
                
                if let _ = error {
                    self.showAlertViewWithMessageAndActionHandler("", message: NSLocalizedString("Profile image is not uploaded on server, please update your profile image manually from edit profile in settings.", comment: ""), actionHandler: {
                        // do nothing
                    })
                }
                self.startNetworkRequest()
            }
        })
    }
    
    func sendProfileInfo() {
        
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        
        
        UserManager.sharedManager().hireUserProfile(self.nameTextFieldValue!, dateOfBirth: self.dobTextFieldValue!, phonenumber: self.phoneNumberTextFieldValue!, roleType: UserManager.sharedManager().roleTypeString(), bio: self.bioTextFieldValue!, deviceInfo: deviceInfo(),completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                
                if success {
                    AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                    
                }
                else {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }
            }
        })
    }
    
    func sendWorkProfileInfo() {
        
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        
        UserManager.sharedManager().workUserProfile(self.nameTextFieldValue!, dateOfBirth: self.dobTextFieldValue!, phonenumber: self.phoneNumberTextFieldValue!, roleType: UserManager.sharedManager().roleTypeString(), bio: self.bioTextFieldValue!,country: self.selectedCountryId!, city: self.selectedCityId!, deviceInfo: deviceInfo(),completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                
                if success {
                    AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
                    
                    
                }
                else {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }
            }
        })
    }
}
