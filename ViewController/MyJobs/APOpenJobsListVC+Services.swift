//
//  APOpenJobsListVC+Services.swift
//  OnDemandApp
//
//  Created by Pawan Dhawan on 22/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

extension APOpenJobsListVC{
    
    
    /* getOpenJobsList method is called to get list of all opened jobs */
    
//    func getOpenJobsList(page:Int){
//        
//        // show loader
//        
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
//        Job.getOpenJobsList(page,completion: { (page, openJobsList ,success, error) -> (Void) in
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
//                
//                if (error!.localizedDescription == "No content")
//                {
//                    if(calledPage == 1){
//                        
//                        if(self.openJobsList != nil && self.openJobsList?.count > 0)
//                        {
//                            self.openJobsList?.removeAll()
//                        }
//                        
//                    }
//                    
//                    if(self.canScrolldown){
//                        self.hasContent = false
//                        self.canScrolldown = false
//                    }
//                    
//                    if(self.openJobsList != nil && self.openJobsList?.count > 0)
//                    {
//                        //do nothing
//                    }else{
//                        
//                        self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
//                    }
//                    self.tableView.reloadData()
//                }
//                else{
//                    
//                    self.showAlertBannerWithMessage((error?.localizedDescription)!, bannerStyle: ALAlertBannerStyleFailure)
//                }
//                
//            } else {
//                
//                self.page = page
//                if page > 1 {
//                    
//                    self.openJobsList?.appendContentsOf(openJobsList!)
//                }
//                else if page == 1
//                {
//                    
//                    self.openJobsList = openJobsList
//                }
//                self.tableView.reloadData()
//                
//            }
//        })
//    }
    
    
//    func acceptJob(jobObj:Job , indexPath : NSIndexPath) {
//        //show loader
//        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
//        jobObj.acceptJob(Int(jobObj.id!)) { (success, error) -> (Void) in
//            // hide loader
//            self.navigationController!.view.hideLoader()
//            if let _ = error {
//                self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
//            } else {
//                
//                self.openJobsList?.removeAtIndex(indexPath.row)
//                self.tableView.reloadData()
//                
//            }
//        }
//    }
    
}
