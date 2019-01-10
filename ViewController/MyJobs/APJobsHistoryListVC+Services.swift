//
//  APJobsHistoryListVC+Services.swift
//  OnDemandApp
//
//  Created by Pawan Dhawan on 22/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

extension APJobsHistoryListVC {
    
    /* getHistoryJobsList method is called to get list of all history jobs */
    
//    func getHistoryJobsList(page:Int){
//        
//        // show loader
//        let calledPage = page
//        
//        if calledPage == 1 {
//            
//            hasContent = true
//            canScrolldown = false
//        }
//        
//        if (!self.isRefreshAnimating){
//            
//            self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
//            
//        }
//        
//        Job.getHistoryJobsList(page, completion: { (page, jobHistoryList, success, error) -> (Void) in
//            // hide loader
//            self.navigationController?.view.hideLoader()
//            
//            if (self.isRefreshAnimating){
//                
//                self.isRefreshAnimating = false
//                
//                if((self.footerView.viewWithTag(10) as! UIActivityIndicatorView).isAnimating()){
//                    
//                    (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
//                    self.tableView.tableFooterView = UIView()
//                    
//                }else{
//                    
//                    self.refreshControl.endRefreshing()
//                    
//                }
//                
//            }else{
//                
//                self.navigationController!.view.hideLoader()
//            }
//            
//            
//            if let _ = error {
//                if (error!.localizedDescription == "No content")
//                {
//                    if(calledPage == 1){
//                        
//                        if(self.jobHistoryList != nil && self.jobHistoryList?.count > 0)
//                        {
//                            self.jobHistoryList?.removeAll()
//                        }
//                        
//                    }
//                    
//                    if(self.canScrolldown){
//                        self.hasContent = false
//                        self.canScrolldown = false
//                    }
//                    
//                    if(self.jobHistoryList != nil && self.jobHistoryList?.count > 0)
//                    {
//                        //do nothing
//                    }else{
//                        
//                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
//                    }
//                    self.tableView.reloadData()
//                    
//                }
//                else{
//                    
//                    if(self.canScrolldown){
//                        self.hasContent = false
//                        self.canScrolldown = false
//                    }
//                    
//                    if(self.jobHistoryList != nil && self.jobHistoryList?.count > 0)
//                    {
//                        //do nothing
//                    }else{
//                        
//                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
//                    }
//                    
//                    
//                }
//            }else {
//                
//                self.page = page
//                
//                if page > 1 {
//                    self.jobHistoryList?.appendContentsOf(jobHistoryList!)
//                }
//                else if page == 1
//                {
//                    self.jobHistoryList = jobHistoryList
//                }
//                
//                
//                self.tableView.reloadData()
//                
//            }
//        })
//    }
    
}
