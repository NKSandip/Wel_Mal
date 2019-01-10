//
//  APNotificationsVC+Services.swift
//  OnDemandApp
//
//  Created by Pawan Dhawan on 29/09/16.
//  Copyright © 2016 Appster. All rights reserved.
//


extension APNotificationsVC {
    
    
    /* getNotificationsList method is called to get list of all notifications */
    
    func getNotificationsList(_ page:Int){
        
        // show loader
        let calledPage = page
        if calledPage == 1 {
            hasContent = true
            canScrolldown = false
        }
        
        
        if (!self.isRefreshAnimating){
            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        }
        
        Notification.getNotificationsList(page, completion: { (page, notificationList ,success, error) -> (Void) in
            
            // hide loader
            DispatchQueue.main.async {
                
                if (!self.isRefreshAnimating){
                    self.navigationController?.view.hideLoader()
                }
            
            if (self.isRefreshAnimating){
                
                self.isRefreshAnimating = false
                if((self.footerView.viewWithTag(10) as! UIActivityIndicatorView).isAnimating){
                    (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                    self.tableView.tableFooterView = UIView()
                }else{
                    
                    self.refreshControl.endRefreshing()
                    
                }
                
            }else{
                // hide loader
                DispatchQueue.main.async {
                    self.navigationController?.view.hideLoader()
                }
            }
            
            
            if let _ = error {
                if (error!.localizedDescription == "No content")
                {
                    if(calledPage == 1){
                        
                        if(self.notificationList != nil && (self.notificationList?.count)! > 0)
                        {
                            self.notificationList?.removeAll()
                        }
                    }
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })

                }
                else{
                    
                    if(self.canScrolldown){
                        self.hasContent = false
                        self.canScrolldown = false
                    }
                    
                    if(self.notificationList != nil && (self.notificationList?.count)! > 0)
                    {
                        // do nothing
                    }else{
                        if UserManager.sharedManager().isUserLoggedIn() {
                            self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                        }
                    }
                }
            } else {
                
                self.page = page
                
                if page > 1 {
                    
                    self.notificationList?.append(contentsOf: notificationList!)
                }
                else if page == 1
                {
                    
                    self.notificationList = notificationList
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
        })
    }
    
    
    func getJobDetails(_ jobId:String){
        
        // show loader
        LoaderHelper.showLoaderWithText(text: Localization("please wait"))
        
        Job.getJobDetails(jobId, completion: { (jobDetails, message, success, error) -> (Void) in
            LoaderHelper.hideLoader()
            DispatchQueue.main.async {
                let myJob = self.notificationList![(self.selectedIndex?.row)!] as! Notification
                myJob.readAt = "read"
                self.tableView.reloadRows(at: [self.selectedIndex!], with: .none)
                
                if let _ = error {
                
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                
                } else {
                    
                    let user = UserManager.sharedManager().activeUser
                    
                    if user?.roleType == 2 {
                    
                        if (jobDetails != nil) {
                            
                            let job:Job = jobDetails as! Job
                            if (job.tab != nil){
                                
                                let tabbarControllerStoryboard  = UIStoryboard(name: "TabbarController", bundle: nil)
                                if job.tab?.intValue == NEW_JOB_REQUEST{
                                    
                                    let detailVC = tabbarControllerStoryboard.instantiateViewController(withIdentifier: "HireDetailVC") as! APHireJobDetailsVC
                                    detailVC.jobRequestedId = Int(jobId)
                                    detailVC.isNewJob = true
                                    detailVC.flagHideTopButtons = true
                                    self.navigationController?.pushViewController(detailVC, animated: true)
                                    
                                }else if job.tab?.intValue == ONGOING_JOB_REQUEST{
                                    
                                    let detailVC = tabbarControllerStoryboard.instantiateViewController(withIdentifier: "HireDetailVC") as! APHireJobDetailsVC
                                    detailVC.jobRequestedId = Int(jobId)
                                    detailVC.isOngoingJob = true
                                    detailVC.flagHideTopButtons = true
                                    self.navigationController?.pushViewController(detailVC, animated: true)
                                    
                                }else{
                                    
                                    let detailVC = tabbarControllerStoryboard.instantiateViewController(withIdentifier: "HireDetailVC") as! APHireJobDetailsVC
                                    detailVC.jobRequestedId = Int(jobId)
                                    detailVC.isCompletedJob = true
                                    detailVC.flagHideTopButtons = true
                                    self.navigationController?.pushViewController(detailVC, animated: true)
                                    
                                }
                            }
                        
                        }else{
                            self.showAlertBannerWithMessage(message, bannerStyle: ALAlertBannerStyleFailure)
                        }
                    
                    }else{
                    
                        if (jobDetails != nil) {
                            
                            let job:Job = jobDetails as! Job
                            if (job.tab != nil){
                                
                                if job.tab?.intValue == FEED_JOB_REQUEST{
                                    
                                    let dashboardStoryboard  = UIStoryboard(name: "Dashboard", bundle: nil)
                                    let viewController = dashboardStoryboard.instantiateViewController(withIdentifier: "WorkJobDetails") as! WorkJobDetails
                                    viewController.job = job
                                    viewController.flagHideTopButtons = true
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                    
                                }else if job.tab?.intValue == NEW_JOB_REQUEST{
                                    
                                    let vc = UIStoryboard.jobProgressDetailVC()
                                    vc?.progressType = Constants.PROGRESS_TYPE_APPLIED
                                    vc?.flagHideTopButtons = true
                                    vc?.job = job
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                    
                                }else if job.tab?.intValue == ONGOING_JOB_REQUEST{
                                    
                                    let vc = UIStoryboard.jobProgressDetailVC()
                                    vc?.progressType = Constants.PROGRESS_TYPE_ONGOING
                                    vc?.job = job
                                    vc?.flagHideTopButtons = true
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                    
                                }else{
                                    
                                    let vc = UIStoryboard.jobProgressDetailVC()
                                    vc?.progressType = Constants.PROGRESS_TYPE_HISTORY
                                    vc?.job = job
                                    vc?.flagHideTopButtons = true
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                    
                                }
                            }
                           
                        }else{
                                self.showAlertBannerWithMessage(message, bannerStyle: ALAlertBannerStyleFailure)
                            
                        }
                    
                    }
                }
            }
            
        })
    }
    
    
    func getChatDetails(_ chatId:String){
        
        // show loader
        LoaderHelper.showLoaderWithText(text: "please wait")
        Notification.getChatDetails(chatId, completion: { (chatDetails, message, success, error) -> (Void) in
            
            DispatchQueue.main.async {
                LoaderHelper.hideLoader()
                self.navigationController!.view.hideAllLoader()
                let myJob = self.notificationList![(self.selectedIndex?.row)!] as! Notification
                myJob.readAt = "read"
                self.tableView.reloadRows(at: [self.selectedIndex!], with: .none)
                
                if let _ = error {
                    
                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
                    
                } else {
                    
                    if (chatDetails != nil) {
                        
                        let chat:ChatDetails = chatDetails as! ChatDetails
                        let jobMemberObj = JobBidMember()
                        jobMemberObj.id = chat.serviceRequestAssignmentId
                        jobMemberObj.providerId = chat.senderId
                        jobMemberObj.name = chat.senderName
                        jobMemberObj.profileImage = chat.senderProfileImage
                        let chatView = ChatViewController()
                        chatView.jobBidMember = jobMemberObj
                        let chatNavigationController = UINavigationController(rootViewController: chatView)
                        self.present(chatNavigationController, animated: true, completion: nil)
                        
                    }else{
                        self.showAlertBannerWithMessage(message, bannerStyle: ALAlertBannerStyleFailure)
                    }
                }
            }
            
        })
    }
}
