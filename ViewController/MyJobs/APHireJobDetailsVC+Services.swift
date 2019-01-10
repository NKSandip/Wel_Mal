//
//  APHireJobDetailVC+Services.swift
//  E3malApp
//
//  Created by Rishav Tomar on 28/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

extension APHireJobDetailsVC {
    
    //MARK: - Job API
    func getNewjobList(page : Int, requestId : Int) {
        
        // show loader
        if page == 1 {
            if self.navigationController == nil {
                self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            }else{
                self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
                
            }
        }
        
        Job.getOpenJobsList(page,requestId,completion: {(openJobsList ,success, error) -> (Void) in
            DispatchQueue.main.async {
                if page == 1 {
                    if self.navigationController == nil{
                        self.view.hideLoader()
                    }else{
                        self.navigationController!.view.hideLoader()
                    }
                }
                if let _ = error {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                }
                else {
                    if page == 1 {
                        self.jobDetail = openJobsList as! Job?
                        self.detailsTableView.dataSource = self
                        self.detailsTableView.delegate = self
                        
                    }
                    else {
                        self.jobDetail?.associateWorkers?.append(contentsOf : (openJobsList as! Job).associateWorkers!)
                        (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                        self.isRefreshAnimating = false
                    }
                    self.detailsTableView.reloadData()
                    self.param["serviceRequestId"] = self.jobDetail?.id
                    self.param["roleType"] = UserManager.sharedManager().activeUser.roleType
                }
            }
        })
    }
    
    // MARK: - Admin Bank Detail API
    func getAdminBankDetail() {
        // show loader
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        
        Job.adminBankDetailRequest { (bankDetail, success, error) -> (Void) in
            DispatchQueue.main.async {
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                if let _ = error {
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    /// Alert banner is 1.5 sec so adding Timer for 2 sec.
                    let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
                }
                else {
                    self.bankDetails = bankDetail as? AdminBankDetail
                    self.bankNameLabel.text = self.bankDetails?.bankUsername
                    self.accountNumberLabel.text = self.bankDetails?.bankName
                    self.IBANLabel.text = self.bankDetails?.accountNo
                    self.numberLabel.text = self.bankDetails?.ibanNumber
                    self.showPaymentActionSheet()
                    
                    
                }
            }
            
        }
    }
    
    func showPaymentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera: String = Localization("Bank Transfer")
        actionSheet.addAction(UIAlertAction(title: camera, style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.setTabBarVisible(visible: false, animated: true)
                self.priceTxtField.text = ""
                self.paymentView.isHidden = false
        }))
        
        let gallery: String = Localization("Online Payment")
        actionSheet.addAction(UIAlertAction(title: gallery, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.checkoutButtonAction()
        }))
        
        let cancel = Localization("Cancel")
        actionSheet.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func checkoutButtonAction() {
        let myString = jobDetail?.associateWorkers?[0].price!
        let myDouble = myString?.doubleValue
        print(myDouble as Any)
        let morePrecisePI = Double((jobDetail?.associateWorkers?[0].price!)!)
        Request.requestCheckoutID(amount: morePrecisePI, currency: Config.currency, completion: {(checkoutID) in
            DispatchQueue.main.async {
                guard let checkoutID = checkoutID else {
                    Utils.showResult(presenter: self, success: false, message: "Checkout ID is empty")
                    return
                }
                self.checkoutProvider = self.configureCheckoutProvider(checkoutID: checkoutID)
                self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
                    DispatchQueue.main.async {
                        self.handleTransactionSubmission(transaction: transaction, error: error)
                    }
                }, paymentBrandSelectedHandler: nil,
                   cancelHandler: nil)
            }
        })
    }
    
    // MARK: - Payment helpers
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            Utils.showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name:NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
        } else {
            Utils.showResult(presenter: self, success: false, message: "Invalid transaction")
        }
    }
    
    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        let provider = OPPPaymentProvider.init(mode: .live)
        let checkoutSettings = Utils.configureCheckoutSettings()
        checkoutSettings.storePaymentDetails = .prompt
        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
    }
    
    func requestPaymentStatus() {
        guard let resourcePath = self.transaction?.resourcePath else {
            Utils.showResult(presenter: self, success: false, message: "Resource path is invalid")
            return
        }
        
        self.transaction = nil
       
        Request.requestPaymentStatus(resourcePath: resourcePath) { (success,dictResponse) in
            DispatchQueue.main.async {
               
                let message = success ? "Your payment was successful" : "Your payment was not successful"
                //Utils.showResult(presenter: self, success: success, message: message)
                
                if success{
                    self.param["registrationId"] = dictResponse?["ndc"]
                    self.param["id"] = dictResponse?["id"]
                    self.sendForReview()
                }
                else{
                    Utils.showResult(presenter: self, success: success, message: message)
                }
                
            }
        }
    }
    
    // MARK: - Async payment callback
    
    func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
        self.checkoutProvider?.dismissCheckout(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        }
    }
    
    func update() {
        self.setTabBarVisible(visible: true, animated: true)
    }
    
    // MARK: - Accept Job API
    func sendForReview() {
        //show loader
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        Job.acceptBidRequest(param: param,completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                
                if success {
                    self.showAlertViewWithMessageAndActionHandler("", message: Localization("Invoice uploaded successfully!"), actionHandler: {
                        self.paymentView.isHidden = true
                        self.setTabBarVisible(visible: true, animated: true)
                        _ = self.navigationController?.popViewController(animated: false)
                        
                    })
                }
                else {
                    self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                }
            }
        })
        
    }
    
    // MARK: - Mark As Complete API
    func markAsComplete() {
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        let jobId = ["serviceRequestId": self.jobDetail?.id]
        Job.hireCompleteJobRequest(param:jobId ,completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                
                if success {
                    self.delegate?.updateList()
                    self.showAlertViewWithMessageAndActionHandler("", message: Localization("Job completed successfully!"), actionHandler: {
                        let _ = self.navigationController?.popViewController(animated: false)
                    })
                }
                else {
                    self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                }
            }
        })
        
    }
    
    // MARK: - Delete Job
    func deleteJob() {
        if self.navigationController == nil {
            self.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }else{
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
            
        }
        let jobId = ["serviceRequestId": Int(self.jobDetail!.id!)]
        
        Job.deleteJobRequest(param:jobId ,completion: { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async{
                
                if self.navigationController == nil{
                    self.view.hideLoader()
                }else{
                    self.navigationController!.view.hideLoader()
                }
                
                if success {
                    self.delegate?.updateList()
                    self.showAlertViewWithMessageAndActionHandler("", message: Localization("Job Deleted Successfully!"), actionHandler: {
                        let _ = self.navigationController?.popViewController(animated: false)
                    })
                }
                else {
                    self.view.makeToast((error?.localizedDescription)!, duration: 3, position: .center)
                }
            }
        })
    }
}
